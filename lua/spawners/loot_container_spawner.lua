require("lua/units/units_utils.lua")
require("lua/utils/table_utils.lua")
require("lua/utils/reflection.lua")
class 'loot_container_spawner' ( LuaEntityObject )

function loot_container_spawner:__init()
	LuaEntityObject.__init(self,self)
end

function loot_container_spawner:init()	
	self.rarity = self.data:GetIntOrDefault( "rarity", 0 );
	self.delay = self.data:GetFloatOrDefault( "delay", 0 );
	self.aggressiveRadius = self.data:GetFloatOrDefault( "aggressive_radius", 20 )
	self:RegisterHandler( self.entity, "InteractWithEntityRequest",  "OnInteractWithEntityRequest" )
	self:RegisterHandler( self.entity, "HarvestStartEvent",   "OnHarvestStartEvent" )
	self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "wait", { from="*", enter="OnEnterWating", exit="OnExitWaiting" } )
	SetupUnitScale( self.entity, self.data )

	EntityService:SetGroup( self.entity, "loot_container");
	EntityService:Rotate( self.entity, 0.0, 1.0, 0.0, RandFloat(0.0, 360.0))

	self.activated = false
	self.spawner_version = 1
end

function loot_container_spawner:OnLoad()
	
	--LogService:Log( "loot_container_spawner:OnLoad" )	

	if ( self.activated == nil ) then
		self.activated = false
	elseif ( self.activated and not self.spawner_version ) then
		EntityService:SpawnAndAttachEntity( "spawners/loot_container_spawner_disarmed", self.entity );
	end

	if ( self.aggressiveRadius == nil ) then
		self.aggressiveRadius = self.data:GetFloatOrDefault( "aggressive_radius", 20 )
	end

	self.spawner_version = 1
end

function loot_container_spawner:OnInteractWithEntityRequest( evt )

	local owner = evt:GetOwner()
	local playerId = PlayerService:GetPlayerByMech( owner )

	local blueprintName = EntityService:GetBlueprintName(self.entity)

	if string.find(blueprintName, "metallic" ) ~= nil then
		CampaignService:UpdateAchievementProgress(ACHIEVEMENT_OPEN_METALLIC_BIOANOMALLY, 1, playerId )
	elseif string.find(blueprintName, "caverns" ) ~= nil then
		CampaignService:UpdateAchievementProgress(ACHIEVEMENT_OPEN_CAVERNS_BIOANOMALLY, 1, playerId )
	elseif string.find(blueprintName, "poogret_poo" ) ~= nil then
		CampaignService:UpdateAchievementProgress(ACHIEVEMENT_COLLECT_RESOURCES_FROM_POO, 1, playerId )
	end

	local playerReferenceComponent = EntityService:GetComponent( owner, "PlayerReferenceComponent")
	if ( playerReferenceComponent ) then
		local forcedGroup = self.data:GetStringOrDefault( "forced_group", "" )
		if ( forcedGroup ~= "" ) then
			QueueEvent("ForceLootContainerTypeRequest", self.entity,	forcedGroup )
		end
		
	end

	EntityService:DestroyEntity( self.entity, "default" )

	local params = { target = tostring( EntityService:GetName( self.entity ) ) }
	QueueEvent( "LuaGlobalEvent", event_sink, "BioanomalyClose", params )
end

function loot_container_spawner:SpawnWaveLogicFiles( waveLogic, waveLogicMul, spawnDistance, ignoreWater )
	if ( ResourceManager:ResourceExists( "FlowGraphTemplate", waveLogic ) ) then
		--LogService:Log( "loot_container_spawner:OnHarvestStartEvent - exist : " .. tostring( waveLogic ) )
		local spawnPoint = UnitService:CreateDynamicSpawnPoints( self.entity, spawnDistance, waveLogicMul, ignoreWater )

		for i = 1, #spawnPoint do
			if ( spawnPoint[i] ~= INVALID_ID ) then
				self.data:SetString( "spawn_point", EntityService:GetName( spawnPoint[i] ) )
				MissionService:ActivateMissionFlow( "", waveLogic, "default", self.data )

				local pathCleaner = EntityService:SpawnEntity( "misc/path_cleaner", self.entity, "" )
				local db = EntityService:GetDatabase( pathCleaner )			
				db:SetString( "to_entity", tostring( spawnPoint[i] ) )
				db:SetString( "from_entity", tostring( self.entity ) )

			else
				LogService:Log( "loot_container_spawner:OnHarvestStartEvent - could not create a spawn point." )
			end
		end

		return true
	elseif ( waveLogic ~= "error" ) then
		LogService:Log( "loot_container_spawner:OnHarvestStartEvent - file does not exist : " .. waveLogic )
	end

	return false
end

function loot_container_spawner:OnHarvestStartEvent( evt )
	if ( self.activated == false ) then
		self.activated = true

		local waveLogic			= self.data:GetStringOrDefault( "wave_logic_file",  "error" )
		local bossLogic			= self.data:GetStringOrDefault( "boss_logic_file",  "error" )
		local waveLogicMul		= self.data:GetIntOrDefault( "wave_logic_file_mul",  1 )
		local bossLogicMul		= self.data:GetIntOrDefault( "boss_logic_file_mul",  0 )
		local waterOverride		= self.data:GetIntOrDefault( "water_override", 0 )
		local waveSpawnDistance = self.data:GetIntOrDefault( "wave_spawn_distance",  40 )

		local ignoreWater = false

		if ( waterOverride == 1 ) then
			ignoreWater = true
		end

		local exist1 = self:SpawnWaveLogicFiles( waveLogic, waveLogicMul, waveSpawnDistance, ignoreWater )
		local exist2 = self:SpawnWaveLogicFiles( bossLogic, bossLogicMul, waveSpawnDistance, ignoreWater )
		if ( exist1 or exist2 ) then
		
			local params = { target = tostring( EntityService:GetName( self.entity ) ) }
			QueueEvent( "LuaGlobalEvent", event_sink, "BioanomalyOpen", params )	

			local waveEffect	= self.data:GetStringOrDefault( "wave_started_effect", "" )
			if waveEffect ~= "" then
				EffectService:SpawnEffect(self.entity,waveEffect);
			end

			EntityService:SpawnAndAttachEntity( "spawners/loot_container_spawner_disarmed", self.entity );
				end

		if ( self.delay > 0) then
			local entity = EntityService:SpawnEntity( "props/special/loot_containers/loot_container_delayer", self.entity, "")
			local db = EntityService:GetDatabase( entity )
			db:SetFloat( "delay", self.delay )
			db:SetFloat( "aggressive_radius", self.aggressiveRadius )
		end
	else
		LogService:Log( "loot_container_spawner:OnHarvestStartEvent - already activated." )
	end
end

return loot_container_spawner