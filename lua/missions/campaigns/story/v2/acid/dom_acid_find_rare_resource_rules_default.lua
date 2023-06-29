return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 900

	rules.gameEvents = 
	{
		{ action = "shegret_attack",      type = "NEGATIVE", gameStates="IDLE|STREAMING",        minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",  weight = 5 },
		{ action = "shegret_attack",      type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",  weight = 3 },
		{ action = "spawn_earthquake",    type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/earthquake.logic",    minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_earthquake",    type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/earthquake.logic",    minTime = 30, maxTime = 60,  weight = 0.5 },		
		{ action = "spawn_blood_moon",    type = "NEGATIVE", gameStates="IDLE|STREAMING",        minEventLevel = 4, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blood_moon",    type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",     type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 4, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",     type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon",    type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",    type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic",           minTime = 30, maxTime = 60 },
		{ action = "spawn_fog",           type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/fog.logic",           minTime = 30, maxTime = 60 },
		{ action = "spawn_wind_weak",     type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_weak",     type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/wind_weak.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_none",     type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_none.logic",     minTime = 30, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_none",     type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/wind_none.logic",     minTime = 30, maxTime = 120, weight = 0.5 },
		{ action = "spawn_ion_storm",     type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_ion_storm",     type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60,  weight = 0.5 },		
		{ action = "spawn_acid_rain",     type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/acid_rain.logic",     minTime = 30, maxTime = 60 },
		{ action = "spawn_acid_rain",     type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/acid_rain.logic",     minTime = 30, maxTime = 30 },
		{ action = "spawn_acid_fissures", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/acid_fissures.logic", minTime = 30, maxTime = 60,  weight = 2 },
		{ action = "spawn_acid_fissures", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/acid_fissures.logic", minTime = 30, maxTime = 60,  weight = 2 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 40, maxTime = 90,  weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 40, maxTime = 90,  weight = 0.5 },	
		{ action = "spawn_comet_silent",  type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/comet_silent.logic",  weight = 2 }
		--{ action = "spawn_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120 },
		--{ action = "spawn_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120 },
		--{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		--{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		--{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		--{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		--{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		--{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
	}

	rules.addResourcesOnRunOut = 
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
		{ name = "logic/objectives/destroy_nest_granan_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_granan_single.logic",   minDifficultyLevel = 3 },
		{ name = "logic/objectives/kill_elite.logic",                   minDifficultyLevel = 4 }
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
		1,  -- difficulty level 7
		2,  -- difficulty level 8
		3,  -- difficulty level 9
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
			
			{ -- difficulty level 7
				"logic/missions/survival/attack_level_1_id_1_acid.logic",
				"logic/missions/survival/attack_level_1_id_2_acid.logic",
			},

			{ -- difficulty level 8
				"logic/missions/survival/attack_level_1_id_1_acid.logic",
				"logic/missions/survival/attack_level_1_id_2_acid.logic",
				"logic/missions/survival/attack_level_2_id_1_acid.logic",
			},

			{ -- difficulty level 9
				"logic/missions/survival/attack_level_1_id_1_acid.logic",
				"logic/missions/survival/attack_level_1_id_2_acid.logic",
				"logic/missions/survival/attack_level_2_id_1_acid.logic",
				"logic/missions/survival/attack_level_2_id_2_acid.logic",
				"logic/missions/survival/attack_level_3_id_1_acid.logic",
				"logic/missions/survival/attack_level_5_id_1_acid.logic",
			},
		},
	}

	rules.extraWaves = 
	{
	
	}

	rules.bosses = 
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
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

	}

    return rules;
end