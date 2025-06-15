local building = require("lua/buildings/building.lua")
require("lua/utils/reflection.lua")

class 'carbonium_factory' ( building )

function carbonium_factory:__init()
	building.__init(self,self)
end

function carbonium_factory:OnInit()
	self:RegisterHandler( self.entity, "BuffEvent",  "OnBuffEvent" ) 
	self:RegisterHandler( event_sink, "LuaGlobalEvent", "OnLuaGlobalEvent" )
end


function carbonium_factory:OnLuaGlobalEvent( event, arg1, arg2 )
	if event:GetEvent() == "BuffEvent" then
		self:OnBuffEvent( event, arg1, arg2 ) 
	end
end

function carbonium_factory:OnBuffEvent( event, arg1, arg2 ) 
	LogService:Log( "carbonium_factory: buff event! ".. tostring(event) .. ", ".. tostring(arg1) .. ", ".. tostring(arg2))
	--local entityDatabase = EntityService:GetDatabase( buildingEntity )
end

function carbonium_factory:OnAnimationMarker( markerName )	
	if ( self.resource == nil or self.resource == "") then self:UpdateResource() end
	if ( self.resource == "") then return end
	if ( markerName == "grab_rocks" ) then
		self.rock = EntityService:SpawnAndAttachEntity(self.resourceBp, self.entity,  "att_grab_rocks", "" )
		EntityService:SetScale( self.rock, 1.3, 1.3, 1.3 )		
		EntityService:FadeEntity( self.rock, DD_FADE_IN, 1 )
	elseif (  markerName =="drop_rocks" and self.rock ~= nil )then
		EntityService:DetachEntity(self.rock)
		EntityService:CreateLifeTime(self.rock, 5.0, "normal" )
	elseif (markerName == "hammer" and self.rock ~= nil ) then
		EntityService:DissolveEntity( self.rock, 3.5 )
		self.rock = nil;	
	end 
end

function carbonium_factory:UpdateResource() 
	local converter = EntityService:GetComponent( self.entity, "ResourceConverterComponent")
	if ( converter ~= nil ) then
		local converterHelper = reflection_helper(converter)
		self.resource = converterHelper.last_ore_produced
		--self.resource = converter:GetField("last_ore_produced"):GetValue()
	end
	
	local shardBps = {}
	shardBps.carbonium   = "items/loot/resources/shard_carbonium"
	shardBps.steel       = "items/loot/resources/shard_steel"
	shardBps.ammonium    = "items/loot/resources/shard_ammonium"
	shardBps.cobalt      = "items/loot/resources/shard_cobalt"
	shardBps.uranium_ore = "items/loot/resources/shard_uranium"
	shardBps.palladium   = "items/loot/resources/shard_palladium"
	shardBps.titanium    = "items/loot/resources/shard_titanium"
	if ( shardBps[self.resource] ~= nil) then 
		self.resourceBp = shardBps[self.resource]
	else
		self.resourceBp = shardBps.carbonium
	end

	LogService:Log( "carbonium_factory: UpdateResource: ".. tostring(self.resource) .. ", ".. tostring(self.resourceBp) .. ", ".. tostring(arg2))
end
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
