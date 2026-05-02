local building = require("lua/buildings/building.lua")
require("lua/utils/throttler_utils.lua")
class 'solar_panels' ( building )

local LOCK_SOLAR_PANELS = "solar_panels";
SetTargetFinderThrottler(LOCK_SOLAR_PANELS, 15)

function solar_panels:__init()
	building.__init(self)
end

function solar_panels:OnBuildingEnd()
	self:Recalculate()
end

function solar_panels:OnInit()
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "working", { execute="OnWorking", interval=0.2} )
	self.fsm:ChangeState( "working" )
	
	self:RegisterHandler( event_sink , "SunsetStartedEvent", "OnSunsetStartedEvent" )
	self:RegisterHandler( event_sink , "DayStartedEvent", "OnDayStartedEvent")
	self:RegisterHandler( event_sink , "NightStartedEvent", "OnNightStartedEvent")
	self:RegisterHandler( event_sink , "RecalculateModifiersEvent", "OnRecalculateModifiersEvent")
	self.timeOfDayOk = false
	self.lastAcidDamage = 0
		
    self.cfsm = self:CreateStateMachine()
    self.cfsm:AddState( "biom_modifier", { execute="OnUpdateBiomModifier" } )
end 

function solar_panels:OnDayStartedEvent(evt)
end
function solar_panels:OnRecalculateModifiersEvent(evt)
	self.cfsm:ChangeState("biom_modifier")
end

function solar_panels:OnSunsetStartedEvent(evt)
end

function solar_panels:OnNightStartedEvent(evt)
end

function solar_panels:OnActivate()
	self.data:SetInt("is_working", 1 )
end

function solar_panels:OnDeactivate()
	self.data:SetInt("is_working", 0 )
end

function solar_panels:OnDamage( evt )
	if ( evt:GetDamageType() == "acid_rain" ) then
		self.lastAcidDamage = -1.0
	end
end

function solar_panels:OnWorking( state , dt)
	local sun_yaw = EnvironmentService:GetSunLocalYaw( self.entity ) + 180.0
	self.data:SetFloat("sun_yaw", sun_yaw  )
	if ( self.lastAcidDamage < 0.0 ) then
		self.lastAcidDamage = self.lastAcidDamage + dt
	end		

	local isRaining =  not EnvironmentService:IsRaining()
	self.timeOfDayOk = EnvironmentService:GetLightIntensity() >= 1.00
	local modificator = BuildingService:GetSolarPowerModificator( self.entity )
	local currentWorking = self.timeOfDayOk and self.lastAcidDamage >= 0 and isRaining and modificator > 0
	if ( currentWorking ~= self.working ) then
		self.working = currentWorking
		if (self.working) then
			BuildingService:EnableBuilding( self.entity )
		else
			BuildingService:DisableBuilding( self.entity )
		end
	end
end

function solar_panels:OnEnterBiomModifier( state )
end

function solar_panels:OnUpdateBiomModifier(state)
	if IsRequestThrottled(LOCK_SOLAR_PANELS) then
		return 
	end
	self:Recalculate()
	state:Exit()
end

function solar_panels:Recalculate()
	local modificator = BuildingService:GetSolarPowerModificator( self.entity )
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "biome" )
	BuildingService:SetResourceConverterEfficientyModificator( self.entity, modificator, "biome" )
end

return solar_panels
