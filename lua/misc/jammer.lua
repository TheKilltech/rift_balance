local magnetic_interf = require("lua/misc/magnetic_interference.lua")
require("lua/utils/table_utils.lua")

class 'jammer' ( magnetic_interf )

function jammer:__init()
	magnetic_interf.__init(self,self)
end

function jammer:Log( logLevel, message )
	local curLevel = 0 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local bp = EntityService:GetBlueprintName( self.entity )
		local context = "jammer ".. bp .." ".. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function jammer:init()
	magnetic_interf.init( self )
	self:Log( 2, "OnInit" )
	
	self:RegisterHandler( self.entity, "DestroyRequest", "OnDestroyRequest" )
	
	self.range    = self.data:GetFloatOrDefault("jamming_range", 100)
	self.strength = self.data:GetFloatOrDefault("jamming_strength", 1.0)
	self.rangeMM  = self.data:GetFloatOrDefault("jamming_range_minimap", 0)
	self.isRandom = self.data:GetIntOrDefault("jamming_random_pos", 0)
	self.data:SetInt("jamming_entity", self.entity)
	--self.parent   = EntityService:GetParent(self.entity)
	EntityService:SetGroup( self.entity, "jammer")
	
	if self.isRandom > 0 then
		local spot = FindService:FindEmptySpotInRadius( self.entity, 1000.0, "", "")
		if spot.first then
			local pos = spot.second
			EntityService:SetPosition( self.entity, pos)
			self:Log(3, "random placement to pos: ".. tostring(pos.x).. " " .. tostring(pos.y).. " ".. tostring(pos.z))
		else self:Log(1, "failed to find empty spot on map for random placement")
		end
	end
	
	self:Activate()
end

function jammer:OnDestroyRequest(evt)
	self:Log( 2, "OnDestroyRequest" )
	self:Deactivate()
	magnetic_interf.OnDestroyRequest( self )
end

function jammer:OnRelease()
	self:Log( 2, "OnRelease" )
	if self.range > 0 then
		QueueEvent("LuaGlobalEvent", event_sink, "JammingEndEvent", {} )
	end
	if self.rangeMM > 0 then
		GuiService:RemoveMinimapMarker( "marker_jamming_".. tostring(self.entity) )
	end
	magnetic_interf.OnRelease( self )
end


function jammer:Activate()
	self:Log( 3, "Activate" )
	self.data:SetInt("jamming_entity", self.entity)
	self.data:SetInt("jamming_active", 1)
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEvent", self.data )
	if self.rangeMM > 0 then
		local pos = EntityService:GetPosition( self.entity )
		local color = { r = 0, g = 150, b = 200, a = 90/255 }
		GuiService:AddMinimapCircleMarker( pos, "marker_jamming_".. tostring(self.entity), self.rangeMM, color.r, color.g, color.b, color.a )
	end
end

function jammer:Deactivate()
	self:Log( 3, "Deactivate" )
	self.data:SetInt("jamming_entity", self.entity)
	self.data:SetInt("jamming_active", 0)
	QueueEvent("LuaGlobalEvent", event_sink, "JammingEndEvent", self.data )
	if self.rangeMM > 0 then
		GuiService:RemoveMinimapMarker( "marker_jamming_".. tostring(self.entity) )
	end
end

return jammer
