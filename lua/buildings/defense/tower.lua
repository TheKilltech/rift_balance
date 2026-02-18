local building = require("lua/buildings/building.lua")

class 'tower' ( building )

function tower:__init()
	building.__init(self,self)
end

function tower:OnInit()
	self:RegisterHandler( event_sink , "DayStartedEvent", "_OnDayCycleDayStartedEvent")	
	self:RegisterHandler( event_sink , "NightStartedEvent", "_OnDayCycleNightStartedEvent")	
	self:RegisterHandler( event_sink , "SunriseStartedEvent", "_OnDayCycleSunriseStartedEvent")	
	self:RegisterHandler( event_sink , "SunsetStartedEvent", "_OnDayCycleSunsetStartedEvent")	
	self:RegisterHandler( self.entity, "ResourceMissingEvent", "OnResourceMissingEvent" ) 

	self.lightStatus = false
	
	self.data:SetFloat( "shooting", 0 )
	local timeOfDay = EnvironmentService:GetTimeOfDay()
end

function tower:OnDestroy()
	return true
end

function tower:_OnDayCycleDayStartedEvent( )
	self:OperateLight("day")
end

function tower:_OnDayCycleNightStartedEvent( )
	self:OperateLight("night")
end

function tower:_OnDayCycleSunriseStartedEvent( )
	self:OperateLight("sunrise")
end

function tower:_OnDayCycleSunsetStartedEvent( )
	self:OperateLight("sunset")
end

function tower:OnActivate()
	self:OperateLight(EnvironmentService:GetTimeOfDay())
end

function tower:OnDeactivate()
	self:OperateLight(EnvironmentService:GetTimeOfDay())
end

function tower:OnTurretEvent( evt )
end

function tower:OperateLight( time )
	if self.working == true and time ~= "day" and self.lightStatus == false then
		EffectService:AttachEffects(self.entity, "lamp")	
		self.lightStatus = true
	elseif self.working == false and self.lightStatus == true then 
		EffectService:DestroyEffectsByGroup(self.entity, "lamp")	
		self.lightStatus = false
	elseif time == "day" and self.lightStatus == true then
		EffectService:DestroyEffectsByGroup(self.entity, "lamp")	
		self.lightStatus = false
	end
end


function tower:OnResourceMissingEvent( evt )
	local resource = evt:GetResource()
	if ( resource ~= "energy" and resource ~= "ai" ) then
		EntityService:ShowTimeoutSoundEvent( INVALID_ID, 30.0, "voice_over/announcement/not_enough_ammo_tower", false )
	end
end


return tower
