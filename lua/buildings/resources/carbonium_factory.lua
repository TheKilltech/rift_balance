local building = require("lua/buildings/building.lua")
require("lua/utils/reflection.lua")

class 'carbonium_factory' ( building )

function carbonium_factory:__init()
	building.__init(self,self)
end

function carbonium_factory:OnInit()
	self:RegisterHandler( self.entity, "BuffEvent",  "OnBuffEvent" ) 
	self:RegisterHandler( event_sink, "LuaGlobalEvent", "OnLuaGlobalEvent" )
	
	self.buffSource = nil
	self.maxBuffDistance = 40
end


function carbonium_factory:OnBuildingEnd()
	--LogService:Log( "carbonium_factory: OnBuildingEnd" )
	self:FindBestBuffSource()
end

function carbonium_factory:OnLuaGlobalEvent( event )
	if event:GetEvent() == "BuffEvent" then
		self:OnBuffEvent( event ) 
	end
end

function carbonium_factory:OnBuffEvent( event ) 
	--LogService:Log( "carbonium_factory: buff event for ".. tostring(self.entity).. " - ".. tostring(event))
	local source = {}
	source.entity      = event:GetDatabase():GetIntOrDefault("buff_source_entity", 0)
	source.modificator = event:GetDatabase():GetFloatOrDefault("buff_modificator", 1.0) 
	source.level       = event:GetDatabase():GetIntOrDefault("buff_source_level", 0)
	source.isActive    = event:GetDatabase():GetIntOrDefault("buff_active", 0)
	source.buffRange   = event:GetDatabase():GetFloatOrDefault("range", 0)
	source.pos         = EntityService:GetPosition( source.entity )
	source.bp          = EntityService:GetBlueprintName( source.entity )
	
	local dist = Distance( source.pos, EntityService:GetPosition( self.entity ))
	--LogService:Log( "carbonium_factory: active ".. tostring(source.isActive)  .. ", source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level)..", distance ".. tostring(dist))
	
	if dist > source.buffRange then
		--LogService:Log( "carbonium_factory: buff source is too far away")
		return
	end
	
	if self.buffSource ~= nil then
		if self.buffSource.entity == source.entity then
			if source.isActive == 0 then self.buffSource = nil end
			self:FindBestBuffSource()
			return
		end
	
		if self.buffSource.level >= source.level then
			--LogService:Log( "carbonium_factory: buff source is worse then current")
			return
		end
	end
	
	self:UpdateBuffState (source)
end

function carbonium_factory:FindBestBuffSource( ) 
	--LogService:Log( "carbonium_factory: FindBestBuffSource" )   
    local entities = FindService:FindEntitiesByBlueprintInRadius( self.entity, "buildings/resources/ore_mill", self.maxBuffDistance )
	--LogService:Log( "carbonium_factory: by bp ".. tostring(#entities) .. " in range ".. tostring(self.maxBuffDistance))
	
	local best = nil
    for ent in Iter(entities ) do
		if ( not BuildingService:IsBuildingFinished( ent ))		then goto continue end
		
		local data = EntityService:GetDatabase( ent )
		local source = {}
		source.entity      = ent
		source.modificator = data:GetFloatOrDefault("buff_modificator", 1.0) 
		source.level       = data:GetIntOrDefault("buff_source_level", 0)
		source.isActive    = data:GetIntOrDefault("buff_active", 0)
		source.buffRange   = data:GetFloatOrDefault("range", 0)
		source.pos         = EntityService:GetPosition( ent )
		source.bp          = EntityService:GetBlueprintName( ent )
		
		local dist = Distance( source.pos, EntityService:GetPosition( self.entity ))
		--LogService:Log( "carbonium_factory: in area, active ".. tostring(source.isActive)  .. ", source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level)..", distance ".. tostring(dist))
		
		if ( source.isActive == 0 ) then    goto continue end
		if ( source.buffRange < dist ) then goto continue end
		
		if ( best == nil or best.level < source.level ) then 
			best = source
			--LogService:Log( "carbonium_factory: new best source ".. source.bp .." ".. source.entity)
		end
		::continue::
    end
	
	self:UpdateBuffState( best ) 
	return best
end

function carbonium_factory:UpdateBuffState( source ) 
	--LogService:Log( "carbonium_factory: UpdateBuffState" )
	self.buffSource = source
	
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "buff" )
	if ( self.buffSource == nil ) then
		--LogService:Log( "carbonium_factory: no buff source")
	else 
		--LogService:Log( "carbonium_factory: new buff source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level))
		BuildingService:SetResourceConverterEfficientyModificator( self.entity, source.modificator , "buff" )
	end
end

function carbonium_factory:OnAnimationMarker( markerName )
	--LogService:Log( "carbonium_factory: OnAnimationMarker ".. tostring(self.minedResource))
	if ( self.minedResource == nil ) then self:UpdateResource() end
	if ( markerName == "grab_rocks" ) then
		if ( self.resourceBp == nil ) then return end
		self.rock = EntityService:SpawnAndAttachEntity(self.resourceBp, self.entity,  "att_grab_rocks", "" )
		EntityService:SetScale( self.rock, 1.3, 1.3, 1.3 )		
		EntityService:FadeEntity( self.rock, DD_FADE_IN, 1 )
	elseif (  markerName =="drop_rocks" and self.rock ~= nil )then
		if ( self.rock == nil ) then return end
		EntityService:DetachEntity(self.rock)
		EntityService:CreateLifeTime(self.rock, 5.0, "normal" )
	elseif (markerName == "hammer" and self.rock ~= nil ) then
		if ( self.rock == nil ) then return end
		EntityService:DissolveEntity( self.rock, 3.5 )
		self.rock = nil;	
	end 
end

function carbonium_factory:UpdateResource() 
	--LogService:Log( "carbonium_factory: UpdateResource")
	local converter = EntityService:GetComponent( self.entity, "ResourceConverterComponent")
	if ( converter ~= nil ) then
		local converterHelper = reflection_helper(converter)
		self.minedResource = converterHelper.last_ore_produced
		if ( self.minedResource == "") then self.minedResource = nil end
		--self.minedResource = converter:GetField("last_ore_produced"):GetValue()
	end
	
	local shardBps = {}
	shardBps.carbonium   = "items/loot/resources/shard_carbonium"
	shardBps.steel       = "items/loot/resources/shard_steel"
	shardBps.ammonium    = "items/loot/resources/shard_ammonium"
	shardBps.cobalt      = "items/loot/resources/shard_cobalt"
	shardBps.uranium_ore = "items/loot/resources/shard_uranium"
	shardBps.palladium   = "items/loot/resources/shard_palladium"
	shardBps.titanium    = "items/loot/resources/shard_titanium"
	if ( shardBps[self.minedResource] ~= nil) then 
		self.resourceBp = shardBps[self.minedResource]
	else
		self.resourceBp = shardBps.carbonium
	end

	--LogService:Log( "carbonium_factory: UpdateResource: ".. tostring(self.minedResource) .. ", ".. tostring(self.resourceBp) .. ", ".. tostring(arg2))
end
--
--function carbonium_factory:OnAnimationMarkerReached(evt)
--	if ( evt:GetMarkerName() == "grab_rocks" ) then
--		EffectService:AttachEffects(self.entity, "grab_rocks")
--	end 
--	if ( evt:GetMarkerName() == "hammer" ) then
--		EffectService:AttachEffects(self.entity, "hammer")
--	end 	
--	if ( evt:GetMarkerName() == "hatch" ) then
--		EffectService:AttachEffects(self.entity, "hatch")
--	end 		
--end

return carbonium_factory
