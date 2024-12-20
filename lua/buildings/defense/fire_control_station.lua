local tower = require("lua/buildings/defense/tower.lua")

class 'fire_control_station' ( tower )

function fire_control_station:__init()
	tower.__init(self,self)
end

function fire_control_station:OnInit()
	-- LogService:Log( "FCS: OnInit" )
	self.radius = 40
	self.alert = 1
	self.alertCooldown = 10
	self.alertLight = "off"
	
	self.radius = self.data:GetFloatOrDefault("radius", 40)
	
	self:RegisterHandler(self.entity, "TurretEvent", "OnTurretEvent")
	
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState("alert",          { enter = "OnEnterAlert", exit = "OnExitAlert" })
	self.fsm:AddState("alert_cooldown", { enter = "OnEnterAlertCooldown", execute = "OnExecuteAlertCooldown", exit= "OnExitCooldownAlertCooldown" , interval = 2 })
	self.fsm:AddState("noalert",        { enter = "OnEnterNoAlert", exit = "OnExitNoAlert" })
end


function fire_control_station:OnActivate()
	-- LogService:Log( "FCS: OnActivate" )
	self.powered = true
	self.fsm:ChangeState("alert_cooldown")
	if ( AnimationService:HasAnim( self.entity, "working") ) then
		AnimationService:StartAnim( self.entity, "working", true )
	end
end

function fire_control_station:OnDeactivate()
	-- LogService:Log( "FCS: OnDeactivate" )
	self.powered = false
	self.fsm:ChangeState("alert_cooldown")
	if ( AnimationService:IsAnimActive( self.entity, "working") ) then
		AnimationService:StopAnim( self.entity, "working")
	end
end

local TS_ON_WEAPON_AIM = 4 -- constant enum value of GetTurretStatus return type
local noTargetId = "4294967295" -- max uint: 2^32 - 1 or (uint)(-1)

function fire_control_station:OnTurretEvent(evt)
	-- LogService:Log( "FCS: OnTurretEvent" )
	local target  = evt:GetTargetEntity()
	local tstatus = evt:GetTurretStatus()
	-- LogService:Log( "FCS: event target ".. tostring(target) .. " status ".. tostring(tstatus) .. " alert " ..tostring(self.alert))
	if tostring(target) ~= noTargetId then 
		-- LogService:Log( "FCS: turret has target")
		self.fsm:ChangeState("alert")
	elseif tstatus == 0 and self.alert > 0 then
		-- LogService:Log( "FCS: no target")
		self.fsm:ChangeState("alert_cooldown")
	end
end

--------- state = alert

function fire_control_station:OnEnterAlert(state)	
	-- LogService:Log( "FCS: OnEnterAlert alert ".. tostring(self.alert))
	self:OperateAlertLight("red")
	if self.working and self.alert ~= 2 then
		local entities = self:GetControlledEntities()
		self:SwitchPowerState( entities, true )
	end
	self.alert = 2
end

function fire_control_station:OnExitAlert(state)	
	-- LogService:Log( "FCS: OnExitAlert alert ".. tostring(self.alert))
end

--------- state = alert_cooldown

function fire_control_station:OnEnterAlertCooldown(state)	
	-- LogService:Log( "FCS: OnEnterAlertCooldown alert ".. tostring(self.alert))
	self:OperateAlertLight("yellow")
	self.alertCooldown = 10
	self.alert = 1
end

function fire_control_station:OnExecuteAlertCooldown(state, dt)
	-- LogService:Log( "FCS: OnExecuteAlertCooldown alert ".. tostring(self.alert) ..", cooldown ".. tostring(self.alertCooldown))
	self.alertCooldown = self.alertCooldown - dt
	if self.alertCooldown <= 0 then	
		-- LogService:Log( "FCS: cooldown ended. switching off alert" )
		self.fsm:ChangeState("noalert")
	end
end

function fire_control_station:OnExitCooldownAlertCooldown(state)	
	-- LogService:Log( "FCS: OnExitCooldownAlertCooldown alert ".. tostring(self.alert) ..", cooldown " .. tostring(self.alertCooldown))
end

--------- state = noalert

function fire_control_station:OnEnterNoAlert(state)	
	-- LogService:Log( "FCS: OnEnterNoAlert alert ".. tostring(self.alert))
	self:OperateAlertLight("green")
	if self.alert ~= 0 and self.working then
		local entities = self:GetControlledEntities()
		self:SwitchPowerState( entities, false )
	end
	self.alert = 0
end

function fire_control_station:OnExitNoAlert(state)	
	-- LogService:Log( "FCS: OnExitNoAlert alert ".. tostring(self.alert))
end




function fire_control_station:GetControlledEntities()
	-- LogService:Log( "FCS: GetControlledEntities" )
	local entities = FindService:FindEntitiesByTypeInRadius( self.entity, "defense", self.radius )
	-- LogService:Log( "FCS: ".. tostring(#entities) .. " in radius ".. tostring(self.radius))
	
	local controlled = {}
    for ent in Iter(entities ) do
        if EntityService:GetComponent(ent, "ResourceConverterComponent") == nil	then goto continue end
		if ( not BuildingService:IsBuildingFinished( ent ))						then goto continue end
		
		local bpname = EntityService:GetBlueprintName(ent)
		if string.find(bpname, "fire_control_station") then goto continue end
		if string.find(bpname, "repair_facility")      then goto continue end
		if string.find(bpname, "short_range_radar")    then goto continue end
		if string.find(bpname, "ai_hub")               then goto continue end
		
		-- LogService:Log( "FCS: entity ".. tostring(ent).. " name ".. tostring(EntityService:GetBlueprintName(ent)))
        Insert(controlled, ent)
		::continue::
    end

    return controlled
end

function fire_control_station:SwitchPowerState( entities, newStatus )  
	-- LogService:Log( "FCS: SwitchPowerState ".. tostring(#entities) .. " entities to power state ".. tostring(newStatus))
	for entity in Iter( entities ) do
		QueueEvent("ChangeBuildingStatusRequest", entity, newStatus )
	end
end

function fire_control_station:OperateAlertLight( targetLightState )
	-- LogService:Log( "FCS: OperateAlertLight from ".. tostring(self.alertLight) .. " to " .. tostring(targetLightState))
	if self.alertLight == targetLightState then return end
	
	if self.alertLight == "red" then
		EffectService:DestroyEffectsByGroup(self.entity, "alert_red")
	elseif self.alertLight == "yellow" then
		EffectService:DestroyEffectsByGroup(self.entity, "alert_yellow")
		EffectService:DestroyEffectsByGroup(self.entity, "target")
	elseif self.alertLight == "green" then
		EffectService:DestroyEffectsByGroup(self.entity, "alert_green")
	end
	
	if self.working == true then		
		if targetLightState == "red" then
			EffectService:AttachEffects(self.entity, "alert_red")
			EffectService:AttachEffects(self.entity, "target")
		elseif targetLightState == "yellow" then
			EffectService:AttachEffects(self.entity, "alert_yellow")
		elseif targetLightState == "green" then
			EffectService:AttachEffects(self.entity, "alert_green")
		end
		self.alertLight = targetLightState
	elseif self.working == false then 
		self.alertLight = "off"
	end
end

return fire_control_station
