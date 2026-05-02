local building = require("lua/buildings/building.lua")
require("lua/utils/throttler_utils.lua")
class 'wind_turbine' ( building )

local LOCK_WIND_TURBINE = "wind_turbine";
SetTargetFinderThrottler(LOCK_WIND_TURBINE, 15)

function wind_turbine:__init()
	building.__init(self)
end

function wind_turbine:OnInit()
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "biom_modifier", { execute="OnUpdateBiomModifier", interval=0.2 } )
	self.lastModifier = 1.0
end 


function wind_turbine:OnBuildingEnd()
	self:Recalculate()
	self:RegisterHandler( event_sink , "RecalculateModifiersEvent", "OnRecalculateModifiersEvent")
end

function wind_turbine:OnRecalculateModifiersEvent(evt)
	self.fsm:ChangeState("biom_modifier")
end


function wind_turbine:OnActivate()
	self.data:SetFloat("is_working", BuildingService:GetWindPowerModificator( self.entity ) )
end

function wind_turbine:OnEnterBiomModifier( state )
end

function wind_turbine:OnUpdateBiomModifier( state)
	if IsRequestThrottled(LOCK_WIND_TURBINE) then
		return 
	end
	self:Recalculate()
	state:Exit()
end

function wind_turbine:Recalculate()
	local modificator = BuildingService:GetWindPowerModificator(self.entity )
	if ( modificator == self.lastModifier) then
		return
	end
	self.lastModifier = modificator
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "biome" )
	BuildingService:SetResourceConverterEfficientyModificator( self.entity, modificator, "biome" )
	if ( self.working ) then
		self.data:SetFloat("is_working", modificator )
	end
end


return wind_turbine
