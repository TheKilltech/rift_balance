local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'ore_mill' ( building )

function ore_mill:__init()
	building.__init(self,self)
end

function ore_mill:OnInit()	
	self:RegisterHandler( self.entity, "StartUpgradingEvent", "OnUpgradingStart" )
	
	self.range   = self.data:GetFloatOrDefault("range", 40)
	self.buffMod = self.data:GetFloatOrDefault("buff_modificator", 1.5)
	
	self.data:SetInt("buff_source_entity", self.entity)
	
    self.fsm = self:CreateStateMachine()
    --self.fsm:AddState( "buff", { enter="OnEnterBuff", execute="OnExecuteBuff", exit="OnExitBuff",  interval = 30 } )
    self.fsm:AddState( "buff", { enter="OnEnterBuff", exit="OnExitBuff" } )
    self.fsm:AddState( "idle", { enter="OnEnterIdle" } )
end


function ore_mill:OnActivate()
	--LogService:Log( "ore_mill: OnActivate ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("buff")
end

function ore_mill:OnDeactivate()
	--LogService:Log( "ore_mill: OnDeactivate ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function ore_mill:OnDestroy()
	--LogService:Log( "ore_mill: OnDestroy ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function ore_mill:OnSell()
	--LogService:Log( "ore_mill: OnSell ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function ore_mill:OnRelease()
	--LogService:Log( "ore_mill: OnRelease ".. self.buildingName.. " ".. tostring(self.entity) )
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", {} )
end

function ore_mill:OnBuildingEnd()
	--self.fsm:ChangeState("buff")
end

function ore_mill:OnUpgradingStart()
	--LogService:Log( "ore_mill: OnUpgradingStart ".. self.buildingName.. " ".. tostring(self.entity) )
	self.fsm:ChangeState("idle")
end

function ore_mill:OnEnterIdle()
end


function ore_mill:OnEnterBuff()
	--LogService:Log( "ore_mill: OnEnterBuff" )
	self.data:SetInt("buff_source_entity", self.entity)
	self.data:SetInt("buff_active", 1)
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", self.data )
end

function ore_mill:OnExitBuff()
	--LogService:Log( "ore_mill: OnExitBuff" )
	self.data:SetInt("buff_source_entity", self.entity)
	self.data:SetInt("buff_active", 0)
	QueueEvent("LuaGlobalEvent", event_sink, "BuffEvent", self.data )
end

return ore_mill
