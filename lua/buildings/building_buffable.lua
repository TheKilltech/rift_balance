local building = require("lua/buildings/building.lua")
require("lua/utils/reflection.lua")
require("lua/utils/table_utils.lua")

class 'building_buffable' ( building )


function building_buffable:__init()
	building.__init(self,self)
end

function building_buffable:Log( logLevel, message )
	local curLevel = 0 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local context = "building_buffable ".. self.buildingName .. " " .. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function building_buffable:OnInit()
	self:Log( 2, "OnInit" )
	self:RegisterHandler( self.entity, "BuffEvent",  "OnBuffEvent" ) 
	self:RegisterHandler( event_sink, "LuaGlobalEvent", "OnLuaGlobalEvent" )
	
	self:InitVariables()
	self:UpdateBuildingInfo()
end

function building_buffable:OnLoad()
	building.OnLoad( self )
	self:Log( 2, "OnLoad" )
	
	self:InitVariables()
end

function building_buffable:InitVariables()
	local buildingComponent = EntityService:GetComponent(self.entity, "BuildingComponent")
	local bp   = buildingComponent.bp or "missing"
	local data = EntityService:GetBlueprintDatabase( bp ) or self.data;
	self.buffableVersion   = self.buffableVersion or 1
	self.buffRequiredName  = data:GetStringOrDefault("buff_required_name", "")
	self.buffRequiredLevel = data:GetIntOrDefault("buff_required_level", -1)
	self.buffReqIconBp     = data:GetStringOrDefault("buff_required_bp", "effects/missing_buff_icon")
	self.buffParticipation = data:GetFloatOrDefault("buff_participation", 1.0)
	self.buffModMax        = data:GetFloatOrDefault("buff_mod_max", 9999)
	self.buffModUpkeepMin  = data:GetFloatOrDefault("buff_mod_upkeep_min", 0)
		
	self.buffBlueprints    = Split( data:GetStringOrDefault("buff_buildings",  "none"), "," )
	
	self:Log( 3, "InitVariables: req name: ".. tostring(self.buffRequiredName) .. " req level: ".. tostring(self.buffRequiredLevel) .. " req icon: ".. tostring(self.buffReqIconBp) .. " #buff-buildings: ".. tostring(self.buffBlueprints))
	
	if not self.fsmInfo then
		self.fsmInfo = self:CreateStateMachine()
		self.fsmInfo:AddState( "update",  { execute="OnExecuteInfoUpdate", interval = 1 } )
		self.fsmInfo:AddState( "update2", { execute="OnExecuteInfoUpdate", interval = 30 } )
		self.fsmInfo:AddState( "idle",   { } )
	end
	
	local isMultiBuffVersion = false
	local buffSources = {}
	if self.buffSource ~= nil and self.buffSource.buffName ~= nil then -- old version case storing a single source -> convert
		buffSources[self.buffSource.buffName] = self.buffSource
	elseif self.buffSource and next(self.buffSource) then
		isMultiBuffVersion = true
	end
	if not isMultiBuffVersion then
		self.buffSource = buffSources
	end
	
	--if not self.buffsInfo then ... end
	self:InitBuffsInfo()
end

function building_buffable:InitBuffsInfo()
	--self.buffInfoUndef = {
	--	showIcon = "gui/hud/buttons/action_menu_upgrade_neutral",
	--	showName = "Buff",
	--	range    = 0
	--}
	self.buffsInfo = {}
	for bp in Iter(self.buffBlueprints) do
		local bpData = EntityService:GetBlueprintDatabase(bp)
		if bpData then
			local name = bpData:GetStringOrDefault("buff_source_name", "")
			if name ~= "" then
				if not self.buffsInfo[name] then
					self.buffsInfo[name] = {
						showIcon = bpData:GetStringOrDefault("buff_icon", "gui/hud/buttons/action_menu_upgrade_neutral"),
						showName = bpData:GetStringOrDefault("buff_localization", "Buff"),
						range    = bpData:GetFloatOrDefault("range", 0)
					}
				else 
					self.buffsInfo[name].range = math.max( self.buffsInfo[name].range, bpData:GetFloatOrDefault("range", 0))
				end
			end
		end
	end
end


function building_buffable:OnBuildingEnd()
	self:Log( 2, "OnBuildingEnd" )
	-- self:FindBestBuffSource( ) -- not needed; OnActivate is called eventually instead
end

function building_buffable:OnLuaGlobalEvent( event )
	if event:GetEvent() == "BuffEvent" then
		self:OnBuffEvent( event ) 
	end
end

function building_buffable:OnBuffEvent( event ) 
	self:Log( 2, "OnBuffEvent - ".. tostring(event))
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
	
	if not Contains(self.buffBlueprints, source.bp) then return end
	
	if source.modificator < 0 then source.modificator = nil end
	if source.modUpkeep < 0   then source.modUpkeep = nil   end
	
	if self.buffSource[source.buffName] ~= nil then
		local findNew = false
		if ((source.entity or 0) == 0) then
			findNew = true
		elseif (self.buffSource[source.buffName].entity == source.entity) and not self:IsValidBuffSource( source ) then
			findNew = true
		end
		if findNew then
			self.buffSource[source.buffName] = {}
			self:FindBestBuffSource( self.buffSource ) -- passing buffSource makes sure the wiped buff is updated in case FindBest does not find an alternative
			return
		end
	end
	
	if (self:IsValidBuffSource( source, true )) then
		local list = {}
		list[source.buffName] = source
		self:UpdateBuffState ( list )
	end
end

function building_buffable:OnActivate()
	self:Log( 2, "OnActivate" )	
	self:FindBestBuffSource()
end

function building_buffable:OnDeactivate()
	self:Log( 2, "OnDeactivate" )
	self:UpdateBuildingInfo()
end

function building_buffable:OnExecuteInfoUpdate()
	self:UpdateBuildingInfo()
	self.fsmInfo:ChangeState("update2")
end

function building_buffable:IsValidBuffSource( source, compareToCurrent )
	if not source           then return false end
	if source.isActive == 0 then return false end
	if not compareToCurrent then compareToCurrent = false end
	
	local dist = Distance( source.pos, EntityService:GetPosition( self.entity ))
	self:Log( 5, "IsValidBuffSource - active ".. tostring(source.isActive)  .. ", source ".. source.bp .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level)..", distance ".. tostring(dist))
	
	if dist > source.buffRange then
		self:Log( 5, "buff source is too far away")
		return false
	end
		
	if self.buffRequiredName == source.buffName then
		if self.buffRequiredLevel > source.level then return false end
	end

	if compareToCurrent and self.buffSource[source.buffName] ~= nil and (self.buffSource[source.buffName].level or -1) >= source.level then
		self:Log( 5, "buff ".. source.buffName .. " source is worse then current")
		return false
	end
	return true
end

function building_buffable:FindBestBuffSource( baseBuffs )
	self:Log( 2, "FindBestBuffSource" )   
	local best = baseBuffs or {}
	for bp in Iter(self.buffBlueprints) do
		local maxDist  = self.maxBuffDistance or 46
		local entities = FindService:FindEntitiesByBlueprintInRadius( self.entity, bp, maxDist)
		self:Log( 5, "by bp ".. tostring(#entities) .. " in range ".. tostring(maxDist))
		
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
				best[source.buffName] = source -- needs to be a distinguished by buffName to support multi-buffs
		        self:Log( 6, "new current best ".. tostring(best))
			end
			::continue::
		end
	end
	self:Log( 2, "best found ".. self:BuffsToString(best))
	
	self:UpdateBuffState( best )  
	return best
end

function building_buffable:UpdateBuffState( buffSources ) 
	self:Log( 2, "UpdateBuffState" )
	
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "buff" ) -- for downwards compatibility
	BuildingService:RemoveConverterCostModifier( self.entity, "buff" )
	for buffName, source in pairs(buffSources) do
		BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, buffName )
		BuildingService:RemoveConverterCostModifier( self.entity, buffName )
		
		self.buffSource[buffName] = source
		
		if (source.entity or 0) == 0  then
			if ( buffName == self.buffRequiredName ) then
				BuildingService:DisableBuilding( self.entity )
				
				if not self.buffReqIconBp then
					self.buffReqIconBp = self.data:GetStringOrDefault("buff_required_bp", "effects/missing_buff_icon")
				end
				if (self.missing_effect or INVALID_ID) == INVALID_ID then
					self.missing_effect = EntityService:SpawnAndAttachEntity( self.buffReqIconBp, self.entity, "att_missing_buff", "")
				end
			end
			self:Log( 2, "buff ".. tostring(buffName).. " no source")
		else 
			if (self.missing_effect or INVALID_ID) ~= INVALID_ID then
				EntityService:RemoveEntity( self.missing_effect )
				self.missing_effect = nil
			end
			BuildingService:EnableBuilding( self.entity )
			self:Log( 2, "new buff ".. tostring(buffName) .. " source ".. tostring(source.bp) .. " " ..tostring(source.entity) .. ", level ".. tostring(source.level))
			
			self.buffParticipation = (self.buffParticipation or 1)
			if source.modificator then
				local mod = math.min( 1 + self.buffParticipation * (source.modificator - 1),  self.buffModMax)
				BuildingService:SetResourceConverterEfficientyModificator( self.entity, mod , source.buffName )
			end
			if source.modUpkeep then
				local mod = math.max( 1 + self.buffParticipation * (source.modUpkeep - 1),  self.buffModUpkeepMin)
				BuildingService:AddConverterCostModifier( self.entity, mod , source.buffName )
			end
		end
	end
	
	self:UpdateBuildingInfo()
	self.fsmInfo:ChangeState("update")
end

function building_buffable:UpdateBuildingInfo()
	local rowNr = 0
	local rowName = ""
	local rowsAll = nil
	
	for buffName, buffInfo in pairs(self.buffsInfo) do
		local source = self.buffSource[buffName] or {}
	
		local buffShowVal = nil
		local mod = (source.modificator or source.modUpkeep)
		if mod ~= nil then
			mod = 1 + (self.buffParticipation or 1) * (mod - 1)
			buffShowVal = string.format("%+.0f", (mod-1)*100) .. "%"
			if source.modificator then
				buffShowVal = "Yield ".. buffShowVal
			else buffShowVal = "Cost ".. buffShowVal
			end
		else
			if self.buffRequiredName == buffName and (self.buffRequiredLevel or -1) >= 0 then
				buffShowVal = "required"
			else buffShowVal = "optional"
			end
		end
		buffShowVal = buffShowVal or self.data:GetStringOrDefault("buff_display_value", "")
		
		rowNr = rowNr + 1
		rowName = "row" .. tostring(rowNr)
		if rowsAll == nil then 
			rowsAll = rowName
		else rowsAll = rowsAll .. "," .. rowName
		end
		
		self.data:SetString("local_group.rows." .. rowName .. ".name",  buffInfo.showName )
		self.data:SetString("local_group.rows." .. rowName .. ".icon",  buffInfo.showIcon )
		self.data:SetString("local_group.rows." .. rowName .. ".value", buffShowVal)
		
		local buffConstrText
		if (self.buffParticipation or 1.0) ~= 1.0 then
			buffConstrText = "gui/hud/buff_participation"
			buffShowVal = string.format("%.0f", self.buffParticipation*100) .. "%"
		
			rowNr = rowNr + 1
			rowName = "row" .. tostring(rowNr)
			self.data:SetString("local_group.rows." .. rowName .. ".name",  buffConstrText )
			self.data:SetString("local_group.rows." .. rowName .. ".icon",  buffInfo.showIcon )
			self.data:SetString("local_group.rows." .. rowName .. ".value", buffShowVal)
			self.data:SetString("stat_categories", "local_group")
			self.data:SetString("local_group.rows", rowName )
			rowsAll = rowsAll .. "," .. rowName
		end
		
		if (self.buffModMax or 9999) ~= 9999 then
			buffConstrText = "gui/hud/buff_mod_max"
			buffShowVal = string.format("%+.0f", (self.buffModMax - 1)*100) .. "%"
		
			rowNr = rowNr + 1
			rowName = "row" .. tostring(rowNr)
			self.data:SetString("local_group.rows." .. rowName .. ".name",  buffConstrText )
			self.data:SetString("local_group.rows." .. rowName .. ".icon",  buffInfo.showIcon )
			self.data:SetString("local_group.rows." .. rowName .. ".value", buffShowVal)
			self.data:SetString("stat_categories", "local_group")
			self.data:SetString("local_group.rows", rowName )
			rowsAll = rowsAll .. "," .. rowName
		end
		
		if (self.buffModUpkeepMin or 0) ~= 0 then
			buffConstrText = "gui/hud/buff_mod_upkeep_min"
			buffShowVal = string.format("%.0f", (self.buffModUpkeepMin - 1)*100) .. "%"
		
			rowNr = rowNr + 1
			rowName = "row" .. tostring(rowNr)
			self.data:SetString("local_group.rows." .. rowName .. ".name",  buffConstrText )
			self.data:SetString("local_group.rows." .. rowName .. ".icon",  buffInfo.showIcon )
			self.data:SetString("local_group.rows." .. rowName .. ".value", buffShowVal)
			self.data:SetString("stat_categories", "local_group")
			self.data:SetString("local_group.rows", rowName )
			rowsAll = rowsAll .. "," .. rowName
		end
	end
	
	self.data:SetString("stat_categories", "local_group")
	self.data:SetString("local_group.rows", rowsAll or "")
end

function building_buffable:BuffsToString( buffSources )
	local str = "{"
	for buffName, source in pairs(buffSources) do
		str = str .. tostring(buffName) .. " " .. tostring(source.entity) .. " (".. tostring(source.bp) .."),  "
	end
	return str .. "}"
end

return building_buffable
