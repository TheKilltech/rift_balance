local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'gas_extractor' ( building )

function gas_extractor:__init()
	building.__init(self)
	
	self.veins = {}
end

function gas_extractor:OnCubeFlyStart()
	self:ClearGasVent()
end

function gas_extractor:ClearGasVent()
	self.veins = BuildingService:GetResourceVeins( self.entity, "flammable_gas_vent")
	for ent in Iter(self.veins ) do
		EffectService:DestroyEffectsByGroup( ent, "steam")
		EntityService:RemoveComponent( ent, "GridMarkerComponent")
		EntityService:RemoveComponent( ent, "MeshComponent")
		EntityService:RemoveComponent( ent, "SelectableComponent")
	end
end

function gas_extractor:OnBuildingEnd()
	if ( #self.veins == 0 ) then
		self:ClearGasVent()
	end
end

function gas_extractor:OnRemove()
	for ent in Iter(self.veins ) do
		EffectService:AttachEffects( ent, "steam")
		QueueEvent("RecreateComponentFromBlueprintRequest", ent, "GridMarkerComponent" )
		QueueEvent("RecreateComponentFromBlueprintRequest", ent, "MeshComponent" )
		QueueEvent("RecreateComponentFromBlueprintRequest", ent, "SelectableComponent" )
	end
end

return gas_extractor
