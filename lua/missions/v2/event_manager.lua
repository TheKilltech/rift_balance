require("lua/utils/string_utils.lua")
require("lua/utils/table_utils.lua")

class 'event_manager' ( LuaGraphNode )

function event_manager:__init()
	LuaGraphNode.__init(self,self)
end

function event_manager:init()

	LogService:Log( "event_manager:------- EVENT MANAGER VER 2.0 ------- " )

	self:InitRules()

	self.currentEventLevel = 1

	self.streamActionResourceGiveBelowPercentage		= 80
	self.streamActionResourceTakeAwayAbovePercentage	= 10
	self.streamActionAmmoGivePercentage					= 80
	self.streamActionAmmoTakeAwayPercentage				= 20

	self.streamAmmunitionSupportGiveAmmoPercentage		= 20
	
	self.streamingVotingTime		= GameStreamingService:GetVotingTime()

	self.areNegativeEventsAllowed	= true
	self.arePositiveEventsAllowed	= true

	self.resourcePercentageStep	    = 3
	self.idleTimeEventMul			= 0.35
	self.idleTimeObjectiveMul		= 0.2
	
	self.objectiveLastLogicFile						= ""
	self.objectiveLastSpawnTime						= 0
	self.objectiveCurrentTimeBetweenNext			= 0
	self.objectiveBaseTimeBetweenNext				= 400
	self.objectiveMinRandTimeBetweenNext			= -100
	self.objectiveMaxRandTimeBetweenNext			= 100
	self.objectiveActiveList						= {}
	self.objectiveAvailableList						= {}

	-- ======================================== DO NOT TOUCH BELOW THE FILE ============================================

	self:RegisterHandler( event_sink, "GameStreamingCreateVoteRequest", "OnGameStreamingCreateVoteRequest" )
	self:RegisterHandler( event_sink, "GameStreamingClearVoteRequest",  "OnGameStreamingClearVoteRequest" )
	self:RegisterHandler( event_sink, "GameStreamingActionEvent",		"OnGameStreamingActionEvent" )

	self.eventManagerTimer = self:CreateStateMachine()
	self.eventManagerTimer:AddState( "timer", { execute="OnExecuteTimer" } )
	self.eventManagerTimer:ChangeState( "timer" )

	self.eventManagerTimer = 0

	self.dynamicStreamingSceneName = "   "

	self.cancelTheAttack		   = false
	self.spawnBoss				   = false;
	self.extraAttacks			   = 0

	self.timeOfDay				   = ""

	self.participants				= ""
	self.participantsPercentageUse  = 0

	self.eventLogicFile				= ""
	self.lastNonStreamEvent			= ""

	self:FillInitialParamsEventManager()

end

function event_manager:Activated()


end

function event_manager:InitRules()
    if ( type( self.rules ) == "string" ) then
        self.rulesFile = self.rules
		LogService:Log( "event_manager:InitRules() : rules file path : " .. tostring( self.rulesFile ) )
		LogService:Log( "event_manager:InitRules() : difficulty : " .. tostring( DifficultyService:GetCurrentDifficultyName() ) )
        self.rules = require( self.rulesFile )()
    end
end

function event_manager:FillInitialParamsEventManager()
	self.excludeResourceList = 
	{
		"uranium",
		"uranium_ore",
		"titanium",
		"palladium",
		"cobalt"
    }

	self.resourceEvents = 
	{
		"spawn_resource_comet",
		"spawn_resource_earthquake"
	}

	self.availableResourcesToSpawn =
	{
		"carbon_vein",
		"iron_vein"
    }

	self.addResourcesOnRunOut		= DeepCopy( self.rules.addResourcesOnRunOut )
	self.addResourcesOnRunOutTimer	= 0
	self.addResourcesOnRunOutTime	= 1200

	if ( self.rules.baseTimeBetweenObjectives ~= nil ) then
		self.objectiveBaseTimeBetweenNext = self.rules.baseTimeBetweenObjectives
	end
end

function event_manager:IncreamentEventLevel( freezedDifficultyLevel )

	self.currentEventLevel = self.currentEventLevel + 1

	if ( self.currentEventLevel > freezedDifficultyLevel ) then
		LogService:Log( "event_manager:IncreamentEventLevel() : Event level will not rise. Clamped to  " .. tostring( freezedDifficultyLevel ) )
		self.currentEventLevel = freezedDifficultyLevel
	end

	LogService:Log( "event_manager:IncreamentEventLevel() - Event level : " .. tostring( self.currentEventLevel ) )
end

function event_manager:OnGameStreamingCreateVoteRequest( event )
	LogService:Log( "event_manager:DOM voting start" )
end

function event_manager:OnGameStreamingClearVoteRequest( event )
	LogService:Log( "event_manager:DOM voting end" )

	GameStreamingService:RemoveDynamicScene( self.dynamicStreamingSceneName )
end

function event_manager:CloseStream()	
	if ( GameStreamingService:IsInStreamEvent() == true ) then
		GameStreamingService:ClearCurrentScene()
	end
end

--  ----------------------------------------------------------- ExecuteTimer ---------------------------------------

function event_manager:OnExecuteTimer( state, dt )
	self.eventManagerTimer = self.eventManagerTimer + dt
end

function event_manager:GetAmountFromAction( actionName )
	for data in Iter( self.currentStreamingData ) do 
		
		if ( data.action == actionName ) and ( data.amount ~= nil ) then
			return data.amount
		end
	end

	return 0
end

function event_manager:TranslateFromAction( actionName )
	for data in Iter( self.currentStreamingData ) do 

		if ( data.action == actionName ) and ( data.originalAction ~= nil ) then
			return data.originalAction
		end
	end

	return actionName
end


function event_manager:GetResourceNameFromAction( actionName )
	for data in Iter( self.currentStreamingData ) do 
		
		if ( data.action == actionName ) and ( data.resourceName ~= nil ) then
			return data.resourceName
		end
	end

	return ""
end

function event_manager:GetResearchNameFromAction( actionName )
	for data in Iter( self.currentStreamingData ) do 
		
		if ( data.action == actionName ) and ( data.researchName ~= nil ) then
			return data.researchName
		end
	end

	return ""
end

function event_manager:GetLogicFileFromAction( actionName, currentStreamingData )
	for data in Iter( currentStreamingData ) do 
		
		if ( data.action == actionName ) and ( data.logicFile ~= nil ) then
			return data.logicFile
		end
	end

	return ""
end

function event_manager:GetMinTimeFromAction( actionName )
	for data in Iter( self.currentStreamingData ) do 		

		if ( data.action == actionName ) and ( data.minTime ~= nil ) then
			return data.minTime
		end
	end

	return 90
end

function event_manager:GetMaxTimeFromAction( actionName )
	for data in Iter( self.currentStreamingData ) do 		

		if ( data.action == actionName ) and ( data.maxTime ~= nil ) then
			return data.maxTime
		end
	end

	return 90
end

function event_manager:HasGameState( gameStates, state )
	local states = Split( gameStates, "|" )

	for gameState in Iter( states ) do
		if ( gameState == state ) then
			return true
		end
	end

	return false
end

function event_manager:AddAmmo( percentage )

	local ammoList = PlayerService:GetAmmoList()

	local players = PlayerService:GetAllPlayers()

	for i = 1, #players, 1 do
		for j = 1, #ammoList, 1 do 
			PlayerService:AddResourceAmount( players[i], ammoList[j], PlayerService:GetResourceLimit( ammoList[j] ) * ( percentage / 100 ), false )
		end
	end
end

function event_manager:SpawnObjective()

	LogService:Log( "event_manager:SpawnObjective() - Trying to spawn an objective. " )

	if ( #self.objectiveAvailableList > 0 ) then
		local random = RandInt( 1, #self.objectiveAvailableList )
		local objectiveName = self.objectiveAvailableList[random]

		local missionName = MissionService:ActivateMissionFlow( "", objectiveName, "default", self.data )

		self.objectiveLastLogicFile				= objectiveName
		self.objectiveLastSpawnTime				= self.eventManagerTimer
		self.objectiveCurrentTimeBetweenNext	= self.objectiveBaseTimeBetweenNext + RandInt( self.objectiveMinRandTimeBetweenNext, self.objectiveMaxRandTimeBetweenNext )

		table.insert( self.objectiveActiveList, missionName )

		LogService:Log( "event_manager:SpawnObjective() - Spawning an objective : " .. objectiveName )
	else
		LogService:Log( "event_manager:SpawnObjective() - No objective to spawn from the objective list." )
	end

end

function event_manager:CheckObjective( checkLastObjectiveSpawnTime, checkCurrentEventLevel )
	
	LogService:Log( "event_manager:CheckObjective()" )

	if ( checkLastObjectiveSpawnTime == true ) then
		
		local timeToNextObjective = self.objectiveLastSpawnTime + self.objectiveCurrentTimeBetweenNext
			
		if ( timeToNextObjective > self.eventManagerTimer ) then
			LogService:Log( "event_manager:CheckObjective() - Not enough time has passed to spawn new objective. Time to next objective" .. tostring( timeToNextObjective ) .. " vs current time " .. tostring( self.eventManagerTimer ) )
			return true
		end		
	end

	if ( self.rules.maxObjectivesAtOnce == #self.objectiveActiveList ) then 		
		LogService:Log( "event_manager:CheckObjective() - There can be only : " .. self.rules.maxObjectivesAtOnce .. " objectives at once. " .. "Current active objectives : " .. #self.objectiveActiveList )
		return true
	end

	local objectives = DeepCopy( self.rules.objectivesLogic )

	local tableTmp = {}

	self.objectiveAvailableList = {}

	for i, data in ipairs( objectives ) do 

		LogService:Log( "event_manager:CheckObjective() - Checking objective : " .. data.name )

		local shouldRemove = false

		for j = 1, #self.objectiveActiveList, 1 do 
			
			local activeObjective = Split( self.objectiveActiveList[j], "#" )

			if ( activeObjective[1] == data.name ) then
				LogService:Log( "event_manager:CheckObjective() - Objective already active : " .. data.name )
				shouldRemove = true
				break
			end
		end

		if ( checkCurrentEventLevel == true ) then
			if ( data.minDifficultyLevel > self.currentEventLevel ) then
				LogService:Log( "event_manager:CheckObjective() - Current event level " .. tostring( self.currentEventLevel ) .." is not enough. Required : " .. tostring( data.minDifficultyLevel ) )
				shouldRemove = true
			end
		end

		if ( data.name == self.objectiveLastLogicFile ) then
			LogService:Log( "event_manager:CheckObjective() - Remove last spawned objective : " .. data.name )
			shouldRemove = true
		end

		if ( shouldRemove == true ) then
			table.insert( tableTmp, data )
		end
	end

	for data in Iter( tableTmp ) do 
		LogService:Log( "event_manager:CheckObjective() - Removing an objective : " .. data.name )
		Remove( objectives, data )
	end

	for i = 1, #objectives, 1 do 
		table.insert( self.objectiveAvailableList, objectives[i].name )
	end

	for i = 1, #self.objectiveAvailableList, 1 do 
		LogService:Log( "event_manager:CheckObjective() -  Available objective." .. self.objectiveAvailableList[i] )
	end

	if ( #objectives == 0 ) then
		return true
	end

	return false
end

function event_manager:PrepareEvents( gameState )

	LogService:Log( "event_manager:PrepareEvents() " .. tostring( gameState ) )

	local streamActive				= GameStreamingService:IsStreamingSessionStarted()

	self.areNegativeEventsAllowed   = GameStreamingService:AreNegativeEventsAllowed()
	self.arePositiveEventsAllowed	= GameStreamingService:ArePositiveEventsAllowed()

	if ( streamActive == true ) then
		LogService:Log( "event_manager:PrepareEvents() - Stream session is active." )
	else
		self.areNegativeEventsAllowed = DifficultyService:AreNegativeEventsEnabled()
		self.arePositiveEventsAllowed = true
		LogService:Log( "event_manager:PrepareEvents() - Stream session is not active." )
	end

	if ( self.areNegativeEventsAllowed == true ) then
		LogService:Log( "event_manager:PrepareEvents() - Negative events are allowed." )
	else
		LogService:Log( "event_manager:PrepareEvents() - Negative events are not allowed." )
	end

	if ( self.arePositiveEventsAllowed == true ) then
		LogService:Log( "event_manager:PrepareEvents() - Positive events are allowed." )
	else
		LogService:Log( "event_manager:PrepareEvents() - Positive events are not allowed." )
	end

	local events = DeepCopy( self.rules.gameEvents )

	local tableTmp = {}

	-- add extra resource event
	for i, data in ipairs( events ) do 
		if ( data.action == "add_resource" ) or ( data.action == "remove_resource" ) then
			tableTmp[#tableTmp + 1] = DeepCopy( events[i] )
		end
	end

	for i = 1, #tableTmp, 1 do 
		events[#events + 1] = DeepCopy( tableTmp[i] )
	end


	local tableTmp = {}

	LogService:Log( "event_manager:PrepareEvents() - Checking configuration." )

	-- check configuration/gamestate
	for i, data in ipairs( events ) do 

		LogService:Log( "event_manager:PrepareEvents() - Checking Action : " .. tostring( data.action ) )
		
		if ( ( data.minEventLevel ~= nil ) and ( data.minEventLevel > self.currentEventLevel ) ) then
			LogService:Log( "event_manager:PrepareEvents() - Current event level " .. tostring( self.currentEventLevel ) .." is not enough. Required : " .. tostring( data.minEventLevel ) )
			table.insert( tableTmp, data )
		end

		if ( ( data.maxEventLevel ~= nil ) and ( data.maxEventLevel < self.currentEventLevel ) ) then
			LogService:Log( "event_manager:PrepareEvents() - Current event level " .. tostring( self.currentEventLevel ) .." is to high. Required : " .. tostring( data.maxEventLevel ) )
			table.insert( tableTmp, data )
		end
	
		if ( ( data.gameStates ~= nil ) and ( self:HasGameState( data.gameStates, gameState ) == false ) ) then
			LogService:Log( "event_manager:PrepareEvents() - Current game state is " .. tostring( gameState ) ..". Action : " .. tostring( data.action ) .. " is only allowed in " .. tostring( data.gameStates ) )
			table.insert( tableTmp, data )
		end

		if ( ( self:HasGameState( data.gameStates, "STREAMING" ) == false ) or ( self:HasGameState( data.gameStates, "NO_STREAMING" ) == false ) ) then
			if ( ( streamActive == false ) and ( self:HasGameState( data.gameStates, "STREAMING" ) == true ) and ( self:HasGameState( data.gameStates, "NO_STREAMING" ) == false ) ) then
				LogService:Log( "event_manager:PrepareEvents() - Action : " .. tostring( data.action ) .. " Only allowed with streaming session." )
				table.insert( tableTmp, data )
			end

			if ( ( streamActive == true ) and ( self:HasGameState( data.gameStates, "STREAMING" ) == false ) and ( self:HasGameState( data.gameStates, "NO_STREAMING" ) == true ) ) then
				LogService:Log( "event_manager:PrepareEvents() - Action : " .. tostring( data.action ) .. " Only allowed without streaming session." )
				table.insert( tableTmp, data )
			end
		else
			LogService:Log( "event_manager:PrepareEvents() - Action : " .. tostring( data.action ) .. ". Allowed in STREAMING and NO_STREAMING." )
		end


		if ( ( self.areNegativeEventsAllowed == false ) and ( self:HasGameState( data.type, "NEGATIVE" ) == true ) ) then
			LogService:Log( "event_manager:PrepareEvents() - Action : " .. tostring( data.action ) .. ". Negative events are not allowed." )
			table.insert( tableTmp, data )
		end

		if ( ( self.arePositiveEventsAllowed == false ) and ( self:HasGameState( data.type, "POSITIVE" ) == true ) ) then
			LogService:Log( "event_manager:PrepareEvents() - Action : " .. tostring( data.action ) .. ". Positive events are not allowed." )
			table.insert( tableTmp, data )
		end
	end



	LogService:Log( "event_manager:PrepareEvents() - Removing events." )
	-- remove not allowed events
	for data in Iter( tableTmp ) do 
		Remove( events, data )
		LogService:Log( "event_manager:PrepareEvents() - Removing : " .. data.action )
	end

	local tableTmp = {}

	LogService:Log( "event_manager:PrepareEvents() - Checking conditions." )

	local addResourceList = {}
	local removeResourceList = {}

	-- check conditions
	for i, data in ipairs( events ) do 

		-- resources
		if ( data.action == "add_resource" ) then
			local remove = self:CheckResourceToAdd( data, addResourceList )
				
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end

		if ( data.action == "remove_resource" ) then
			local remove = self:CheckResourceToRemove( data, removeResourceList )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end

		-- ammo
		if ( data.action == "full_ammo" ) then
			local remove = self:CheckAmmoRefill( data )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end

		if ( data.action == "remove_ammo" ) then
			local remove = self:CheckAmmoRemove( data )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end

		if ( data.action == "new_objective" ) then
			local remove = self:CheckObjective( false, false )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end

		if ( data.action == "change_time_of_day" ) then
			local remove = self:CheckTimeOfDay( false, false )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end	

		if ( data.action == "shegret_attack" ) or
		   ( data.action == "shegret_attack_hard" ) or
		   ( data.action == "shegret_attack_very_hard" ) then
			local remove = false

			if ( ( self:GetTimeOfDay() == "day" ) or ( UnitService:IsLessDefendedOutpostExist( "resource", "light" ) == false ) ) then
				remove = true
			end

			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end	

		if ( data.action == "spawn_super_moon" ) or
		   ( data.action == "spawn_blood_moon" ) or
		   ( data.action == "spawn_fireflies" ) or
		   ( data.action == "spawn_blue_moon" ) then
			local remove = self:IsEarlyNight( false, false )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end	

		if ( data.action == "spawn_solar_eclipse" ) or
		   ( data.action == "spawn_solar_burn" ) then
			local remove = self:IsEarlyDay( false, false )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end	

		if ( data.action == "unlock_research" ) then
			local remove = self:CheckResearch( data )
		
			if ( remove == true ) then
				table.insert( tableTmp, data )
			end
		end

		if ( ( data.action == "spawn_rain" ) or ( data.action == "spawn_acid_rain" ) ) then
			local remove = EnvironmentService:IsRaining()
					
			if ( remove == true ) then
				LogService:Log( "event_manager:PrepareEvents() : it's already raining. Removing " .. tostring( data.action ) )
				table.insert( tableTmp, data )
			end
		end
	
	end

	-- remove not allowed events
	for data in Iter( tableTmp ) do 
		Remove( events, data )
		LogService:Log( "event_manager:PrepareEvents() - Removing : " .. data.action )
	end

	return events
end

-- this should me merged into one function!!! - CheckResource
function event_manager:CheckResourceToAdd( data, addResourceList )

	LogService:Log( "event_manager:CheckResourceToAdd()" )

	local resourceList = PlayerService:GetGlobalResourcesList()

	local availableResurces = {}

	for i = 1, #resourceList, 1 do 
		local resourcePercentage = ( PlayerService:GetResourceAmount( resourceList[i] ) / PlayerService:GetResourceLimit( resourceList[i] ) ) * 100

		LogService:Log( "event_manager:Checking resource " .. resourceList[i] .. " - current percentage : " .. tostring( resourcePercentage ) )

		if ( resourcePercentage < self.streamActionResourceGiveBelowPercentage ) then
			
			local shouldAdd = true

			for j = 1, #addResourceList, 1 do 
				if ( addResourceList[j] == resourceList[i] ) then
					shouldAdd = false
					break
				end
			end

			for j = 1, #self.excludeResourceList, 1 do 
				if ( self.excludeResourceList[j] == resourceList[i] ) then
					shouldAdd = false
					break
				end
			end

			if ( shouldAdd == true ) then
				table.insert( availableResurces, resourceList[i] )
			end
		else
			LogService:Log( "event_manager:Resource percentage above " .. tostring( self.streamActionResourceGiveBelowPercentage ) .. " removing resource : " .. resourceList[i] )
		end
	end

	if ( #availableResurces > 0 ) then
		local resourceName = availableResurces[RandInt( 1, #availableResurces )]

		table.insert( addResourceList, resourceName )

		data.originalAction = data.action	
		data.action			= "add_" ..  resourceName
		data.amount			= PlayerService:GetResourceLimit( resourceName ) * ( ( data.basePercentage + ( self.resourcePercentageStep * ( self.currentEventLevel - 1 ) ) ) / 100 )
		data.passValue		= true
		data.resourceName	= resourceName	

		return false
	end
	
	return true

end

function event_manager:IsEarlyNight()
	local hour = EnvironmentService:GetTimeOfDayHour()

	LogService:Log( "event_manager:IsEarlyNight() - current hour : " .. tostring( hour ) )

	if ( ( ( hour >= 22 ) and ( hour <= 24 ) ) or ( hour <= 1 ) ) then
		return false
	end

	return true
end

function event_manager:IsEarlyDay()
	local hour = EnvironmentService:GetTimeOfDayHour()

	LogService:Log( "event_manager:IsEarlyDay() - current hour : " .. tostring( hour ) )

	if ( ( hour >= 9 ) and ( hour <= 16 ) ) then
		return false
	end

	return true
end

function event_manager:GetTimeOfDay()
	local timeOfDay = EnvironmentService:GetTimeOfDay()

	if ( timeOfDay == "day" or timeOfDay == "sunrise" ) then
		return "day"
	else
		return "night"
	end
end

function event_manager:CheckTimeOfDay()
	local hour = EnvironmentService:GetTimeOfDayHour()

	LogService:Log( "event_manager:CheckTimeOfDay() - current hour : " .. tostring( hour ) )

	if ( ( ( hour >= 22 ) and ( hour <= 24 ) ) or ( hour <= 3 ) ) then
		self.timeOfDay = "day"
		return false
	end

	if ( ( hour >= 10 ) and ( hour <= 18 ) ) then
		self.timeOfDay = "night"
		return false
	end

	return true
end

function event_manager:CheckResearch( data )

	LogService:Log( "event_manager:CheckResearch()" )
	
	local researchList = PlayerService:GetResearchesAvailableToUnlockList( true )

	if ( #researchList > 0 ) then
		local researchName = researchList[RandInt( 1, #researchList )]

		data.passValue		= true
		data.researchName	= researchName
		data.text			= PlayerService:GetResearchNameFromResearchId( researchName )

		return false
	end
	
	return true
end

-- this should me merged into one function!!! - CheckResource
function event_manager:CheckResourceToRemove( data, removeResourceList )

	LogService:Log( "event_manager:CheckResourceToRemove()" )

	local resourceList = PlayerService:GetGlobalResourcesList()

	local availableResurces = {}

	for i = 1, #resourceList, 1 do 
		local resourcePercentage = ( PlayerService:GetResourceAmount( resourceList[i] ) / PlayerService:GetResourceLimit( resourceList[i] ) ) * 100

		LogService:Log( "event_manager:Checking resource " .. resourceList[i] .. " - current percentage : " .. tostring( resourcePercentage ) )

		if ( resourcePercentage > self.streamActionResourceTakeAwayAbovePercentage ) then

			local shouldAdd = true

			for j = 1, #removeResourceList, 1 do 
				if ( removeResourceList[j] == resourceList[i] ) then
					shouldAdd = false
					break
				end
			end

			for j = 1, #self.excludeResourceList, 1 do 
				if ( self.excludeResourceList[j] == resourceList[i] ) then
					shouldAdd = false
					break
				end
			end

			if ( shouldAdd == true ) then
				table.insert( availableResurces, resourceList[i] )
			end
		else
			LogService:Log( "event_manager:Resource percentage below " .. tostring( self.streamActionResourceTakeAwayAbovePercentage ) .. " removing action : " .. resourceList[i] )
		end
	end

	if ( #availableResurces > 0 ) then
		local resourceName = availableResurces[RandInt( 1, #availableResurces )]

		table.insert( removeResourceList, resourceName )

		data.originalAction = data.action
		data.action			= "remove_" ..  resourceName
		data.amount			= PlayerService:GetResourceLimit( resourceName ) * ( ( data.basePercentage + ( self.resourcePercentageStep * ( self.currentEventLevel - 1 ) ) ) / 100 )
		data.passValue		= true
		data.resourceName	= resourceName

		return false
	end
	
	return true

end

function event_manager:CheckAmmoRefill( data )

	LogService:Log( "event_manager:CheckAmmoRefill() " .. tostring( self.streamActionAmmoGivePercentage ) )

	local ammoList = PlayerService:GetAmmoList()

	for i = 1, #ammoList, 1 do 

		if ( PlayerService:GetResourceAmount( ammoList[i] ) > 0 ) then
	
			local ammoPercentage = ( PlayerService:GetResourceAmount( ammoList[i] ) / PlayerService:GetResourceLimit( ammoList[i] ) ) * 100

			LogService:Log( "event_manager:Checking action " .. tostring( data.action ) .. " for " .. ammoList[i] .. " - current percentage : " .. tostring( ammoPercentage ) )

			if ( ammoPercentage > self.streamActionAmmoGivePercentage ) then
				LogService:Log( "event_manager:Ammo give percentage " .. tostring( self.streamActionAmmoGivePercentage ) .. " removing action : " .. data.action )
				return true
			end
		end
	end
	
	return false

end

function event_manager:CheckAmmoRemove( data )

	LogService:Log( "event_manager:CheckAmmoRemove() " .. tostring( self.streamActionAmmoTakeAwayPercentage ) )

	local ammoList = PlayerService:GetAmmoList()

	for i = 1, #ammoList, 1 do 

		if ( PlayerService:GetResourceAmount( ammoList[i] ) > 0 ) then
			local ammoPercentage = ( PlayerService:GetResourceAmount( ammoList[i] ) / PlayerService:GetResourceLimit( ammoList[i] ) ) * 100

			LogService:Log( "Checking action " .. tostring( data.action ) .. " for " .. ammoList[i] .. " - current percentage : " .. tostring( ammoPercentage ) )

			if ( ammoPercentage < self.streamActionAmmoTakeAwayPercentage ) then
				LogService:Log( "Ammo take away percentage " .. tostring( self.streamActionAmmoTakeAwayPercentage ) .. " removing action : " .. data.action )
				return true
			end
		end	
	end
	
	return false

end

function event_manager:CheckObjectiveLogicFile( logicFile )
	
	LogService:Log( "event_manager:CheckObjectiveLogicFile " .. logicFile  )

	for i = 1, #self.objectiveActiveList, 1 do 
		if self.objectiveActiveList[i] == logicFile then
			LogService:Log( "event_manager:CheckObjectiveLogicFile - objectve has finished : " .. logicFile )
			table.remove( self.objectiveActiveList, i )		
		end
	end
end

function event_manager:SpawnExtraResources( logicFile, resourceName, minAmount, maxAmount )
	LogService:Log( "event_manager:SpawnExtraResources " .. resourceName  )
	self.data:SetInt( "minAmount", minAmount )
	self.data:SetInt( "maxAmount", maxAmount )
	self.data:SetString( "resource", resourceName )
	MissionService:ActivateMissionFlow( "", logicFile, "default", self.data )

end

function event_manager:StartStreamingVoting()
	LogService:Log( "event_manager:StartAnEvent() - building streaming event" )
	GameStreamingService:CreateDynamicScene( self.dynamicStreamingSceneName )

	local optionsAtOnce = RandInt( 3, 6 )

	LogService:Log( "event_manager:Options count : " .. tostring( optionsAtOnce) )

	self.currentActions = {}
	local currentStreamingData = {}

	for i = 1, #self.currentStreamingData, 1 do 
		LogService:Log( "event_manager:StartAnEvent() - available event : " .. self.currentStreamingData[i].action )
	end

	local tempStreamingData = DeepCopy( self.currentStreamingData )

	if ( optionsAtOnce > #tempStreamingData ) then
		optionsAtOnce = #tempStreamingData
		LogService:Log( "event_manager:StartAnEvent() - clamping optionsAtOnce : " .. tostring( #tempStreamingData ) )
	end

	while #currentStreamingData ~= optionsAtOnce do
		local event = self:GetEventByWeight( tempStreamingData )

		for i = 1, #tempStreamingData, 1 do 
			if ( event == tempStreamingData[i].action ) then
				LogService:Log( "event_manager:StartAnEvent() - picking event : " .. tempStreamingData[i].action )
				currentStreamingData[#currentStreamingData + 1] = tempStreamingData[i]
				table.remove( tempStreamingData, i )
				break
			end
		end
	end 

	LogService:Log( "event_manager: Creating streaming actions : " .. tostring( optionsAtOnce) )

	-- create actions
	for data in Iter( currentStreamingData ) do 
		LogService:Log( data.action )

		local value = 0
		local text = ""

		if ( ( data.passValue ~= nil ) or ( data.passValue == true ) ) then

			if ( data.amount ~= nil ) then
				value = math.abs( data.amount )
			end 

			if ( data.text ~= nil ) then
				text = data.text
			end 
		end
		Insert( self.currentActions, data.action )
		GameStreamingService:AddActionToDynamicScene( self.dynamicStreamingSceneName, data.action, value, text )
	end

	-- start voting
	GameStreamingService:StartVoting( self.dynamicStreamingSceneName, self.streamingVotingTime )
end

function event_manager:StartAnEvent( gameState )

	LogService:Log( "event_manager:StartAnEvent()" )

	if ( gameState == "IDLE" ) then	
		if ( ( self.addResourcesOnRunOut ~= nil ) and ( #self.addResourcesOnRunOut > 0 ) )then

			LogService:Log( "event_manager:StartAnEvent - checking resources amount on map." )

			local runningOutResources = {}

			for i = 1, #self.addResourcesOnRunOut, 1 do 
				local currentResourcePercentage = ResourceService:GetPercentOfAvailableResourceByType( self.addResourcesOnRunOut[i].name )

				if ( currentResourcePercentage ~= nil ) then
					
					currentResourcePercentage = currentResourcePercentage * 100;

					if ( self.addResourcesOnRunOut[i].runOutPercentageOnMap >= currentResourcePercentage ) then
						local runningOutResourcesIndex = #runningOutResources + 1
						runningOutResources[runningOutResourcesIndex] = self.addResourcesOnRunOut[i]
						runningOutResources[runningOutResourcesIndex].currentResourcePercentage = currentResourcePercentage
						LogService:Log( "event_manager:StartAnEvent - resource is running out : " .. self.addResourcesOnRunOut[i].name .. " amount " ..  tostring( currentResourcePercentage ) .. " adding on below " .. tostring( self.addResourcesOnRunOut[i].runOutPercentageOnMap ) ) 
					else
						LogService:Log( "event_manager:StartAnEvent - resource is not running out : " .. self.addResourcesOnRunOut[i].name .. " amount " ..  tostring( currentResourcePercentage ) .. " adding on below " .. tostring( self.addResourcesOnRunOut[i].runOutPercentageOnMap ) ) 
					end
				else
					LogService:Log( "event_manager:StartAnEvent - resource does not exist on this map : " .. self.addResourcesOnRunOut[i].name )
				end
			end

			local runOutOnMap = false
			local lowerIndex = 1
			local minResourcePercentage = 100

			for i = 1, #runningOutResources, 1 do 
				local currentResourcePercentage = runningOutResources[i].currentResourcePercentage
				if ( minResourcePercentage >= currentResourcePercentage ) then
					lowerIndex = i
					runOutOnMap = true
					minResourcePercentage = currentResourcePercentage
				end
			end

			if ( runOutOnMap ) then
				LogService:Log( "event_manager:StartAnEvent - selecting most run out resource : " .. runningOutResources[lowerIndex].name )	
			
				if ( self.addResourcesOnRunOutTimer > self.eventManagerTimer ) then
					LogService:Log( "event_manager:StartAnEvent - timer is not ready to spawn new resources : " .. tostring( self.addResourcesOnRunOutTimer ) .. " current time : " .. tostring( self.eventManagerTimer ) )
				elseif ( ( runOutOnMap ) and ( self.addResourcesOnRunOutTimer < self.eventManagerTimer ) ) then
					local eventName = self.resourceEvents[RandInt( 1, #self.resourceEvents )] 
					local logicFile = self:GetLogicFileFromAction( eventName, self.rules.gameEvents )

					self.addResourcesOnRunOutTimer = self.eventManagerTimer + self.addResourcesOnRunOutTime

					if ( logicFile ~= "" ) then
						
						LogService:Log( "event_manager:StartAnEvent - spawning resource event : " .. eventName .. " logic file name : " .. logicFile )			
						LogService:Log( "event_manager:StartAnEvent - skipping events : " .. gameState )

						self:SpawnExtraResources( logicFile, runningOutResources[lowerIndex].name, runningOutResources[lowerIndex].minToSpawn, runningOutResources[lowerIndex].maxToSpawn )

						return
					else
						LogService:Log( "event_manager:StartAnEvent - spawning resource event " .. eventName .. " does not exist in the rules." )
					end
				end		
			end
		end
	end

	if ( GameStreamingService:IsInStreamEvent() == true ) then
		LogService:Log( "event_manager:StartAnEvent() - GameStreamingService:IsInStreamEvent() == true" )
		return
	end

	self.currentStreamingData = self:PrepareEvents( gameState )

	if ( ( GameStreamingService:IsStreamingSessionStarted() == true ) and ( #self.spawnedAttacks <= 1 ) and ( GameStreamingService:IsInStreamEvent() == false ) and ( #self.currentStreamingData > 1 ) ) then

		self:StartStreamingVoting()

	elseif ( ( GameStreamingService:IsStreamingSessionStarted() == false ) and ( GameStreamingService:IsInStreamEvent() == false ) and ( #self.currentStreamingData > 0 ) ) then

		LogService:Log( "event_manager:StartAnEvent() - building game event" )

		
		local eventChanceRoll = RandInt( 0, 100 )
		local eventChance = 100

		LogService:Log( "event_manager:StartAnEvent() - eventChanceRoll : " .. eventChanceRoll )

		if ( eventChanceRoll <= eventChance ) then
			for i = 1, #self.currentStreamingData, 1 do 
				if ( self.currentStreamingData[i].action == "new_objective" ) then
					table.remove( self.currentStreamingData, i )
					break
				end
			end

			LogService:Log( "event_manager:StartAnEvent() - removing last event from the list : " .. self.lastNonStreamEvent )
			for i = 1, #self.currentStreamingData, 1 do 
				if ( self.currentStreamingData[i].action == self.lastNonStreamEvent ) then
					table.remove( self.currentStreamingData, i )
					break
				end
			end

			for i = 1, #self.currentStreamingData, 1 do 
				LogService:Log( "event_manager:StartAnEvent() - available event : " .. self.currentStreamingData[i].action )
			end

			if ( #self.currentStreamingData > 0 ) then
				local event = self:GetEventByWeight( self.currentStreamingData )
				self.lastNonStreamEvent	= event
				self:SpawnEvent( event, "" )
			end
		else
			LogService:Log( "event_manager:StartAnEvent() - eventChanceRoll is below roll chance : " .. eventChance )
		end

	end
end


function event_manager:GetEventByWeight( currentStreamingData )
    
	LogService:Log( "event_manager:GetEventByWeight - checking events Probability." )	

	local totalWeight = 0.0

    local events = {}
    for i = 1, #currentStreamingData, 1 do 

        local rangeStart = totalWeight

        if ( currentStreamingData[i].weight ~= nil )  then
            totalWeight = totalWeight + currentStreamingData[i].weight
        else
            totalWeight = totalWeight + 1.0
        end

        local rangeEnd = totalWeight

		LogService:Log( tostring( currentStreamingData[i].action ) .. " -  range : " .. tostring( rangeStart ) .. " - " .. tostring( rangeEnd ) )

        events[currentStreamingData[i].action] = { min = rangeStart, max = rangeEnd }
    end

    local rand = math.random( 0.0, ( totalWeight * 100 ) - 1 ) / 100
    LogService:Log("event_manager:GetEventByWeight - Random : " .. tostring( rand ) )

    for event,v in pairs( events ) do
        if v.min <= rand and v.max > rand then
			LogService:Log("event_manager:GetEventByWeight - Choosing " .. tostring( event ) .. " range: " .. tostring( v.min ) .. " - " .. tostring( v.max ) )
            return event;
        end
    end

end

function event_manager:ChangeTimeOfDay()
	if ( self.timeOfDay ~= "" ) then
		EnvironmentService:SetForwardToTimeOfDay( self.timeOfDay )
		self.timeOfDay = ""
	end
end

function event_manager:StartObjective()
	
	local remove = self:CheckObjective( true, true )

	if ( remove == false ) then
		self:SpawnObjective()
	end
end

--  ----------------------------------------------------------- HelpFromAbove ---------------------------------------

function event_manager:OnEnterHelpFromAbove( state )

	LogService:Log( "event_manager:OnEnterHelpFromAbove" )

	state:SetDurationLimit( 5 )

end

function event_manager:OnExecuteHelpFromAbove( state )


end

function event_manager:OnExitHelpFromAbove( state )

	LogService:Log( "event_manager:OnExitHelpFromAbove" )

end

function event_manager:OnGameStreamingActionEvent( event )
	self:SpawnEvent( event:GetActionName(), event:GetParticipantList() )
end

function event_manager:PickRandomParticipant( participants )
	local list = Split( participants, "|" )

	if ( #list > 0 ) then
		local random = RandInt( 1, #list )
		return list[random]
	end

	return ""
end

function event_manager:SpawnEvent( action, participants )

	local translatedEventName = self:TranslateFromAction( action )

	LogService:Log( "event_manager:SpawnEvent : translatedEventName " .. translatedEventName )
	LogService:Log( "event_manager:SpawnEvent : action " .. action )

	LogService:Log( "event_manager:SpawnEvent : participants " .. participants )

	local amount		= self:GetAmountFromAction( action )
	self.eventLogicFile = self:GetLogicFileFromAction( action, self.currentStreamingData )

	if ( translatedEventName == "spawn_acid_rain" ) or 
		( translatedEventName == "spawn_comet_silent" ) or
		( translatedEventName == "spawn_wind_weak" ) or
		( translatedEventName == "spawn_wind_strong" ) or
		( translatedEventName == "spawn_wind_none" ) or
		( translatedEventName == "spawn_meteor_shower" ) or
		( translatedEventName == "spawn_volcanic_rock_rain" ) or		   
		( translatedEventName == "spawn_ion_storm" ) or
		( translatedEventName == "spawn_thunderstorm" ) or
		( translatedEventName == "spawn_solar_eclipse" ) or
		( translatedEventName == "spawn_earthquake" ) or
		( translatedEventName == "spawn_volcanic_ash_clouds" ) or
		( translatedEventName == "spawn_solar_burn" ) or	  
		( translatedEventName == "spawn_blue_hail" ) or	  	   
		( translatedEventName == "spawn_super_moon" ) or
		( translatedEventName == "spawn_fog" ) or
		( translatedEventName == "shegret_attack" ) or
		( translatedEventName == "shegret_attack_hard" ) or
		( translatedEventName == "shegret_attack_very_hard" ) or
		( translatedEventName == "kermon_attack" ) or
		( translatedEventName == "kermon_attack_hard" ) or
		( translatedEventName == "kermon_attack_very_hard" ) or
		( translatedEventName == "phirian_attack" ) or
		( translatedEventName == "phirian_attack_hard" ) or
		( translatedEventName == "phirian_attack_very_hard" ) or
		( translatedEventName == "spawn_acid_fissures" ) or
		( translatedEventName == "spawn_blood_moon" ) or
		( translatedEventName == "spawn_blue_moon" ) or
		( translatedEventName == "spawn_dust_storm" ) or
		--SWAMP EVENTS START
		( translatedEventName == "spawn_tornado_near_player" ) or
		( translatedEventName == "spawn_tornado_near_base" ) or
		( translatedEventName == "spawn_tornado_acid_near_player" ) or
		( translatedEventName == "spawn_tornado_acid_near_base" ) or
		( translatedEventName == "spawn_tornado_fire_near_player" ) or
		( translatedEventName == "spawn_tornado_fire_near_base" ) or
		( translatedEventName == "spawn_firestorm" ) or
		( translatedEventName == "spawn_fireflies" ) or
		( translatedEventName == "spawn_blooming_air" ) or
		( translatedEventName == "spawn_migrating_birds" ) or
		( translatedEventName == "spawn_monsoon" ) or
		( translatedEventName == "spawn_comet_boss_mudroner_acid" ) or
		( translatedEventName == "spawn_comet_boss_mudroner_cryo" ) or
		( translatedEventName == "spawn_comet_boss_mudroner_energy" ) or
		( translatedEventName == "spawn_comet_boss_mudroner_fire" ) or
		--SWAMP EVENTS END
		--CAVERNS EVENTS START
		( translatedEventName == "spawn_cave_in" ) or
		( translatedEventName == "spawn_falling_stalactites" ) or
		( translatedEventName == "spawn_crystal_growth" ) or
		--CAVERNS EVENTS END
		( translatedEventName == "spawn_rain" ) then
		local timeMin		= self:GetMinTimeFromAction( action )
		local timeMax		= self:GetMaxTimeFromAction( action )
		local randomTime    = RandInt( timeMin, timeMax )
		LogService:Log( "event_manager:SpawnEvent - min time " .. tostring( timeMin ) )
		LogService:Log( "event_manager:SpawnEvent - max time " .. tostring( timeMax ) )
		LogService:Log( "event_manager:SpawnEvent - time set to " .. tostring( randomTime ) )
		self.data:SetInt( "time", randomTime )
		MissionService:ActivateMissionFlow( "", self.eventLogicFile, "default", self.data )
	elseif ( translatedEventName == "add_resource" ) then
		PlayerService:AddResourceAmount( self:GetResourceNameFromAction( action ), amount )
	elseif ( translatedEventName == "remove_resource" ) then
		PlayerService:AddResourceAmount( self:GetResourceNameFromAction( action ), -amount )
	elseif ( translatedEventName == "cancel_the_attack" ) then
		self.cancelTheAttack = true
	elseif ( translatedEventName == "stronger_attack" ) then
		self.extraAttacks = amount
		self.participants = participants
		self.participantsPercentageUse = 33
	elseif ( translatedEventName == "full_ammo" ) then
		self:AddAmmo( 100 )
	elseif ( translatedEventName == "remove_ammo" ) then
		self:AddAmmo( -100 )
	elseif ( translatedEventName == "extra_ammo" ) then
		self:AddAmmo( self.streamAmmunitionSupportGiveAmmoPercentage )
	elseif ( translatedEventName == "meteor_strike" ) then
		MeteorService:SpawnMeteorInFrustum( "weather/meteor_medium", 50, 140 )
	elseif ( translatedEventName == "new_objective" ) then
		self:SpawnObjective()
	elseif ( translatedEventName == "change_time_of_day" ) then
		self:ChangeTimeOfDay()
	elseif ( ( translatedEventName == "spawn_resource_comet" ) or ( translatedEventName == "spawn_resource_earthquake" ) )then
		local resource = self.availableResourcesToSpawn[RandInt( 1, #self.availableResourcesToSpawn )]
		self:SpawnExtraResources( self.eventLogicFile, resource, 10000, 20000 )
	elseif ( translatedEventName == "boss_attack" ) then
		self.spawnBoss = true
		self.participants = self:PickRandomParticipant( participants )
		self.participantsPercentageUse = 100
	elseif ( translatedEventName == "unlock_research" ) then
		PlayerService:UnlockResearch( self:GetResearchNameFromAction( translatedEventName ) )
	end

end

return event_manager