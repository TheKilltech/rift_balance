require("lua/utils/table_utils.lua")

class 'research_shielding' ( LuaGraphNode )

function research_shielding:__init()
    LuaGraphNode.__init(self,self)
end

function research_shielding:init()
	Assert( self.data:HasString("damage_type"), " ERROR: no damage type in shielding.lua script database!" )
	self.damage_type = self.data:GetStringOrDefault("damage_type","")

	self.resistance_factors =
	{
		["sunburn"] = 0.0
	};

	self.version = 1
end

function research_shielding:IsReadyForResearch()
	return true
end

function research_shielding:SetResistance( entity, factor )
	EnvironmentService:SetResistance( entity, self.damage_type, factor, "shielding_item_" .. self.damage_type)
end

function research_shielding:OnResearchAcquired()
	local entities = FindService:FindEntitiesByType( "building" )
	for entity in Iter( entities ) do
		self:SetResistance(entity, 0.0)
	end
	
	entities = FindService:FindEntitiesByType( "player" )
	for entity in Iter( entities ) do
		self:SetResistance(entity, self.resistance_factors[self.damage_type] or 0.0)
	end
	
	--EnvironmentService:SetWeatherResistance( self.damage_type )
	
	self:RegisterHandler( event_sink , "StartBuildingEvent", "OnStartBuildingEvent")
	self:RegisterHandler( event_sink , "PlayerControlledEntityChangeEvent", "OnPlayerControlledEntityChangeEvent")
	self:RegisterHandler( event_sink , "ShieldEntityCreatedEvent", "OnShieldEntityCreatedEvent")
end

function research_shielding:OnStartBuildingEvent(evt)
	self:SetResistance(evt:GetEntity(), 0.0)
end

function research_shielding:OnShieldEntityCreatedEvent(evt)
	local factor = self.resistance_factors[self.damage_type] or 0.0;
	self:SetResistance(evt:GetEntity(), factor)
end

function research_shielding:OnPlayerControlledEntityChangeEvent(evt)
	if ( EntityService:IsAlive( evt:GetControlledEntity() ) ) then
		local factor = self.resistance_factors[self.damage_type] or 0.0;
		self:SetResistance(evt:GetControlledEntity(), factor)
	end
end

function research_shielding:Activated()
	if ( self.data:GetIntOrDefault("is_acquired", 0 ) == 1 ) then
		self:OnResearchAcquired()
	end
end

-- Deprecated start
function research_shielding:OnBuildingStartEvent( evt )
end
-- Deprecated end

function research_shielding:OnLoad( )
	
	if ( self.version == nil or self.version < 1 ) then
		self:UnregisterHandler( event_sink , "BuildingStartEvent", "OnBuildingStartEvent");
		self.version = 1
	end
end


return research_shielding