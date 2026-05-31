class 'magnetic_interference' ( LuaEntityObject )

require("lua/utils/table_utils.lua")

function magnetic_interference:__init()
	LuaEntityObject.__init(self,self)
end

function magnetic_interference:init()
	self:RegisterHandler( self.entity, "EnteredTriggerEvent", "OnEnteredTriggerEvent" )
	self:RegisterHandler( self.entity, "LeftTriggerEvent",    "OnLeftTriggerEvent" )
	self:RegisterHandler( self.entity, "DestroyRequest",      "OnDestroyRequest" )
	
	self.disabledEnts = {}
end

function magnetic_interference:OnLoad()
end

function magnetic_interference:OnEnteredTriggerEvent( evt )
	--PlayerService:DisableBuildMode( evt:GetOtherEntity() )
	--EffectService:AttachEffects( evt:GetOtherEntity(), "interference" )
	GuiService:EnableMinimapInterference()
	Insert(self.disabledEnts, evt:GetOtherEntity() )
end

function magnetic_interference:OnLeftTriggerEvent( evt )
	--PlayerService:EnableBuildMode( evt:GetOtherEntity() )
	--EffectService:DestroyEffectsByGroup( evt:GetOtherEntity(), "interference" )
	GuiService:DisableMinimapInterference()
	Remove( self.disabledEnts, evt:GetOtherEntity() )
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
	
	for ent in Iter( self.disabledEnts ) do
		--PlayerService:EnableBuildMode( ent )
		GuiService:DisableMinimapInterference()
    end
	
	Clear( self.disabledEnts )
end

return magnetic_interference
 