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
				ConvertLogicEntries(waves)
			end
		end
	end

	if data.extraWaves then
		for _,waves in ipairs( data.extraWaves ) do
			ConvertLogicEntries(waves)
		end
	end

	if data.bosses then
		for _,waves in pairs( data.bosses ) do
			ConvertLogicEntries(waves)
		end
	end

	return data
end

function dom_mananger:init()

	-- ========================================= Configuration ======================================

	self:VerboseLog(" ------- DOM MANAGER VER 2.0 ------- " )

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
	self:RegisterHandler( event_sink, "BuildingStartEvent",        	   "OnBuildingStartEvent" )
	self:RegisterHandler( event_sink, "LuaGlobalEvent",       		   "OnLuaGlobalEvent" )
	self:RegisterHandler( event_sink, "RespawnFailedEvent",			   "OnRespawnFailedEvent" )
	self:RegisterHandler( event_sink, "PlayerDiedEvent",			   "OnPlayerDiedEvent" )

    self.spawner = self:CreateStateMachine()
    self.spawner:AddState( "spawn", { enter="OnEnterSpawn", execute="OnExecuteSpawn", exit= "OnExitSpawn" } )
	self.spawner:AddState( "wait", { enter="OnEnterWait", exit= "OnExitWait" } )
	self.spawner:AddState( "cooldown_after_spawn", { enter="OnEnterCooldownAfterSpawnTime", execute="OnExecuteCooldownAfterSpawnTime", exit= "OnExitCooldownAfterSpawnTime" } )
	self.spawner:AddState( "prepare_spawn", { enter="OnEnterPrepareSpawn", execute="OnExecutePrepareSpawn", exit= "OnExitPrepareSpawn" } )
	self.spawner:AddState( "idle", { enter="OnEnterIdle", execute="OnExecuteIdle", exit= "OnExitIdle" } )
	self.spawner:AddState( "streaming", { enter="OnEnterStreaming", execute="OnExecuteStreaming", exit= "OnExitStreaming" } )
	self.spawner:AddState( "sleep", { enter="OnEnterSleep", execute="OnExecuteSleep", exit= "OnExitSleep" } )
	self.spawner:AddState( "dummy_state", { enter="OnEnterDummyState", execute="OnExecuteDummyState", exit= "OnEnterDummyState" } )

	self.upgradeHQ = self:CreateStateMachine()
	self.upgradeHQ:AddState( "hq_entry_logic", { enter="OnHqEnterEntryLogic", exit= "OnHqExitEntryLogic" } )
	self.upgradeHQ:AddState( "hq_attack_logic", { enter="OnHqEnterAttackLogic", execute="OnExecuteAttackLogic", exit= "OnHqExitAttackLogic" } )
	self.upgradeHQ:AddState( "hq_exit_logic", { enter="OnHqEnterExitLogic", exit= "OnHqExitExitLogic" } )

	self.difficultyIncrease = self:CreateStateMachine()
	self.difficultyIncrease:AddState( "difficulty_increase", { enter="OnEnterDifficultyIncrease", exit= "OnExitDifficultyIncrease" } )

	self.currentDifficultyLevel = 0
	self.maxDifficultyLevel     = 9

	self.spawnedAttacks		= {}

	self.randomNumber			   = 0

	self.objectivePrepareForTheAttacLogicFileName		= "objectivePrepareForTheAttacLogicFileName"
	self.objectivePrepareForTheAttacLogicFile			= "logic/missions/survival/next_attack_in.logic" -- TODO

	self.preparedAttacks = {}
	self.preparedAttackMarkers = {}

	self.hqPreparedAttacks				= {}
	self.hqPreparedAttackMarkers		= {}
	self.hqLogicLevel					= {}
	self.upgradeHqWaves					= {}
	self.onUpgradeHqLogicEndFileName	= ""
	self.hqAttackSafeTime				= 600

	self.sleepSafeTime = 1200

	self.dumpAllDifficultyInfo = true

	self.freezedDifficultyLevel = self.maxDifficultyLevel

	self.pauseAttacks = DifficultyService:AreWavesDisabled()

	if ( self.pauseAttacks == false ) then
		self.pauseAttacks = self.rules.pauseAttacks
	end

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

end

function dom_mananger:Update()
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

		debug = debug .. " Current difficulty level: " .. tostring( self.currentDifficultyLevel ) .. "\n"
		debug = debug .. " Max difficulty level : " .. tostring( self.freezedDifficultyLevel ) .. "\n"
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
		elseif ( currentSpawnerState == "prepare_spawn" ) then
			debug = debug .. " Time left: " .. tostring( self.waitForSpawnTimer )
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

	self.rules = ProcessRulesTable( self.rules )

	self:VerboseLog("OnLoad - current hq state : " .. tostring( self.upgradeHQ:GetCurrentState() ) )
	self:VerboseLog("OnLoad - current dom state : " .. tostring( self.spawner:GetCurrentState() ) )

	self:LogicFilesSanityCheck();

	self:FillInitialParamsEventManager()
end

function dom_mananger:FillInitialParamsDomManager()

end

	-- ======================================== LOGIC ============================================

function dom_mananger:LogicFilesSanityCheck()

	self:VerboseLog(" ------- LogicFilesSanityCheck ------- " )

	local failedLogicFile = {}

	self:LogicEntryTableCheck( self.rules.buildingsUpgradeStartsLogic, "rules.buildingsUpgradeStartsLogic : ", failedLogicFile )
	self:LogicEntryTableCheck( self.rules.majorAttackLogic, "rules.majorAttackLogic : ", failedLogicFile )

	for data in Iter( self.rules.objectivesLogic ) do 

		if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
			local log = "rules.objectivesLogic : " .. data.name

			table.insert( failedLogicFile, log )
			log = log .. " NOT EXIST"
			LogService:Log( log )
		end
	end

	for data in Iter( self.rules.wavesEntryDefinitions ) do
		if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.name ) ) then
			local log = "rules.wavesEntryDefinitions : " .. data.name

			table.insert( failedLogicFile, log )
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

				table.insert( failedLogicFile, log )
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

	if ( #logicTable ~= 0 ) then		
		if ( #logicTable ~= self.maxDifficultyLevel ) then
			Assert( false, logString .. " size must equal " .. tostring( self.maxDifficultyLevel ) )
		end

		for i = 1, self.maxDifficultyLevel, 1 do 
			for data in Iter( logicTable[i] ) do 
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

function dom_mananger:LogicEntryTableCheck( logicTable, logString, failedLogicFileTable )
	
	if ( logicTable ~= nil ) then
		for data in Iter( logicTable ) do 

			if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.entryLogic ) ) then
				local log = logString .. data.entryLogic
				table.insert( failedLogicFile, log )
				log = log .. " NOT EXIST"
				LogService:Log( log )
			end

		end

		for data in Iter( logicTable ) do 
			if ( not ResourceManager:ResourceExists( "FlowGraphTemplate", data.exitLogic ) ) then
				local log = logString .. data.exitLogic
				table.insert( failedLogicFile, log )
				log = log .. " NOT EXIST"
				LogService:Log( log )
			end
		end
	end
end

function dom_mananger:VerboseLog( message )
	LogService:LogIf( g_verbose_dom_manager, message )
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
	end
end

function dom_mananger:DumpDomProgress( rules )
	self:VerboseLog("prepare attacks : " .. tostring( rules.prepareAttacks ) )
	
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

	if ( self.pauseAttacks == false ) then
		self:VerboseLog("Attack number : 1 Time : 0 Difficulty level : 1 ");

		for i = 2, 20, 1 do
		
			
			difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
			attackTime = attackTime + rules.cooldownAfterAttacks[difficultyLevel]
			prepareAttackTime = attackTime
			difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
			attackTime = attackTime + rules.idleTime[difficultyLevel]
			prepareAttackTime = attackTime

			if ( rules.prepareAttacks == true ) then
				difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
			end

			attackTime = attackTime + rules.prepareSpawnTime[difficultyLevel]

			if ( rules.prepareAttacks == false ) then
				difficultyLevel = self:GetDifficultyLevelFromTime( attackTime, difficultyData )
				prepareAttackTime = attackTime
			end

			self:VerboseLog("Attack number : " .. tostring( i ) .. " Prepare time " .. tostring( prepareAttackTime ) ..  " Attack time : " .. tostring( attackTime ) ..
							"  Difficulty level : ".. tostring( difficultyLevel ) );

			if ( rules.prepareAttacks == true ) then
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

	if ( ( self.pauseAttacks == true ) and ( idleTime > 0 ) ) then
		domType = "scout"
	elseif ( ( self.pauseAttacks == true ) and ( idleTime == 0 ) ) then
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

function dom_mananger:OnBuildingStartEvent( evt )
	
	local isUpgrading = evt:GetUpgrading();
	if ( isUpgrading == false ) then
		return
	end
	
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
			entities = UnitService:CreateDynamicSpawnPoints( target[1], spawn_target_min_radius, spawn_target_max_radius, 1 )
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

function dom_mananger:GetWavePool( currentDifficultyLevel )

	local availableAttackPool = self.availableAttackGroups

	local availableWaves = {}

	if ( self.isForceAttackGroupEnabled == true ) then
		self:VerboseLog("GetWavePool - forced group attack : " .. self.forceAttackGroupName )
		
		self.isForceAttackGroupEnabled = false

		availableAttackPool = {}
		availableAttackPool[#availableAttackPool + 1] = self.forceAttackGroupName
	else
		self:VerboseLog("GetWavePool - available groups." )

		for i = 1, #self.availableAttackGroups, 1 do 
			self:VerboseLog( tostring( self.availableAttackGroups[i] ) )
		end	
	end
		
	for group in Iter ( availableAttackPool )  do
		local waves = self.rules.waves[ group ]
		
		currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #waves )

		if ( currentDifficultyLevel > 0 ) then
			for data in Iter( waves[currentDifficultyLevel] ) do 
				self:VerboseLog("Adding wave to the wave pool : " .. data.name)
				availableWaves[#availableWaves + 1] = data
			end
		end
	end

	return availableWaves
end

function dom_mananger:GetBossPool()
	local currentDifficultyLevel = self.currentDifficultyLevel	
	currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #self.rules.bosses )	

	if ( currentDifficultyLevel > 0 ) then
		return self.rules.bosses[currentDifficultyLevel]
	else
		return {}
	end
end

function dom_mananger:GetExtraWavePool()
	local currentDifficultyLevel = self.currentDifficultyLevel	
	currentDifficultyLevel = Clamp( currentDifficultyLevel, 0, #self.rules.extraWaves )	

	if ( currentDifficultyLevel > 0 ) then
		return self.rules.extraWaves[currentDifficultyLevel]
	else
		return {}
	end
end

function dom_mananger:GetAttackCount( currentDifficultyLevel )	
	return self.rules.maxAttackCountPerDifficulty[currentDifficultyLevel]
end

function dom_mananger:GetPrepareSpawnTime()
	return self.rules.prepareSpawnTime[self.currentDifficultyLevel]
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

		if ( ( self.pauseAttacks == true ) and ( idleTime > 0 ) ) then
			self.spawner:ChangeState( "idle" )
		elseif ( ( self.pauseAttacks == true ) and ( idleTime == 0 ) ) then
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


	if ( ( self.pauseAttacks == false ) and ( self.cancelTheAttack == false ) ) then
		self.data:SetFloat( "time_max", self.waitForSpawnTimer )
		MissionService:ActivateMissionFlow( self.objectivePrepareForTheAttacLogicFileName, self.objectivePrepareForTheAttacLogicFile, "default", self.data )

		if ( self.rules.prepareAttackDefinitions ~= nil ) then
			MissionService:ActivateMissionFlow( "", self.rules.prepareAttackDefinitions[self.currentDifficultyLevel].name, "default" )
		end

		self.preparedAttacks = {}
		self.preparedAttackMarkers = {}

		if ( self.rules.prepareAttacks == true ) then
			local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

			self:VerboseLog("Border spawn point group :" .. borderSpawnPointGroupName )
			self:VerboseLog("Difficulty Level : " .. tostring(self.currentDifficultyLevel ) )

			self:PrepareWave( self:GetAttackCount( self.currentDifficultyLevel ), borderSpawnPointGroupName, self:GetWavePool( self.currentDifficultyLevel ), "OnEnterPrepareSpawn: Prepare attack name : ", self.waitForSpawnTimer, self.preparedAttacks, self.preparedAttackMarkers )
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

		if ( self.pauseAttacks == true ) then
			self.spawner:ChangeState( "dummy_state" )
		else
			self.spawner:ChangeState( "streaming" )
		end
	end

	if ( self.rules.eventsPerPrepareState ~= 0 ) then
		if ( ( self.waitForSpawnTimer < self.eventActivateTime ) and ( self.eventActivated == false ) ) then
			self:StartAnEvent( "IDLE" )
			self.eventActivated = true
		end

		if ( ( self.waitForSpawnTimer < self.objectiveActivateTime ) and ( self.objectiveActivated == false ) ) then
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
	self.cooldownTimer = self.rules.cooldownAfterAttacks[self.currentDifficultyLevel]
end

function dom_mananger:OnExecuteCooldownAfterSpawnTime( state, dt )
	self.cooldownTimer  = self.cooldownTimer - dt

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

	local stateDuration = self.rules.idleTime[self.currentDifficultyLevel]

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
		
		if ( ( self.pauseAttacks == true ) and ( idleTime > 0 ) ) then
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

	if ( ( self.pauseAttacks == true ) and ( idleTime > 0 ) ) then
		self.spawner:ChangeState( "idle" )
	elseif ( ( self.pauseAttacks == true ) and ( idleTime == 0 ) ) then
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

	if ( self.rules.prepareAttacks == true ) then

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
	end
end

function dom_mananger:OnHqExitEntryLogic( state )
	self:VerboseLog("OnHqExitEntryLogic" )
	self.upgradeHQ:ChangeState( "hq_attack_logic" )
end


--------------------------------------------------- hq_attack_logic -------------------------------------------------

function dom_mananger:OnHqEnterAttackLogic( state )
	self:VerboseLog("OnHqEnterAttackLogic" )

	if ( self.rules.prepareAttacks == true ) then
		self:SpawnPreparedWave( "dom_mananger:OnHqExitEntryLogic: Spawn attack name : ", true, self.hqPreparedAttacks, self.upgradeHqWaves )
	else
		local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

		self:VerboseLog("Border spawn point group :" .. borderSpawnPointGroupName )

		local difficultyLevel = self.currentDifficultyLevel + self.hqLogicLevel.level

		if ( self.hqLogicLevel.minLevel ~= nil ) and ( difficultyLevel < self.hqLogicLevel.minLevel ) then
			difficultyLevel = self.hqLogicLevel.minLevel
		end

		difficultyLevel = Clamp( difficultyLevel, 1, self.maxDifficultyLevel )

		local wavePool = self:GetWavePool( difficultyLevel );

		self:SpawnWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "OnHqEnterAttackLogic: Spawn attack name : ", true, "", "label_small", 0, self.upgradeHqWaves )
	end
	self.hqAttackSafeTimer = self.hqAttackSafeTime
end

function dom_mananger:OnExecuteAttackLogic( state, dt )
	self.hqAttackSafeTimer  = self.hqAttackSafeTimer - dt

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

function dom_mananger:PrepareWave( attackCount, borderSpawnPointGroupName, wavePool, log, indicatorTimer, attacks, markers )

	for i = 1, attackCount do
		local waveData = wavePool[RandInt( 1, #wavePool )]
		self:VerboseLog( "PrepareWave: wave_logic='" .. waveData.name .. "'")

		local spawnPointName = self:RandomizeSpawnPoint( borderSpawnPointGroupName, waveData )
		if ( spawnPointName ~= "none" ) then
			local index = #attacks + 1

			attacks[index] = {}
			attacks[index].waveName = waveData.name
			attacks[index].spawnPointName = spawnPointName

			markers[#markers + 1] = self:SpawnWaveIndicator( indicatorTimer, spawnPointName, "effects/messages_and_markers/wave_marker" )

			self:VerboseLog( log .. waveData.name )
		end
	end

end

function dom_mananger:SpawnPreparedWave( log, shouldAddtoSpawnedAttacks, preparedAttacks, spawnedAttacks )
	for preparedWave in Iter( preparedAttacks ) do 
		self.data:SetString( "spawn_point", preparedWave.spawnPointName )

		self:VerboseLog( log .. preparedWave.waveName )

		self:PrepareLabels( "", "label_small", 0 )

		local currentLogicFile = MissionService:ActivateMissionFlow( "", preparedWave.waveName, "default", self.data )
		self:SpawnWaveIndicator( 45, preparedWave.spawnPointName, "effects/messages_and_markers/wave_marker" )				

		if ( shouldAddtoSpawnedAttacks == true ) then
			spawnedAttacks[#spawnedAttacks + 1] = currentLogicFile
		end
	end
end

function dom_mananger:SpawnWave( attackCount, borderSpawnPointGroupName, wavePool, log, shouldAddtoSpawnedAttacks, participants, labelName, participantsPercentageUse, spawnedAttacks )
	for i = 1, attackCount do
		local waveData = wavePool[RandInt( 1, #wavePool )]
		self:VerboseLog( "SpawnWave: wave_logic='" .. waveData.name .. "'")

		local spawnPointName = self:RandomizeSpawnPoint(borderSpawnPointGroupName, waveData )
		if ( spawnPointName ~= "none" ) then
			self:VerboseLog( log .. waveData.name )

			self:PrepareLabels( participants, labelName, participantsPercentageUse )

			self.data:SetString( "spawn_point", spawnPointName )

			local currentLogicFile = MissionService:ActivateMissionFlow( "", waveData.name, "default", self.data )
			self:SpawnWaveIndicator( 45, spawnPointName, "effects/messages_and_markers/wave_marker" )				

			if ( shouldAddtoSpawnedAttacks == true ) then
				spawnedAttacks[#spawnedAttacks + 1] = currentLogicFile
			end
		end
	end

end
--------------------------------------------------- spawn -------------------------------------------------

function dom_mananger:SpawnWavesForDifficultyLevel( difficultyLevel, shouldAddtoSpawnedAttacks )
	local borderSpawnPointGroupName = self.borderSpawnPointGroupNames[RandInt( 1,#self.borderSpawnPointGroupNames )]

	if ( shouldAddtoSpawnedAttacks and #self.preparedAttacks > 0 ) then
		self:SpawnPreparedWave( "dom_mananger:OnEnterSpawn: Prepare attack name : ", shouldAddtoSpawnedAttacks, self.preparedAttacks, self.spawnedAttacks )
	else
		local wavePool = self:GetWavePool( difficultyLevel )
		self:SpawnWave( self:GetAttackCount( difficultyLevel ), borderSpawnPointGroupName, wavePool, "dom_mananger:OnEnterSpawn: Normal attack name : ", shouldAddtoSpawnedAttacks, "", "label_small", 0, self.spawnedAttacks )
	end

	self:SpawnWave( self.extraAttacks, borderSpawnPointGroupName, self:GetExtraWavePool(), "dom_mananger:OnEnterSpawn: Extra attack name : ", shouldAddtoSpawnedAttacks, self.participants, "label_small", self.participantsPercentageUse, self.spawnedAttacks )

	if ( self.spawnBoss == true ) then
		self:SpawnWave( 1, borderSpawnPointGroupName, self:GetBossPool(), "dom_mananger:OnEnterSpawn: Boss attack name : ", false, self.participants, "label_medium", self.participantsPercentageUse, self.spawnedAttacks )
	end		

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

	self:StartAnEvent( "ATTACK" )
end

function dom_mananger:OnExecuteStreaming( state )
	
	if ( ( GameStreamingService:IsInStreamEvent() == false ) or ( GameStreamingService:IsStreamingSessionStarted() == false ) ) then
		self.spawner:ChangeState( "spawn" )
	end

end

function dom_mananger:OnExitStreaming( state )
	self:VerboseLog("OnExitStreaming" )
end

function dom_mananger:OnRespawnFailedEvent()
	self:VerboseLog("Mission failed" )

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
end

return dom_mananger