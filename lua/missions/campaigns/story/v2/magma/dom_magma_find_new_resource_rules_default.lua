return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 3
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = true
	rules.prepareAttacks = true

	rules.gameEvents = 
	{
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60 },		
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120 },				
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 60, maxTime = 120 },				
		{ action = "spawn_volcanic_rock_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic", minTime = 40, maxTime = 90 },
		{ action = "spawn_volcanic_rock_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic", minTime = 40, maxTime = 90 },
		{ action = "spawn_volcanic_ash_clouds", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_volcanic_ash_clouds", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 40, maxTime = 90 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 40, maxTime = 90 },
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 9, logicFile="logic/weather/tornado_fire_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 9, logicFile="logic/weather/tornado_fire_near_player.logic", weight = 0.5 },
		
		{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120 },
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
		{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 2 }
	}

	rules.addResourcesOnRunOut = 
	{

	}

	rules.timeToNextDifficultyLevel = 
	{			
		1200, -- difficulty level 1
		1200, -- difficulty level 2
		1200, -- difficulty level 3	
		1200, -- difficulty level 4
		1200, -- difficulty level 5
		1200, -- difficulty level 6
		1200, -- difficulty level 7
		1200, -- difficulty level 8
		1200, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		60,  -- difficulty level 1
		60,  -- difficulty level 2
		60,  -- difficulty level 3
		60,  -- difficulty level 4	
		60,  -- difficulty level 5	
		60,  -- difficulty level 6	
		60,  -- difficulty level 7
		60,  -- difficulty level 8	
		60,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
  
	}

	rules.objectivesLogic = 
	{
	
	}

	rules.cooldownAfterAttacks = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3
		0,  -- difficulty level 4	
		0,  -- difficulty level 5	
		0,  -- difficulty level 6	
		0,  -- difficulty level 7
		0,  -- difficulty level 8	
		0,  -- difficulty level 9	
	}

	rules.idleTime = 
	{			
		600,  -- difficulty level 1
		600,  -- difficulty level 2
		600,  -- difficulty level 3
		600,  -- difficulty level 4	
		600,  -- difficulty level 5	
		600,  -- difficulty level 6	
		600,  -- difficulty level 7
		600,  -- difficulty level 8	
		600,  -- difficulty level 9	
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3		
		0,  -- difficulty level 4
		0,  -- difficulty level 5
		0,  -- difficulty level 6
		0,  -- difficulty level 7
		0,  -- difficulty level 8
		0,  -- difficulty level 9
	}
	
	rules.wavesEntryDefinitions =
	{
	}

	rules.waves = 
	{
		["default"] =
		{			
		},
	}

	rules.extraWaves = 
	{
	
	}

	rules.bosses = 
	{

	}

    return rules;
end