return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 0
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = false

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
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, maxEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, maxEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "very_hard" } },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack.logic", weight = 3, bindingParams = { attack_strength = "very_hard" } },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 1 },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 1 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60 },		
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25  },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.25  },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.25  },				
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 60, maxTime = 120 },				
		{ action = "spawn_volcanic_rock_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic", minTime = 25, maxTime = 30 },
		{ action = "spawn_volcanic_rock_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic", minTime = 25, maxTime = 30 },
		{ action = "spawn_volcanic_ash_clouds", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_volcanic_ash_clouds", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120 },	
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_earthquake.logic" },		
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 25, maxTime = 30, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 25, maxTime = 30, weight = 0.5 },
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
			additionalWaves = 1,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},
			}
		},

		 -- difficulty level 7
		{ 
			additionalWaves = 1,
			waves = 
			{
				"logic/missions/survival/attack_boss_dynamic.logic"
			}
		},

		 -- difficulty level 8
		{ 
			additionalWaves = 1,
			waves = 
			{
				"logic/missions/survival/attack_boss_dynamic.logic"
			}
		},

		 -- difficulty level 9
		{ 
			additionalWaves = 1,
			waves = 
			{
				"logic/missions/survival/attack_boss_dynamic.logic"
			}
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
		420,  -- difficulty level 2
		420,  -- difficulty level 3
		420,  -- difficulty level 4	
		420,  -- difficulty level 5	
		420,  -- difficulty level 6	
		420,  -- difficulty level 7
		420,  -- difficulty level 8	
		420,  -- difficulty level 9	
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
		{ name = "logic/objectives/destroy_nest_morirot_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 5 }, 
		{ name = "logic/objectives/destroy_nest_morirot_multiple.logic", minDifficultyLevel = 6 } 
	}

	rules.cooldownAfterAttacks = 
	{			
		60,  -- difficulty level 1
		90,  -- difficulty level 2
		120,  -- difficulty level 3
		180,  -- difficulty level 4	
		180,  -- difficulty level 5	
		180,  -- difficulty level 6	
		240,  -- difficulty level 7
		240,  -- difficulty level 8	
		240,  -- difficulty level 9	
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
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		2,  -- difficulty level 5
		2,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		3,  -- difficulty level 9
	}
	
	rules.wavesEntryDefinitions =
	{
		 -- difficulty level 1
			"logic/dom/attack_level_1_entry.logic",
		 -- difficulty level 2
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 3		
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 4		
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 5		
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 6		
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 7		
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 8		
			"logic/dom/attack_level_2_entry.logic",
		 -- difficulty level 9		
			"logic/dom/attack_level_2_entry.logic",
	}

	rules.waves = 
	{
		["default"] =
		{
			 -- difficulty level 1		
			{ 
				{ name="logic/missions/survival/attack_level_1_id_1_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/attack_level_1_id_2_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/attack_level_2_id_1_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/attack_level_2_id_2_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/attack_level_3_id_1_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/attack_level_3_id_2_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/attack_level_4_id_1_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/attack_level_4_id_2_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/attack_level_5_id_1_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/attack_level_5_id_2_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},			
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/attack_level_6_id_1_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},
				{ name="logic/missions/survival/attack_level_6_id_2_magma.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},		
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1_magma.logic",
				"logic/missions/survival/attack_level_7_id_2_magma.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",
			},
		},
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_level_1_id_1_magma.logic",
			"logic/missions/survival/attack_level_1_id_2_magma.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_level_2_id_1_magma.logic",
			"logic/missions/survival/attack_level_2_id_2_magma.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_level_3_id_1_magma.logic",
			"logic/missions/survival/attack_level_3_id_2_magma.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_level_4_id_1_magma.logic",
			"logic/missions/survival/attack_level_4_id_2_magma.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_level_5_id_1_magma.logic",
			"logic/missions/survival/attack_level_5_id_2_magma.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_level_6_id_1_magma.logic",
			"logic/missions/survival/attack_level_6_id_2_magma.logic",			
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_level_7_id_1_magma.logic",
			"logic/missions/survival/attack_level_7_id_2_magma.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_level_8_id_1_magma.logic",
			"logic/missions/survival/attack_level_8_id_2_magma.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_level_8_id_1_magma.logic",
			"logic/missions/survival/attack_level_8_id_2_magma.logic",
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