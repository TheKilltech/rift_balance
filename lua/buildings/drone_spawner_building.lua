require("lua/utils/table_utils.lua")
require("lua/utils/string_utils.lua")

local building = require("lua/buildings/building.lua")
class 'drone_spawner_building' ( building )

local DRONE_SPAWNER_BUILDING_REMOVE_OPERATE_ACTION_MENU = 1
local DRONE_SPAWNER_BUILDING_CURRENT_VERSION = DRONE_SPAWNER_BUILDING_REMOVE_OPERATE_ACTION_MENU

local DRONE_FADE_TIME = 0.3

function drone_spawner_building:__init()
	building.__init(self,self)
end

function drone_spawner_building:FillInitialParams()
	local database = EntityService:GetBlueprintDatabase( self.entity ) or self.data;
	self.drone_search_radius = database:GetFloatOrDefault("drone_search_radius", database:GetFloatOrDefault("radius", 25.0));
	self.drone_attachments = database:GetStringOrDefault( "drone_attachments", "att_landing" )
	self.drone_per_attachment = database:GetIntOrDefault( "drone_per_spot", 2 )
	self.drones_visible = database:GetIntOrDefault( "drone_visible_on_spot", 1 ) == 1
	self.drone_blueprint = database:GetStringOrDefault( "drone_blueprint", "error" )
end

function drone_spawner_building:OnInit()
	self.drones = {}
	self.drones_visible = true
	self.version = DRONE_SPAWNER_BUILDING_CURRENT_VERSION
	self:FillInitialParams();
end

function drone_spawner_building:SpawnLandingSpots()
	if ( self.drone_landing_spots == nil or #self.drone_landing_spots == 0 ) then
		self.drone_landing_spots = {}

		local attachments = Split( self.drone_attachments, "," )
		for spot in Iter( attachments ) do
			local entity = EntityService:SpawnAndAttachEntity(self.entity, spot );
			Insert(self.drone_landing_spots, entity);
		end
	end
end

function drone_spawner_building:OnOperateActionMenuEvent()
end

function drone_spawner_building:OnLoad()
	--self.version = self.version or 0
	--if self.version < DRONE_SPAWNER_BUILDING_REMOVE_OPERATE_ACTION_MENU then
	--	self:UnregisterHandler( self.entity, "OperateActionMenuEvent", "OnOperateActionMenuEvent")
--
	--	self.version = DRONE_SPAWNER_BUILDING_REMOVE_OPERATE_ACTION_MENU
	--end
	self:FillInitialParams();
	self:SpawnLandingSpots();
	self:SpawnDrones()

	building.OnLoad(self)
end

function drone_spawner_building:UpdateActiveDrones(drone, active)
	if active then
		QueueEvent( "EnableDroneRequest", drone )
	else
		QueueEvent( "DisableDroneRequest", drone )
	end

	local drones_achievement = _G["drones_achievement"] or { drones = {}, triggered = false }
	if active then
		drones_achievement.drones[ drone ] = true

		local drones_count = 0
		for drone,_ in pairs(drones_achievement.drones) do
			drones_count = drones_count + 1
		end

		if not drones_achievement.triggered and drones_count >= 50 then
			drones_achievement.triggered = true
			CampaignService:UnlockAchievement( ACHIEVEMENT_I_AM_THE_SWARM )
		end
	else
		drones_achievement.drones[ drone ] = nil
	end

	_G["drones_achievement"] = drones_achievement
end

function drone_spawner_building:OnBuildingEnd()
	self:SpawnLandingSpots()
	self:SpawnDrones()
end

function drone_spawner_building:OnActivate()
	for drone in Iter( self.drones ) do
		self:UpdateActiveDrones(drone, true)
	end
end

function drone_spawner_building:OnDeactivate()
	for drone in Iter( self.drones ) do
		self:UpdateActiveDrones(drone, false)
	end
end

function drone_spawner_building:SpawnDrones()
	self:CleanupDrones();

	local isActive = self.working;

	local blueprints = Split( self.drone_blueprint, ",") 
	
	local droneIdx = 0;
	for attachment in Iter( self.drone_landing_spots ) do
		for i=1,self.drone_per_attachment do
			local drone_blueprint = blueprints[ (droneIdx % #blueprints) + 1 ]
			local drone = EntityService:SpawnEntity( drone_blueprint, attachment, EntityService:GetTeam(self.entity) )
			EntityService:SetScale( drone, 0.75,0.75,0.75 )

			UnitService:SetCurrentTarget( drone, "owner", attachment )
			if self.drones_visible then
				EntityService:FadeEntity( drone, DD_FADE_IN, DRONE_FADE_TIME )
			else
				QueueEvent( "FadeEntityOutRequest", drone, 1, true )
			end
			
			self:RegisterHandler( drone, "DroneLandingStartedEvent", "_OnDroneLandingStartedEvent" )
			self:RegisterHandler( drone, "DroneLandingEndedEvent", "_OnDroneLandingEndedEvent" )
			self:RegisterHandler( drone, "DroneLiftingStartedEvent", "_OnDroneLiftingStartedEvent" )
			self:RegisterHandler( drone, "DroneLiftingEndedEvent", "_OnDroneLiftingEndedEvent" )
			self:DroneSpawned( drone )

			local database = EntityService:GetDatabase( drone )
			database:SetInt("drone_id", droneIdx )
			database:SetFloat("drone_search_radius", self.drone_search_radius )
			droneIdx = droneIdx + 1
			Insert( self.drones, drone )

			self:UpdateActiveDrones( drone, isActive )
		end
	end
end

function drone_spawner_building:CleanupDrones( skipReleaseEvents )

	for drone in Iter( self.drones ) do
		self:UpdateActiveDrones(drone, false)

		if ( not skipReleaseEvents ) then
			self:UnregisterHandler( drone, "DroneLandingStartedEvent", "_OnDroneLandingStartedEvent" )
			self:UnregisterHandler( drone, "DroneLandingEndedEvent", "_OnDroneLandingEndedEvent" )
			self:UnregisterHandler( drone, "DroneLiftingStartedEvent", "_OnDroneLiftingStartedEvent" )
			self:UnregisterHandler( drone, "DroneLiftingEndedEvent", "_OnDroneLiftingEndedEvent" )
		end
		QueueEvent( "EmitStateMachineEventRequest", drone, "state_dead" )
		QueueEvent( "DissolveEntityRequest", drone, 0.5, 0.0 )
	end

	Clear(self.drones)
end

function drone_spawner_building:OnSellStart()
	self:CleanupDrones()
end

function drone_spawner_building:OnOverride()
	self:CleanupDrones()
end

function drone_spawner_building:OnRemove()
	self:CleanupDrones( true )
end

function drone_spawner_building:_OnDroneLiftingStartedEvent(evt)
	if not self.drones_visible then
		EntityService:FadeEntity( evt:GetEntity(), DD_FADE_IN, DRONE_FADE_TIME )
	end

	self:OnDroneLiftingStarted(evt:GetEntity())
end

function drone_spawner_building:_OnDroneLandingStartedEvent(evt)
	self:OnDroneLandingStarted(evt:GetEntity())
end

function drone_spawner_building:_OnDroneLiftingEndedEvent(evt)
	self:OnDroneLiftingEnded(evt:GetEntity())
end

function drone_spawner_building:_OnDroneLandingEndedEvent(evt)
	if not self.drones_visible then
		QueueEvent( "FadeEntityOutRequest", evt:GetEntity(), 1.0, true )
	end

	self:OnDroneLandingEnded(evt:GetEntity())
end

function drone_spawner_building:OnDroneLiftingStarted( )
end

function drone_spawner_building:OnDroneLandingStarted( )
end

function drone_spawner_building:DroneSpawned( drone )
end

function drone_spawner_building:OnDroneLiftingEnded( )
end

function drone_spawner_building:OnDroneLandingEnded( )
end

return drone_spawner_building
