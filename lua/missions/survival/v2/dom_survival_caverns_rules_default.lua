return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 0
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true

	rules.gameEvents = 
	{
		{ action = "new_objective", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
		{ action = "add_resource", type = "POSITIVE", gameStates = "ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource", type = "NEGATIVE", gameStates = "ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack", type = "NEGATIVE", gameStates = "ATTACK|STREAMING", minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack", type = "POSITIVE", gameStates = "ATTACK|STREAMING", minEventLevel = 1 },
		{ action = "unlock_research", type = "POSITIVE", gameStates = "ATTACK|IDLE|STREAMING", minEventLevel = 1 },
		{ action = "full_ammo", type = "POSITIVE", gameStates = "ATTACK|STREAMING", minEventLevel = 2 },
		{ action = "remove_ammo", type = "NEGATIVE", gameStates = "ATTACK|STREAMING", minEventLevel = 2 },
		{ action = "boss_attack", type = "NEGATIVE", gameStates = "ATTACK|STREAMING", minEventLevel = 4 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },		
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, maxEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, maxEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "very_hard" } },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "very_hard" } },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_cave_in", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/cave_in.logic" },
		{ action = "spawn_cave_in", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/cave_in.logic" },
		{ action = "spawn_crystal_growth", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/crystal_growth.logic" },
		{ action = "spawn_crystal_growth", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/crystal_growth.logic" },
		{ action = "spawn_falling_stalactites", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/falling_stalactites.logic" },
		{ action = "spawn_falling_stalactites", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/falling_stalactites.logic" },
		
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_vein", runOutPercentageOnMap = 45, minToSpawn = 30000, maxToSpawn = 45000 },
		{ name = "iron_vein", runOutPercentageOnMap = 45, minToSpawn = 30000, maxToSpawn = 45000 },
	}
	
	rules.creatureDifficultyIncrementPerDOMDifficulty =
	{
		[1] =
		{	
			0,	 -- initial difficulty
			0, -- difficulty level 2
			0, -- difficulty level 3	
			0, -- difficulty level 4
			0, -- difficulty level 5
			0.5, -- difficulty level 6
			0.5, -- difficulty level 7
			0.5, -- difficulty level 8
			1.5, -- difficulty level 9
		},
		[2] =
		{	
			0, -- initial difficulty
			2, -- difficulty level 2
			0, -- difficulty level 3	
			1, -- difficulty level 4
			0, -- difficulty level 5
			1, -- difficulty level 6
			0, -- difficulty level 7
			1, -- difficulty level 8
			0, -- difficulty level 9
		},
		[3] =
		{	
			2,	 -- initial difficulty
			0, -- difficulty level 2
			1, -- difficulty level 3	
			0, -- difficulty level 4
			1, -- difficulty level 5
			0, -- difficulty level 6
			1, -- difficulty level 7
			0, -- difficulty level 8
			1, -- difficulty level 9
		},
		[4] =
		{	
			2,	 -- initial difficulty
			1, -- difficulty level 2
			0, -- difficulty level 3	
			1, -- difficulty level 4
			0, -- difficulty level 5
			1, -- difficulty level 6
			0, -- difficulty level 7
			1, -- difficulty level 8
			1, -- difficulty level 9
		},
	}

	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		600, -- difficulty level 2
		600, -- difficulty level 3	
		600, -- difficulty level 4
		600, -- difficulty level 5
		600, -- difficulty level 6
		600, -- difficulty level 7
		600, -- difficulty level 8
		600, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		420,  -- difficulty level 1
		360,  -- difficulty level 2
		360,  -- difficulty level 3
		480,  -- difficulty level 4	
		360,  -- difficulty level 5	
		360,  -- difficulty level 6	
		480,  -- difficulty level 7
		360,  -- difficulty level 8	
		360,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
		--{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		--{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		--{ name = "headquarters_lvl_4", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_5", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_6", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_7", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic", minDifficultyLevel = 3 },		
	}

	rules.cooldownAfterAttacks = 
	{			
		120,  -- difficulty level 1
		150,  -- difficulty level 2
		150,  -- difficulty level 3
		210,  -- difficulty level 4	
		210,  -- difficulty level 5	
		210,  -- difficulty level 6	
		270,  -- difficulty level 7
		270,  -- difficulty level 8	
		270,  -- difficulty level 9	
	}

	rules.idleTime = 
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

	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		1,  -- difficulty level 3		
		2,  -- difficulty level 4
		2,  -- difficulty level 5
		2,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		3,  -- difficulty level 9
	}

	--rules.prepareAttackDefinitions =
	--{
	--	 -- difficulty level 1
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 2
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 3		
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 4		
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 5		
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 6		
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 7		
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 8		
	--		"logic/dom/attack_level_1_prepare.logic",
	--	 -- difficulty level 9		
	--		"logic/dom/attack_level_1_prepare.logic",		
	--}	
	
	rules.wavesEntryDefinitions =
	{
		 -- difficulty level 1
			"logic/missions/survival/caverns/attack_level_1_caverns_entry.logic",
		 -- difficulty level 2
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 3		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 4		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 5		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 6		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 7		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 8		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
		 -- difficulty level 9		
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic",
	}

	rules.waves = 
	{
		["default"] =
		{
			-- difficulty level 1		
			{ 
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns.logic",			
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
			},
		},
	}
	
	rules.multiplayerWaves = 
	{
		 -- difficulty level 1		
		{ 
			additionalWaves = -1, -- Additional Waves count = 1 + additionalWaves - regardless of player number. Multiplayer Additional waves are disabled in single player mode. Check dom_mananger:GetMultiplayerAttackCount for actual code
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			}
		},
	
		 -- difficulty level 2
		{ 
			additionalWaves = 0,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			}
		},
		 -- difficulty level 3
		{ 
			additionalWaves = 0,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
			}
		},

		 -- difficulty level 4
		{ 
			additionalWaves = 0,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
			}
		},

		 -- difficulty level 5
		{ 
			additionalWaves = 0,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
			}
		},

		 -- difficulty level 6
		{ 
			additionalWaves = 0,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},
			}
		},

		 -- difficulty level 7
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_dynamic.logic"
			}
		},

		 -- difficulty level 8
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_dynamic.logic"
			}
		},

		 -- difficulty level 9
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_dynamic.logic"
			}
		},
	}

	rules.extraWaves = 	
	{
		 -- difficulty level 1		
		{ 
			{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=300.0, target_max_radius=600.0},
			{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=300.0, target_max_radius=600.0},
		},
	
		 -- difficulty level 2
		{ 			
			{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=300.0, target_max_radius=600.0},
			{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=300.0, target_max_radius=600.0},
		},

		 -- difficulty level 3
		{ 
			{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=300.0, target_max_radius=600.0},
			{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=300.0, target_max_radius=600.0},
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic",			
			"logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic",						
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/caverns/attack_level_6_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_6_id_2_caverns.logic",			
			"logic/missions/survival/caverns/attack_level_6_id_3_caverns.logic",						
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/caverns/attack_level_7_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_7_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_7_id_3_caverns.logic",			
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",			
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",			
		},
	}



	rules.bosses = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_boss_dynamic.logic",		
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_boss_dynamic.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_boss_dynamic.logic",
		},
	}

    return rules;
end