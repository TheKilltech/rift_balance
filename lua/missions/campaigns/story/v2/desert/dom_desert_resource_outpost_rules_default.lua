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
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, logicFile="logic/event/shegret_attack.logic", weight = 5 },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/event/shegret_attack.logic", weight = 5 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/earthquake.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/earthquake.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_solar_burn", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/solar_burn.logic", minTime = 15, maxTime = 30, weight = 4 },
		{ action = "spawn_solar_burn", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/solar_burn.logic", minTime = 15, maxTime = 30, weight = 4 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_dust_storm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/dust_storm.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_dust_storm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/dust_storm.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60 },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_player.logic" },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_player.logic" },
		--{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_base.logic" },
		--{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_base.logic" },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_earthquake.logic", weight = 1 },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_earthquake.logic", weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.25 },	
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
		{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 2 }
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "uranium_ore_vein", runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
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
		{ name = "logic/objectives/destroy_nest_mushbit_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_mushbit_multiple.logic", minDifficultyLevel = 6 } 
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
		1,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		2,  -- difficulty level 5
		2,  -- difficulty level 6
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

	rules.waves = 
	{
		["default"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_1_id_2_desert.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1_desert.logic",
				"logic/missions/survival/attack_level_2_id_2_desert.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1_desert.logic",
				"logic/missions/survival/attack_level_3_id_2_desert.logic",
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1_desert.logic",
				"logic/missions/survival/attack_level_5_id_2_desert.logic",			
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1_desert.logic",
				"logic/missions/survival/attack_level_6_id_2_desert.logic",			
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1_desert.logic",
				"logic/missions/survival/attack_level_7_id_2_desert.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",
			},
		},
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_level_1_id_1_desert.logic",
			"logic/missions/survival/attack_level_1_id_2_desert.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_level_2_id_1_desert.logic",
			"logic/missions/survival/attack_level_2_id_2_desert.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_level_3_id_1_desert.logic",
			"logic/missions/survival/attack_level_3_id_2_desert.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_level_4_id_1_desert.logic",
			"logic/missions/survival/attack_level_4_id_2_desert.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_level_5_id_1_desert.logic",
			"logic/missions/survival/attack_level_5_id_2_desert.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_level_6_id_1_desert.logic",
			"logic/missions/survival/attack_level_6_id_2_desert.logic",			
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_level_7_id_1_desert.logic",
			"logic/missions/survival/attack_level_7_id_2_desert.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_level_8_id_1_desert.logic",
			"logic/missions/survival/attack_level_8_id_2_desert.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_level_8_id_1_desert.logic",
			"logic/missions/survival/attack_level_8_id_2_desert.logic",
		},
	}

	rules.bosses = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",	
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",		
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_boss_stregaros.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	}

    return rules;
end