return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 0
	rules.eventsPerIdleState = 1
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.spawnAttackEventProbability = 0.2
	rules.spawn2ndAttackEventProbability = 0.2

	rules.gameEvents = 
	{
		{ action = "new_objective",             type = "POSITIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",        type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3 },
		{ action = "add_resource",              type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1, amount = 2 },
		{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK|NO_STREAMING",      minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1 },
		{ action = "unlock_research",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1 },
		{ action = "full_ammo",                 type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "remove_ammo",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "boss_attack",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 4 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|STREAMING",           minEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",        minEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3 },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_cave_in",             type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/cave_in.logic" },
		{ action = "spawn_crystal_growth",      type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/crystal_growth.logic" },
		{ action = "spawn_falling_stalactites", type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 4, logicFile="logic/weather/falling_stalactites.logic" },

	}

	rules.addResourcesOnRunOut = 
	{	
	}

	rules.majorAttackLogic =
	{				
	}

	rules.timeToNextDifficultyLevel = 
	{			
		180, -- difficulty level 1
		180, -- difficulty level 2
		180, -- difficulty level 3
		300, -- difficulty level 4
		900, -- difficulty level 5
		1020, -- difficulty level 6
		1200, -- difficulty level 7
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
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 1		 
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 3			
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 5			
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 6					
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 7				
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 8					
		"logic/dom/attack_level_2_caverns_entry.logic", -- difficulty level 9
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
						 
			{ -- difficulty level 8
				"logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
			},
			 
			{ -- difficulty level 9
				"logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
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
		
		{ -- difficulty level 8
			"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
		},
		  
		{ -- difficulty level 9
			"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic",
		},	
	}

	rules.bosses = 
	{		
	}

    return rules;
end