class 'magnetic_boulder' ( LuaEntityObject )
require("lua/utils/table_utils.lua")

function magnetic_boulder:__init()
	LuaEntityObject.__init(self,self)
end

function magnetic_boulder:init()
	self:RegisterHandler( self.entity, "EnteredTriggerEvent", "OnEnteredTriggerEvent" )
	self:RegisterHandler( self.entity, "LeftTriggerEvent", "OnLeftTriggerEvent" )
	self:RegisterHandler( self.entity, "DestroyRequest", "OnDestroyRequest" )
	
	self.disabledEnts = {}
	self.version = 1
end

function magnetic_boulder:OnLoad()
	self.version = self.version or 0
	if self.version < 1 then
		for ent in Iter( self.disabledEnts ) do
			GuiService:DisableMinimapInterference()
		end

		self.version = 1
	end
end

function magnetic_boulder:OnEnteredTriggerEvent( evt )
	PlayerService:DisableBuildMode( evt:GetOtherEntity() )
	GuiService:EnableMinimapInterference()
	Insert(self.disabledEnts, evt:GetOtherEntity() )
	--EffectService:AttachEffects( evt:GetOtherEntity(), "interference" )
end

function magnetic_boulder:OnLeftTriggerEvent( evt )
	PlayerService:EnableBuildMode( evt:GetOtherEntity() )
	GuiService:DisableMinimapInterference()
	--EffectService:DestroyEffectsByGroup( evt:GetOtherEntity(), "interference" )
	Remove( self.disabledEnts, evt:GetOtherEntity() )
end

function magnetic_boulder:OnDestroyRequest()
	EffectService:SpawnEffects(self.entity, "wreck")
	EntityService:RequestDestroyPattern( self.entity, "default", true )	
end

function magnetic_boulder:OnRelease()
	for ent in Iter( self.disabledEnts ) do
		PlayerService:EnableBuildMode( ent )
    end
	
	Clear( self.disabledEnts )
end

return magnetic_boulder
 