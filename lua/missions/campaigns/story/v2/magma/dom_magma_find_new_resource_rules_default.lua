return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 3
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true

	rules.gameEvents = 
	{
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60 },		
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="IDLE|STREAMING",        minEventLevel = 2, logicFile="logic/weather/blood_moon.logic",          minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/blood_moon.logic",          minTime = 60, maxTime = 120 },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 2, logicFile="logic/weather/blue_moon.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/blue_moon.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic",       minTime = 60, maxTime = 120 },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic",       minTime = 60, maxTime = 120 },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic",          minTime = 60, maxTime = 120 },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/super_moon.logic",          minTime = 60, maxTime = 120 },				
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",           minTime = 60, maxTime = 120 },				
		{ action = "spawn_volcanic_rock_rain",  type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic",  minTime = 40, maxTime = 90 },
		{ action = "spawn_volcanic_rock_rain",  type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic",  minTime = 40, maxTime = 90 },
		{ action = "spawn_volcanic_ash_clouds", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_volcanic_ash_clouds", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates = "IDLE|STREAMING",      minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates = "IDLE|NO_STREAMING",   minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic",       minTime = 40, maxTime = 90 },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic",       minTime = 40, maxTime = 90 },
		{ action = "spawn_comet_silent",        type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/comet_silent.logic",        weight = 2 },
		{ action = "spawn_firestorm",           type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/firestorm.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 5, logicFile="logic/weather/tornado_fire_near_player.logic",                          weight = 0.5  },
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
		{ name = "logic/objectives/destroy_nest_morirot_single.logic",   minDifficultyLevel = 3 }, 
		{ name = "logic/objectives/destroy_nest_morirot_multiple.logic", minDifficultyLevel = 6 }
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
				"logic/missions/survival/attack_level_1_id_1_magma.logic",
				"logic/missions/survival/attack_level_1_id_2_magma.logic",
			},
			
			{ -- difficulty level 8
				"logic/missions/survival/attack_level_1_id_1_magma.logic",
				"logic/missions/survival/attack_level_1_id_2_magma.logic",
				"logic/missions/survival/attack_level_2_id_1_magma.logic",
			},
			
			{ -- difficulty level 9
				"logic/missions/survival/attack_level_1_id_1_magma.logic",
				"logic/missions/survival/attack_level_1_id_2_magma.logic",
				"logic/missions/survival/attack_level_2_id_1_magma.logic",
				"logic/missions/survival/attack_level_2_id_2_magma.logic",
				"logic/missions/survival/attack_level_3_id_1_magma.logic",
				"logic/missions/survival/attack_level_5_id_1_magma.logic",
			},
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