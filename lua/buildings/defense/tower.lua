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
	self:RegisterHandler( self.entity, "TurretEvent", "_OnTurretEvent")
	
	self.lightStatus = false
	
	self.factorStandbyUpkeep = self.data:GetFloatOrDefault("standby_upkeep_factor", 0.5)
	
		
	self.data:SetFloat( "shooting", 0 )
	local timeOfDay = EnvironmentService:GetTimeOfDay()
	BuildingService:AddConverterCostModifier( self.entity, self.factorStandbyUpkeep , "standby" )
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

local noTargetId = "4294967295" -- max uint: 2^32 - 1 or (uint)(-1)

function tower:_OnTurretEvent( evt )
	if self.factorStandbyUpkeep == 1 then return end
	local target  = evt:GetTargetEntity()
	local tstatus = evt:GetTurretStatus()
	
	if tostring(target) ~= noTargetId then
		BuildingService:RemoveConverterCostModifier( self.entity, "standby" )
	elseif tstatus == 0 then
		BuildingService:AddConverterCostModifier( self.entity, self.factorStandbyUpkeep , "standby" )
	end
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
