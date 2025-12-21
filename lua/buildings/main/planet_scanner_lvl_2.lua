local planet_scanner = require("lua/buildings/main/planet_scanner.lua")
local tower          = require("lua/buildings/defense/tower.lua")
require("lua/utils/table_utils.lua")


class 'planet_scanner_lvl_2' ( tower )

function planet_scanner_lvl_2:__init()
	planet_scanner.__init(self,self)
	tower.__init(self,self)
end

function planet_scanner_lvl_2:OnInit()
	planet_scanner.OnInit(self,self)
	tower.OnInit(self,self)
	
    self:RegisterHandler( self.entity, "TurretEvent", "OnTurretEvent" )

    self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "working", { enter="OnWorkingEnter", execute="OnWorkingExecute" } )
	self.fsm:AddState( "cooldown", { enter="OnCooldownEnter", exit="OnCooldownExit" } )

	self.crosshairBp = self.data:GetStringOrDefault( "crosshair_bp", "" )
	self.rocketBp = self.data:GetStringOrDefault( "rocket_bp", "" )
    self.areaRadius = self.data:GetFloatOrDefault( "rocket_radius", 10.0 )
    self.areaHeight = self.data:GetFloatOrDefault( "rocket_height", 100.0 )
    self.rocketInitialHeight = self.data:GetFloatOrDefault( "rocket_initial_height", 10.0 )
	
	--self.strikeBp = self.data:GetStringOrDefault("strike_bp", "items/skills/orbital_laser_extreme")

    self.readyStrike = nil
    self.prepareStrike = nil
end


function planet_scanner_lvl_2:OnActivate()
	planet_scanner.OnActivate(self)
	tower.OnActivate(self)

	self.fsm:ChangeState( "working" )
end

function planet_scanner_lvl_2:OnDeactivate()
	planet_scanner.OnDeactivate(self)
	tower.OnDeactivate(self)
end

function planet_scanner_lvl_2:OnTurretEvent( evt )
end


function planet_scanner_lvl_2:OnWorkingEnter( state )
	if self.prepareStrike == nil and self.readyStrike == nil then
		self.prepareStrike = 1
	end
end

function planet_scanner_lvl_2:OnWorkingExecute( state )
	local progress = WeaponService:GetWeaponReloadProgress( self.entity );
	local currentTime = state:GetDuration()
	
	if self.readyStrike ~= nil then 
		if progress < 1.0 then
			self.readyStrike = nil

			if self.crosshairBp ~= "" then
				local targetEnt = WeaponService:GetTurretTarget( self.entity )
				if targetEnt ~= INVALID_ID then 
					local targetPos = EntityService:GetPosition( targetEnt )
					WeaponService:SpawnDangerMarker( self.crosshairBp, targetPos, self.areaRadius, 4.0 )
					
					--targetPos.y = targetPos.y + 30
					--self.fire = EntityService:SpawnEntity(self.strikeBp, targetPos, EntityService:GetTeam(self.entity))
	
					--WeaponService:UpdateWeaponStatComponent(self.fire, self.fire)
					--WeaponService:StartShoot(self.fire)
				end
			end

			self.prepareStrike = 1
			self.fsm:ChangeState( "cooldown" )
		end
	end

	if self.prepareStrike ~= nil then
		self.data:SetInt("is_ready", 1 )
		if progress >= 1 then
	    	self.readyStrike = self.prepareStrike;
	    	self.prepareStrike = nil
		end
	end
end

function planet_scanner_lvl_2:OnCooldownEnter( state )
	state:SetDurationLimit( 1.0 )
end

function planet_scanner_lvl_2:OnCooldownExit( state )
	self.data:SetInt("is_ready", 0 )
	self.fsm:ChangeState( "working" )
end


function planet_scanner_lvl_2:OnLoad()
    planet_scanner.OnLoad(self)
    tower.OnLoad(self)
end

return planet_scanner_lvl_2
