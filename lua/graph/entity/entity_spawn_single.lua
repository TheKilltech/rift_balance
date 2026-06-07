require("lua/utils/find_utils.lua")

class 'entity_spawn_single' ( LuaGraphNode )

function entity_spawn_single:__init()
    LuaGraphNode.__init(self, self)
end

function entity_spawn_single:init()	
	self.blueprint = self.data:GetString( "blueprint" )	
	self.team = self.data:GetString( "team" )		
	
	self.entityName = self.data:GetString( "entity_name" )
	if self.entityName ~= "" and self.data:GetIntOrDefault("name_is_global", 1) == 0 then
		self.entityName = self.parent:CreateGraphUniqueString(self.entityName)
	end

	self.entityGroup = self.data:GetString( "entity_group" )	
	
	self.singleTarget = self.data:GetIntOrDefault("target_single", 0)
	self.targetAttachment = self.data:GetStringOrDefault( "target_attachment", "" )

	self.searchTargetType = self.data:GetString("search_target_type")
    self.searchTargetValue = self.data:GetString("search_target_value")

    self.targetFindType = self.data:GetString("find_type") 
	self.targetFindValue = self.data:GetString("find_value") 
	
	self.searchRadius = self.data:GetFloatOrDefault("search_radius", 0)

	self.attach = self.data:GetIntOrDefault("attach_entity", 0)
	
    if self.searchTargetType == "LocalName" then
		self.searchTargetType = "Name"
		self.searchTargetValue = self.parent:CreateGraphUniqueString(self.searchTargetValue)
	end

    if self.targetFindType == "LocalName" then
		self.targetFindType = "Name"
		self.targetFindValue = self.parent:CreateGraphUniqueString(self.targetFindValue)
	end
end

function entity_spawn_single:Activated()	
    self.entities = FindEntitiesByTarget(self.targetFindType, self.targetFindValue, 0.0, self.searchRadius, self.searchTargetType, self.searchTargetValue);
	if ( #self.entities == 0 ) then
		Assert( self.entities ~= 0, "ERROR: Spawn Entity block failed to find a target - skipping block" )
		self:SetFinished()
		return
	end
	for entity in Iter(self.entities) do
		-- Spawn entity
		if self.targetAttachment == "" then
			self.entityId = EntityService:SpawnEntity( self.blueprint, entity, self.team )
		else
			self.entityId = EntityService:SpawnEntity( self.blueprint, entity, self.targetAttachment, self.team )
		end
		-- Name the entity, but only if it is singular
		if ( entityName ~= "" ) then
			EntityService:SetName( self.entityId, self.entityName )			
		end
	
		if entityGroup ~= "" then
			EntityService:SetGroup( self.entityId, self.entityGroup )		
		end	

		if ( self.attach == 1 ) then
			if self.targetAttachment == "" then
				EntityService:AttachEntity( self.entityId, entity)
			else
				EntityService:AttachEntity( self.entityId, entity,self.targetAttachment)
			end
			EntityService:SetPosition( self.entityId, 0, 0, 0)
		end
		
		-- If SIngle Entity Switch is enabled then break the loop here
		if self.singleTarget == 1 then
			self:SetFinished()
			return
		end
		
	end	
	
	self:SetFinished()
end

return entity_spawn_single