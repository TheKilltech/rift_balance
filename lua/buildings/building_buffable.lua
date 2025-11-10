local building = require("lua/buildings/building.lua")
require("lua/utils/reflection.lua")

class 'building_buffable' ( building )

function building_buffable:__init()
	building.__init(self,self)
end

function building_buffable:OnInit()
	self:RegisterHandler( self.entity, "BuffEvent",  "OnBuffEvent" ) 
	self:RegisterHandler( event_sink, "LuaGlobalEvent", "OnLuaGlobalEvent" )
	
	self.buffRequiredName  = self.data:GetStringOrDefault("buff_required_name", "")
	self.buffRequiredLevel = self.data:GetIntOrDefault("buff_required_level", -1)
	
	self.buffSource = nil
	self.maxBuffDistance = 40
end


function building_buffable:OnBuildingEnd()
	--LogService:Log( "building_buffable: OnBuildingEnd" )
	self:FindBestBuffSource()
end

function building_buffable:OnLuaGlobalEvent( event )
	if event:GetEvent() == "BuffEvent" then
		self:OnBuffEvent( event ) 
	end
end

function building_buffable:OnBuffEvent( event ) 
	--LogService:Log( "building_buffable: buff event for ".. self.buildingName.. " ".. tostring(self.entity).. " - ".. tostring(event))
	local source = {}
	source.buffName    = event:GetDatabase():GetStringOrDefault("buff_source_name", "")
	source.entity      = event:GetDatabase():GetIntOrDefault("buff_source_entity", 0)
	source.modificator = event:GetDatabase():GetFloatOrDefault("buff_modificator", 1.0) 
	source.level       = event:GetDatabase():GetIntOrDefault("buff_source_level", -1)
	source.isActive    = event:GetDatabase():GetIntOrDefault("buff_active", -1)
	source.buffRange   = event:GetDatabase():GetFloatOrDefault("range", 0)
	source.pos         = EntityService:GetPosition( source.entity )
	source.bp          = EntityService:GetBlueprintName( source.entity )
	
	if self.buffSource ~= nil and (self.buffSource.entity == source.entity or source.entity == 0) then
		if source.isActive <= 0 then
			self.buffSource = nil
			self:FindBestBuffSource()
			return
		end
	end
	
	if (self:IsValidBuffSource( source )) then
		self:UpdateBuffState (source)
	end
end

function building_buffable:IsValidBuffSource( source )
	if source.isActive == 0 then return false end
	
	local dist = Distance( source.pos, EntityService:GetPosition( self.entity ))
	--LogService:Log( "building_buffable: IsValidBuffSource - active ".. tostring(source.isActive)  .. ", source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level)..", distance ".. tostring(dist))
	
	if dist > source.buffRange then
		--LogService:Log( "building_buffable: buff source is too far away")
		return false
	end
		
	if self.buffRequiredName ~= "" then
		if self.buffRequiredName ~= source.buffName then return false end
		if self.buffRequiredLevel > source.level    then return false end
	end
	
	if self.buffSource ~= nil and self.buffSource.level >= source.level then
		--LogService:Log( "building_buffable: buff source is worse then current")
		return false
	end
	return true
end

function building_buffable:FindBestBuffSource( ) 
	--LogService:Log( "building_buffable: FindBestBuffSource" )   
	local best = nil
	local buffBps = Split( self.data:GetStringOrDefault("buff_buildings",  "buildings/resources/ore_mill"), "," )
	for bp in Iter(buffBps) do
		local entities = FindService:FindEntitiesByBlueprintInRadius( self.entity, bp, self.maxBuffDistance or 30)
		--LogService:Log( "building_buffable: by bp ".. tostring(#entities) .. " in range ".. tostring(self.maxBuffDistance))
		
		for ent in Iter(entities ) do
			if ( not BuildingService:IsBuildingFinished( ent ))		then goto continue end
			
			local data = EntityService:GetDatabase( ent )
			local source = {}
			source.entity      = ent
			source.buffName    = data:GetStringOrDefault("buff_source_name", "")
			source.modificator = data:GetFloatOrDefault("buff_modificator", 1.0) 
			source.level       = data:GetIntOrDefault("buff_source_level", -1)
			source.isActive    = data:GetIntOrDefault("buff_active", -1)
			source.buffRange   = data:GetFloatOrDefault("range", 0)
			source.pos         = EntityService:GetPosition( ent )
			source.bp          = EntityService:GetBlueprintName( ent )
			
			if (self:IsValidBuffSource( source )) then
				best = source
		        --LogService:Log( "building_buffable: new current best ".. tostring(best))
			end
			::continue::
		end
	end
	--LogService:Log( "building_buffable: best found ".. tostring(best))
	
	self:UpdateBuffState( best ) 
	return best
end

function building_buffable:UpdateBuffState( source ) 
	--LogService:Log( "building_buffable: UpdateBuffState" )
	self.buffSource = source
	
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "buff" )
	if ( self.buffSource == nil ) then
		if ( self.buffRequiredName ~= "" ) then
			BuildingService:DisableBuilding( self.entity )
		end
		--LogService:Log( "building_buffable: no buff source")
	else 
		BuildingService:EnableBuilding( self.entity )
		--LogService:Log( "building_buffable: new buff source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level))
		BuildingService:SetResourceConverterEfficientyModificator( self.entity, source.modificator , "buff" )
	end
end

return building_buffable
