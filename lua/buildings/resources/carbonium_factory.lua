local building_buffable = require("lua/buildings/building_buffable.lua")

class 'carbonium_factory' ( building_buffable )

function carbonium_factory:__init()
	building_buffable.__init(self,self)
end


function carbonium_factory:OnAnimationMarker( markerName )
	--LogService:Log( "carbonium_factory: OnAnimationMarker ".. tostring(self.minedResource))
	if ( self.minedResource == nil ) then self:UpdateResource() end
	if ( markerName == "grab_rocks" ) then
		if ( self.resourceBp == nil ) then return end
		self.rock = EntityService:SpawnAndAttachEntity(self.resourceBp, self.entity,  "att_grab_rocks", "" )
		EntityService:SetScale( self.rock, 1.3, 1.3, 1.3 )		
		EntityService:FadeEntity( self.rock, DD_FADE_IN, 1 )
	elseif (  markerName =="drop_rocks" and self.rock ~= nil )then
		if ( self.rock == nil ) then return end
		EntityService:DetachEntity(self.rock)
		EntityService:CreateLifeTime(self.rock, 5.0, "normal" )
	elseif (markerName == "hammer" and self.rock ~= nil ) then
		if ( self.rock == nil ) then return end
		EntityService:DissolveEntity( self.rock, 3.5 )
		self.rock = nil;	
	end 
end

function carbonium_factory:UpdateResource() 
	--LogService:Log( "carbonium_factory: UpdateResource")
	local converter = EntityService:GetComponent( self.entity, "ResourceConverterComponent")
	if ( converter ~= nil ) then
		local converterHelper = reflection_helper(converter)
		self.minedResource = converterHelper.last_ore_produced
		if ( self.minedResource == "") then self.minedResource = nil end
		--self.minedResource = converter:GetField("last_ore_produced"):GetValue()
	end
	
	local shardBps = {}
	shardBps.carbonium   = "items/loot/resources/shard_carbonium"
	shardBps.steel       = "items/loot/resources/shard_steel"
	shardBps.ammonium    = "items/loot/resources/shard_ammonium"
	shardBps.cobalt      = "items/loot/resources/shard_cobalt"
	shardBps.uranium_ore = "items/loot/resources/shard_uranium"
	shardBps.palladium   = "items/loot/resources/shard_palladium"
	shardBps.titanium    = "items/loot/resources/shard_titanium"
	if ( shardBps[self.minedResource] ~= nil) then 
		self.resourceBp = shardBps[self.minedResource]
	else
		self.resourceBp = shardBps.carbonium
	end

	--LogService:Log( "carbonium_factory: UpdateResource: ".. tostring(self.minedResource) .. ", ".. tostring(self.resourceBp) .. ", ".. tostring(arg2))
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
