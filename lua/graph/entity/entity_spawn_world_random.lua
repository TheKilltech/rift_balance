class 'entity_spawn_world_random' ( LuaGraphNode )
require("lua/utils/table_utils.lua")

function entity_spawn_world_random:__init()
    LuaGraphNode.__init(self, self)
end

function entity_spawn_world_random:init()		
end

local function FindSpawnPositions( spawnPoint, minRadius, maxRadius, minBorderRadius, maxBorderRadius, count )
	if not Assert( spawnPoint ~= INVALID_ID, "ERROR: failed to acquire player spawn point!") then
		return {}
	end

	local result = FindService:FindEmptySpotsInRadius( spawnPoint, minRadius, maxRadius, "", "", minBorderRadius, maxBorderRadius,count )
	if Assert( #result ~= 0, "ERROR: FindSpawnPosition failed to find empty spot!" ) then
		return result
	end

	return {}
end

function entity_spawn_world_random:Activated()
	local minRadius = self.data:GetFloatOrDefault("min_spawn_radius", 0)
	local maxRadius = self.data:GetFloatOrDefault("max_spawn_radius", 0)
	local count = 	  self.data:GetIntOrDefault("count", 1)

	local minBorderRadius = self.data:GetFloatOrDefault("min_border_distance", 0)
	local maxBorderRadius = self.data:GetFloatOrDefault("max_border_distance", 0)

	local spawnPoint = INVALID_ID

	local spawnTarget = self.data:GetStringOrDefault( "spawn_target", "" )
	if spawnTarget ~= "" then
		spawnPoint = FindService:FindEntityByName( spawnTarget );
		Assert( spawnPoint ~= INVALID_ID, "ERROR: failed to find entity with name: '" .. spawnTarget .. "'" )
	else
		spawnPoint = MapGenerator:GetInitialSpawnPoint()
	end

	local blueprint = self.data:GetString( "blueprint" )
	local entityName = self.data:GetString( "entity_name" )
	local entityGroup = self.data:GetString( "entity_group" )
	local team = self.data:GetStringOrDefault( "team", "" )	
	
	local pos = FindSpawnPositions( spawnPoint, minRadius, maxRadius, minBorderRadius, maxBorderRadius, count );
	if ( #pos < count ) then
		Assert(false, "ERROR: Failed to find all spots to spawn entities: '" .. blueprint .. "', spots found: " .. tostring(#pos) .. ", spots required: " .. tostring( count ) .. ". Spawning only " .. tostring(#pos) .. " entities")
		count = #pos
	end
	
	for i=1,count do
		local entity = EntityService:SpawnEntity(blueprint, pos[i].x, pos[i].y, pos[i].z, team)
		Assert( entity ~= INVALID_ID, "ERROR: failed to spawn blueprint: `" .. blueprint .. "` at [" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "]")

		if entityName ~= "" then
			EntityService:SetName( entity, entityName )		
		end

		if entityGroup ~= "" then
			EntityService:SetGroup( entity, entityGroup )
		end	
	end
	
	self:SetFinished()
end

return entity_spawn_world_random