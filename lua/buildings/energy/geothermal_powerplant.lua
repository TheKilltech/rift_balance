local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'geothermal_powerplant' ( building )

function geothermal_powerplant:__init()
	building.__init(self)
	
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "biom_modifier", { enter="OnEnterBiomModifier", execute="OnUpdateBiomModifier" } )
	self.veins = {}
end

function geothermal_powerplant:OnCubeFlyStart()
	self:ClearGeothermalVent()
end

function geothermal_powerplant:ClearGeothermalVent()
	self.veins = BuildingService:GetResourceVeins( self.entity, "geothermal_vent")
	for ent in Iter(self.veins ) do
		EffectService:DestroyEffectsByGroup( ent, "steam")
		EntityService:RemoveComponent(ent, "SelectableComponent")
	end
end

function geothermal_powerplant:OnBuildingEnd()
	self:Recalculate()
	self:RegisterHandler( event_sink , "RecalculateModifiersEvent", "OnRecalculateModifiersEvent")

	if ( #self.veins == 0 ) then
		self:ClearGeothermalVent()
	end
end

function geothermal_powerplant:OnEnterBiomModifier( state )
	state:SetDurationLimit(10)
end

function geothermal_powerplant:OnUpdateBiomModifier()
	self:Recalculate()
end

function geothermal_powerplant:OnRecalculateModifiersEvent(evt)
	self:Recalculate()
	self.fsm:ChangeState("biom_modifier")
end

function geothermal_powerplant:Recalculate()
	local modificator = BuildingService:GetGeothermalPowerModificator()
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "biome" )
	BuildingService:SetResourceConverterEfficientyModificator( self.entity, modificator, "biome" )
end

function geothermal_powerplant:OnRemove()
	for ent in Iter(self.veins ) do
		EffectService:AttachEffects( ent, "steam")
		QueueEvent("RecreateComponentFromBlueprintRequest", ent, "SelectableComponent" )
	end
end

return geothermal_powerplant
