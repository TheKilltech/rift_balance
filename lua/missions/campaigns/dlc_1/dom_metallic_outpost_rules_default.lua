return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800

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
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120 , weight = 2 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },		
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 4, maxEventLevel = 5, logicFile="logic/event/shegret_attack.logic", weight = 5, bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, maxEventLevel = 5, logicFile="logic/event/shegret_attack.logic", weight = 5, bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 5, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 5, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack.logic", weight = 5, bindingParams = { attack_strength = "very_hard" } },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack.logic", weight = 5, bindingParams = { attack_strength = "very_hard" } },
		{ action = "kermon_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 6, logicFile="logic/event/kermon_attack.logic", weight = 1, bindingParams = { attack_strength = "normal" } },
		{ action = "kermon_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 6, logicFile="logic/event/kermon_attack.logic", weight = 1, bindingParams = { attack_strength = "normal" } },
		{ action = "kermon_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 7, maxEventLevel = 8, logicFile="logic/event/kermon_attack.logic", weight = 1, bindingParams = { attack_strength = "hard" } },
		{ action = "kermon_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 7, maxEventLevel = 8, logicFile="logic/event/kermon_attack.logic", weight = 1, bindingParams = { attack_strength = "hard" } },
		{ action = "kermon_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 9, maxEventLevel = 9, logicFile="logic/event/kermon_attack.logic", weight = 1, bindingParams = { attack_strength = "very_hard" } },
		{ action = "kermon_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 9, maxEventLevel = 9, logicFile="logic/event/kermon_attack.logic", weight = 1, bindingParams = { attack_strength = "very_hard" } },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_none.logic", minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_none.logic", minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 1 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 1 },		
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },	
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein", runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		300, -- difficulty level 2
		300, -- difficulty level 3	
		300, -- difficulty level 4
		450, -- difficulty level 5
		450, -- difficulty level 6
		450, -- difficulty level 7
		450, -- difficulty level 8
		450, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		120,  -- difficulty level 1
		120,  -- difficulty level 2
		120,  -- difficulty level 3
		120,  -- difficulty level 4	
		120,  -- difficulty level 5	
		120,  -- difficulty level 6	
		120,  -- difficulty level 7
		120,  -- difficulty level 8	
		120,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_wingmite_single.logic", minDifficultyLevel = 4, maxDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_wingmite_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_bradron_single.logic", minDifficultyLevel = 4, maxDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_bradron_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_octabit_single.logic", minDifficultyLevel = 5, maxDifficultyLevel = 7 }, 
		{ name = "logic/objectives/destroy_nest_octabit_multiple.logic", minDifficultyLevel = 7 },
		{ name = "logic/objectives/destroy_nest_flurian_single.logic", minDifficultyLevel = 6, maxDifficultyLevel = 8 }, 
		{ name = "logic/objectives/destroy_nest_flurian_multiple.logic", minDifficultyLevel = 8 }
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
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		840,  -- difficulty level 6	
		900,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
	}
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}
	
	rules.prepareAttackDefinitions =
	{
		 -- difficulty level 1
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 2
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 3		
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 4		
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 5		
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 6		
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 7		
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 8		
			"logic/dom/attack_level_1_prepare.logic",
		 -- difficulty level 9		
			"logic/dom/attack_level_1_prepare.logic",		
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
			additionalWaves = -1,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			}
		},
		 -- difficulty level 3
		{ 
			additionalWaves = -1,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
			}
		},

		 -- difficulty level 4
		{ 
			additionalWaves = -1,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
			}
		},

		 -- difficulty level 5
		{ 
			additionalWaves = -1,
			waves = 
			{
				{ name="logic/missions/survival/attack_boss_dynamic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
			}
		},

		 -- difficulty level 6 -- this is when FLurians start to spawn and when boss attacks can start
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

	rules.waves = 
	{
		["default"] =
		{
			-- difficulty level 1		
			{ 
				{ name="logic/missions/survival/metallic/attack_level_1_id_1_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/metallic/attack_level_1_id_2_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/metallic/attack_level_2_id_1_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/metallic/attack_level_2_id_2_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/metallic/attack_level_3_id_1_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/metallic/attack_level_3_id_2_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/metallic/attack_level_4_id_1_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/metallic/attack_level_4_id_2_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/metallic/attack_level_4_id_3_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/metallic/attack_level_5_id_1_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/metallic/attack_level_5_id_2_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},			
				{ name="logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},								
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},
				{ name="logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},			
				{ name="logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},									
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",				
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",				
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",				
			},
		},
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/metallic/attack_level_1_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_1_id_2_metallic.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/metallic/attack_level_2_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_2_id_2_metallic.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/metallic/attack_level_3_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_3_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/metallic/attack_level_4_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_4_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_4_id_3_metallic.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/metallic/attack_level_5_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_5_id_2_metallic.logic",			
			"logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic",								
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
			"logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic",								
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",			
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",			
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",			
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