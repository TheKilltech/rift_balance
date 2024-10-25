return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.eventsPerPrepareStateChance = 25
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.idleTimeRelativeVariation = 0.5         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 10               -- chance in percent
	rules.preparationTimeRelativeVariation = 0.6  -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 10        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "new_objective",                type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
		{ action = "add_resource",                 type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",              type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",              type = "NEGATIVE", gameStates="ATTACK|STREAMING", minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",            type = "POSITIVE", gameStates="ATTACK|STREAMING", minEventLevel = 1 },
		{ action = "unlock_research",              type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1 },
		{ action = "full_ammo",                    type = "POSITIVE", gameStates="ATTACK|STREAMING", minEventLevel = 2 },
		{ action = "remove_ammo",                  type = "NEGATIVE", gameStates="ATTACK|STREAMING", minEventLevel = 2 },
		{ action = "boss_attack",                  type = "NEGATIVE", gameStates="ATTACK|STREAMING", minEventLevel = 4 },
		{ action = "spawn_earthquake",             type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 3,                    logicFile="logic/weather/earthquake.logic",             minTime = 60, maxTime = 60,  weight = 0.3 },
		{ action = "spawn_blue_hail",              type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",              minTime = 30, maxTime = 60,  weight = 0.2 },
		{ action = "spawn_thunderstorm",           type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon",             type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 5,                    logicFile="logic/weather/blood_moon.logic",             minTime = 60, maxTime = 120, weight = 0.5},
		{ action = "spawn_blue_moon",              type = "POSITIVE", gameStates="IDLE",             minEventLevel = 3,                    logicFile="logic/weather/blue_moon.logic",              minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",          type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 5,                    logicFile="logic/weather/solar_eclipse.logic",          minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",             type = "POSITIVE", gameStates="ATTACK|IDLE",      minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",             minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",                    type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 1,                    logicFile="logic/weather/fog.logic",                    minTime = 60, maxTime = 120 },
		{ action = "shegret_attack",               type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 3,                    logicFile="logic/event/shegret_attack.logic",                                        weight = 5 },
		{ action = "shegret_attack_hard",          type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 4,                    logicFile="logic/event/shegret_attack_hard.logic",                                   weight = 5 },
		{ action = "shegret_attack_very_hard",     type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 5,                    logicFile="logic/event/shegret_attack_very_hard.logic",                              weight = 3 },
		{ action = "kermon_attack",                type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 4,                    logicFile="logic/event/kermon_attack.logic",                                         weight = 0.5 },
		{ action = "kermon_attack_hard",           type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                                    weight = 0.5 },
		{ action = "kermon_attack_very_hard",      type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",                               weight = 0.5 },
		{ action = "phirian_attack",               type = "NEGATIVE", gameStates="IDLE",             minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                                        weight = 0.5 },
		{ action = "spawn_rain",                   type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 1,                    logicFile="logic/weather/rain.logic",                   minTime = 120, maxTime = 120 },
		{ action = "spawn_wind_weak",              type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 1,                    logicFile="logic/weather/wind_weak.logic",              minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong",            type = "POSITIVE", gameStates="ATTACK|IDLE",      minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",            minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none",              type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 2,                    logicFile="logic/weather/wind_none.logic",              minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm",              type = "POSITIVE", gameStates="ATTACK|IDLE",      minEventLevel = 4,                    logicFile="logic/weather/ion_storm.logic",              minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_tornado_near_player",    type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic",                                 weight = 0.35 },
		{ action = "spawn_tornado_near_base",      type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 3,                    logicFile="logic/weather/tornado_near_base.logic",                                   weight = 0.35 },	
		{ action = "spawn_resource_comet",         type = "POSITIVE", gameStates="IDLE",             minEventLevel = 4,                    logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake",    type = "POSITIVE", gameStates="ATTACK|IDLE",      minEventLevel = 5,                    logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower",          type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 2,                    logicFile="logic/weather/meteor_shower.logic",          minTime = 30, maxTime = 60,  weight = 0.3 },
		{ action = "spawn_firestorm",              type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 2,                    logicFile="logic/weather/firestorm.logic",              minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fireflies",              type = "POSITIVE", gameStates="IDLE",             minEventLevel = 1,                    logicFile="logic/weather/fireflies.logic",              minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_tornado_fire_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 8,                    logicFile="logic/weather/tornado_fire_near_base.logic",                              weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE",      minEventLevel = 8,                    logicFile="logic/weather/tornado_acid_near_base.logic",                              weight = 0.5 },
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
		{ action = "spawn_comet_silent",           type = "POSITIVE", gameStates="IDLE",             minEventLevel = 1,                    logicFile="logic/weather/comet_silent.logic",                                        weight = 2 }
	}

	rules.addResourcesOnRunOut =     
	{
		{ name = "cobalt_vein", runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 1, minLevel = 5, prepareTime = 120, entryLogic = "logic/hq_upgrade/upgrade_entry_lvl1.logic", exitLogic = "logic/hq_upgrade/upgrade_exit_lvl1.logic" },     
	}

	rules.spawnCooldownEventChance = -- events spawn chance during/after attack (cooldown). values should be descending
	{
		25,  -- 1st event probability in percent
		5,   -- 2nd event probability in percent
		1,   -- 3rd event probability in percent
	}
	
	rules.timeToNextDifficultyLevel = 
	{			
		400, -- difficulty level 1
		600, -- difficulty level 2
		800, -- difficulty level 3	
		1200, -- difficulty level 4
		1200, -- difficulty level 5
		1200, -- difficulty level 6
		1200, -- difficulty level 7
		1200, -- difficulty level 8
		1200, -- difficulty level 9
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
		{ name = "logic/objectives/kill_elite.logic", minDifficultyLevel = 4 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic", minDifficultyLevel = 5 }
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
		900,  -- difficulty level 1
		900,  -- difficulty level 2
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
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 1
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 2
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 3
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 4
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 5
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 6
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 7
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 8
		"logic/dom/attack_level_1_prepare.logic",-- difficulty level 9
	}

	rules.wavesEntryDefinitions = 
	{
		"logic/dom/attack_level_1_entry.logic",-- difficulty level 1
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 2
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 3
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 4
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 5
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 6
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 7
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 8
		"logic/dom/attack_level_2_entry.logic",-- difficulty level 9
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