local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'buff_source' ( building )

function buff_source:__init()
	building.__init(self,self)
end

function buff_source:OnInit()
	self:RegisterHandler( self.entity, "StartUpgradingEvent", "OnUpgradingStart" )
	
	self.range   = self.data:GetFloatOrDefault("range", 40)
	self.buffMod = self.data:GetFloatOrDefault("buff_modificator", -1.0)
	self.costMod = self.data:GetFloatOrDefault("buff_mod_upkeep", -1.0)
	self.buffShowName = self.data:GetStringOrDefault("buff_localization", "Buff")
	self.buffShowVal  = self.data:GetStringOrDefault("buff_display_value", "")
	self.buffShowIcon = self.data:GetStringOrDefault("buff_icon", "")
	
	self.data:SetInt("buff_source_entity", self.entity)
	
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "buff", { enter="OnEnterBuff", exit="OnExitBuff" } )
    self.fsm:AddState( "idle", { enter="OnEnterIdle" } )
	
    self.fsmInfo = self:CreateStateMachine()
    self.fsmInfo:AddState( "update",  { execute="OnExecuteInfoUpdate", interval = 1 } )
    self.fsmInfo:AddState( "update2", { execute="OnExecuteInfoUpdate", interval = 30 } )
    self.fsmInfo:AddState( "idle",   { } )
	
    self:UpdateBuildingInfo()
end

function buff_source:OnLoad()
	self.range   = self.data:GetFloatOrDefault("range", 40)
	self.buffMod = self.data:GetFloatOrDefault("buff_modificator", -1.0)
	self.costMod = self.data:GetFloatOrDefault("buff_mod_upkeep", -1.0)
	
	self.data:SetInt("buff_source_entity", self.entity)
end


function buff_source:OnActivate()
	--LogService:Log( "buff_source: OnActivate ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("buff")
	self.fsmInfo:ChangeState("update")
end

function buff_source:OnDeactivate()
	--LogService:Log( "buff_source: OnDeactivate ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
	self.fsmInfo:ChangeState("update")
end

function buff_source:OnDestroy()
	--LogService:Log( "buff_source: OnDestroy ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function buff_source:OnSell()
	--LogService:Log( "buff_source: OnSell ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function buff_source:OnRelease()
	--LogService:Log( "buff_source: OnRelease ".. self.buildingName.. " ".. tostring(self.entity) )
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", {} )
end

function buff_source:OnBuildingEnd()
	--LogService:Log( "buff_source: OnBuildingEnd ".. self.buildingName.. " ".. tostring(self.entity) )
	if self.working == true then
		self.fsm:ChangeState("buff")
	else self.fsm:ChangeState("idle")
	end
end

function buff_source:OnUpgradingStart()
	--LogService:Log( "buff_source: OnUpgradingStart ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function buff_source:OnExecuteInfoUpdate()
	self:UpdateBuildingInfo()
	self.fsmInfo:ChangeState("update2")
end

function buff_source:OnEnterIdle()
	--LogService:Log( "buff_source: OnEnterIdle" )
    self:UpdateBuildingInfo()
end

function buff_source:OnEnterBuff()
	--LogService:Log( "buff_source: OnEnterBuff" )
	self.data:SetInt("buff_source_entity", self.entity)
	self.data:SetInt("buff_active", 1)
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", self.data )
    self:UpdateBuildingInfo()
end

function buff_source:OnExitBuff()
	--LogService:Log( "buff_source: OnExitBuff" )
	self.data:SetInt("buff_source_entity", self.entity)
	self.data:SetInt("buff_active", 0)
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", self.data )
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
