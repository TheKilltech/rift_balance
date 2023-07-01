return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 1
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.spawnAttackEventProbability = 0.2
	rules.spawn2ndAttackEventProbability = 0.2

	rules.gameEvents = 
	{
		{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1 },
		{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|NO_STREAMING",      minEventLevel = 1 },
		{ action = "stronger_attack", 	        type = "NEGATIVE", gameStates="ATTACK|STREAMING", 		  minEventLevel = 8, amount = 2 },
		{ action = "stronger_attack", 	        type = "NEGATIVE", gameStates="ATTACK|NO_STREAMING", 	  minEventLevel = 8, amount = 2 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3, logicFile="logic/event/shegret_attack.logic",  weight = 8 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 3, logicFile="logic/event/shegret_attack.logic",  weight = 8 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/earthquake.logic",    minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic",    minTime = 60, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 4, logicFile="logic/weather/blue_hail.logic",     minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail",           type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic",     minTime = 30, maxTime = 60, weight = 0.1 },
		{ action = "spawn_thunderstorm",        type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic",  minTime = 60, maxTime = 120 },
		{ action = "spawn_thunderstorm",        type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic",  minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120 , weight = 0.5},
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 3, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 3, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, logicFile="logic/weather/fog.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 1, logicFile="logic/weather/fog.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, logicFile="logic/weather/rain.logic",          minTime = 120, maxTime = 120 },
		{ action = "spawn_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic",          minTime = 120, maxTime = 120 },
		{ action = "spawn_wind_weak",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, logicFile="logic/weather/wind_weak.logic",     minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_weak",           type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic",     minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong",         type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, logicFile="logic/weather/wind_strong.logic",   minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong",         type = "POSITIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic",   minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 2, logicFile="logic/weather/wind_none.logic",     minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none",           type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_none.logic",     minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic",   weight = 0.5 },
		{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic",   weight = 0.25 },		
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates="IDLE|STREAMING",           minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic", weight = 1 },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic", weight = 0.5 },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60, weight = 0.25 },	
		{ action = "spawn_comet_silent",        type = "POSITIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 1, logicFile="logic/weather/comet_silent.logic",        weight = 2 }
	}

	rules.addResourcesOnRunOut = 
	{		
	}

	rules.majorAttackLogic =
	{				
	}

	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		200, -- difficulty level 2
		200, -- difficulty level 3	
		600, -- difficulty level 4
		1200, -- difficulty level 5
		1200, -- difficulty level 6
		1500, -- difficulty level 7
		1500, -- difficulty level 8
		1500, -- difficulty level 9
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
		90,  -- difficulty level 3
		120,  -- difficulty level 4	
		120,  -- difficulty level 5	
		180,  -- difficulty level 6	
		180,  -- difficulty level 7
		240,  -- difficulty level 8	
		240,  -- difficulty level 9	
	}

	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		1200,  -- difficulty level 6	
		1200,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1200,  -- difficulty level 9	
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
		1,  -- difficulty level 8
		2,  -- difficulty level 9
	}
	
	rules.prepareAttackDefinitions =
	{		
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 1		
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 3				
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 5					
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 6			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 7			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 8					
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 9		
	}

	rules.wavesEntryDefinitions =
	{		 
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 1		 
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 3			
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 5			
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 6					
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 7				
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 8					
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 9
	}
	
	rules.waves = 
	{
		["default"] =
		{					
			{}, -- difficulty level 1
			{}, -- difficulty level 2
			{}, -- difficulty level 3
			{}, -- difficulty level 4
			{}, -- difficulty level 5			
			{}, -- difficulty level 6	
			{}, -- difficulty level 7
			
			{ -- difficulty level 7
				"logic/missions/survival/attack_level_1_id_1.logic",
				"logic/missions/survival/attack_level_1_id_2.logic",
			},
			
			{ -- difficulty level 8
				"logic/missions/survival/attack_level_1_id_1.logic",
				"logic/missions/survival/attack_level_1_id_2.logic",
				"logic/missions/survival/attack_level_2_id_1.logic",
			},
		},
	}

	rules.extraWaves = 
	{
		{}, -- difficulty level 1
		{}, -- difficulty level 2
		{}, -- difficulty level 3
		{}, -- difficulty level 4
		{}, -- difficulty level 5			
		{}, -- difficulty level 6
		{}, -- difficulty level 7
		{}, -- difficulty level 8
				 
		{ -- difficulty level 9
			"logic/missions/survival/attack_level_1_id_1_alpha.logic",
			"logic/missions/survival/attack_level_1_id_2_alpha.logic",
			"logic/missions/survival/attack_level_1_id_1_ultra.logic",
			"logic/missions/survival/attack_level_1_id_2_ultra.logic",
			"logic/missions/survival/attack_level_3_id_1_alpha.logic",
			"logic/missions/survival/attack_level_3_id_2_ultra.logic",
		},	
	}

	rules.bosses = 
	{	
	}

    return rules;
end