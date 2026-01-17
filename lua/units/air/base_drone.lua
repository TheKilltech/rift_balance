require("lua/utils/table_utils.lua")
require("lua/units/units_utils.lua")
require("lua/utils/throttler_utils.lua")

class 'base_drone' ( LuaEntityObject )


function base_drone:__init()
	LuaEntityObject.__init(self, self)
end

local function GetLockName(lock_type)
	return lock_type .. "_lock"
end

local function UnlockAlive( target, lock_type )
	if EntityService:IsAlive( target ) then
		UnitService:SetCurrentTarget( target, GetLockName( lock_type ), INVALID_ID )
	end
end

local function GetParent( entity )
	local parent = EntityService:GetParent( entity )
	if parent == INVALID_ID then
		return entity
	end

	return GetParent( parent )
end
function base_drone:UpdateInitialState()
	local owner = self:GetDroneOwnerTarget();
	if not EntityService:GetComponent( owner, "BuildingComponent") or BuildingService:IsWorking( owner ) then
		QueueEvent( "EnableDroneRequest", self.entity )
	else
		QueueEvent( "DisableDroneRequest", self.entity )
	end
	self.is_lifting = false
	self.is_landing = false
	self.has_speed_penalty = self.has_speed_penalty or false
end

function base_drone:SetEnabled( enabled )
	self.is_enabled = enabled

	if enabled then
		if self.OnDroneEnabled then
			self:OnDroneEnabled()
		end
		UnitService:SetStateMachineParam(self.entity, "is_enabled", 1)
	else
		if self.OnDroneDisabled then
			self:OnDroneDisabled()
		end
		UnitService:SetStateMachineParam(self.entity, "is_enabled", 0)
	end
end

function base_drone:init()
	self:RegisterHandler( self.entity, "EnableDroneRequest", "_OnEnableDroneRequest" )
	self:RegisterHandler( self.entity, "DisableDroneRequest", "_OnDisableDroneRequest" )
	self:RegisterHandler( self.entity, "DroneOwnerActionStartedEvent", "_OnDroneOwnerAction" )
	self:RegisterHandler( self.entity, "DroneTargetActionStartedEvent", "_OnDroneTargetAction" )
	self:RegisterHandler( self.entity, "TimerElapsedEvent", "_OnDroneFindTargetRequest" )
	self:RegisterHandler( self.entity, "DroneLiftingStartedEvent", "_OnDroneLiftingStartedEvent" )
	self:RegisterHandler( self.entity, "DroneLiftingEndedEvent", "_OnDroneLiftingEndedEvent" )
	self:RegisterHandler( self.entity, "DroneLandingStartedEvent", "_OnDroneLandingStartedEvent" )
	self:RegisterHandler( self.entity, "DroneLandingEndedEvent", "_OnDroneLandingEndedEvent" )
	
	self:RegisterHandler( self.entity, "DestroyRequest", "_OnDroneDestroyRequest" )

	self.locked_targets = {};
	self.has_speed_penalty = false;

	self.checker = self:CreateStateMachine()
	self.checker:AddState("owner_distance_check", { execute="OnOwnerDistanceCheckExecute", interval=3.0})
	self.checker:ChangeState("owner_distance_check")

	SetupUnitScale( self.entity, self.data );

	if self.OnInit then
		self:OnInit()
	end

	self:SetEnabled(false)
	self:UpdateInitialState()
end

function base_drone:OnLoad()
	self:UpdateInitialState()

	for item, i in IterReverse( self.locked_targets ) do
		UnlockAlive( item.entity, item.type )
		self.locked_targets[i] = nil
	end

	self:UnlockAllTargets();
	self:SetEnabled(false)
	UnitService:SetCurrentTarget( self.entity, "action", INVALID_ID );

	QueueEvent("DissolveEntityRequest", self.entity, 0.1, 0.0 )
end

function base_drone:OnOwnerDistanceCheckExecute()
	local owner = self:GetDroneOwnerTarget()
	if not EntityService:IsAlive(owner) then
		return
	end

	local distance = EntityService:GetDistance2DBetween( self.entity, owner )
	if self.search_radius and distance > self.search_radius * 2.0 and EntityService:GetComponent( self.entity, "IsVisibleComponent" ) == nil then

		if self.is_enabled then
			QueueEvent( "DisableDroneRequest", self.entity )
			QueueEvent( "EnableDroneRequest", self.entity )
		end

		local target_position = EntityService:GetPosition( owner )
		target_position.y = EntityService:GetPositionY( self.entity )

		EntityService:Teleport( self.entity, target_position )
		EntityService:FadeEntity( self.entity, DD_FADE_IN, 0.3 )
	end

	local action_target = self:GetDroneActionTarget()
	if action_target ~= INVALID_ID and not EntityService:IsAlive( action_target ) then
		self:SetTargetActionFinished()
	end
end

function base_drone:_OnEnableDroneRequest( evt )
	local storage = self.data:GetFloatOrDefault( "storage", 1 );

	self:SetEnabled(true)
	EntityService:SetGraphicsUniform( self.entity, "cGlowFactor", storage )
end

function base_drone:_OnDisableDroneRequest( evt )
	self:UnlockAllTargets();
	self:SetEnabled(false)

	UnitService:SetCurrentTarget( self.entity, "action", INVALID_ID );
	EntityService:SetGraphicsUniform( self.entity, "cGlowFactor", 0 )
end

function base_drone:_OnDroneOwnerAction(evt)
	UnitService:SetStateMachineParam(self.entity, "owner_action_finished", 0)

	if self.OnDroneOwnerAction then
		local owner = UnitService:GetCurrentTarget( self.entity, "owner");
		Assert( owner ~= INVALID_ID, "ERROR: invalid owner action target!")
		self:OnDroneOwnerAction( owner )
	else
		self:SetOwnerActionFinished()
	end
end

function base_drone:LockTarget( target, lock_type )
	if Assert( not self:IsTargetLocked( target, lock_type ), "ERROR: target has already lock of type: " .. lock_type ) then
		local locks = self.locked_targets[target]
		if not locks then
			locks = {}
			self.locked_targets[target] = locks
		end
		-- locks[lock_type] = true

		locks[#locks + 1] = lock_type
		UnitService:SetCurrentTarget( target, GetLockName( lock_type ), self.entity );

	end
end

function base_drone:IsTargetLocked( target, lock_type )
	return UnitService:GetCurrentTarget( target, GetLockName( lock_type ) ) ~= INVALID_ID
end

function base_drone:UnlockTarget( target, lock_type )
	local target_locks = self.locked_targets[target]
	if target_locks ~= nil then
		local index = IndexOf( target_locks, lock_type )
		if index ~= nil then
			UnlockAlive( target, lock_type )
			table.remove( target_locks, index )
			if next( target_locks ) == nil then
				self.locked_targets[target] = nil
			end

			return true
		end
	end

	return Assert( false, "ERROR: target was not locked by this entity!" )
end

function base_drone:HandlePartiallyWorkingPenalty()
	local working_time = BuildingService:GetWorkingTime( self:GetDroneOwnerTarget() )
	if working_time == nil then
		return false
	end

	if ConsoleService:GetConfig("cheat_unlimited_money") == "1" then
		return false
	end

	local apply_penalty = working_time < 1.0

	-- disable all drones except first one
	local drone_index = self.data:GetIntOrDefault("drone_id", 0 )
	if apply_penalty and drone_index > 0 then
		return true
	end

	-- apply movement penalty on first drone
	if ( self.has_speed_penalty ~= apply_penalty ) then
		if ( apply_penalty ) then
			QueueEvent("AddMaxSpeedModifierRequest", self.entity, "working_penalty", 0.1)
		else
			QueueEvent("RemoveMaxSpeedModifierRequest", self.entity, "working_penalty")
		end
		self.has_speed_penalty = apply_penalty
	end

	return false
end

function base_drone:_OnDroneFindTargetRequest(evt)
	if not evt.GetName or evt:GetName() ~= "drone_find_target" then
		return
	end

	if not self.is_enabled then
		return
	end

	if self:HandlePartiallyWorkingPenalty() then
		return
	end

	self:UnlockAllTargets()
	if self.FindActionTarget ~= nil then
		local target = self:FindActionTarget();
		UnitService:SetCurrentTarget( self.entity, "action", target );
		if target ~= INVALID_ID then
			UnitService:EmitStateMachineParam(self.entity, "action_target_found")
			UnitService:SetStateMachineParam( self.entity, "action_target_valid", 1)
		else
			UnitService:SetStateMachineParam( self.entity, "action_target_valid", 0)
		end
	end
end

function base_drone:SetDroneTarget()
	local target = self:FindActionTarget()
	if target ~= INVALID_ID then
		UnitService:SetCurrentTarget( self.entity, "action", target )
		UnitService:SetStateMachineParam( self.entity, "action_target_valid", 1 )
		UnitService:EmitStateMachineParam( self.entity, "action_target_found" )
		return true
	end
	return false
end

function base_drone:SetOwnerActionFinished()
	UnitService:SetStateMachineParam(self.entity, "owner_action_finished", 1)
end

function base_drone:SetTargetActionFinished()
	UnitService:SetStateMachineParam(self.entity, "target_action_finished", 1)
	UnitService:SetCurrentTarget( self.entity, "action", INVALID_ID );
	UnitService:SetStateMachineParam(self.entity, "action_target_valid", 0)
end

function base_drone:_OnDroneTargetAction(evt)
	UnitService:SetStateMachineParam(self.entity, "target_action_finished", 0)

	if self.OnDroneTargetAction then
		local target = UnitService:GetCurrentTarget( self.entity, "action" );
		if target ~= INVALID_ID and EntityService:IsAlive(target) then
			self:OnDroneTargetAction( target )
		else
			self:SetTargetActionFinished()
		end
	else
		self:SetTargetActionFinished()
	end
end

function base_drone:GetDroneActionTarget()
	return UnitService:GetCurrentTarget( self.entity, "action" );
end

function base_drone:GetDroneOwnerTarget()
	return GetParent( UnitService:GetCurrentTarget( self.entity, "owner" ) );
end

function base_drone:UnlockAllTargets()
	local ref_locked_targets = self.locked_targets
	for target, locks in pairs( ref_locked_targets ) do
		for _, lock_type in ipairs( locks ) do
			UnlockAlive( target, lock_type )
			-- self:UnlockTarget( target, lock_type )
		end
		ref_locked_targets[target] = nil
	end
end

function base_drone:_OnDroneLiftingStartedEvent()
	self.is_lifting = true

	if self.OnDroneLifting then
		self:OnDroneLifting()
	end

	EffectService:AttachEffects(self.entity, "fly")
end

function base_drone:_OnDroneLiftingEndedEvent()
	self.is_lifting = false
end

function base_drone:_OnDroneLandingStartedEvent()
	self.is_landing = true

	EffectService:DestroyEffectsByGroup(self.entity, "fly")
end

function base_drone:_OnDroneLandingEndedEvent()
	self.is_landing = false

	if self.OnDroneLanding then
		self:OnDroneLanding()
	end
end

function base_drone:_OnDroneDestroyRequest()
	self:UnlockAllTargets();
end

function base_drone:OnRelease()
	self:UnlockAllTargets();
end

return base_drone
