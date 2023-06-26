require("lua/utils/table_utils.lua")

local event_manager = require( "lua/missions/event_manager.lua" )

class 'dom_mananger' ( event_manager )

function dom_mananger:__init()
    event_manager.__init(self, self)
end

function dom_mananger:init()

	-- ========================================= Configuration ======================================

	event_manager.init( self )

	self.currentDifficultyLevel = 0
	self.maxDifficultyLevel     = 9

	-- TODO
	self.wavesDisabled = DifficultyService:AreWavesDisabled()

	-- borderSpawnPointsByDirection : can be more/less
	self.borderSpawnPointGroupNames =
	{
		"spawn_enemy_border_south",
		"spawn_enemy_border_north",
		"spawn_enemy_border_east",
		"spawn_enemy_border_west"
	}

	-- ======================================== DO NOT TOUCH BELOW THE FILE ============================================

	self:RegisterHandler( event_sink, "MissionFlowDeactivatedEvent",   "OnMissionFlowDeactivatedEvent" )
	self:RegisterHandler( event_sink, "MissionFlowActivatedEvent",     "OnMissionFlowActivatedEvent" )
	self:RegisterHandler( event_sink, "BuildingStartEvent",        	   "OnBuildingStartEvent" )
	self:RegisterHandler( event_sink, "LuaGlobalEvent",       		   "OnLuaGlobalEvent" )
	self:RegisterHandler( event_sink, "RespawnFailedEvent",			   "OnRespawnFailedEvent" )
	self:RegisterHandler( event_sink, "PlayerDiedEvent",			   "OnPlayerDiedEvent" )

    self.spawner = self:CreateStateMachine()
    self.spawner:AddState( "spawn", { enter="OnEnterSpawn", execute="OnExecuteSpawn", exit= "OnExitSpawn" } )
	self.spawner:AddState( "wait", { enter="OnEnterWait", exit= "OnExitWait" } )
	self.spawner:AddState( "idle_time", { enter="OnEnterIdleTime", execute="OnExecuteIdleTime", exit= "OnExitIdleTime" } )
	self.spawner:AddState( "wait_for_spawn", { enter="OnEnterWaitForSpawn", execute="OnExecuteWaitForSpawn", exit= "OnExitWaitForSpawn" } )
	self.spawner:AddState( "streaming", { enter="OnEnterStreaming", execute="OnExecuteStreaming" } )
	self.spawner:AddState( "sleep", { enter="OnEnterSleep", exit= "OnExitSleep" } )

	self.difficultyIncrease = self:CreateStateMachine()
	self.difficultyIncrease:AddState( "difficulty_increase", { enter="OnEnterDifficultyIncrease", exit= "OnExitDifficultyIncrease" } )

	self.buildingsBuild		= {}
	self.spawnedAttacks		= {}

	self.randomNumber			           = 0
	self.timeToNextDifficultyLevelIterator = 1

	self.spawnTimer				   = 0

	self.objectivePrepareForTheAttacLogicFileName		= "objectivePrepareForTheAttacLogicFileName"
	self.objectivePrepareForTheAttacLogicFile			= "logic/missions/survival/next_attack_in.logic" -- TODO

	self.onUpgradeLogicFileName							= ""

	self:LogicFilesSanityCheck();

end

	-- ======================================== LOGIC ============================================

function dom_mananger:LogicFilesSanityCheck()

	LogService:Log( "------- LogicFilesSanityCheck ------- " )

	local failedLogicFile = {}

	for data in Iter( self.rules.buildingsUpgradeStartsLogic ) do 
		local log = "rules.buildingsUpgradeStartsLogic : " .. data.logic

		if ( ResourceManager:ResourceExists( "FlowGraphTemplate", data.logic ) ) then
			log = log .. "EXIST"
		else
			table.insert( failedLogicFile, log )
			log = log .. "NOT EXIST"
		end

		LogService:Log( log )

	end

	for data in Iter( self.rules.objectivesLogic ) do 
		local log = "rules.objectivesLogic : " .. data.name

		if ( ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
			log = log .. "EXIST"
		else
			table.insert( failedLogicFile, log )
			log = log .. "NOT EXIST"
		end

		LogService:Log( log )
	end

	for data in Iter( self.rules.wavesEntryDefinitions ) do
		local log = "rules.wavesEntryDefinitions : " .. data

		if ( ResourceManager:ResourceExists( "FlowGraphTemplate", data ) ) then
			log = log .. "EXIST"
		else
			table.insert( failedLogicFile, log )
			log = log .. "NOT EXIST"			
		end

		LogService:Log( log )
	end

	self:LogicTableCheck( self.rules.waves, "rules.waves", failedLogicFile )
	self:LogicTableCheck( self.rules.extraWaves, "rules.extraWaves", failedLogicFile )
	self:LogicTableCheck( self.rules.bosses, "rules.bosses", failedLogicFile )


	if ( #failedLogicFile > 0 ) then
		local log = ""
		for data in Iter( failedLogicFile ) do 
			log = log .. data .. " "
		end

		Assert( false, "Logic files don't exist : " .. log )
	end
end

function dom_mananger:LogicTableCheck( logicTable, logString, failedLogicFileTable )
	for i = 1, self.maxDifficultyLevel, 1 do 
		for data in Iter( logicTable[i] ) do 
			if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data ) ) then
				local log = logString .. " " .. tostring( i ) .. " : " .. data

				table.insert( failedLogicFileTable, log )
				LogService:Log( log .. " NOT EXIST" )
			end
		end
	end
end

function dom_mananger:OnLuaGlobalEvent( evt )
	
	local eventName = evt:GetEvent()
	
	if ( eventName == "FinishSurvival" ) then
		LogService:Log( "OnLuaGlobalEvent : forced closed" )
		self:CloseStream()
		self:ClosePrepareForTheAttack()
		self:SetSuspended( true )
	elseif ( eventName == "PauseDOM" ) then
		self:SetSuspended( true )
	elseif ( eventName == "ResumeDOM" ) then
		self:SetSuspended( false )
	end    
end

function dom_mananger:ClosePrepareForTheAttack()
	LogService:Log( "ClosePrepareForTheAttack : trying to close prepare fo the attack timer" )

	if ( MissionService:IsGraphActive( self.objectivePrepareForTheAttacLogicFileName ) == true ) then
		LogService:Log( "ClosePrepareForTheAttack : is active - MissionService:DeactivateMissionFlow" )
		MissionService:DeactivateMissionFlow( self.objectivePrepareForTheAttacLogicFileName )
	end
end

function dom_mananger:OnBuildingStartEvent( evt )
	
	local isUpgrading = evt:GetUpgrading();
	if ( isUpgrading == false ) then
		return
	end
	
	local buildingName = BuildingService:GetBuildingName( evt:GetEntity() );
	local upgradeTime = BuildingService:CalculateBuildTime( evt:GetEntity() )

	LogService:Log( "Upgrading building : " .. buildingName .. " in time " .. tostring( upgradeTime ) )

	for data in Iter( self.rules.buildingsUpgradeStartsLogic ) do 

		--LogService:Log( "Compare : " .. data.name .. " " .. buildingName )
		if ( data.name == buildingName ) then
			
			self:ClosePrepareForTheAttack();
		
			self.data:SetFloat( "time_max", upgradeTime )
			LogService:Log( "Activate Mission Flow : " .. data.logic )
			self:PrepareLabels( "", "label_small", 0 )
			self.onUpgradeLogicFileName = MissionService:ActivateMissionFlow( "", data.logic, "default", self.data )

			self.spawner:ChangeState( "sleep" )
		end
	end
end

function dom_mananger:OnMissionFlowDeactivatedEvent( event )

	local logicFile = event:GetName()
	
	for i = 1, #self.spawnedAttacks, 1 do 
		if self.spawnedAttacks[i] == logicFile then
			table.remove( self.spawnedAttacks, i )		
		end
	end

	if ( logicFile == self.onUpgradeLogicFileName ) then
		LogService:Log( "OnMissionFlowDeactivatedEvent : onUpgradeLogicFileName finished : " .. self.onUpgradeLogicFileName )
		self.onUpgradeLogicFileName = ""

		if ( self.spawner:GetCurrentState() == "sleep" ) then
			self.spawner:ChangeState( "idle_time" )
		end
	end

	self:CheckObjectiveLogicFile( logicFile )
end

function dom_mananger:OnMissionFlowActivatedEvent( event )

end

function dom_mananger:Activated()
	
	self.currentDifficultyLevel = 1
		 
	self.difficultyIncrease:ChangeState( "difficulty_increase" )
	
	self.spawner:ChangeState( "wait" )

end 

function dom_mananger:OnEnterDifficultyIncrease( state )
	state:SetDurationLimit( self.rules.timeToNextDifficultyLevel[self.currentDifficultyLevel] )	
end

function dom_mananger:OnExitDifficultyIncrease( state )
	
	self.timeToNextDifficultyLevelIterator = self.timeToNextDifficultyLevelIterator + 1

	if ( self.currentDifficultyLevel < self.maxDifficultyLevel ) then

		if ( self.currentDifficultyLevel < self.timeToNextDifficultyLevelIterator ) then
			self.currentDifficultyLevel = self.timeToNextDifficultyLevelIterator
		end

		LogService:Log( "OnExitDifficultyIncrease : Difficulty level : " .. tostring( self.currentDifficultyLevel ) )

		self:IncreamentEventLevel()

		self.difficultyIncrease:ChangeState( "difficulty_increase" )
	end
end

function dom_mananger:RandomizeSpawnPoint( borderSpawnPointGroupName )
	self.spawnPointPool = FindService:FindEntitiesByGroup( borderSpawnPointGroupName )
	
	if #self.spawnPointPool == 0 then
		return false;
	end

	if #self.spawnPointPool > 1 then
		repeat
			self.tempRandomNumber = RandInt( 1,#self.spawnPointPool )
		until self.tempRandomNumber ~= self.randomNumber
		self.randomNumber = self.tempRandomNumber
	else
		self.randomNumber = 1
	end
	
	local spawnPointName = EntityService:GetName( self.spawnPointPool[self.randomNumber] )
	Assert( spawnPointName ~= "", "Entity without name used as spawn point!");

	self.data:SetString( "spawn_point", spawnPointName )

	LogService:Log( "Current spawn point :" .. spawnPointName )
	return true;
end

function dom_mananger:GetWavePool()
	return self.rules.waves[self.currentDifficultyLevel]
end

function dom_mananger:GetBossPool()
	return self.rules.bosses[self.currentDifficultyLevel]
end

function dom_mananger:GetExtraWavePool()
	return self.rules.extraWaves[self.currentDifficultyLevel]
end

function dom_mananger:GetAttackCount()	
	return self.rules.maxAttackCountPerDifficulty[self.currentDifficultyLevel]
end

function dom_mananger:GetNextSpawnIntervalOnDifficultyLevel()
	return self.rules.nextSpawnIntervalOnDifficultyLevel[self.currentDifficultyLevel]
end

--------------------------------------------------- wait -------------------------------------------------

function dom_mananger:OnEnterWait( state )
	LogService:Log( "OnEnterWait" )

	self:SetSuspended( true )

	state:SetDurationLimit( 5 )
end

function dom_mananger:OnExitWait( state )
	LogService:Log( "OnExitWait" )

	if ( self.wavesDisabled == false ) then
		self.spawner:ChangeState( "streaming" )
	else
		self.spawner:ChangeState( "wait_for_spawn" )
	end
end

-------------------------------------------- wait_for_spawn -------------------------------------------------

function dom_mananger:OnEnterWaitForSpawn( state )
	
	LogService:Log( "OnEnterWaitForSpawn" )
	self.waitForSpawnTimer = self:GetNextSpawnIntervalOnDifficultyLevel()

	self.eventActivateTime	= self.waitForSpawnTimer - ( self.waitForSpawnTimer * self.idleTimeEventMul )
	self.eventActivated		= false	

	self.objectiveActivateTime	= self.waitForSpawnTimer - ( self.waitForSpawnTimer * self.idleTimeObjectiveMul )
	self.objectiveActivated		= false	

	if ( self.wavesDisabled == false ) then
		self.data:SetFloat( "time_max", self.waitForSpawnTimer )
		MissionService:ActivateMissionFlow( self.objectivePrepareForTheAttacLogicFileName, self.objectivePrepareForTheAttacLogicFile, "default", self.data )	
	end
end

function dom_mananger:OnExecuteWaitForSpawn( state, dt )
	self.waitForSpawnTimer  = self.waitForSpawnTimer - dt

	if ( self.waitForSpawnTimer < 0 ) then
		if ( self.wavesDisabled == false ) then
			self.spawner:ChangeState( "streaming" )
		else
			self.spawner:ChangeState( "wait_for_spawn" )
		end
	end

	if ( ( self.waitForSpawnTimer < self.eventActivateTime ) and ( self.eventActivated == false ) ) then
		self:StartAnEvent( "IDLE" )
		self.eventActivated = true
	end

	if ( ( self.waitForSpawnTimer < self.objectiveActivateTime ) and ( self.objectiveActivated == false ) ) then
		self:StartObjective()
		self.objectiveActivated = true
	end
end

function dom_mananger:OnExitWaitForSpawn( state )
	LogService:Log( "OnExitWaitForSpawn" )
end

--------------------------------------------------- idle_time -------------------------------------------------

function dom_mananger:OnEnterIdleTime( state )
	LogService:Log( "OnEnterIdleTime" )
	self.idleTimeTimer = self.rules.idleTimeBetweenAttacks[self.currentDifficultyLevel]
end

function dom_mananger:OnExecuteIdleTime( state, dt )
	self.idleTimeTimer  = self.idleTimeTimer - dt

	if ( self.idleTimeTimer < 0 ) then
		self.spawner:ChangeState( "wait_for_spawn" )
	end
end

function dom_mananger:OnExitIdleTime( state )
	LogService:Log( "OnExitIdleTime" )
end

--------------------------------------------------- sleep -------------------------------------------------

function dom_mananger:OnEnterSleep( state )
	LogService:Log( "OnEnterSleep - stoping base mission flow." )

	self:CloseStream()

end

function dom_mananger:OnExitSleep( state )
	LogService:Log( "OnExitSleep - resuming base mission flow." )
end

function dom_mananger:PrepareLabels( labels, labelName, labelsPercentageUse )
	self.data:SetString( "labels", labels )
	self.data:SetString( "label_name", labelName )
	self.data:SetInt( "labels_percentage_use", labelsPercentageUse )
end

function dom_mananger:SpawnWave( attackCount, borderSpawnPointGroupName, callback, log, shouldAddtoSpawnedAttacks, participants, labelName, participantsPercentageUse )
	for i = 1, attackCount do 
		local hasSpawnPoint = self:RandomizeSpawnPoint( borderSpawnPointGroupName )
		if Assert( hasSpawnPoint, "Failed to find spawn point for group: " .. borderSpawnPointGroupName ) then
			local wavePool = callback(self)

			local waveName = wavePool[RandInt( 1, #wavePool )]

			LogService:Log( log .. waveName )

			self:PrepareLabels( participants, labelName, participantsPercentageUse )

			local currentLogicFile = MissionService:ActivateMissionFlow( "", waveName, "default", self.data )
			self:SpawnWaveIndicator()				

			if ( shouldAddtoSpawnedAttacks == true ) then
				self.spawnedAttacks[#self.spawnedAttacks + 1] = currentLogicFile
			end
		end
	end

end
--------------------------------------------------- spawn -------------------------------------------------

function dom_mananger:OnEnterSpawn( state )

	LogService:Log( "OnEnterSpawn" )

	if ( self.cancelTheAttack == true ) then
		self.cancelTheAttack = false
	else
		if ( #self.spawnedAttacks <= 1 ) then	
		
			local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

			LogService:Log( "Border spawn point group :" .. borderSpawnPointGroupName )
			LogService:Log( "Difficulty Level : " .. tostring(self.currentDifficultyLevel) )

			self:SpawnWave( self:GetAttackCount(), borderSpawnPointGroupName, dom_mananger.GetWavePool, "OnEnterSpawn: Normal attack name : ", true, "", "label_small", 0 )
			self:SpawnWave( self.extraAttacks, borderSpawnPointGroupName, dom_mananger.GetExtraWavePool, "OnEnterSpawn: Extra attack name : ", true, self.participants, "label_small", self.participantsPercentageUse )

			if ( self.spawnBoss == true ) then
				self:SpawnWave( 1, borderSpawnPointGroupName, dom_mananger.GetBossPool, "OnEnterSpawn: Boss attack name : ", false, self.participants, "label_medium", self.participantsPercentageUse )
			end

			MissionService:ActivateMissionFlow( "", self.rules.wavesEntryDefinitions[self.currentDifficultyLevel], "default", self.data )			
		end
	end

	self.extraAttacks = 0
	self.spawnBoss = false
	self.participants = ""
	self.participantsPercentageUse = 0
end

function dom_mananger:OnExecuteSpawn( state, dt )
	self.spawner:ChangeState( "idle_time" )
end

function dom_mananger:OnExitSpawn( state )
	LogService:Log( "OnExitSpawn" )	
end

function dom_mananger:SpawnWaveIndicator()
	LogService:Log( "SpawnWaveIndicator" )	
	local spawnPoint = self.data:GetString( "spawn_point" )	
	local indicatorID = EntityService:SpawnEntity( "effects/messages_and_markers/wave_marker", spawnPoint, "no_team" )
	EntityService:CreateLifeTime( indicatorID, 45.0, "normal" )
end

	-- ======================================== STREAMING ============================================

function dom_mananger:OnEnterStreaming( state )

	LogService:Log( "OnEnterStreaming" )

	LogService:Log( "Current attacks count : " .. tostring( #self.spawnedAttacks ) )

	while ( #self.spawnedAttacks >= 2 ) do

		LogService:Log( "Removing extra attack : " .. tostring( self.spawnedAttacks[1] ) )

		LogService:Log( "MissionService:DeactivateMissionFlow by force : " .. self.spawnedAttacks[1] )
		MissionService:DeactivateMissionFlow( self.spawnedAttacks[1] )

		table.remove( self.spawnedAttacks, 1 )	
	end

	self:StartAnEvent( "ATTACK" )
end

function dom_mananger:OnExecuteStreaming( state )
	
	if ( ( GameStreamingService:IsInStreamEvent() == false ) or ( GameStreamingService:IsStreamingSessionStarted() == false ) ) then
		self.spawner:ChangeState( "spawn" )
	end

end


function dom_mananger:OnRespawnFailedEvent()
	LogService:Log( "Mission failed" )
    LampService:ReportGameFailed()
	MissionService:ShowEndGameHud( 5.0, false )
	local failedAction = MissionService:GetCurrentMissionFailedAction();
	if ( failedAction ~= MFA_REMAIN ) then
		MissionService:DeactivateAllFlows()
	end
end

function dom_mananger:DestroyPlayerItems( owner, playerId )
	local count = DifficultyService:GetNumberOfItemsRemovedOnDeath();

	if ( count == 0 ) then
		return
	end

	local status = CampaignService:GetMissionStatus( CampaignService:GetCurrentMissionId() )
	if ( status ~= MISSION_STATUS_IN_PROGRESS and status ~= MISSION_STATUS_NONE ) then
		return
	end

	local items = PlayerService:GetAllEquippedItemsInSlot( "LEFT_HAND", playerId )
	ConcatUnique( items, PlayerService:GetAllEquippedItemsInSlot( "RIGHT_HAND", playerId ) )   
	count = math.min( count, #items )

	local name = ""
	local lvl = ""
	for i=1,count,1 do
		local number = RandInt(1, #items)
		local entity = items[number];
		Remove( items, entity)
		name = ItemService:GetItemName( entity )
		lvl = ItemService:GetItemLevel( entity )
		EntityService:RemoveEntity( entity)
	end

end

function dom_mananger:DropPlayerItems( owner, playerId )
	local dropItemsCount = DifficultyService:GetNumberOfItemsDroppedOnDeath();
	if ( dropItemsCount == 0 ) then
		return
	end

	--local status = CampaignService:GetMissionStatus( CampaignService:GetCurrentMissionId() )
	--if ( status ~= MISSION_STATUS_IN_PROGRESS and status ~= MISSION_STATUS_NONE ) then
	--	return
	--end

	local items = PlayerService:GetAllEquippedItemsInSlot( "LEFT_HAND", playerId )
	ConcatUnique( items, PlayerService:GetAllEquippedItemsInSlot( "RIGHT_HAND", playerId ) )   
	dropItemsCount = math.min( dropItemsCount, #items )

	local dropped = {}
	local name = ""
	local lvl = ""
	for i=1,dropItemsCount,1 do
		local number = RandInt(1, #items)
		local entity = items[number];
		Insert(dropped, entity )
		Remove( items, entity)
		name = ItemService:GetItemName( entity )
		lvl = ItemService:GetItemLevel( entity )
		PlayerService:DropItem( entity, owner, owner )
	end

	if dropItemsCount >= (#items + #dropped) then
		CampaignService:UnlockAchievement(ACHIEVEMENT_LEAVING_EMPTY_HANDED);
	end
end

function dom_mananger:OnPlayerDiedEvent( evt )
	--LogService:Log("OnPlayerDiedEvent")
	self:DestroyPlayerItems(evt:GetEntity(), evt:GetPlayerId())
	self:DropPlayerItems(evt:GetEntity(), evt:GetPlayerId())
end

return dom_mananger