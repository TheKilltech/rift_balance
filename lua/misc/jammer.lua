local magnetic_interf = require("lua/misc/magnetic_interference.lua")
require("lua/utils/table_utils.lua")

class 'jammer' ( magnetic_interf )

function jammer:__init()
	magnetic_interf.__init(self,self)
end

function jammer:Log( logLevel, message )
	local curLevel = 0 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local context = "jammer ".. tostring(self.buildingName) .. " ".. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function jammer:init()
	magnetic_interf.init( self )
	self:Log( 2, "OnInit" )
	
	self:RegisterHandler( self.entity, "DestroyRequest", "OnDestroyRequest" )
	
	self.range    = self.data:GetFloatOrDefault("jamming_range", 100)
	self.strength = self.data:GetFloatOrDefault("jamming_strength", 1.0)
	--self.parent   = EntityService:GetParent(self.entity)
	
	self.data:SetInt("jamming_entity", self.entity)
	
	self:Activate()
end

function jammer:OnDestroyRequest(evt)
	self:Log( 2, "OnDestroyRequest" )
	self:Deactivate()
end

function jammer:OnRelease()
	self:Log( 2, "OnRelease" )
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEndEvent", {} )
	magnetic_interf.OnRelease( self )
end


function jammer:Activate()
	self:Log( 3, "Activate" )
	self.data:SetInt("jamming_entity", self.entity)
	self.data:SetInt("jamming_active", 1)
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEvent", self.data )
end

function jammer:Deactivate()
	self:Log( 3, "Deactivate" )
	self.data:SetInt("jamming_entity", self.entity)
	self.data:SetInt("jamming_active", 0)
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEndEvent", self.data )
end

return jammer
