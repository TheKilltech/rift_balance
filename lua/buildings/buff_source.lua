local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'buff_source' ( building )

function buff_source:__init()
	building.__init(self,self)
end

function buff_source:Log( logLevel, message )
	local curLevel = 0 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local context = "buff_source ".. self.buildingName .. " ".. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function buff_source:OnInit()
	self:Log( 2, "OnInit" )
	self:RegisterHandler( self.entity, "StartUpgradingEvent", "OnUpgradingStart" )
	self:RegisterHandler( self.entity, "BuildingModifiedEvent",  "OnBuildingModifiedEvent" )
	
	self.range   = self.data:GetFloatOrDefault("range", 40)
	self.buffMod = self.data:GetFloatOrDefault("buff_modificator", -1.0)
	self.costMod = self.data:GetFloatOrDefault("buff_mod_upkeep", -1.0)
	self.buffShowName = self.data:GetStringOrDefault("buff_localization", "Buff")
	self.buffShowVal  = self.data:GetStringOrDefault("buff_display_value", "")
	self.buffShowIcon = self.data:GetStringOrDefault("buff_icon", "")
	
	self.data:SetInt("buff_source_entity", self.entity)
	
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "buff", { enter="OnEnterBuff", exit="OnExitBuff" } )
    self.fsm:AddState( "full", { enter="OnEnterFull", execute="OnExecuteFull", interval = 2 } )
    self.fsm:AddState( "idle", { enter="OnEnterIdle" } )
	
    self.fsmInfo = self:CreateStateMachine()
    self.fsmInfo:AddState( "update",  { execute="OnExecuteInfoUpdate", interval = 1 } )
    self.fsmInfo:AddState( "update2", { execute="OnExecuteInfoUpdate", interval = 30 } )
    self.fsmInfo:AddState( "idle",   { } )
	
    self:UpdateBuildingInfo()
end

function buff_source:OnLoad()
	building.OnLoad( self )
	self:Log( 2, "OnLoad" )
	
	if not self.fsmInfo then
		self.fsmInfo = self:CreateStateMachine()
		self.fsmInfo:AddState( "update",  { execute="OnExecuteInfoUpdate", interval = 1 } )
		self.fsmInfo:AddState( "update2", { execute="OnExecuteInfoUpdate", interval = 30 } )
		self.fsmInfo:AddState( "idle",   { } )
	end
    if ( self.fsm and self.fsm:GetState("full") == nil ) then
        self.fsm:AddState("full", { enter="OnEnterFull", execute="OnExecuteFull", interval = 2 } )
    end
end


function buff_source:OnActivate()
	self:Log( 2, "OnActivate" )
	self.fsm:ChangeState("buff")
	self.fsmInfo:ChangeState("update")
end

function buff_source:OnDeactivate()
	self:Log( 2, "OnDeactivate" )
	
	local statusComp = EntityService:GetComponent( self.entity, "BuildingStatusComponent")
	if ( statusComp ~= nil ) then
		local statusHelper = reflection_helper(statusComp)
		if statusHelper.status.status == 182 then -- status for storage is full (i hope); statusHelper.status.missing_resources should contain a readable string, but cannot access it
			self:Log( 3, "status full storage, ignore deactivate")
			self.fsm:ChangeState("full")
			self.fsmInfo:ChangeState("idle")
			return -- keep buff alive despite full storage disable
		end
	end
	
	self.fsm:ChangeState("idle")
	self.fsmInfo:ChangeState("update")
end

function buff_source:OnBuildingModifiedEvent() -- ToDo: remove
	self:Log( 2, "OnBuildingModifiedEvent" )
end

function buff_source:OnDestroy()
	self:Log( 2, "OnDestroy" )
	self.fsm:ChangeState("idle")
end

function buff_source:OnSell()
	self:Log( 2, "OnSell" )
	self.fsm:ChangeState("idle")
end

function buff_source:OnRelease()
	self:Log( 2, "OnRelease" )
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", {} )
	building.OnRelease( self )
end

function buff_source:OnBuildingEnd()
	self:Log( 2, "OnBuildingEnd " )
	if self.working == true then
		self.fsm:ChangeState("buff")
	else self.fsm:ChangeState("idle")
	end
end

function buff_source:OnUpgradingStart()
	self:Log( 2, "OnUpgradingStart " )
	self.fsm:ChangeState("idle")
end

function buff_source:OnExecuteInfoUpdate()
	self:UpdateBuildingInfo()
	self.fsmInfo:ChangeState("update2")
end

function buff_source:OnEnterIdle()
	self:Log( 3, "OnEnterIdle" )
	self.data:SetInt("buff_source_entity", self.entity)
	self.data:SetInt("buff_active", 0)
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", self.data )
    self:UpdateBuildingInfo()
end

function buff_source:OnEnterBuff()
	self:Log( 3, "OnEnterBuff" )
	self.data:SetInt("buff_source_entity", self.entity)
	self.data:SetInt("buff_active", 1)
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", self.data )
    self:UpdateBuildingInfo()
end

function buff_source:OnExitBuff()
	self:Log( 3, "OnExitBuff" )
    self:UpdateBuildingInfo()
end

function buff_source:OnEnterFull()
	self:Log( 3, "OnEnterFull" )
    self:UpdateBuildingInfo()
end

function buff_source:OnExecuteFull()
	local statusComp = EntityService:GetComponent( self.entity, "BuildingStatusComponent")
	if ( statusComp ~= nil ) then
		local statusHelper = reflection_helper(statusComp)
		if statusHelper.status.status ~= 182 and self.working == false  then
			self:Log( 3, "OnExecuteFull - status no longer full and not working, go idle" )
			self.fsm:ChangeState("idle")
			self.fsmInfo:ChangeState("update")
		end
	end
    self:UpdateBuildingInfo()
end

function buff_source:UpdateBuildingInfo()
	if not self.data then return end
	local valDefault = ""
	local buffStat = self.data:GetFloatOrDefault("buff_modificator", -1.0)
	if buffStat >= 0 then 
		valDefault = "Yield ".. string.format("%+.0f", (buffStat-1)*100) .. "%"
	else
		buffStat = self.data:GetFloatOrDefault("buff_mod_upkeep", -1.0)
		valDefault = "Cost ".. string.format("%+.0f", (buffStat-1)*100) .. "%"
	end
	
	local buffShowName = self.data:GetStringOrDefault("buff_localization", "Buff")
	local buffShowVal  = self.data:GetStringOrDefault("buff_display_value", valDefault)
	local buffShowIcon = self.data:GetStringOrDefault("buff_icon", "gui/hud/buttons/action_menu_upgrade_neutral")

	local rowName = "row" .. tostring(1)
	self.data:SetString("production_group.rows." .. rowName .. ".name",  buffShowName )
	self.data:SetString("production_group.rows." .. rowName .. ".icon",  buffShowIcon )
	self.data:SetString("production_group.rows." .. rowName .. ".value", buffShowVal)
	
    self.data:SetString("stat_categories", "production_group")
    self.data:SetString("production_group.rows", rowName )
end

return buff_source
