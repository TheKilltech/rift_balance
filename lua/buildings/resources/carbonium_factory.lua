local building = require("lua/buildings/building.lua")

class 'carbonium_factory' ( building )

function carbonium_factory:__init()
	building.__init(self,self)
end


function carbonium_factory:OnAnimationMarker( markerName )
	if ( markerName == "grab_rocks" ) then
		self.rock = EntityService:SpawnAndAttachEntity("buildings/resources/carbonium_factory_shard", self.entity,  "att_grab_rocks", "" )
		EntityService:SetScale( self.rock, 1.3, 1.3, 1.3 )		
		EntityService:FadeEntity( self.rock, DD_FADE_IN, 1 )
	elseif (  markerName =="drop_rocks" and self.rock ~= nil and EntityService:IsAlive( self.rock ) )then
		EntityService:DetachEntity(self.rock)
		EntityService:CreateLifeTime(self.rock, 5.0, "normal" )
	elseif (markerName == "hammer" and self.rock ~= nil and EntityService:IsAlive( self.rock )) then
		EntityService:DissolveEntity( self.rock, 3.5 )
		self.rock = nil;	
	end 
end

function carbonium_factory:OnDestroy()
	if ( self.rock ~= nil ) then
		if ( EntityService:IsAlive( self.rock ) ) then
			EntityService:DissolveEntity( self.rock, 3.5 )
		end
		self.rock = nil;
	end
end

--function carbonium_factory:OnInit()
--	self:RegisterHandler( self.entity, "AnimationMarkerReached",  "OnAnimationMarkerReached" ) 
--end
--
--function carbonium_factory:OnAnimationMarkerReached(evt)
--	if ( evt:GetMarkerName() == "grab_rocks" ) then
--		EffectService:AttachEffects(self.entity, "grab_rocks")
--	end 
--	if ( evt:GetMarkerName() == "hammer" ) then
--		EffectService:AttachEffects(self.entity, "hammer")
--	end 	
--	if ( evt:GetMarkerName() == "hatch" ) then
--		EffectService:AttachEffects(self.entity, "hatch")
--	end 		
--end

return carbonium_factory
