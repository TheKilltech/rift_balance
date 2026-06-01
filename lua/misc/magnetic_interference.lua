class 'magnetic_interference' ( LuaEntityObject )

require("lua/utils/table_utils.lua")

function magnetic_interference:__init()
	LuaEntityObject.__init(self,self)
end

function magnetic_interference:init()
	self:RegisterHandler( self.entity, "EnteredTriggerEvent", "OnEnteredTriggerEvent" )
	self:RegisterHandler( self.entity, "LeftTriggerEvent",    "OnLeftTriggerEvent" )
	self:RegisterHandler( self.entity, "DestroyRequest",      "OnDestroyRequest" )
	
	self.globalInterference = self.data:GetIntOrDefault("interference_global", 0)
	
	self.disabledEnts = {}
	
	if self.globalInterference > 0 then
		GuiService:EnableMinimapInterference()
	else
	end
end

function magnetic_interference:OnLoad()
end

function magnetic_interference:OnEnteredTriggerEvent( evt )
	if self.globalInterference == 0 then
		--PlayerService:DisableBuildMode( evt:GetOtherEntity() )
		--EffectService:AttachEffects( evt:GetOtherEntity(), "interference" )
		GuiService:EnableMinimapInterference()
		Insert(self.disabledEnts, evt:GetOtherEntity() )
	end
end

function magnetic_interference:OnLeftTriggerEvent( evt )
	if self.globalInterference == 0 then
		--PlayerService:EnableBuildMode( evt:GetOtherEntity() )
		--EffectService:DestroyEffectsByGroup( evt:GetOtherEntity(), "interference" )
		GuiService:DisableMinimapInterference()
		Remove( self.disabledEnts, evt:GetOtherEntity() )
	end
end

function magnetic_interference:OnDestroyRequest()
	self:Disable()
end

function magnetic_interference:OnRelease()
	self:Disable()
end

function magnetic_interference:Disable()
	self:UnregisterHandler( self.entity, "EnteredTriggerEvent", "OnEnteredTriggerEvent" )
	self:UnregisterHandler( self.entity, "LeftTriggerEvent",    "OnLeftTriggerEvent" )
	
	GuiService:DisableMinimapInterference()
	if self.globalInterference == 0 then
		for ent in Iter( self.disabledEnts ) do
			--PlayerService:EnableBuildMode( ent )
		end
		
		Clear( self.disabledEnts )
	end	
end

return magnetic_interference
 