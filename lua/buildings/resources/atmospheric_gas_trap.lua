local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'atmospheric_gas_trap' ( building )

function atmospheric_gas_trap:__init()
	building.__init(self,self)
end

function atmospheric_gas_trap:OnInit()
	self.resource = self.data:GetStringOrDefault("resource", "fluorine")
	self.biome    = MissionService:GetCurrentBiomeName();
	
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "biom_modifier", { enter="OnEnterBiomModifier", execute="OnUpdateBiomModifier" } )
end


function atmospheric_gas_trap:OnBuildingEnd()
	self:Recalculate()
	self:RegisterHandler( event_sink , "RecalculateModifiersEvent", "OnRecalculateModifiersEvent")
end

function atmospheric_gas_trap:OnEnterBiomModifier( state )
	state:SetDurationLimit(10)
end

function atmospheric_gas_trap:OnUpdateBiomModifier()
	self:Recalculate()
end

function atmospheric_gas_trap:OnRecalculateModifiersEvent(evt)
	self:Recalculate()
	self.fsm:ChangeState("biom_modifier")
end


function atmospheric_gas_trap:Recalculate()
	local modificator = self:GetBiomeModificator( self.biome )
	
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "biome" )
	BuildingService:SetResourceConverterEfficientyModificator( self.entity, modificator, "biome" )
end

function atmospheric_gas_trap:GetBiomeModificator(biome)
	local biomeMods = {}
	if (self.resource == "fluorine") then
		biomeMods.jungle   = 1.0
		biomeMods.desert   = 0.5
		biomeMods.acid     = 3.0
		biomeMods.magma    = 1.5
		biomeMods.metallic = 0.75
		biomeMods.caverns  = 0.75
		biomeMods.swamp    = 1.5
	elseif (self.resource == "nitrogen") then
		biomeMods.jungle   = 1.0
		biomeMods.desert   = 0.75
		biomeMods.acid     = 1.0
		biomeMods.magma    = 1.0
		biomeMods.metallic = 0.75
		biomeMods.caverns  = 1.5
		biomeMods.swamp    = 1.0
	end
	
	local modificator = biomeMods[ biome ]
	if (modificator == nil) then modificator = 1.0 end
	return modificator
end

return atmospheric_gas_trap
