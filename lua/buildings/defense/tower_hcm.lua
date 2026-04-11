local tower = require("lua/buildings/defense/tower.lua")
require("lua/utils/table_utils.lua")

class 'tower_hcm' ( tower )

function tower_hcm:__init()
	tower.__init(self,self)
end

function tower_hcm:OnInit()
    tower.OnInit(self)

    self:RegisterHandler( self.entity, "TurretEvent", "OnTurretEvent" )

    self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "working", { enter="OnWorkingEnter", execute="OnWorkingExecute" } )
	self.fsm:AddState( "cooldown", { enter="OnCooldownEnter", exit="OnCooldownExit" } )

	self.crosshairBp = self.data:GetStringOrDefault( "crosshair_bp", "" )
	self.rocketBp = self.data:GetStringOrDefault( "rocket_bp", "" )
    self.areaRadius = self.data:GetFloatOrDefault( "rocket_radius", 10.0 )
    self.areaHeight = self.data:GetFloatOrDefault( "rocket_height", 100.0 )
    self.rocketInitialHeight = self.data:GetFloatOrDefault( "rocket_initial_height", 10.0 )

    self.readyRocker = nil
    self.pendingRocket = nil
end

function tower_hcm:OnActivate()
	tower.OnActivate(self)

	self.fsm:ChangeState( "working" )

	if self.readyRocker ~= nil then
		EntityService:SetGraphicsUniform( self.readyRocker, "cGlowFactor", 1 )
	end

	if self.pendingRocket ~= nil then
		EntityService:SetGraphicsUniform( self.pendingRocket, "cGlowFactor", 1 )
	end
end

function tower_hcm:OnDeactivate()
	tower.OnDeactivate(self)

	if self.readyRocker ~= nil then
		EntityService:SetGraphicsUniform( self.readyRocker, "cGlowFactor", 0 )
	end

	if self.pendingRocket ~= nil then
		EntityService:SetGraphicsUniform( self.pendingRocket, "cGlowFactor", 0 )
	end
end

function tower_hcm:_OnTurretEvent( evt )
end

function tower_hcm:OnTurretEvent( evt )
   self:UpdateMuzzles()
end

function tower_hcm:OnWorkingEnter( state )
	if self.pendingRocket == nil and self.readyRocker == nil then
		self.pendingRocket = EntityService:SpawnAndAttachEntity( self.rocketBp, self.entity, "att_rocket", "" )
		BuildingService:RemoveConverterCostModifier( self.entity, "idle" )
	end
end

function tower_hcm:UpdateMuzzles()
	local targetEnt = WeaponService:GetTurretTarget( self.entity )
	if targetEnt ~= INVALID_ID then 
		local targetPos = EntityService:GetPosition( targetEnt )

		local muzzlePos1 = { x = targetPos.x, y = self.areaHeight - ( 0.2 * self.areaHeight ), z = targetPos.z }
		EntityService:SetBonePosition( self.entity, "att_muzzle_1", muzzlePos1 )

		local muzzlePos2 = { x = targetPos.x + 0.9 * self.areaRadius, y = self.areaHeight - ( RandFloat( 0.0, 0.18 ) * self.areaHeight ), z = targetPos.z - 0.5 * self.areaRadius }
		EntityService:SetBonePosition( self.entity, "att_muzzle_2", muzzlePos2 )

		local muzzlePos3 = { x = targetPos.x - 0.9 * self.areaRadius, y = self.areaHeight - ( RandFloat( 0.0, 0.18 ) * self.areaHeight ), z = targetPos.z - 0.5 * self.areaRadius }
		EntityService:SetBonePosition( self.entity, "att_muzzle_3", muzzlePos3 )

		local muzzlePos4 = { x = targetPos.x, y = self.areaHeight - ( RandFloat( 0.0, 0.18 ) * self.areaHeight ), z = targetPos.z - self.areaRadius }
		EntityService:SetBonePosition( self.entity, "att_muzzle_4", muzzlePos4 )

		local muzzlePos5 = { x = targetPos.x - 0.5 * self.areaRadius, y = self.areaHeight - ( RandFloat( 0.0, 0.18 ) * self.areaHeight ), z = targetPos.z + 0.9 * self.areaRadius }
		EntityService:SetBonePosition( self.entity, "att_muzzle_5", muzzlePos5 )

		local muzzlePos6 = { x = targetPos.x + 0.5 * self.areaRadius, y = self.areaHeight - ( RandFloat( 0.0, 0.18 ) * self.areaHeight ), z = targetPos.z + 0.9 * self.areaRadius }
		EntityService:SetBonePosition( self.entity, "att_muzzle_6", muzzlePos6 )
	end
end

function tower_hcm:OnWorkingExecute( state )
	local progress = WeaponService:GetWeaponReloadProgress( self.entity );
	local currentTime = state:GetDuration()
	
	if self.readyRocker ~= nil then 
		if progress < 1.0 then 
			self:DetachAndFireRocket( self.readyRocker )
			self.readyRocker = nil

			if self.crosshairBp ~= "" then
				local targetEnt = WeaponService:GetTurretTarget( self.entity )
				if targetEnt ~= INVALID_ID then 
					local targetPos = EntityService:GetPosition( targetEnt )
					WeaponService:SpawnDangerMarker( self.crosshairBp, targetPos, self.areaRadius, 4.0 )
				end
			end

			BuildingService:RemoveConverterCostModifier( self.entity, "idle" )
			self.pendingRocket = EntityService:SpawnAndAttachEntity( self.rocketBp, self.entity, "att_rocket", "" )
			self.fsm:ChangeState( "cooldown" )
		end
	end

	if self.pendingRocket ~= nil then
		local statusInfo = ""
		self.data:SetInt("is_ready", 1 )
		if progress > 0 and progress < 1.0 then
			statusInfo = string.format("%.0f", (progress)*100) .. "%"
	    	EntityService:SetPosition( self.pendingRocket, self.rocketInitialHeight * progress, 0, 0 )
			
		elseif progress >= 1 then
			statusInfo = "ready"
	    	self.readyRocker = self.pendingRocket;
	    	self.pendingRocket = nil
			BuildingService:AddConverterCostModifier( self.entity, 0 , "idle" )
		end
		self.data:SetString("production_group.rows.row1.icon", "gui/hud/buttons/action_menu_upgrade_neutral")
		self.data:SetString("production_group.rows.row1.name", "Rocket Prep" )
		self.data:SetString("production_group.rows.row1.value", statusInfo )
		self.data:SetString("stat_categories", "production_group")
		self.data:SetString("production_group.rows", "row1" )
	end

	self:UpdateMuzzles()
end

function tower_hcm:OnCooldownEnter( state )
	state:SetDurationLimit( 1.0 )
end

function tower_hcm:OnCooldownExit( state )
	self.data:SetInt("is_ready", 0 )
	self.fsm:ChangeState( "working" )
end

function tower_hcm:DetachAndFireRocket( rocketEnt )
	MoveService:MoveInDirection( rocketEnt, 0, 30.0, 15.0, { x=1, y=0, z=0 } )
	QueueEvent( "DissolveEntityRequest", rocketEnt, 2.0, 3.0 )
	EffectService:AttachEffects( rocketEnt, "exhaust" )
end

return tower_hcm
