require("lua/utils/find_utils.lua")

class 'entity_spawn_single' ( LuaGraphNode )

function entity_spawn_single:__init()
    LuaGraphNode.__init(self, self)
end

function entity_spawn_single:init()
	self.entityGroup = self.data:GetString( "entity_group" )
	self.entityName  = self.data:GetString( "entity_name" )
	if self.entityName ~= "" and self.data:GetIntOrDefault("name_is_global", 1) == 0 then
		self.entityName = self.parent:CreateGraphUniqueString(self.entityName)
	end

	self.searchTargetType  = self.data:GetString("search_target_type")
    self.searchTargetValue = self.data:GetString("search_target_value")

    self.targetFindType    = self.data:GetString("find_type") 
	self.targetFindValue   = self.data:GetString("find_value") 
	
    if self.searchTargetType == "LocalName" then
		self.searchTargetType = "Name"
		self.searchTargetValue = self.parent:CreateGraphUniqueString(self.searchTargetValue)
	end

    if self.targetFindType == "LocalName" then
		self.targetFindType = "Name"
		self.targetFindValue = self.parent:CreateGraphUniqueString(self.targetFindValue)
	end
	LogService:Log( "spawn entity: init - " .. tostring(self.entityName) .. " " .. tostring(self.entityGroup))
end

function entity_spawn_single:Activated()
	local blueprint  = self.data:GetString( "blueprint" )
	local team       = self.data:GetString( "team" )
	local minTime    = self.data:GetIntOrDefault("min_life_time", 0)
	local maxTime    = self.data:GetIntOrDefault("max_life_time", 0)
	local lifeTime   = math.random( minTime, maxTime )

	local targetAttachment  = self.data:GetStringOrDefault( "target_attachment", "" )
	local attach            = self.data:GetIntOrDefault("attach_entity", 0)
	local singleTarget      = self.data:GetIntOrDefault("target_single", 0)
	local searchRadius      = self.data:GetFloatOrDefault("search_radius", 0)
	
	LogService:Log( "spawn entity: Activated - " .. tostring(blueprint) .. " " .. tostring(self.entityName) .. " " .. tostring(self.entityGroup))
	
	self.entities = FindEntitiesByTarget(self.targetFindType, self.targetFindValue, 0.0, searchRadius, self.searchTargetType, self.searchTargetValue);
	if ( #self.entities == 0 ) then
		LogService:Log( "spawn entity: failed (target not found)")
		Assert( self.entities ~= 0, "ERROR: Spawn Entity block failed to find a target - skipping block" )
		self:SetFinished()
		return
	end
	for entity in Iter(self.entities) do
		-- Spawn entity
		if targetAttachment == "" then
			self.entityId = EntityService:SpawnEntity( blueprint, entity, team )
		else
			self.entityId = EntityService:SpawnEntity( blueprint, entity, targetAttachment, team )
		end
		-- Name the entity, but only if it is singular
		if ( self.entityName ~= "" ) then
			EntityService:SetName( self.entityId, self.entityName )
		end
	
		if ( self.entityGroup ~= "" ) then
			EntityService:SetGroup( self.entityId, self.entityGroup )
		end	

		if lifeTime > 0 then
			EntityService:CreateLifeTime( self.entityId, lifeTime, "" )
		end
		
		if ( attach == 1 ) then
			if targetAttachment == "" then
				EntityService:AttachEntity( self.entityId, entity)
			else
				EntityService:AttachEntity( self.entityId, entity, targetAttachment)
			end
			EntityService:SetPosition( self.entityId, 0, 0, 0)
		end
		
		-- If SIngle Entity Switch is enabled then break the loop here
		if singleTarget == 1 then
			self:SetFinished()
			return
		end
		
	end	
	
	self:SetFinished()
end

return entity_spawn_single