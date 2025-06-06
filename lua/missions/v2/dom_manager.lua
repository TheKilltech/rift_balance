require("lua/utils/table_utils.lua")
require("lua/utils/find_utils.lua")
require("lua/utils/numeric_utils.lua")

local event_manager = require( "lua/missions/v2/event_manager.lua" )

class 'dom_mananger' ( event_manager )

function dom_mananger:__init()
    event_manager.__init(self, self)
end

local function ProcessRulesTable( rules )
	local data = DeepCopy(rules)

	local ConvertLogicEntries = function( waves )
		for i,logic in ipairs( waves ) do
			if type(logic) == 'string' then
				waves[ i ] = { name = logic }
			end
		end
	end

	if data.wavesEntryDefinitions then
		ConvertLogicEntries(data.wavesEntryDefinitions)
	end

	if data.prepareAttackDefinitions then
		ConvertLogicEntries(data.prepareAttackDefinitions)
	end

	if data.waves then
		for _,difficulties in pairs( data.waves ) do
			for _,waves in ipairs( difficulties ) do
				if waves then ConvertLogicEntries(waves) end
			end
		end
	end

	if data.extraWaves then
		for _,waves in ipairs( data.extraWaves ) do
			if waves then ConvertLogicEntries(waves) end
		end
	end

	if data.bosses then
		for _,waves in pairs( data.bosses ) do
			if waves then ConvertLogicEntries(waves) end
		end
	end

	if data.multiplayerWaves then
		for _,data in pairs( data.multiplayerWaves ) do
			ConvertLogicEntries( data.waves )
		end
	end

	return data
end

function dom_mananger:init()

	-- ========================================= Configuration ======================================

	self:VerboseLog(" ------- DOM MANAGER VER 2.0 mod 0.2 ------- " )

	event_manager.init( self )

	-- borderSpawnPointsByDirection : can be more/less
	self.borderSpawnPointGroupNames =
	{
		"spawn_enemy_border_south",
		"spawn_enemy_border_north",
		"spawn_enemy_border_east",
		"spawn_enemy_border_west"
	}

	self.rules = ProcessRulesTable( self.rules )

	-- ======================================== DO NOT TOUCH BELOW THE FILE ============================================

	self.DOMEventName_FinishSurvival			= "FinishSurvival"
	self.DOMEventName_PauseDOM					= "PauseDOM"
	self.DOMEventName_ResumeDOM					= "ResumeDOM"
	self.DOMEventName_DOMMaxDifficultyLevel		= "DOMMaxDifficultyLevel"
	self.DOMEventName_DOMResumeAttacks			= "DOMResumeAttacks"
	self.DOMEventName_DOMPauseAttacks			= "DOMPauseAttacks"
	self.DOMEventName_DOMCancelUpcomingAttack	= "DOMCancelUpcomingAttack"
	self.DOMEventName_DOMForceGroupNextAttack	= "DOMForceGroupNextAttack"
	self.DOMEventName_DOMAddAttackGroup			= "DOMAddAttackGroup"
	self.DOMEventName_DOMRemoveAttackGroup		= "DOMRemoveAttackGroup"
	self.DOMEventName_DOMSendMajorAttack		= "DOMSendMajorAttack"

	self.DOMEventName_dump_dom_data				= "dump_dom_data"

	self.defaultAttackGroupName = "default"

	self:RegisterHandler( event_sink, "MissionFlowDeactivatedEvent",   "OnMissionFlowDeactivatedEvent" )
	self:RegisterHandler( event_sink, "MissionFlowActivatedEvent",     "OnMissionFlowActivatedEvent" )
	self:RegisterHandler( event_sink, "StartUpgradingEvent",  		   "OnStartUpgradingEvent" )
	self:RegisterHandler( event_sink, "LuaGlobalEvent",       		   "OnLuaGlobalEvent" )
	self:RegisterHandler( event_sink, "RespawnFailedEvent",			   "OnRespawnFailedEvent" )
	self:RegisterHandler( event_sink, "PlayerDiedEvent",			   "OnPlayerDiedEvent" )

    self.spawner = self:CreateStateMachine()
    self.spawner:AddState( "spawn",                { enter="OnEnterSpawn",                  execute="OnExecuteSpawn",                  exit="OnExitSpawn" } )
	self.spawner:AddState( "wait",                 { enter="OnEnterWait",                                                              exit="OnExitWait" } )
	self.spawner:AddState( "cooldown_after_spawn", { enter="OnEnterCooldownAfterSpawnTime", execute="OnExecuteCooldownAfterSpawnTime", exit="OnExitCooldownAfterSpawnTime" } )
	self.spawner:AddState( "prepare_spawn",        { enter="OnEnterPrepareSpawn",           execute="OnExecutePrepareSpawn",           exit="OnExitPrepareSpawn" } )
	self.spawner:AddState( "idle",                 { enter="OnEnterIdle",                   execute="OnExecuteIdle",                   exit="OnExitIdle" } )
	self.spawner:AddState( "streaming",            { enter="OnEnterStreaming",              execute="OnExecuteStreaming",              exit="OnExitStreaming" } )
	self.spawner:AddState( "sleep",                { enter="OnEnterSleep",                  execute="OnExecuteSleep",                  exit="OnExitSleep" } )
	self.spawner:AddState( "dummy_state",          { enter="OnEnterDummyState",             execute="OnExecuteDummyState",             exit="OnEnterDummyState" } )

	self.upgradeHQ = self:CreateStateMachine()
	self.upgradeHQ:AddState( "hq_entry_logic",  { enter="OnHqEnterEntryLogic",                                  exit= "OnHqExitEntryLogic" } )
	self.upgradeHQ:AddState( "hq_attack_logic", { enter="OnHqEnterAttackLogic", execute="OnExecuteAttackLogic", exit= "OnHqExitAttackLogic" } )
	self.upgradeHQ:AddState( "hq_exit_logic",   { enter="OnHqEnterExitLogic",                                   exit= "OnHqExitExitLogic" } )

	self.difficultyIncrease = self:CreateStateMachine()
	self.difficultyIncrease:AddState( "difficulty_increase", { enter="OnEnterDifficultyIncrease", exit= "OnExitDifficultyIncrease" } )

	self.currentDifficultyLevel = 0
	self.maxDifficultyLevel     = 9

	self.spawnedAttacks		= {}

	self.randomNumber			   = 0

	self.objectivePrepareForTheAttacLogicFileName		= "objectivePrepareForTheAttacLogicFileName"
	self.objectivePrepareForTheAttacLogicFile			= "logic/missions/survival/next_attack_in.logic" -- TODO

	self.preparedAttacks                = {}
	self.preparedAttackMarkers          = {}
	self.WaveRepeatState                = "streaming"
	self.WaveStateMachine               = self.spawner

	self.hqPreparedAttacks				= {}
	self.hqPreparedAttackMarkers		= {}
	self.hqLogicLevel					= {}
	self.upgradeHqWaves					= {}
	self.onUpgradeHqLogicEndFileName	= ""
	self.hqAttackSafeTime				= 600

	self.coolEventSpawnTime = {}
	self.sleepSafeTime = 1200

	self.dumpAllDifficultyInfo = true

	self.freezedDifficultyLevel = self.maxDifficultyLevel

	self.pauseAttacks = DifficultyService:AreWavesDisabled()

	if ( self.pauseAttacks == false ) then
		self.pauseAttacks = self.rules.pauseAttacks
	end
	self.prepAttacks = self.rules.prepareAttacks

	local currentDifficulty = DifficultyService:GetCurrentDifficultyName()

	if ( currentDifficulty == "sandbox" ) then
		self:VerboseLog(" sandbox mode on - pausing attacks." )	
		self.pauseAttacks = true
	end

	self.isForceAttackGroupEnabled = false
	self.forceAttackGroupName	   = self.defaultAttackGroupName

	self.availableAttackGroups = {}

	self.availableAttackGroups[#self.availableAttackGroups + 1] = self.defaultAttackGroupName
	self:LogicFilesSanityCheck();

	self.player_death_position 	 = {}

	self.version = 1
end

function dom_mananger:Update( dt)

	if ( self.debugVoteMachine == "ENTER") then
		self:OnDebugVoteStart()
		self.debugVoteTimer = GameStreamingService:GetVotingTime()
		self.debugVoteMachine = "EXECUTE";
	elseif( self.debugVoteMachine == "EXECUTE") then
		self:OnDebugVoteExecute()
		self.debugVoteTimer = self.debugVoteTimer - dt
	elseif( self.debugVoteMachine == "EXIT") then
		self:OnDebugVoteExit()
		self.debugVoteMachine = "";
	end

	if event_manager.Update then
		event_manager.Update(self)
	end

	for level in Iter( g_debug_dom_manager_spawn_wave_levels ) do
		self:SpawnWavesForDifficultyLevel(level, false)
	end

	g_debug_dom_manager_spawn_wave_levels = {}

	if not g_debug_dom_manager then
		return
	end

	local debug = "DEBUG DOM MANAGER:"
	debug = debug .. "\n"

	local difficultyState = self.difficultyIncrease:GetCurrentState()
	if difficultyState ~= "" then
		local state = self.difficultyIncrease:GetState( difficultyState )

		debug = debug .. " Current difficulty level: " .. tostring( self.currentDifficultyLevel ) .. " / " .. tostring( self.freezedDifficultyLevel ) .. "\n"
		debug = debug .. " Time to next difficulty level : " .. tostring( state:GetDurationLimit() - state:GetDuration() )
	end

	debug = debug .. "\n\n"

	local currentSpawnerState = self.spawner:GetCurrentState()
	if currentSpawnerState ~= "" then
		debug = debug .. "GLOBAL DOM STATE \n"
		debug = debug .. " " .. currentSpawnerState .. "\n"

		local state = self.spawner:GetState( currentSpawnerState )

		if ( currentSpawnerState == "wait" ) then
			debug = debug .. " Time left: " .. tostring( state:GetDurationLimit() - state:GetDuration() )
		elseif ( currentSpawnerState == "cooldown_after_spawn" ) then
			debug = debug .. " Time left: " .. tostring( self.cooldownTimer )
			if (self.rules.waveRepeatChances) then 
				local repeatChances = self.rules.waveRepeatChances[self.currentDifficultyLevel]
				local repeatChance  = repeatChances[self.waveRepeated+1] or 0
				debug = debug .. " wave repeat chance: " .. tostring( repeatChance ) .. "%,"
				debug = debug .. " repeated " .. tostring( self.waveRepeated ) .. " times, "
				if (self.waveRepeatTime > 0 ) then
					debug = debug .. " next " .. tostring( self.cooldownTimer - self.waveRepeatTime ) .. " / " .. tostring( self.rules.cooldownAfterAttacks[self.currentDifficultyLevel] - self.waveRepeatTime ) .. "\n"
				else debug = debug .. " finished\n"
				end
				if (self.coolEventSpawnTime) then
					debug = debug .. " events: " .. tostring( #self.coolEventSpawnTime ) .. " queued, "
					for i = 1, #self.coolEventSpawnTime, 1 do
						if (self.coolEventSpawnTime[i] and self.coolEventSpawnTime[i] > 0 and self.coolEventSpawnTime[i] < self.waveEventsTimer) then
							debug = debug .. " [" .. tostring(i) .. "]: " .. tostring( self.waveEventsTimer - self.coolEventSpawnTime[i] )
						end
					end		
				end				
			end
		elseif ( currentSpawnerState == "prepare_spawn" ) then
			debug = debug .. " full prepare: ".. tostring(self.prepAttacks).. ", Time left: " .. tostring( self.waitForSpawnTimer )
		elseif ( currentSpawnerState == "idle" ) then
			debug = debug .. " Time left: " .. tostring( self.idleTimer )
		elseif ( currentSpawnerState == "sleep" ) then
			debug = debug .. " Time left: " .. tostring( self.sleepSafeTime )
		end
	end



	LogService:DebugText( 50, 1000, debug);
end

function dom_mananger:OnLoad()
	self:VerboseLog("OnLoad" )

	if ( self.rulesFile ~= nil ) then
		self:VerboseLog("OnLoad - reloading rules." )

		local rulesOldPath = self.rulesFile
		local currentDifficultyName = DifficultyService:GetCurrentDifficultyName() 

		self:VerboseLog("OnLoad() : rules file path : " .. rulesOldPath )
		self:VerboseLog("OnLoad() : difficulty : " .. currentDifficultyName )

		local rulesOldPathTable = Split( rulesOldPath, "_" )
		local rulesCheckNewPath = ""

		for i = 1, #rulesOldPathTable - 1, 1 do 
			rulesCheckNewPath = rulesCheckNewPath .. rulesOldPathTable[i] .. "_"
		end
		
		rulesCheckNewPath = rulesCheckNewPath .. currentDifficultyName .. ".lua"

		self:VerboseLog("OnLoad - checking if there is a new rule : " .. rulesCheckNewPath )

		if ( rulesCheckNewPath ~= rulesOldPath ) then
			self:VerboseLog("OnLoad - old rules don't match difficulty level. Searching if new one exist" )
			if ( script_exists( rulesCheckNewPath ) == true ) then
				self:VerboseLog("OnLoad - new rules exist. Reloading." )
				self.rulesFile = rulesCheckNewPath
			else
				self:VerboseLog("OnLoad - new rules don't exist" )
			end
		else
			self:VerboseLog("OnLoad - old rules match. Nothing to load." )
		end
		
		self.rules = ProcessRulesTable( require( self.rulesFile )() )
	end

	if ( self.version == nil ) then
		self:RegisterHandler( event_sink, "StartUpgradingEvent",        	   "OnStartUpgradingEvent" )
		self:UnregisterHandler( event_sink, "BuildingStartEvent",        	   "OnBuildingStartEvent" )
		self.version = 1
	end

	self.player_death_position 	 = self.player_death_position or {}

	self.rules = ProcessRulesTable( self.rules )

	self:VerboseLog("OnLoad - current hq state : " .. tostring( self.upgradeHQ:GetCurrentState() ) )
	self:VerboseLog("OnLoad - current dom state : " .. tostring( self.spawner:GetCurrentState() ) )

	self:LogicFilesSanityCheck();

	self:FillInitialParamsEventManager()
	self:FillInitialParamsDomManager()
end

function dom_mananger:FillInitialParamsDomManager()
	for group in Iter( self.availableAttackGroups ) do 
		self.availableEventGroups[group] = true
	end
end

	-- ======================================== LOGIC ============================================

function dom_mananger:LogicFilesSanityCheck()

	self:VerboseLog(" ------- LogicFilesSanityCheck ------- " )

	local failedLogicFileTable = {}

	self:LogicEntryTableCheck( self.rules.buildingsUpgradeStartsLogic, "rules.buildingsUpgradeStartsLogic : ", failedLogicFileTable )
	self:LogicEntryTableCheck( self.rules.majorAttackLogic, "rules.majorAttackLogic : ", failedLogicFileTable )

	for data in Iter( self.rules.objectivesLogic ) do 

		if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
			local log = "rules.objectivesLogic : " .. data.name

			table.insert( failedLogicFileTable, log )
			log = log .. " NOT EXIST"
			LogService:Log( log )
		end
	end

	for data in Iter( self.rules.wavesEntryDefinitions ) do
		if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
			local log = "rules.wavesEntryDefinitions : " .. data.name

			table.insert( failedLogicFileTable, log )
			log = log .. " NOT EXIST"			
			LogService:Log( log )
		end

	end


	if ( self.rules.prepareAttackDefinitions ~= nil ) then

		if ( #self.rules.prepareAttackDefinitions ~= self.maxDifficultyLevel ) then
			Assert( false, "rules.prepareAttackDefinitions : size must equal " .. tostring( self.maxDifficultyLevel ) )
		end

		for data in Iter( self.rules.prepareAttackDefinitions ) do

			if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
				local log = "rules.prepareAttackDefinitions : " .. data.name 

				table.insert( failedLogicFileTable, log )
				log = log .. " NOT EXIST"			
				LogService:Log( log )
			end	
		end
	end

	for group, groupData in pairs( self.rules.waves ) do

		self:VerboseLog( "rules.waves : " .. tostring( group ) )

		if ( #groupData ~= 0 ) then

			if ( #groupData ~= self.maxDifficultyLevel ) then
				Assert( false, "rules.waves : " .. tostring( group ) .. " size must equal " .. tostring( self.maxDifficultyLevel ) )
			end

			for i = 1, self.maxDifficultyLevel, 1 do 
				for data in Iter( groupData[i] ) do 
					if data then
						if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
							local log = "rules.waves" .. " " .. tostring( i ) .. " : " .. data.name
							table.insert( failedLogicFileTable, log )
							log = log .. " NOT EXIST"			
							LogService:Log( log )
						end
					end
				end
			end
		end
	end

	self:LogicTableCheck( self.rules.extraWaves, "rules.extraWaves", failedLogicFileTable )
	self:LogicTableCheck( self.rules.bosses, "rules.bosses", failedLogicFileTable )

	if ( self.rules.multiplayerWaves ~= nil ) then		
		if ( #self.rules.multiplayerWaves ~= self.maxDifficultyLevel ) then
			Assert( false, "rules.multiplayerWaves size must equal " .. tostring( self.maxDifficultyLevel ) )
		end

		if self.rules.multiplayerWaves then
			for i = 1, self.maxDifficultyLevel, 1 do 
				for wave in Iter( self.rules.multiplayerWaves[i].waves ) do 
					if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", wave.name ) ) then
						local log = "rules.multiplayerWaves " .. tostring( i ) .. " : " .. wave.name
						table.insert( failedLogicFile, log )
						log = log .. " NOT EXIST"			
						LogService:Log( log )
					end
				end
			end
		end
	end

	if ( #failedLogicFileTable > 0 ) then
		local log = ""
		for data in Iter( failedLogicFileTable ) do 
			log = log .. data .. " "
		end

		Assert( false, "Logic files don't exist : " .. log )
	end
end

function dom_mananger:LogicTableCheck( logicTable, logString, failedLogicFileTable )

	if ( #logicTable ~= 0 ) then		
		if ( #logicTable ~= self.maxDifficultyLevel ) then
			Assert( false, logString .. " size must equal " .. tostring( self.maxDifficultyLevel ) )
		end

		for i = 1, self.maxDifficultyLevel, 1 do 
			for data in Iter( logicTable[i] ) do 
				if data then
					if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
						local log = logString .. " " .. tostring( i ) .. " : " .. data.name
						table.insert( failedLogicFileTable, log )
						log = log .. " NOT EXIST"			
						LogService:Log( log )
					end
				end
			end
		end
	end
end

function dom_mananger:LogicEntryTableCheck( logicTable, logString, failedLogicFileTable )
	
	if ( logicTable ~= nil ) then
		for data in Iter( logicTable ) do 

			if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.entryLogic ) ) then
				local log = logString .. data.entryLogic
				table.insert( failedLogicFileTable, log )
				log = log .. " NOT EXIST"
				LogService:Log( log )
			end

		end

		for data in Iter( logicTable ) do 
			if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.exitLogic ) ) then
				local log = logString .. data.exitLogic
				table.insert( failedLogicFileTable, log )
				log = log .. " NOT EXIST"
				LogService:Log( log )
			end
		end
	end
end

function dom_mananger:VerboseLog( message )
	--LogService:LogIf( g_verbose_dom_manager, message )
	LogService:Log( message )
end


function dom_mananger:OnDebugVoteStart()
	self.debugVoteParticipent = 0
	self.debugVoteClientAdded = false
	if ( GameStreamingService:IsStreamingSessionStarted() == false ) then
		QueueEvent("GameStreamingAddClientEvent", INVALID_ID, 0 )
		self.debugVoteClientAdded = true
	end
	self.debugVoteStarted = false
end


function dom_mananger:OnDebugVoteExecute( )
	if ( self.debugVoteStarted == false and GameStreamingService:IsStreamingSessionStarted()) then
		self.currentStreamingData = self:PrepareEvents( "IDLE" )
		self:StartStreamingVoting()
		self.debugVoteStarted = true
	end

	if ( self.debugVoteStarted ) then
		local actionIdx = RandInt( 1, #self.currentActions )
		local action = self.currentActions[actionIdx]
		QueueEvent("GameStreamingUpdateActionEvent",INVALID_ID, action, "ParticipentDebug_" .. tostring(self.debugVoteParticipent), self.debugVoteParticipent)
		self.debugVoteParticipent = self.debugVoteParticipent + 1
	end
end

function dom_mananger:OnDebugVoteExit()
	self.debugVoteParticipent = 0
	if( self.debugVoteClientAdded ) then
		QueueEvent("GameStreamingRemoveClientEvent", INVALID_ID, 0 )
		self.debugVoteClientAdded = false
	end
end

function dom_mananger:OnLuaGlobalEvent( evt )
	
	local eventName = evt:GetEvent()
	local params = evt:GetDatabase()

	if ( eventName == self.DOMEventName_FinishSurvival ) then
		self:VerboseLog( "dom_mananger:OnLuaGlobalEvent : forced closed" )
		self:CloseStream()
		self:ClosePrepareForTheAttack()
		self:SetSuspended( true )
		CampaignService:OperateDOMPlanetaryJump( true )
	elseif ( eventName == self.DOMEventName_PauseDOM ) then
		self:PauseDOM()
	elseif ( eventName == self.DOMEventName_ResumeDOM ) then
		self:ResumeDOM()
	elseif ( eventName == self.DOMEventName_DOMMaxDifficultyLevel ) then
		self:SetMaxDifficultyLevel( params:GetIntOrDefault( "max_dom_difficulty_level", self.maxDifficultyLevel ) )
	elseif ( eventName == self.DOMEventName_DOMResumeAttacks ) then
		self:ResumeAttacks()
	elseif ( eventName == self.DOMEventName_DOMPauseAttacks ) then
		self:PauseAttacks()
	elseif ( eventName == self.DOMEventName_DOMCancelUpcomingAttack ) then
		self:CancelUpcomingAttack()
	elseif ( eventName == self.DOMEventName_DOMForceGroupNextAttack ) then
		self:ForceGroupNextAttack( params:GetStringOrDefault( "group_name", "default" ) )
	elseif ( eventName == self.DOMEventName_DOMAddAttackGroup ) then
		self:AddAttackGroup( params:GetStringOrDefault( "group_name", "default" ) )
	elseif ( eventName == self.DOMEventName_DOMRemoveAttackGroup ) then
		self:RemoveAttackGroup( params:GetStringOrDefault( "group_name", "default" ) )
	elseif ( eventName == self.DOMEventName_dump_dom_data ) then
		self:DumpDomData()
	elseif ( eventName == self.DOMEventName_DOMSendMajorAttack ) then
		self:SendMajorAttack()
	elseif ( eventName == "DebugStartVote") then
		self.debugVoteMachine = "ENTER";
	end
end

function dom_mananger:DumpDomProgress( rules )
	self:VerboseLog("prepare attacks : " .. tostring( self.prepAttacks ) )
	
	local difficultyData = {}
	for i = 1, self.maxDifficultyLevel, 1 do 
		difficultyData[i] = {}
		difficultyData[i].level = i
		difficultyData[i].maxTime  = rules.timeToNextDifficultyLevel[i]
		difficultyData[i].minTime = 0

		if ( difficultyData[i].level > 1 ) then
			difficultyData[i].maxTime = difficultyData[i].maxTime + difficultyData[i-1].maxTime
			difficultyData[i].minTime = difficultyData[i-1].maxTime
		end
	end

	for i = 1, #difficultyData, 1 do 
		self:VerboseLog("difficultyData : " .. tostring( difficultyData[i].level ) .. " " .. tostring( difficultyData[i].minTime ) .. "-" .. tostring( difficultyData[i].maxTime ) )
	end

	
	local attackCounter = 1
	local difficultyLevel = 1
	local attackTime = 0
	local prepareAttackTime = 0

	if ( self:GetPauseAttacks() == false ) then
		self:VerboseLog("Attack number : 1 Time : 0 Difficulty level : 1 ");

		for i = 2, 20, 1 do
		
			
			difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
			attackTime = attackTime + rules.cooldownAfterAttacks[difficultyLevel]
			prepareAttackTime = attackTime
			difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
			attackTime = attackTime + rules.idleTime[difficultyLevel]
			prepareAttackTime = attackTime

			if ( self.prepAttacks == true ) then
				difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
			end

			attackTime = attackTime + rules.prepareSpawnTime[difficultyLevel]

			if ( self.prepAttacks == false ) then
				difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
				prepareAttackTime = attackTime
			end

			self:VerboseLog("Attack number : " .. tostring( i ) .. " Prepare time " .. tostring( prepareAttackTime ) ..  " Attack time : " .. tostring( attackTime ) ..
							"  Difficulty level : ".. tostring( difficultyLevel ) );

			if ( self.prepAttacks == true ) then
				prepareAttackTime = attackTime
			end
		 
		end
	else
		self:VerboseLog("No attacks.");
	end
end

function dom_mananger:DumpDomData()
	self:VerboseLog("DumpDomData" )
	self:VerboseLog("OnLuaGlobalEvent : current difficulty level - " .. tostring( self.currentDifficultyLevel ) )
	self:VerboseLog("OnLuaGlobalEvent : max difficulty level - " .. tostring( self.maxDifficultyLevel ) )
	self:VerboseLog("OnLuaGlobalEvent : current freezed difficulty level - " .. tostring( self.freezedDifficultyLevel ) )
	self:VerboseLog("OnLuaGlobalEvent : base time between objectives - " .. tostring( self.objectiveBaseTimeBetweenNext ) )
	self:VerboseLog("OnLuaGlobalEvent : difficulty - " .. DifficultyService:GetCurrentDifficultyName() )

	local domType = "error"
	local idleTime = self:GetIdleTime()

	if ( ( self:GetPauseAttacks() == true ) and ( idleTime > 0 ) ) then
		domType = "scout"
	elseif ( ( self:GetPauseAttacks() == true ) and ( idleTime == 0 ) ) then
		domType = "sandbox"
	elseif ( idleTime == 0 ) then
		domType = "survival"
	else
		domType = "HQ/Outpost"
	end

	self:VerboseLog("dom type: " .. domType )

	local rulesOldPathTable = Split( self.rulesFile, "_" )
	local rulesCheckNewPath = ""

	for i = 1, #rulesOldPathTable - 1, 1 do 
		rulesCheckNewPath = rulesCheckNewPath .. rulesOldPathTable[i] .. "_"
	end

	local difficultyName = 
	{
		"default",
		"easy",
		"normal",
		"hard",
		"brutal",
    }

	if ( self.dumpAllDifficultyInfo == true ) then
		for i = 1, #difficultyName, 1 do
			local path = rulesCheckNewPath .. difficultyName[i] .. ".lua"
			if ( script_exists( path ) == true ) then
				self:VerboseLog("difficulty: " .. difficultyName[i] )
				self:DumpDomProgress( ProcessRulesTable( require( path )() ) )
			else
				self:VerboseLog("difficulty: " .. difficultyName[i] .. " the same as default" )
			end
		end
	else
		self:DumpDomProgress( self.rules )
	end
end

function dom_mananger:GetDifficultyLevelFromTime( time, difficultyData )
	for i = 1, #difficultyData, 1 do
		if ( time < difficultyData[i].maxTime ) then
			return difficultyData[i].level
		end
	end

	return self.maxDifficultyLevel
end

function dom_mananger:SendMajorAttack()
	self:VerboseLog( "SendMajorAttack" )

	if ( ( self.rules.majorAttackLogic ~= nil ) and ( #self.rules.majorAttackLogic > 0 ) ) then
		self:VerboseLog( "SendMajorAttack - ready." )
		
		self:SetSuspended( false )

		self.hqLogicLevel.level       = self.rules.majorAttackLogic[1].level
		self.hqLogicLevel.prepareTime = self.rules.majorAttackLogic[1].prepareTime
		self.hqLogicLevel.entryLogic  = self.rules.majorAttackLogic[1].entryLogic
		self.hqLogicLevel.exitLogic   = self.rules.majorAttackLogic[1].exitLogic
		
		if ( self.rules.majorAttackLogic[1].minLevel ~= nil ) then
			self:VerboseLog( "SendMajorAttack - min difficulty level set to " .. tostring( self.rules.majorAttackLogic[1].minLevel ) )
			self.hqLogicLevel.minLevel    = self.rules.majorAttackLogic[1].minLevel
		end

		self:ClosePrepareForTheAttack();

		self.upgradeHQ:ChangeState( "hq_entry_logic" )
		self.spawner:ChangeState( "sleep" )
	else
		self:VerboseLog( "SendMajorAttack - rules.majorAttackLogic has no entry." )
	end
end

function dom_mananger:IsGroupWaveExist( groupName )
	for group, groupData in pairs( self.rules.waves ) do
		 if ( groupName == group ) then
			return true
		 end
	end

	return false
end

function dom_mananger:IsAvailableAttackGroupExist( groupName )
	for i = 1, #self.availableAttackGroups, 1 do 
		 if ( groupName == self.availableAttackGroups[i] ) then
			return true
		 end
	end

	return false
end

function dom_mananger:ForceGroupNextAttack( groupName )
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_DOMForceGroupNextAttack : " .. tostring( groupName ) )

	if ( self:IsGroupWaveExist( groupName ) == true ) then
		self.isForceAttackGroupEnabled = true
		self.forceAttackGroupName	   = groupName
		
		self:VerboseLog( "ForceGroupNextAttack : success - setting next attack to: " .. tostring( groupName ) )
	else
		self:VerboseLog( "ForceGroupNextAttack : failed : " .. tostring( groupName ) .. " does not exist in rules.waves" )
	end
end

function dom_mananger:AddAttackGroup( groupName )
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_DOMAddAttackGroup : " .. tostring( groupName ) )

	if ( self:IsGroupWaveExist( groupName ) == true ) then
		if ( self:IsAvailableAttackGroupExist( groupName ) == false ) then
			self:VerboseLog( "AddAttackGroup : success - adding to the wave pool : " .. tostring( groupName ) )
			self.availableAttackGroups[#self.availableAttackGroups + 1] = groupName
		else
			self:VerboseLog( "AddAttackGroup : already added : " .. tostring( groupName ) )
		end		
	else
		self:VerboseLog( "AddAttackGroup : failed : " .. tostring( groupName ) .. " does not exist in rules.waves" )
	end
	self.availableEventGroups = self.availableAttackGroups -- ToDo: testing concept. not sure how to update for now
end

function dom_mananger:RemoveAttackGroup( groupName )
	self:VerboseLog( "OnLuaGlobalEvent: DOMEventName_DOMRemoveAttackGroup : " .. tostring( groupName ) )

	if ( self:IsGroupWaveExist( groupName ) == true ) then
		if ( self:IsAvailableAttackGroupExist( groupName ) == true ) then
			self:VerboseLog( "RemoveAttackGroup : success - removing from the wave pool: " .. tostring( groupName ) )
			
			for i = 1, #self.availableAttackGroups, 1 do 
				if ( groupName == self.availableAttackGroups[i] ) then
					table.remove( self.availableAttackGroups, i )
					break
				end
			end

		else
			self:VerboseLog( "RemoveAttackGroup: not exist in the wave pool : " .. tostring( groupName ) )
		end		
	else
		self:VerboseLog( "RemoveAttackGroup : failed : " .. tostring( groupName ) .. " does not exist in rules.waves" )
	end
	self.availableEventGroups = self.availableAttackGroups -- ToDo: testing concept. not sure how to update for now
end

function dom_mananger:PauseDOM()
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_PauseDOM" )
	self:SetSuspended( true )
	CampaignService:OperateDOMPlanetaryJump( true )
end

function dom_mananger:ResumeDOM()
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_ResumeDOM" )
	self:SetSuspended( false )
end

function dom_mananger:CancelUpcomingAttack()
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_DOMCancelUpcomingAttack" )
	self.cancelTheAttack = true
	self:ClosePrepareForTheAttack()
end


function dom_mananger:PauseAttacks()
	self:VerboseLog( "OnLuaGlobalEvent : pausing attacks" )
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_DOMPauseAttacks" )
end

function dom_mananger:ResumeAttacks()
	self:VerboseLog( "OnLuaGlobalEvent : resuming attacks" )
	self:VerboseLog( "OnLuaGlobalEvent : DOMEventName_DOMPauseAttacks" )
end

function dom_mananger:SetMaxDifficultyLevel( maxDifficultyLevel )
	maxDifficultyLevel = Clamp( maxDifficultyLevel, 1, self.maxDifficultyLevel )

	self:VerboseLog( "OnLuaGlobalEvent: changing max difficulty level" )
	self:VerboseLog( "OnLuaGlobalEvent: current freezed difficulty level - " .. tostring( self.freezedDifficultyLevel ) )
	self:VerboseLog( "OnLuaGlobalEvent: current difficulty level - " .. tostring( self.currentDifficultyLevel ) )

	self.freezedDifficultyLevel = maxDifficultyLevel

	self:VerboseLog( "OnLuaGlobalEvent : changed freezed difficulty level - " .. tostring( self.freezedDifficultyLevel ) )

	if ( self.currentDifficultyLevel > self.freezedDifficultyLevel ) then
		self:VerboseLog("OnLuaGlobalEvent : current difficulty level is higher than freezed one." )

		self.currentDifficultyLevel = self.freezedDifficultyLevel

		self:VerboseLog("OnLuaGlobalEvent : current difficulty level is - " .. tostring( self.currentDifficultyLevel ) )
	end

	if ( self.currentEventLevel > self.freezedDifficultyLevel ) then
		self:VerboseLog("OnLuaGlobalEvent : current event level is higher than freezed one." )

		self.currentEventLevel = self.freezedDifficultyLevel

		self:VerboseLog("OnLuaGlobalEvent : current event level is - " .. tostring( self.currentEventLevel ) )
	end
end

function dom_mananger:ClosePrepareForTheAttack()
	self:VerboseLog("ClosePrepareForTheAttack : trying to close prepare fo the attack timer" )

	if ( MissionService:IsGraphActive( self.objectivePrepareForTheAttacLogicFileName ) == true ) then
		self:VerboseLog("ClosePrepareForTheAttack : is active - MissionService:DeactivateMissionFlow" )
		MissionService:DeactivateMissionFlow( self.objectivePrepareForTheAttacLogicFileName )
	end

	for data in Iter( self.preparedAttackMarkers ) do 
		if EntityService:IsAlive( data ) then
			EntityService:RemoveEntity( data )

			self:VerboseLog("Removing SpawnWaveIndicator : " .. tostring( data ) )

		end
	end

	self.preparedAttackMarkers = {}

	CampaignService:OperateDOMPlanetaryJump( true )
end

function dom_mananger:OnStartUpgradingEvent( evt )
	local buildingName = BuildingService:GetBuildingName( evt:GetEntity() );
	local upgradeTime = BuildingService:CalculateBuildTime( evt:GetEntity() )

	for i = 1, #self.rules.buildingsUpgradeStartsLogic, 1 do 
		if ( self.rules.buildingsUpgradeStartsLogic[i].name == buildingName ) then
			
			self:SetSuspended( false )

			self.hqLogicLevel.level       = self.rules.buildingsUpgradeStartsLogic[i].level
			self.hqLogicLevel.prepareTime = self.rules.buildingsUpgradeStartsLogic[i].prepareTime
			self.hqLogicLevel.entryLogic  = self.rules.buildingsUpgradeStartsLogic[i].entryLogic
			self.hqLogicLevel.exitLogic   = self.rules.buildingsUpgradeStartsLogic[i].exitLogic

			if ( self.rules.buildingsUpgradeStartsLogic[i].minLevel ~= nil ) then
				self:VerboseLog("Upgrading hq - min difficulty level set to " .. tostring( self.rules.buildingsUpgradeStartsLogic[i].minLevel ) )
				self.hqLogicLevel.minLevel    = self.rules.buildingsUpgradeStartsLogic[i].minLevel
			end

			self:ClosePrepareForTheAttack();

			self.upgradeHQ:ChangeState( "hq_entry_logic" )
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

	for i = 1, #self.upgradeHqWaves, 1 do 
		if self.upgradeHqWaves[i] == logicFile then
			table.remove( self.upgradeHqWaves, i )		
		end

		if ( #self.upgradeHqWaves == 0 ) then
			self.upgradeHQ:ChangeState( "hq_exit_logic" )
		end
	end

	if ( logicFile == self.onUpgradeHqLogicEndFileName ) then
		self:VerboseLog("OnMissionFlowDeactivatedEvent : onUpgradeHqLogicEndFileName finished : " .. self.onUpgradeHqLogicEndFileName )
		self.onUpgradeHqLogicEndFileName = ""
	
		if ( self.spawner:GetCurrentState() == "sleep" ) then
			self.spawner:ChangeState( "cooldown_after_spawn" )
			self.upgradeHQ:Deactivate()
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
	
	self:VerboseLog("OnExitDifficultyIncrease : Changing difficulty level." )

	if ( self.currentDifficultyLevel < self.maxDifficultyLevel ) then

		self.currentDifficultyLevel = self.currentDifficultyLevel + 1

		if ( self.currentDifficultyLevel > self.freezedDifficultyLevel ) then
			self:VerboseLog("OnExitDifficultyIncrease : Difficulty level will not rise. Clamped to  " .. tostring( self.freezedDifficultyLevel ) )
			self.currentDifficultyLevel = self.freezedDifficultyLevel
		end

		self:VerboseLog("OnExitDifficultyIncrease : Difficulty level : " .. tostring( self.currentDifficultyLevel ) )

		self:IncreamentEventLevel( self.freezedDifficultyLevel )

		self.difficultyIncrease:ChangeState( "difficulty_increase" )
	else
		self:VerboseLog("OnExitDifficultyIncrease : Difficulty level is max - " .. tostring( self.currentDifficultyLevel ) )
	end

end

function dom_mananger:RandomizeSpawnPoint( borderSpawnPointGroupName, waveData )
	local spawn_type = waveData.spawn_type or FIND_TYPE_GROUP
	local spawn_type_value = waveData.spawn_type_value or borderSpawnPointGroupName
	local spawn_target_type = waveData.target_type or ""
	local spawn_target_value = waveData.target_type_value or ""
	local spawn_target_max_radius = waveData.target_max_radius or 0.0
	local spawn_target_min_radius = waveData.target_min_radius or 0.0

	self:VerboseLog( "RandomizeSpawnPoint: spawn_type: '" .. spawn_type .. "', spawn_type_value='" .. spawn_type_value .. "', spawn_target_type='" .. spawn_target_type .. ", spawn_target_value='" .. spawn_target_value .. "'" )

	if spawn_type == "RandomBorder" then
		spawn_type = FIND_TYPE_GROUP
		spawn_type_value = self.borderSpawnPointGroupNames[ RandInt(1, #self.borderSpawnPointGroupNames) ]
	elseif spawn_type == "Direction" then
		spawn_type = FIND_TYPE_GROUP
		if spawn_type_value == "" then
			spawn_type_value = borderSpawnPointGroupName
		end
	end

	local entities = {}
	if spawn_type == "RandomBorderInDistance" then
		local borders = Copy(self.borderSpawnPointGroupNames)
		while #borders > 0 and #entities == 0 do
			local border_index = RandInt(1, #borders)
			entities = FindEntitiesByTarget(FIND_TYPE_GROUP, borders[border_index], spawn_target_min_radius, spawn_target_max_radius, spawn_target_type, spawn_target_value)
			table.remove(borders, border_index)
		end
	elseif spawn_type == "CreateDynamic" then
		local target = FindEntities( spawn_target_type, spawn_target_name )
		if #target > 0 then
			entities = UnitService:CreateDynamicSpawnPoints( target[1], spawn_target_min_radius, spawn_target_max_radius, 1, false )
		end
	else
		entities = FindEntitiesByTarget(spawn_type, spawn_type_value, spawn_target_min_radius, spawn_target_max_radius, spawn_target_type, spawn_target_value)
	end

	if #entities == 0 then
		if waveData.spawn_type or waveData.target_type then
			self:VerboseLog( "RandomizeSpawnPoint: failed to find spawn points for spawn_type: '" .. tostring( waveData.spawn_type ) .. "', spawn_target_type='" .. tostring(spawn_target_type) .. "' going back to random!" )
			return self:RandomizeSpawnPoint(borderSpawnPointGroupName, { name = waveData.name } )
		else
			self:VerboseLog( "RandomizeSpawnPoint: failed to find spawn points for wave: '" .. waveData.name .. "'" )
		end

		return "none";
	end	

	if #entities > 1 then
		repeat
			self.tempRandomNumber = RandInt( 1,#entities )
		until self.tempRandomNumber ~= self.randomNumber
		self.randomNumber = self.tempRandomNumber
	else
		self.randomNumber = 1
	end
	
	local spawnPointName = EntityService:GetName( entities[self.randomNumber] )
	if spawnPointName == "" then
		spawnPointName = tostring(entities[self.randomNumber])
		EntityService:SetName(spawnPointName)
	end

	return spawnPointName;
end

function dom_mananger:GetWavePool( currentDifficultyLevel, silent )
	local availableAttackPool = self.availableAttackGroups
	local availableWaves      = {}

	if ( self.isForceAttackGroupEnabled == true ) then
		if (not silent) then self:VerboseLog("GetWavePool - forced group attack : " .. self.forceAttackGroupName ) end
		
		self.isForceAttackGroupEnabled = false

		availableAttackPool = {}
		availableAttackPool[#availableAttackPool + 1] = self.forceAttackGroupName
	else
		if (not silent) then self:VerboseLog("GetWavePool - available groups." ) end

		for i = 1, #self.availableAttackGroups, 1 do 
			self:VerboseLog( tostring( self.availableAttackGroups[i] ) )
		end	
	end
		
	for group in Iter ( availableAttackPool )  do
		local waves = self.rules.waves[ group ]
		
		currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #waves )

		if ( currentDifficultyLevel > 0 ) then
			for data in Iter( waves[currentDifficultyLevel] ) do 
				if (not silent) then self:VerboseLog("Adding wave to the wave pool : " .. data.name) end
				availableWaves[#availableWaves + 1] = data
			end
		end
	end

	return availableWaves
end

function dom_mananger:GetPool( pool, currentDifficultyLevel )
	if ( currentDifficultyLevel > 0 ) then
		return pool[currentDifficultyLevel]
	else
		return {}
	end
end

function dom_mananger:GetBossPool()
	local currentDifficultyLevel = self.currentDifficultyLevel	
	currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #self.rules.bosses )	

	return self:GetPool( self.rules.bosses, currentDifficultyLevel )
end

function dom_mananger:GetMultiplayerWavePool()
	local currentDifficultyLevel = self.currentDifficultyLevel	
	currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #self.rules.multiplayerWaves )	

	local pool = self:GetPool( self.rules.multiplayerWaves, currentDifficultyLevel )

	if ( pool ~= nil ) then	
		for data in Iter( pool.waves ) do 
			self:VerboseLog( "Adding multiplayer wave to the wave pool : " .. data.name )
		end

		return pool.waves
	end

	return {}
end

function dom_mananger:GetExtraWavePool()
	local currentDifficultyLevel = self.currentDifficultyLevel	
	currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #self.rules.extraWaves )	

	return self:GetPool( self.rules.extraWaves, currentDifficultyLevel )
end

function dom_mananger:GetPauseAttacks()	
	if (self.pauseAttacks == false) then
		if (self:GetAttackCount( self.currentDifficultyLevel ) <= 0) then return true end
		
		local wavesPool = self:GetWavePool( self.currentDifficultyLevel, true )
		if (#wavesPool <= 0) then return true end
	end
	
	return self.pauseAttacks
end

function dom_mananger:GetAttackCount( currentDifficultyLevel )	
	local minAttacks = 0
	local maxAttacks = 0
	if (self.rules.attackCountPerDifficulty) then
		minAttacks = self.rules.attackCountPerDifficulty[currentDifficultyLevel].minCount
		maxAttacks = self.rules.attackCountPerDifficulty[currentDifficultyLevel].maxCount
	else
		maxAttacks = self.rules.maxAttackCountPerDifficulty[currentDifficultyLevel]
		minAttacks = maxAttacks
	end
	return RandInt( minAttacks, maxAttacks )
end

function dom_mananger:GetMultiplayerAttackCount( currentDifficultyLevel )
	local playersCount = #PlayerService:GetAllPlayers() - 1

	self:VerboseLog("GetMultiplayerAttackCount : " .. tostring( playersCount ) )

	if ( playersCount > 0 ) then
		return self.rules.multiplayerWaves[currentDifficultyLevel].additionalWaves + playersCount
	else
		return 0
	end
end

function dom_mananger:GetPrepareSpawnTime()
	local stateDuration = self.rules.prepareSpawnTime[self.currentDifficultyLevel]
	self:VerboseLog("Preparation time base ".. tostring(stateDuration))
	
	if ((self.rules.preparationTimeRelativeVariation or 0.35) > 0) then
		local rngScale = (math.random()-0.5)*2*(self.rules.preparationTimeRelativeVariation or 0.35)
		stateDuration = stateDuration * (1 + rngScale)
		self:VerboseLog("Preparation time random scaling by ".. tostring(rngScale) .. " changing base to ".. tostring(stateDuration))
	elseif ((self.rules.preparationTimeCancelChance or 5) > math.random()*100) then
		stateDuration = 10
		self:VerboseLog("Preparation time modifier: cancelled (down to ".. tostring(stateDuration).. ")")
	end
	return stateDuration
end

function dom_mananger:GetIdleTime()
	return self.rules.idleTime[self.currentDifficultyLevel]
end

--------------------------------------------------- wait -------------------------------------------------

function dom_mananger:OnEnterWait( state )
	self:VerboseLog("OnEnterWait" )

	self:SetSuspended( true )
	CampaignService:OperateDOMPlanetaryJump( true )

	state:SetDurationLimit( 5 )
end

function dom_mananger:OnExitWait( state )
	self:VerboseLog("OnExitWait" )

	--if ( self.wavesDisabled == false ) then
	--	self.spawner:ChangeState( "streaming" )
	--else
	--	self.spawner:ChangeState( "prepare_spawn" )
	--end

	if ( self.upgradeHQ:GetCurrentState() ~= "hq_entry_logic" ) then
		local idleTime = self:GetIdleTime()

		local pauseAttacks = self:GetPauseAttacks()
		if ( ( pauseAttacks == true ) and ( idleTime > 0 ) ) then
			self.spawner:ChangeState( "idle" )
		elseif ( ( pauseAttacks == true ) and ( idleTime == 0 ) ) then
			self.spawner:ChangeState( "prepare_spawn" )
		else
			self.spawner:ChangeState( "streaming" )
		end
	end

end

-------------------------------------------- prepare_spawn -------------------------------------------------

function dom_mananger:OnEnterPrepareSpawn( state )

	self:VerboseLog("OnEnterPrepareSpawn" )

	CampaignService:OperateDOMPlanetaryJump( false )

	self.waitForSpawnTimer = self:GetPrepareSpawnTime()

	self.eventActivateTime	= self.waitForSpawnTimer - ( self.waitForSpawnTimer * self.idleTimeEventMul )
	self.eventActivated		= false	

	self.objectiveActivateTime	= self.waitForSpawnTimer - ( self.waitForSpawnTimer * self.idleTimeObjectiveMul )
	self.objectiveActivated		= false	
	
	if ( self.rules.eventsPerPrepareState ~= 0) then
		self:VerboseLog("OnEnterPrepareSpawn - deciding events in prepared state" );
		local rngRoll = RandInt(0, 100)	
		if ( (self.rules.eventsPerPrepareStateChance or 100) >= rngRoll ) then
			self.eventsPerPrepareState  = 1
		else self.eventsPerPrepareState  = 0
		end		
		self:VerboseLog("OnEnterPrepareSpawn - chance ".. tostring(self.rules.eventsPerPrepareStateChance or 100) .. ", roll ".. tostring(rngRoll) .. ", result: ".. tostring(self.eventsPerPrepareState > 0) );
	end

	if ( ( self:GetPauseAttacks() == false ) and ( self.cancelTheAttack == false ) ) then
		self.data:SetFloat( "time_max", self.waitForSpawnTimer )
		MissionService:ActivateMissionFlow( self.objectivePrepareForTheAttacLogicFileName, self.objectivePrepareForTheAttacLogicFile, "default", self.data )

		if ( self.rules.prepareAttackDefinitions ~= nil ) then
			MissionService:ActivateMissionFlow( "", self.rules.prepareAttackDefinitions[self.currentDifficultyLevel].name, "default" )
		end

		self.preparedAttacks       = {}
		self.preparedAttackMarkers = {}
		self.WaveStateMachine      = self.spawner
		self.WaveRepeatState       = "streaming"
		if ( self:GetPauseAttacks() == true ) then
			self.WaveRepeatState = "dummy_state"
		end

		if ( self.prepAttacks == true ) then
			local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

			self:VerboseLog("Border spawn point group :" .. borderSpawnPointGroupName )
			self:VerboseLog("Difficulty Level : " .. tostring(self.currentDifficultyLevel ) )

			local wavePool = self:GetWavePool( self.currentDifficultyLevel )
			self:PrepareWave( self:GetAttackCount( self.currentDifficultyLevel ), borderSpawnPointGroupName, wavePool, "OnEnterPrepareSpawn: Prepare attack name : ", self.waitForSpawnTimer, self.preparedAttacks, self.preparedAttackMarkers )

			if ( self.rules.multiplayerWaves ~= nil ) then
				local multiplayerAttackCount = self:GetMultiplayerAttackCount( self.currentDifficultyLevel )

				if ( multiplayerAttackCount > 0 ) then
					wavePool = self:GetMultiplayerWavePool( self.currentDifficultyLevel )
					self:PrepareWave( multiplayerAttackCount, borderSpawnPointGroupName, wavePool, "OnEnterPrepareSpawn: Prepare attack name : ", self.waitForSpawnTimer, self.preparedAttacks, self.preparedAttackMarkers )
				end
			end
		end
	end

	--if ( self.wavesDisabled == false ) then
	--	self.data:SetFloat( "time_max", self.waitForSpawnTimer )
	--	MissionService:ActivateMissionFlow( self.objectivePrepareForTheAttacLogicFileName, self.objectivePrepareForTheAttacLogicFile, "default", self.data )	
	--end



end

function dom_mananger:OnExecutePrepareSpawn( state, dt )
	self.waitForSpawnTimer  = self.waitForSpawnTimer - dt

	if ( self.waitForSpawnTimer < 0 ) then
		self.waveRepeated = 0
		if ( self:GetPauseAttacks() == true ) then
			self.spawner:ChangeState( "dummy_state" )
		else
			self.spawner:ChangeState( "streaming" )
		end
	end

	if ( self.eventsPerPrepareState ~= 0 ) then
		if ( ( self.waitForSpawnTimer < self.eventActivateTime ) and not self.eventActivated ) then
			self:StartAnEvent( "IDLE" )
			self.eventActivated = true
		end

		if ( ( self.waitForSpawnTimer < self.objectiveActivateTime ) and not self.objectiveActivated ) then
			self:StartObjective()
			self.objectiveActivated = true
		end
	end
end

function dom_mananger:OnExitPrepareSpawn( state )
	self:VerboseLog("OnExitPrepareSpawn" )

	CampaignService:OperateDOMPlanetaryJump( true )
end

--------------------------------------------------- cooldown_after_spawn -------------------------------------------------

function dom_mananger:OnEnterCooldownAfterSpawnTime( state )
	self:VerboseLog("OnEnterCooldownAfterSpawnTime" )
	self.cooldownTimer  = self.rules.cooldownAfterAttacks[self.currentDifficultyLevel]
	
	self:BeginWaveCooldown( self.cooldownTimer )
end

function dom_mananger:OnExecuteCooldownAfterSpawnTime( state, dt )
	self.cooldownTimer = self.cooldownTimer - dt
	
	self:DoWaveCooldown( self.cooldownTimer, dt )
	
	if ( self.cooldownTimer < 0 ) then
		self.spawner:ChangeState( "idle" )
	end
end

function dom_mananger:OnExitCooldownAfterSpawnTime( state )
	self:VerboseLog("OnExitCooldownAfterSpawnTime" )
end

--------------------------------------------------- idle -------------------------------------------------

function dom_mananger:OnEnterIdle( state )
	self:VerboseLog("OnEnterIdle" )
	CampaignService:OperateDOMPlanetaryJump( true ) -- just in case, planetary travel is stuck due to a bug
	
	local stateDuration = self.rules.idleTime[self.currentDifficultyLevel]
	self:VerboseLog("Idle time base ".. tostring(stateDuration))
	
	if ((self.rules.idleTimeRelativeVariation or 0.35) > 0) then
		local rngScale = (math.random()-0.5)*2*(self.rules.idleTimeRelativeVariation or 0.35)
		stateDuration = stateDuration * (1 + rngScale)
		self:VerboseLog("Idle time random scaling by ".. tostring(rngScale) .. " changing base ".. tostring(self.rules.idleTime[self.currentDifficultyLevel]) .." to ".. tostring(stateDuration))
	elseif ((self.rules.idleTimeCancelChance or 10)> math.random()*100) then
		stateDuration = 30
		self:VerboseLog("Idle time modifier: cancelled (down to ".. tostring(stateDuration) ..")")
	end
	self.idleTimer = stateDuration

	--state:SetDurationLimit( stateDuration )

	self.allowEvents = false
	local numberOfEvents = self.rules.eventsPerIdleState

	if ( self.rules.eventsPerIdleState > 0 ) then
		self.allowEvents = true

		if ( self.idleTimer < 400 ) then
			numberOfEvents = 1
			self:VerboseLog("OnEnterIdle - clamping number of events to : " .. tostring( numberOfEvents ) )
		end
	else
		numberOfEvents = 1
	end

	self.timePerEvent = stateDuration / numberOfEvents
	self.currentTimePerEvent = self.timePerEvent

	self.eventActivateTime	= self.timePerEvent
	self.eventActivated		= false	

	self.objectiveActivateTime	= self.timePerEvent - ( self.timePerEvent * self.idleTimeObjectiveMul )
	self.objectiveActivated		= false	


	self:VerboseLog("OnEnterIdle - Duration : " .. tostring( stateDuration ) )
	self:VerboseLog("OnEnterIdle - Objective activate time : " .. tostring( self.objectiveActivateTime ) )
	self:VerboseLog("OnEnterIdle - Allow events: " .. tostring( self.allowEvents ) )


	if ( self.rules.eventsPerIdleState > 0 ) then
		self:VerboseLog("OnEnterIdle - Number of events: " .. tostring( numberOfEvents ) )
		self:VerboseLog("OnEnterIdle - Time per event : " .. tostring( self.timePerEvent ) )
		self:VerboseLog("OnEnterIdle - Event activate time : " .. tostring( self.eventActivateTime ) )
	end
end

function dom_mananger:OnExecuteIdle( state, dt )
	self.idleTimer  = self.idleTimer - dt

	if ( self.idleTimer < 0 ) then

		local idleTime = self:GetIdleTime()
		
		if ( ( self:GetPauseAttacks() == true ) and ( idleTime > 0 ) ) then
			self.spawner:ChangeState( "dummy_state" )
		else
			self.spawner:ChangeState( "prepare_spawn" )
		end
	end

	self.currentTimePerEvent  = self.currentTimePerEvent - dt

	if ( self.currentTimePerEvent < 0 ) then
		self.currentTimePerEvent = self.timePerEvent
		self.eventActivated = false
	end

	if ( ( self.currentTimePerEvent < self.eventActivateTime ) and ( self.eventActivated == false ) ) then

		if ( self.allowEvents == true ) then
			self:StartAnEvent( "IDLE" )
		end

		self.eventActivated = true
	end

	if ( ( self.currentTimePerEvent < self.objectiveActivateTime ) and ( self.objectiveActivated == false ) ) then
		self:StartObjective()
		self.objectiveActivated = true
	end


end

function dom_mananger:OnExitIdle( state )
	self:VerboseLog("OnExitIdle" )
end

--------------------------------------------------- dummy_state -------------------------------------------------

function dom_mananger:OnEnterDummyState( state )
	self:VerboseLog("OnEnterDummyState" )
end

function dom_mananger:OnExecuteDummyState( state, dt )
	local idleTime = self:GetIdleTime()
	local pauseAttacks = self:GetPauseAttacks()

	if ( ( pauseAttacks == true ) and ( idleTime > 0 ) ) then
		self.spawner:ChangeState( "idle" )
	elseif ( ( pauseAttacks == true ) and ( idleTime == 0 ) ) then
		self.spawner:ChangeState( "prepare_spawn" )
	else
		self.spawner:ChangeState( "cooldown_after_spawn" )
	end
end

function dom_mananger:OnExitDummyState( state )
	self:VerboseLog( "OnExitDummyState" )
end

--------------------------------------------------- sleep -------------------------------------------------

function dom_mananger:OnEnterSleep( state )
	self:VerboseLog("OnEnterSleep - stoping base mission flow." )

	self:CloseStream()

	self.sleepSafeTimer = self.sleepSafeTime
end

function dom_mananger:OnExecuteSleep( state, dt )
	self.sleepSafeTimer  = self.sleepSafeTimer - dt

	if ( self.sleepSafeTimer < 0 ) then
		self.spawner:ChangeState( "cooldown_after_spawn" )
	end

end

function dom_mananger:OnExitSleep( state )
	self:VerboseLog("OnExitSleep - resuming base mission flow." )

	CampaignService:OperateDOMPlanetaryJump( true )
end

--------------------------------------------------- hq_entry_logic -------------------------------------------------

function dom_mananger:OnHqEnterEntryLogic( state )
	self:VerboseLog("OnHqEnterEntryLogic" )

	CampaignService:OperateDOMPlanetaryJump( false )

	self.data:SetFloat( "time_max", self.hqLogicLevel.prepareTime )

	self:VerboseLog("HQ upgrade time : " .. self.hqLogicLevel.prepareTime )
	self:VerboseLog("HQ upgrade entry logic : " .. self.hqLogicLevel.entryLogic )

	MissionService:ActivateMissionFlow( "", self.hqLogicLevel.entryLogic, "default", self.data )

	state:SetDurationLimit( self.hqLogicLevel.prepareTime )

	self.hqPreparedAttacks       = {}
	self.hqPreparedAttackMarkers = {}
	self.upgradeHqWaves			 = {}
	self.WaveRepeatState         = "hq_attack_logic"
	self.WaveStateMachine        = self.upgradeHQ
	
	if ( self.prepAttacks == true ) then

		local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

		self:VerboseLog("Border spawn point group :" .. borderSpawnPointGroupName )

		local difficultyLevel = self.currentDifficultyLevel + self.hqLogicLevel.level

		if ( self.hqLogicLevel.minLevel ~= nil ) and ( difficultyLevel < self.hqLogicLevel.minLevel ) then
			difficultyLevel = self.hqLogicLevel.minLevel
		end

		difficultyLevel = Clamp( difficultyLevel, 1, self.maxDifficultyLevel )

		self:VerboseLog("Difficulty Level : " .. tostring( self.currentDifficultyLevel ) .. " changed to : " .. tostring( difficultyLevel ) )

		local wavePool = self:GetWavePool( difficultyLevel );

		self:PrepareWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "OnHqEnterEntryLogic: Prepare attack name : ", self.hqLogicLevel.prepareTime, self.hqPreparedAttacks, self.hqPreparedAttackMarkers )

		if ( self.rules.multiplayerWaves ~= nil ) then
			local multiplayerAttackCount = self:GetMultiplayerAttackCount( self.currentDifficultyLevel )

			if ( multiplayerAttackCount > 0 ) then
				wavePool = self:GetMultiplayerWavePool( self.currentDifficultyLevel )
				self:PrepareWave( multiplayerAttackCount, borderSpawnPointGroupName, wavePool, "OnHqEnterEntryLogic: Prepare attack name : ", self.hqLogicLevel.prepareTime, self.hqPreparedAttacks, self.hqPreparedAttackMarkers )
			end
		end
	end
end

function dom_mananger:OnHqExitEntryLogic( state )
	self.waveRepeated = 0
	
	self:VerboseLog("OnHqExitEntryLogic" )
	self.upgradeHQ:ChangeState( "hq_attack_logic" )
end


--------------------------------------------------- hq_attack_logic -------------------------------------------------

function dom_mananger:OnHqEnterAttackLogic( state )
	self:VerboseLog("OnHqEnterAttackLogic" )

	if ( self.prepAttacks == false ) then  -- late attack preperation as a workaround
		local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

		self:VerboseLog("Border spawn point group :" .. borderSpawnPointGroupName )

		local difficultyLevel = self.currentDifficultyLevel + self.hqLogicLevel.level

		if ( self.hqLogicLevel.minLevel ~= nil ) and ( difficultyLevel < self.hqLogicLevel.minLevel ) then
			difficultyLevel = self.hqLogicLevel.minLevel
		end

		difficultyLevel = Clamp( difficultyLevel, 1, self.maxDifficultyLevel )

		local wavePool = self:GetWavePool( difficultyLevel );

		self.WaveRepeatState   = "hq_attack_logic"
		self.WaveStateMachine  = self.upgradeHQ
		self.hqPreparedAttacks = {}
		
		self:PrepareWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "OnHqEnterAttackLogic: Fast-prep attack name : ", 0, self.hqPreparedAttacks, nil, "", "label_small", 0)
		--self:SpawnWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "OnHqEnterAttackLogic: Fast-spawn attack name : ", true, "", "label_small", 0, self.upgradeHqWaves, self.hqPreparedAttacks )

		if ( self.rules.multiplayerWaves ~= nil ) then
			local multiplayerAttackCount = self:GetMultiplayerAttackCount( self.currentDifficultyLevel )

			if ( multiplayerAttackCount > 0 ) then
				wavePool = self:GetMultiplayerWavePool( difficultyLevel )
				self:PrepareWave( multiplayerAttackCount, borderSpawnPointGroupName, wavePool, "OnHqEnterAttackLogic: Fast-prep multiplayer attack name : ", 0, self.hqPreparedAttacks, nil, "", "label_small", 0)
				--self:SpawnWave( multiplayerAttackCount, borderSpawnPointGroupName, wavePool, "OnHqEnterAttackLogic: Fast-spawn multiplayer attack name : ", true, "", "label_small", 0, self.upgradeHqWaves, self.hqPreparedAttacks )
			end
		end
	end
	
	self:SpawnPreparedWave( "dom_mananger:OnHqExitEntryLogic: Spawn attack name : ", true, self.hqPreparedAttacks, self.upgradeHqWaves )
	
	self.hqAttackSafeTimer = self.hqAttackSafeTime
	self:BeginWaveCooldown( self.hqAttackSafeTimer )
end

function dom_mananger:OnExecuteAttackLogic( state, dt )
	self.hqAttackSafeTimer  = self.hqAttackSafeTimer - dt
	
	self:DoWaveCooldown( self.hqAttackSafeTimer, dt )

	if ( self.hqAttackSafeTimer < 0 ) then
		self.upgradeHQ:ChangeState( "hq_exit_logic" )
	end
end

function dom_mananger:OnHqExitAttackLogic( state )
	self:VerboseLog("OnHqExitAttackLogic" )
end

--------------------------------------------------- hq_exit_logic -------------------------------------------------

function dom_mananger:OnHqEnterExitLogic( state )
	self:VerboseLog("OnHqEnterExitLogic" )

	self.onUpgradeHqLogicEndFileName = MissionService:ActivateMissionFlow( "", self.hqLogicLevel.exitLogic, "default", self.data )
end

function dom_mananger:OnHqExitExitLogic( state )
	self:VerboseLog("OnHqExitExitLogic" )
end

function dom_mananger:PrepareLabels( labels, labelName, labelsPercentageUse )
	self.data:SetString( "labels", labels )
	self.data:SetString( "label_name", labelName )
	self.data:SetInt( "labels_percentage_use", labelsPercentageUse )
end

function dom_mananger:NewAttackSetup( waveData, wavePool, borderSpawnPointGroupName, spawnPointName, maxRepeats)
	-- waveData: single element from waves definitions setup in the mission lua
	if maxRepeats == nil then maxRepeats = waveData.maxRepeats
	else maxRepeats = math.min(maxRepeats, waveData.maxRepeats or 99)
	end
	attack = {}
	attack.waveName       = waveData.name
	attack.maxRepeats     = maxRepeats
	attack.spawnGroupName = borderSpawnPointGroupName
	attack.spawnPointName = spawnPointName
	attack.originalPool   = wavePool
	return attack
end

function dom_mananger:PrepareWave( attackCount, borderSpawnPointGroupName, wavePool, log, indicatorTimer, attacks, markers, participants, labelName, participantsPercentageUse )

	for i = 1, attackCount do
		local waveData = wavePool[RandInt( 1, #wavePool )]
		self:VerboseLog( "PrepareWave: wave_logic='" .. waveData.name .. "'")

		local spawnPointName = self:RandomizeSpawnPoint( borderSpawnPointGroupName, waveData )
		if ( spawnPointName ~= "none" ) then
			local index = #attacks + 1

			if ( participants ~= nil ) then
				self:PrepareLabels( participants, labelName, participantsPercentageUse )
			end
			
			attacks[index] = self:NewAttackSetup( waveData, wavePool, borderSpawnPointGroupName, spawnPointName)

			if (markers) then
				markers[#markers + 1] = self:SpawnWaveIndicator( indicatorTimer, spawnPointName, "effects/messages_and_markers/wave_marker" )
			end
			
			self:VerboseLog( log .. waveData.name )
		end
	end
end

function dom_mananger:ReshuffleWave( index, attacks, reshuffleSwapn, reshuffleSpawnGroup )
	local borderSpawnPointGroupName = attacks[index].spawnGroupName
	local spawnPointName            = attacks[index].spawnPointName
	local wavePool                  = attacks[index].originalPool
	local maxRepeats                = attacks[index].maxRepeats
	if (wavePool == nil or #wavePool == 0) then
		self:VerboseLog( "Wave Reshuffle: attack ".. tostring(index) .." original wavePool is nil. using default pool")
		wavePool = self:GetWavePool( self.currentDifficultyLevel )
	end
	local waveData  = wavePool[RandInt( 1, #wavePool )]
	local textSpawn = ""
	
	if (reshuffleSpawnGroup ) then
		borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]
		reshuffleSwapn = true
		textSpawn = ", new group: " .. tostring(borderSpawnPointGroupName)
	end
	
	if (reshuffleSwapn and borderSpawnPointGroupName ~= nil) then
		spawnPointName = self:RandomizeSpawnPoint( borderSpawnPointGroupName, waveData )
		textSpawn = textSpawn .. " new spawn: " .. tostring(spawnPointName)
	end
	
	if ( spawnPointName ~= "none" ) then
		attacks[index] = self:NewAttackSetup( waveData, wavePool, borderSpawnPointGroupName, spawnPointName, maxRepeats)

		-- markers[index] = self:SpawnWaveIndicator( indicatorTimer, spawnPointName, "effects/messages_and_markers/wave_marker" )
		
		self:VerboseLog( "Wave Reshuffle: attack ".. tostring(index).. " changed to wave_logic='" .. waveData.name .. "'".. textSpawn)
	end
end

function dom_mananger:RepeatWave(attacks)
	if (not attacks or #attacks==0) then return attacks end
	self:VerboseLog("RepeatWave: checking " .. tostring(#attacks) .. " attacks for repeat and reshuffle")
	
	if ( self.waveRepeated == nil ) then self.waveRepeated = 0 end
	local repeatChances       = self.rules.waveRepeatChances[self.currentDifficultyLevel]
	local repeatChance        = repeatChances[self.waveRepeated+1] or 0
	local chanceWaveReroll    = self.rules.waveChanceReroll or 40
	local chanceNewSpawn      = self.rules.waveChanceRerollSpawn or 15
	local chanceNewSpawnGroup = self.rules.waveChanceRerollSpawnGroup or 0
	
	local newAttacks = {}
	for i = 1, #attacks, 1 do
		local attack = attacks[i]
		if attack.maxRepeats ~= nil and self.waveRepeated >= attack.maxRepeats then
			self:VerboseLog("RepeatWave: attack ".. attackStr .. " reached its max repeats of ".. tostring(attack.maxRepeats) .." and will not contine")
		else
			local rngRoll = RandInt(0, 100)
			local attackStr = tostring(i) .."/".. tostring(#attacks)
			self:VerboseLog("RepeatWave: attack ".. attackStr .. " repeat ".. tostring(self.waveRepeated + 1) .." chance " .. tostring(repeatChance) .. ", rolled " .. tostring(rngRoll) .. " => " ..  tostring(repeatChance > rngRoll))
			if ( repeatChance > rngRoll) then
				rngRoll = RandInt(1, 100)
				self:VerboseLog("RepeatWave: attack ".. attackStr.. " reshuffle chance ".. tostring(chanceWaveReroll) ..", rolled ".. tostring(rngRoll) .." => " .. tostring(chanceWaveReroll > rngRoll) )
				if ( chanceWaveReroll > rngRoll) then
					self:ReshuffleWave( i, attacks, chanceNewSpawnGroup < RandInt(1, 100), chanceNewSpawn < RandInt(1, 100) )
				end
				newAttacks[#newAttacks + 1] = attack
			end		
		end
	end
	
	if (#newAttacks > 0) then
		self:VerboseLog("RepeatWave: repeat ".. tostring(self.waveRepeated + 1) .." is set up with ".. tostring(#newAttacks).. "/".. tostring(#self.preparedAttacks) .." attacks continuing")
		attacks = newAttacks
		
		if (not self.WaveStateMachine) then -- for downwards compatibility with some saves
			self.WaveStateMachine = self.spawner
			self.WaveRepeatState  = "streaming"
		end
		self.WaveStateMachine:ChangeState( self.WaveRepeatState ) 
		
		self.waveRepeated = self.waveRepeated + 1
		self.eventsPerPrepareState = 0
	else 
		self:VerboseLog("RepeatWave: no attacks remaining, wave is completed.")
		self.waveRepeatTime = -9999
		self.prepAttacks = self.rules.prepareAttacks
	end
	
	return attacks
end

function dom_mananger:BeginWaveCooldown( cooldownTime )
	self:VerboseLog("BeginWaveCooldown ( ".. tostring(cooldownTime) .. " )" )
	self.waveRepeatTime = math.max(10, cooldownTime - (10 + RandInt(4, 7)*self.currentDifficultyLevel))
	self:VerboseLog("setting wave repeat time to ".. tostring(self.waveRepeatTime) .. " / " .. tostring(cooldownTime)  )
	if (self.rules.waveRepeatChances) then
		self.prepAttacks = false
	end 
	
	if ((self.waveRepeated or 0) == 0) then
		self.waveEventsTimer = cooldownTime
		self.coolEventSpawnTime = {}
		local rngRoll = RandInt(0, 100)	
		if (not self.rules.spawnCooldownEventChance) then
			self.rules.spawnCooldownEventChance = { 25, 20, 20}
		end
		for i,prob in ipairs(self.rules.spawnCooldownEventChance) do
			self:VerboseLog("Event ".. tostring(i) .." after wave: roll " .. tostring(rngRoll) .. " vs probability " .. tostring(prob) .." => ".. tostring(prob >= rngRoll))
			if (prob and prob >= rngRoll) then
				self.coolEventSpawnTime[i] = RandInt(1,cooldownTime)
				self:VerboseLog("Event ".. tostring(i) .." after wave: time set to " .. tostring(self.coolEventSpawnTime[i]) .. " / " .. tostring(cooldownTime))
			else
				break
			end
		end
	end
end

function dom_mananger:DoWaveCooldown( timer, dt )
	if  (not self.waveEventsTimer) then self.waveEventsTimer = 1000 end -- line for downwards compatibility (property may not be set in older saves)
	
	self.waveEventsTimer = self.waveEventsTimer - dt
	if (self.waveEventsTimer < 0) then self.waveEventsTimer = 0 end
	
	for i = 1, #self.coolEventSpawnTime, 1 do
		if (self.coolEventSpawnTime[i] and self.coolEventSpawnTime[i] > self.waveEventsTimer) then
			self:VerboseLog("Event on Cooldown ".. tostring(i) ..": starting")
			self:StartAnEvent( "ATTACK" )
			self.coolEventSpawnTime[i] = -9999
		end
	end

	if ( timer < self.waveRepeatTime and self.rules.waveRepeatChances ) then
		if (#self.hqPreparedAttacks>0)     then self.hqPreparedAttacks = self:RepeatWave(self.hqPreparedAttacks)
		elseif (#self.preparedAttacks>0)   then self.preparedAttacks   = self:RepeatWave(self.preparedAttacks)
		end
		if (#self.preparedAttacks + #self.hqPreparedAttacks == 0) then
			self.waveRepeatTime = -9999
			self:VerboseLog("DoWaveCooldown: no attack definitions to repeat")
		end
	end
end

function dom_mananger:SpawnPreparedWave( log, shouldAddtoSpawnedAttacks, preparedAttacks, spawnedAttacks )
	for preparedWave in Iter( preparedAttacks ) do 
		self.data:SetString( "spawn_point", preparedWave.spawnPointName )

		self:VerboseLog( log .. preparedWave.waveName .. "  " )
		self:VerboseLog( "dom_mananger activating " .. preparedWave.waveName .. "  (wave repeat: " .. tostring((self.waveRepeated or 1) -1) .. ")")

		self:PrepareLabels( "", "label_small", 0 )

		local currentLogicFile = MissionService:ActivateMissionFlow( "", preparedWave.waveName, "default", self.data )
		self:SpawnWaveIndicator( 45, preparedWave.spawnPointName, "effects/messages_and_markers/wave_marker" )				

		if ( shouldAddtoSpawnedAttacks == true ) then
			spawnedAttacks[#spawnedAttacks + 1] = currentLogicFile
		end
	end
end

function dom_mananger:SpawnWave( attackCount, borderSpawnPointGroupName, wavePool, log, shouldAddtoSpawnedAttacks, participants, labelName, participantsPercentageUse, spawnedAttacks, attacks )
	local newAttacks = {}
	self:PrepareWave( attackCount, borderSpawnPointGroupName, wavePool, log, 0, newAttacks, nil, participants, labelName, participantsPercentageUse ) -- workaround to memorize active accackts in self.preparedAttacks so wave repoeats can rely on that.
	self:SpawnPreparedWave( log, shouldAddtoSpawnedAttacks, newAttacks, spawnedAttacks )
		
	-- attacks must be in saved somewhere to be able to repeat them
	if (not attacks) then attacks = {} end
	for i=1,#newAttacks do
        attacks[#attacks+1] = newAttacks[i]
    end
end
--------------------------------------------------- spawn -------------------------------------------------

function dom_mananger:SpawnWavesForDifficultyLevel( difficultyLevel, shouldAddtoSpawnedAttacks )
	local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]
	local wavePool = {}
	
	if ((self.waveRepeated or 0) == 0) then -- attack preperation must be done only once
		if ( not shouldAddtoSpawnedAttacks or #self.preparedAttacks <= 0 ) then  -- late attack preparation
			self.WaveRepeatState  = "streaming"
			self.WaveStateMachine = self.spawner
			self.preparedAttacks  = {} -- preparedAttacks are used to determine repeats, hence why they need to be setup despite lack of preparation
			
			wavePool = self:GetWavePool( difficultyLevel )
			self:PrepareWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Fast-prep normal attack name : ", 0, self.preparedAttacks, nil, "", "label_small", 0)
			--self:SpawnWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Fast-spawn normal attack name : ", shouldAddtoSpawnedAttacks, "", "label_small", 0, self.spawnedAttacks, self.preparedAttacks )

			if ( self.rules.multiplayerWaves ~= nil ) then
				local multiplayerAttackCount = self:GetMultiplayerAttackCount( self.currentDifficultyLevel )

				if ( multiplayerAttackCount > 0 ) then
					wavePool = self:GetMultiplayerWavePool( difficultyLevel )
					self:PrepareWave( multiplayerAttackCount, borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Fast-prep multiplayer attack name : ", 0, self.preparedAttacks, nil,  "", "label_small", 0)
					--self:SpawnWave( multiplayerAttackCount, borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Fast-spawn multiplayer attack name : ", shouldAddtoSpawnedAttacks, "", "label_small", 0, self.spawnedAttacks, self.preparedAttacks )
				end
			end
		end
	end

	if ( self.extraAttacks > 0) then
		wavePool = self:GetExtraWavePool()
		self:PrepareWave( self.extraAttacks, borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Fast-prep extra attack name : ", 0, self.preparedAttacks, nil, self.participants, "label_small", self.participantsPercentageUse)
		--self:SpawnWave( self.extraAttacks, borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Fast-spawn extra attack name : ", shouldAddtoSpawnedAttacks, self.participants, "label_small", self.participantsPercentageUse, self.spawnedAttacks, self.preparedAttacks )
	end
	if ( self.spawnBoss == true ) then
		wavePool = self:GetBossPool()
		self:PrepareWave( 1, borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Boss attack name : ", 0, self.preparedAttacks, nil, self.participants, "label_medium", self.participantsPercentageUse)
		--self:SpawnWave( 1, borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Boss attack name : ", false, self.participants, "label_medium", self.participantsPercentageUse, self.spawnedAttacks, self.preparedAttacks )
	end
	
	
	self:SpawnPreparedWave( "dom_mananger:OnEnterSpawn: Spawn papared attack name : ", shouldAddtoSpawnedAttacks, self.preparedAttacks, self.spawnedAttacks )
	
	if ( difficultyLevel <= #self.rules.wavesEntryDefinitions ) then
		MissionService:ActivateMissionFlow( "", self.rules.wavesEntryDefinitions[difficultyLevel].name, "default", self.data )	
	end
	
end

function dom_mananger:OnEnterSpawn( state )
	self:VerboseLog("OnEnterSpawn" )
	
	if ( self.cancelTheAttack == true ) then
		self:VerboseLog("Canceling the attack." )
		self.cancelTheAttack = false
	else
		if ( #self.spawnedAttacks <= 1 ) then	
			self:SpawnWavesForDifficultyLevel(self.currentDifficultyLevel, true)
		end
	end

	self.extraAttacks = 0
	self.spawnBoss = false
	self.participants = ""
	self.participantsPercentageUse = 0
end

function dom_mananger:OnExecuteSpawn( state, dt )
	self.spawner:ChangeState( "cooldown_after_spawn" )
end

function dom_mananger:OnExitSpawn( state )
	self:VerboseLog("OnExitSpawn" )	
end

function dom_mananger:SpawnWaveIndicator( indicatorTimer, spawnPoint, markerName )
		
	local indicatorID = EntityService:SpawnEntity( markerName, spawnPoint, "no_team" )
	EntityService:CreateLifeTime( indicatorID, indicatorTimer, "normal" )
	self:VerboseLog("SpawnWaveIndicator : " .. tostring( indicatorID ) )
	return indicatorID
end

	-- ======================================== STREAMING ============================================

function dom_mananger:OnEnterStreaming( state )
	self:VerboseLog("OnEnterStreaming" )
	self:VerboseLog("Current attacks count : " .. tostring( #self.spawnedAttacks ) )

	while ( #self.spawnedAttacks >= 2 ) do

		self:VerboseLog("Removing extra attack : " .. tostring( self.spawnedAttacks[1] ) )
		self:VerboseLog("MissionService:DeactivateMissionFlow by force : " .. self.spawnedAttacks[1] )

		MissionService:DeactivateMissionFlow( self.spawnedAttacks[1] )

		table.remove( self.spawnedAttacks, 1 )	
	end

	--self:StartAnEvent( "ATTACK" )
end

function dom_mananger:OnExecuteStreaming( state )
	
	if ( ( GameStreamingService:IsInStreamEvent() == false ) or ( GameStreamingService:IsStreamingSessionStarted() == false ) ) then
		self.spawner:ChangeState( "spawn" )
	end

end

function dom_mananger:OnExitStreaming( state )
	self:VerboseLog("OnExitStreaming" )
end

local function HasOtherAlivePlayersInTeam( current_player )
	local player_team = PlayerService:GetPlayerTeam( current_player )

	local players = PlayerService:GetPlayersFromTeam( player_team )
	for player_id in Iter(players) do
		local pawn = PlayerService:GetPlayerControlledEnt( player_id )
		if current_player ~= player_id and HealthService:IsAlive( pawn ) then
			return true
		end
	end

	return false
end

function dom_mananger:OnRespawnFailedEvent( evt )
	self:VerboseLog("Mission failed" )

	local player_id = evt:GetPlayerId()
	if HasOtherAlivePlayersInTeam( player_id) and self.player_death_position[ player_id ] then

		local position = self.player_death_position[ player_id ]
		self.player_death_position[ player_id ] = nil;

		local player_team = EntityService:GetTeam(PlayerService:GetPlayerTeam( player_id ))
		local spawner = EntityService:SpawnEntity("player/player_respawner", position.x, position.y, position.z, "none" )

		local player_reference = reflection_helper(EntityService:CreateComponent(spawner, "PlayerReferenceComponent"))
		player_reference.player_id = player_id
		player_reference.reference_type.internal_enum = 4
		return;
	end

    LampService:ReportGameFailed()
	MissionService:ShowEndGameHud( 5.0, false )

	local failedAction = MissionService:GetCurrentMissionFailedAction();
	if ( failedAction ~= MFA_REMAIN ) then
		MissionService:DeactivateAllFlows()
	end
end

function dom_mananger:DestroyPlayerItems( owner, player )
	local count = DifficultyService:GetNumberOfItemsRemovedOnDeath();

	if ( count == 0 ) then
		return
	end
	local status = CampaignService:GetMissionStatus( CampaignService:GetCurrentMissionId() )
	if ( status ~= MISSION_STATUS_IN_PROGRESS and status ~= MISSION_STATUS_NONE ) then
		return
	end

	local items = PlayerService:GetAllEquippedItemsInSlot( "LEFT_HAND", player )
	ConcatUnique( items, PlayerService:GetAllEquippedItemsInSlot( "RIGHT_HAND", player ) )   
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

function dom_mananger:DropPlayerItems( owner, player )
	local dropItemsCount = DifficultyService:GetNumberOfItemsDroppedOnDeath();
	if ( dropItemsCount == 0 ) then
		return
	end

	local mech = PlayerService:GetPlayerControlledEnt( player)
	if ( mech ~= INVALID_ID ) then
		local mechDatabase = EntityService:GetDatabase( mech )
		if ( mechDatabase:GetIntOrDefault("disable_drop",0  ) == 1 ) then
			return
		end
	end

	local items = PlayerService:GetAllEquippedItemsInSlot( "LEFT_HAND" , player)
	ConcatUnique( items, PlayerService:GetAllEquippedItemsInSlot( "RIGHT_HAND", player ) )   
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
	self:DestroyPlayerItems(evt:GetEntity(), evt:GetPlayerId())
	self:DropPlayerItems(evt:GetEntity(), evt:GetPlayerId())

	self.player_death_position[ evt:GetPlayerId() ] = EntityService:GetPosition( evt:GetEntity() )
end

return dom_mananger