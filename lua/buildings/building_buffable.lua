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
	
    self.fsmInfo = self:CreateStateMachine()
    self.fsmInfo:AddState( "update",  { execute="OnExecuteInfoUpdate", interval = 1 } )
    self.fsmInfo:AddState( "update2", { execute="OnExecuteInfoUpdate", interval = 30 } )
    self.fsmInfo:AddState( "idle",   { } )
	
	self:UpdateBuildingInfo( self.buffSource )
end


function building_buffable:OnBuildingEnd()
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": OnBuildingEnd" )
	self:FindBestBuffSource()
end

function building_buffable:OnLuaGlobalEvent( event )
	if event:GetEvent() == "BuffEvent" then
		self:OnBuffEvent( event ) 
	end
end

function building_buffable:OnBuffEvent( event ) 
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": buff event for ".. self.buildingName.. " - ".. tostring(event))
	local source = {}
	source.buffName    = event:GetDatabase():GetStringOrDefault("buff_source_name", "")
	source.entity      = event:GetDatabase():GetIntOrDefault("buff_source_entity", 0)
	source.modificator = event:GetDatabase():GetFloatOrDefault("buff_modificator", -1.0)
	source.modUpkeep   = event:GetDatabase():GetFloatOrDefault("buff_mod_upkeep", -1.0)
	source.level       = event:GetDatabase():GetIntOrDefault("buff_source_level", -1)
	source.isActive    = event:GetDatabase():GetIntOrDefault("buff_active", -1)
	source.buffRange   = event:GetDatabase():GetFloatOrDefault("range", 0)
	source.pos         = EntityService:GetPosition( source.entity )
	source.bp          = EntityService:GetBlueprintName( source.entity )
	
	if source.modificator < 0 then source.modificator = nil end
	if source.modUpkeep < 0   then source.modUpkeep = nil   end
	
	if self.buffSource ~= nil and (self.buffSource.entity == source.entity or source.entity == 0) then
		if source.isActive <= 0 then
			self.buffSource = nil
			self:FindBestBuffSource()
			return
		end
	end
	
	if (self:IsValidBuffSource( source, true )) then
		self:UpdateBuffState (source)
	end
end

function building_buffable:OnActivate()
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": OnActivate" )
	
	self:FindBestBuffSource()
end

function building_buffable:OnDeactivate()
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": OnDeactivate" )   
	building_buffable:UpdateBuildingInfo( self.buffSource )
end

function building_buffable:OnExecuteInfoUpdate()
	self:UpdateBuildingInfo( self.buffSource )
	self.fsmInfo:ChangeState("update2")
end

function building_buffable:IsValidBuffSource( source, compareToCurrent )
	if not source           then return false end
	if source.isActive == 0 then return false end
	if not compareToCurrent then compareToCurrent = false end
	
	local dist = Distance( source.pos, EntityService:GetPosition( self.entity ))
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": IsValidBuffSource - active ".. tostring(source.isActive)  .. ", source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level)..", distance ".. tostring(dist))
	
	if dist > source.buffRange then
		--LogService:Log( "building_buffable ".. tostring(self.entity)..": buff source is too far away")
		return false
	end
		
	if self.buffRequiredName ~= "" then
		if self.buffRequiredName ~= source.buffName then return false end
		if self.buffRequiredLevel > source.level    then return false end
	end
	
	if compareToCurrent and self.buffSource ~= nil and self.buffSource.level >= source.level then
		--LogService:Log( "building_buffable ".. tostring(self.entity)..": buff source is worse then current")
		return false
	end
	return true
end

function building_buffable:FindBestBuffSource( ) 
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": FindBestBuffSource" )   
	local best = nil
	local buffBps = Split( self.data:GetStringOrDefault("buff_buildings",  "buildings/resources/ore_mill"), "," )
	for bp in Iter(buffBps) do
		local entities = FindService:FindEntitiesByBlueprintInRadius( self.entity, bp, self.maxBuffDistance or 30)
		--LogService:Log( "building_buffable ".. tostring(self.entity)..": by bp ".. tostring(#entities) .. " in range ".. tostring(self.maxBuffDistance))
		
		for ent in Iter(entities ) do
			if ( not BuildingService:IsBuildingFinished( ent ))		then goto continue end
			
			local data = EntityService:GetDatabase( ent )
			local source = {}
			source.entity      = ent
			source.buffName    = data:GetStringOrDefault("buff_source_name", "")
			source.modificator = data:GetFloatOrDefault("buff_modificator", -1.0)
			source.modUpkeep   = data:GetFloatOrDefault("buff_mod_upkeep", -1.0)
			source.level       = data:GetIntOrDefault("buff_source_level", -1)
			source.isActive    = data:GetIntOrDefault("buff_active", -1)
			source.buffRange   = data:GetFloatOrDefault("range", 0)
			source.pos         = EntityService:GetPosition( ent )
			source.bp          = EntityService:GetBlueprintName( ent )
			
			if source.modificator < 0 then source.modificator = nil end
			if source.modUpkeep < 0   then source.modUpkeep = nil   end
			if (self:IsValidBuffSource( source )) then
				best = source
		        --LogService:Log( "building_buffable ".. tostring(self.entity)..": new current best ".. tostring(best))
			end
			::continue::
		end
	end
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": best found ".. tostring(best))
	
	self:UpdateBuffState( best ) 
	return best
end

function building_buffable:UpdateBuffState( source ) 
	--LogService:Log( "building_buffable ".. tostring(self.entity)..": UpdateBuffState" )
	self.buffSource = source
	--self.buffSource.updateTime = os.time()
	
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "buff" )
	BuildingService:RemoveConverterCostModifier( self.entity, "buff" )
	
	self:UpdateBuildingInfo( source )
	self.fsmInfo:ChangeState("update")
	
	if ( self.buffSource == nil ) then
		if ( self.buffRequiredName ~= "" ) then
			BuildingService:DisableBuilding( self.entity )
			
			if not self.reqIconBp then
				local data = EntityService:GetDatabase( self.entity )
				self.reqIconBp = data:GetStringOrDefault("buff_required_bp", "buildings/resources/ore_mill_missing_icon")
			end
			if (self.missing_effect or INVALID_ID) == INVALID_ID then
				self.missing_effect = EntityService:SpawnAndAttachEntity( self.reqIconBp, self.entity, "att_missing_buff", "")
			end
		end
		--LogService:Log( "building_buffable ".. tostring(self.entity)..": no buff source")
	else 
		if (self.missing_effect or INVALID_ID) ~= INVALID_ID then
			EntityService:RemoveEntity( self.missing_effect )
			self.missing_effect = nil
		end
		BuildingService:EnableBuilding( self.entity )
		--LogService:Log( "building_buffable ".. tostring(self.entity)..": new buff source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level))
		if source.modificator then
			BuildingService:SetResourceConverterEfficientyModificator( self.entity, source.modificator , "buff" )
		end
		if source.modUpkeep then
			BuildingService:AddConverterCostModifier( self.entity, source.modUpkeep , "buff" )
		end
		
	end
end

function building_buffable:UpdateBuildingInfo( source )
	local valDefault = ""
	if source ~= nil then
		valDefault = string.format("%+.0f", ((source.modificator or source.modUpkeep)-1)*100) .. "%"
		if source.modificator then
			valDefault = "Yield ".. valDefault
		else valDefault = "Cost ".. valDefault
		end
	else
		if (self.buffRequiredLevel or -1) >= 0 then valDefault = "required" else  valDefault = "optional" end
	end
	
	if not self.data then return end
	local buffShowName = self.data:GetStringOrDefault("buff_localization", "Buff")
	local buffShowVal  = self.data:GetStringOrDefault("buff_display_value", valDefault)
	local buffShowIcon = self.data:GetStringOrDefault("buff_icon", "gui/hud/buttons/action_menu_upgrade_neutral")

	local rowName = "row" .. tostring(1)
	self.data:SetString("local_group.rows." .. rowName .. ".name",  buffShowName )
	self.data:SetString("local_group.rows." .. rowName .. ".icon",  buffShowIcon )
	self.data:SetString("local_group.rows." .. rowName .. ".value", buffShowVal)
	self.data:SetString("stat_categories", "local_group")
	self.data:SetString("local_group.rows", rowName )
end

return building_buffable
