return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 0
	rules.eventsPerIdleState = 1
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = true
	rules.prepareAttacks = true	

	rules.gameEvents = 
	{	
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120 , weight = 0.5 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 1  },
		{ action = "spawn_fog", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 1  },				
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 1 },
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 1 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 120, maxTime = 180, weight = 1 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 120, maxTime = 180, weight = 1 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_none.logic", minTime = 90, maxTime = 150, weight = 1 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_none.logic", minTime = 90, maxTime = 150, weight = 1 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 1 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 1 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },		
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },	
		--{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120 },
		--{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 120, maxTime = 180, weight = 4 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 120, maxTime = 180, weight = 4 },
		--{ action = "spawn_blooming_air", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/blooming_air.logic", minTime = 120, maxTime = 180, weight = 2 },
		--{ action = "spawn_blooming_air", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/blooming_air.logic", minTime = 120, maxTime = 180, weight = 2 },		
		{ action = "spawn_monsoon", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/monsoon.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_monsoon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/monsoon.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },			
		--{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/weather/tornado_fire_near_player.logic", weight = 0.5 },
		--{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/weather/tornado_fire_near_player.logic", weight = 0.5 },		
		{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/comet_silent.logic", weight = 2 },
	}

	rules.addResourcesOnRunOut = 
	{	
	}

	rules.majorAttackLogic =
	{				
	}

	rules.timeToNextDifficultyLevel = 
	{			
		480, -- difficulty level 1
		240, -- difficulty level 2
		240, -- difficulty level 3	
		240, -- difficulty level 4
		240, -- difficulty level 5
		240, -- difficulty level 6
		240, -- difficulty level 7
		240, -- difficulty level 8
		240, -- difficulty level 9
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
		360,  -- difficulty level 1
		360,  -- difficulty level 2
		360,  -- difficulty level 3
		360,  -- difficulty level 4	
		360,  -- difficulty level 5	
		360,  -- difficulty level 6	
		360,  -- difficulty level 7
		360,  -- difficulty level 8	
		360,  -- difficulty level 9	
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