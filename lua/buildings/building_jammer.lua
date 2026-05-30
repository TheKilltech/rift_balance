local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'jammer' ( building )

function jammer:__init()
	building.__init(self,self)
end

function jammer:Log( logLevel, message )
	local curLevel = 1 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local context = "jammer ".. self.buildingName .. " ".. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function jammer:OnInit()
	self:Log( 2, "OnInit" )
	
	self.range    = self.data:GetFloatOrDefault("jamming_range", 100)
	self.strength = self.data:GetFloatOrDefault("jamming_strength", 1.0)
	
	self.data:SetInt("jamming_entity", self.entity)
	
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "jamming", { enter="OnEnterJamming", exit="OnExitJamming" } )
    self.fsm:AddState( "idle",    { enter="OnEnterIdle" } )
end

function jammer:OnLoad()
	building.OnLoad( self )
	self:Log( 2, "OnLoad" )
end


function jammer:OnActivate()
	self:Log( 2, "OnActivate" )
	self.fsm:ChangeState("jamming")
end

function jammer:OnDeactivate()
	self:Log( 2, "OnDeactivate" )
	self.fsm:ChangeState("idle")
end

function jammer:OnDestroy()
	self:Log( 2, "OnDestroy" )
	self.fsm:ChangeState("idle")
end

function jammer:OnSell()
	self:Log( 2, "OnSell" )
	self.fsm:ChangeState("idle")
end

function jammer:OnRelease()
	self:Log( 2, "OnRelease" )
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEndEvent", {} )
	building.OnRelease( self )
end

function jammer:OnBuildingEnd()
	self:Log( 2, "OnBuildingEnd " )
	if self.working == true then
		self.fsm:ChangeState("jamming")
	else self.fsm:ChangeState("idle")
	end
end

function jammer:OnEnterIdle()
	self:Log( 3, "OnEnterIdle" )
	self.data:SetInt("jamming_entity", self.entity)
	self.data:SetInt("jamming_active", 0)
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEndEvent", self.data )
end

function jammer:OnEnterJamming()
	self:Log( 3, "OnEnterJamming" )
	self.data:SetInt("jamming_entity", self.entity)
	self.data:SetInt("jamming_active", 1)
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEvent", self.data )
end

function jammer:OnExitJamming()
	self:Log( 3, "OnExitJamming" )
end

function jammer:OnEnterFull()
	self:Log( 3, "OnEnterFull" )
end


return jammer
