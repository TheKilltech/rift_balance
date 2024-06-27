return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 2400

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
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.2 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.1 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120 , weight = 0.5},
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_fog", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120 },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 5 },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/shegret_attack.logic", weight = 5 },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 8, logicFile="logic/event/shegret_attack_hard.logic", weight = 5 },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 8, logicFile="logic/event/shegret_attack_hard.logic", weight = 5 },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 9, logicFile="logic/event/shegret_attack_very_hard.logic", weight = 5 },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 9, logicFile="logic/event/shegret_attack_very_hard.logic", weight = 5 },
		{ action = "kermon_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/kermon_attack.logic", weight = 0.5 },
		{ action = "kermon_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/kermon_attack.logic", weight = 0.5 },
		{ action = "kermon_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 8, logicFile="logic/event/kermon_attack_hard.logic", weight = 0.5 },
		{ action = "kermon_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 8, logicFile="logic/event/kermon_attack_hard.logic", weight = 0.5 },
		{ action = "kermon_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 9, maxEventLevel = 9, logicFile="logic/event/kermon_attack_very_hard.logic", weight = 0.5 },
		{ action = "kermon_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 9, maxEventLevel = 9, logicFile="logic/event/kermon_attack_very_hard.logic", weight = 0.5 },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 6, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 0.5 },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 6, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 0.5 },
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120 },
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/wind_none.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/wind_none.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.2 },
		{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/tornado_near_base.logic", weight = 0.25 },
		{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/tornado_near_base.logic", weight = 0.1 },		
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic", weight = 1 },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic", weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.2 },
		{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_tornado_fire_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 8, logicFile="logic/weather/tornado_fire_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_fire_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, logicFile="logic/weather/tornado_fire_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 8, logicFile="logic/weather/tornado_acid_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, logicFile="logic/weather/tornado_acid_near_base.logic", weight = 0.5 },		
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
		{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 2 }
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_vein", runOutPercentageOnMap = 45, minToSpawn = 20000, maxToSpawn = 30000 },
		{ name = "iron_vein", runOutPercentageOnMap = 45, minToSpawn = 20000, maxToSpawn = 30000 },
	}

	rules.timeToNextDifficultyLevel = 
	{			
		900, -- difficulty level 1
		1800, -- difficulty level 2
		1800, -- difficulty level 3	
		1800, -- difficulty level 4
		1800, -- difficulty level 5
		1800, -- difficulty level 6
		1800, -- difficulty level 7
		1800, -- difficulty level 8
		1800, -- difficulty level 9
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
		{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		{ name = "headquarters_lvl_4", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_5", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_6", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_7", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic", minDifficultyLevel = 4 },
		--{ name = "logic/objectives/destroy_fire_gnerot.logic", minDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic", minDifficultyLevel = 5 }
		--{ name = "logic/objectives/find_loot_container.logic", minDifficultyLevel = 2 },
		--{ name = "logic/objectives/find_treasure.logic", minDifficultyLevel = 2 },
		--{ name = "logic/objectives/harvest_container.logic", minDifficultyLevel = 6 },
		--{ name = "logic/objectives/harvest_plant.logic", minDifficultyLevel = 6 },
		--{ name = "logic/objectives/harvest_rubble.logic", minDifficultyLevel = 6 },
		--{ name = "logic/objectives/hedroner_spawn.logic", minDifficultyLevel = 3 },
		--{ name = "logic/objectives/destroy_creeper.logic", minDifficultyLevel = 6 } 
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
		1200,  -- difficulty level 1
		1200,  -- difficulty level 2
		900,  -- difficulty level 3
		900,  -- difficulty level 4	
		900,  -- difficulty level 5	
		900,  -- difficulty level 6	
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

	rules.waves = 
	{
		["default"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/attack_level_1_id_1.logic",
				"logic/missions/survival/attack_level_1_id_2.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1.logic",
				"logic/missions/survival/attack_level_2_id_2.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1.logic",
				"logic/missions/survival/attack_level_3_id_2.logic",
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1.logic",
				"logic/missions/survival/attack_level_4_id_2.logic",
				--"logic/missions/survival/attack_level_4_id_3.logic",
				"logic/missions/survival/attack_level_4_id_4.logic",
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1.logic",
				"logic/missions/survival/attack_level_5_id_2.logic",			
				"logic/missions/survival/attack_level_4_id_3.logic",			
				"logic/missions/survival/attack_level_5_id_4.logic",			
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1.logic",
				"logic/missions/survival/attack_level_6_id_2.logic",			
				"logic/missions/survival/attack_level_5_id_3.logic",			
				"logic/missions/survival/attack_level_6_id_4.logic",			
				"logic/missions/survival/attack_level_6_id_5.logic",			
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1.logic",
				"logic/missions/survival/attack_level_7_id_2.logic",
				"logic/missions/survival/attack_level_6_id_3.logic",
				"logic/missions/survival/attack_level_7_id_4.logic",
				"logic/missions/survival/attack_level_7_id_5.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_7_id_3.logic",
				"logic/missions/survival/attack_level_8_id_4.logic",
				"logic/missions/survival/attack_level_8_id_5.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_8_id_3.logic",
				"logic/missions/survival/attack_level_8_id_4.logic",
				"logic/missions/survival/attack_level_8_id_5.logic",
			},
		},

		["desert"] =
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

		["acid"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/attack_level_1_id_1_acid.logic",
				"logic/missions/survival/attack_level_1_id_2_acid.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1_acid.logic",
				"logic/missions/survival/attack_level_2_id_2_acid.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1_acid.logic",
				"logic/missions/survival/attack_level_3_id_2_acid.logic",
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1_acid.logic",
				"logic/missions/survival/attack_level_4_id_2_acid.logic",
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1_acid.logic",
				"logic/missions/survival/attack_level_5_id_2_acid.logic",			
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1_acid.logic",
				"logic/missions/survival/attack_level_6_id_2_acid.logic",			
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1_acid.logic",
				"logic/missions/survival/attack_level_7_id_2_acid.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",
			},
		},

		["magma"] =
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
		},
		
		["metallic"] =
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
				"logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic", -- double wave to increase octabit probability
				"logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic", -- double wave to increase octabit probability
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
		},
		
		["caverns"] =
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
		
		["swamp"] =
		{
			-- difficulty level 1		
			{ 
				{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				--{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				--{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/swamp/attack_level_3_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/swamp/attack_level_3_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/swamp/attack_level_3_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/swamp/attack_level_4_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
				{ name="logic/missions/survival/swamp/attack_level_4_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/swamp/attack_level_5_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},			
				{ name="logic/missions/survival/swamp/attack_level_5_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},			
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0},							
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp.logic",
				--"logic/missions/survival/swamp/attack_level_7_id_5_swamp.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				--"logic/missions/survival/swamp/attack_level_8_id_5_swamp.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				--"logic/missions/survival/swamp/attack_level_8_id_5_swamp.logic",
			},
		},
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_level_1_id_1.logic",
			"logic/missions/survival/attack_level_1_id_2.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_level_2_id_1.logic",
			"logic/missions/survival/attack_level_2_id_2.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_level_3_id_1.logic",
			"logic/missions/survival/attack_level_3_id_2.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_level_4_id_1.logic",
			"logic/missions/survival/attack_level_4_id_2.logic",
			"logic/missions/survival/attack_level_4_id_3.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_level_5_id_1.logic",
			"logic/missions/survival/attack_level_5_id_2.logic",			
			"logic/missions/survival/attack_level_5_id_3.logic",			
			"logic/missions/survival/attack_level_5_id_4.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_level_6_id_1.logic",
			"logic/missions/survival/attack_level_6_id_2.logic",			
			"logic/missions/survival/attack_level_6_id_3.logic",			
			"logic/missions/survival/attack_level_6_id_4.logic",			
			"logic/missions/survival/attack_level_6_id_5.logic",			
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_level_7_id_1.logic",
			"logic/missions/survival/attack_level_7_id_2.logic",
			"logic/missions/survival/attack_level_7_id_3.logic",
			"logic/missions/survival/attack_level_7_id_4.logic",
			"logic/missions/survival/attack_level_7_id_5.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_level_8_id_1.logic",
			"logic/missions/survival/attack_level_8_id_2.logic",
			"logic/missions/survival/attack_level_8_id_3.logic",
			"logic/missions/survival/attack_level_8_id_4.logic",
			"logic/missions/survival/attack_level_8_id_5.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_level_8_id_1.logic",
			"logic/missions/survival/attack_level_8_id_2.logic",
			"logic/missions/survival/attack_level_8_id_3.logic",
			"logic/missions/survival/attack_level_8_id_4.logic",
			"logic/missions/survival/attack_level_8_id_5.logic",
		},
	}

	rules.bosses = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",		
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",			
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
		},
	}

    return rules;
end