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
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
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
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, maxEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3 },
		{ action = "shegret_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, maxEventLevel = 4, logicFile="logic/event/shegret_attack.logic", weight = 3 },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/shegret_attack_hard.logic", weight = 3 },
		{ action = "shegret_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/shegret_attack_hard.logic", weight = 3 },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack_very_hard.logic", weight = 3 },
		{ action = "shegret_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/shegret_attack_very_hard.logic", weight = 3 },
		{ action = "kermon_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 4, maxEventLevel = 5, logicFile="logic/event/kermon_attack.logic", weight = 1 },
		{ action = "kermon_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, maxEventLevel = 5, logicFile="logic/event/kermon_attack.logic", weight = 1 },
		{ action = "kermon_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/kermon_attack_hard.logic", weight = 1 },
		{ action = "kermon_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 6, maxEventLevel = 7, logicFile="logic/event/kermon_attack_hard.logic", weight = 1 },
		{ action = "kermon_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/kermon_attack_very_hard.logic", weight = 1 },
		{ action = "kermon_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/kermon_attack_very_hard.logic", weight = 1 },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 1 },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 1 },
		--{ action = "phirian_attack_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/phirian_attack_hard.logic", weight = 3 },
		--{ action = "phirian_attack_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, maxEventLevel = 7, logicFile="logic/event/phirian_attack_hard.logic", weight = 3 },
		--{ action = "phirian_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/phirian_attack_very_hard.logic", weight = 3 },
		--{ action = "phirian_attack_very_hard", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 8, maxEventLevel = 9, logicFile="logic/event/phirian_attack_very_hard.logic", weight = 3 }
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120 },
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_weak.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_none.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_none.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic", weight = 0.5 },		
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },	
		{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_firestorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/firestorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 60, maxTime = 120 },
		--{ action = "spawn_migrating_birds", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/migrating_birds.logic", minTime = 60, maxTime = 120 },
		--{ action = "spawn_migrating_birds", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/migrating_birds.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_acid_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_acid_near_base.logic", weight = 0.5 },		
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_fire_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_fire_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_fire_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_fire_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_fire_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_fire_near_base.logic", weight = 0.5 },
		{ action = "spawn_comet_boss_mudroner_acid", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		{ action = "spawn_comet_boss_mudroner_acid", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		{ action = "spawn_comet_boss_mudroner_cryo", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		{ action = "spawn_comet_boss_mudroner_cryo", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_energy.logic"  },
		{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_energy.logic"  },
		{ action = "spawn_comet_boss_mudroner_fire", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
		{ action = "spawn_comet_boss_mudroner_fire", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_vein", runOutPercentageOnMap = 45, minToSpawn = 10000, maxToSpawn = 20000 },
		{ name = "iron_vein", runOutPercentageOnMap = 45, minToSpawn = 10000, maxToSpawn = 20000 },
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
		360,  -- difficulty level 1
		360,  -- difficulty level 2
		360,  -- difficulty level 3
		360,  -- difficulty level 4	
		360,  -- difficulty level 5	
		360,  -- difficulty level 6	
		360,  -- difficulty level 7
		360,  -- difficulty level 8	
		360,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
		{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		{ name = "headquarters_lvl_4", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_5", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_6", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_7", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic", minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_creeper.logic", minDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_fire_gnerot.logic", minDifficultyLevel = 5 },
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
		3,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}
	
	rules.wavesEntryDefinitions =
	{
		 -- difficulty level 1
			"logic/missions/survival/attack_level_1_entry.logic",
		 -- difficulty level 2
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 3		
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 4		
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 5		
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 6		
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 7		
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 8		
			"logic/missions/survival/attack_level_2_entry.logic",
		 -- difficulty level 9		
			"logic/missions/survival/attack_level_2_entry.logic",		
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

	rules.multiplayerWaves = 
	{
		 -- difficulty level 1		
		{ 
			additionalWaves = 0, -- Additional Waves count = NumberOfPlayers + (additionalWaves -1(const)). E.g. 2 players + 0 -1 = 1 additional multiplayer wave for 2 players. Multiplayer Additional waves are disabled in single player mode. Check dom_mananger:GetMultiplayerAttackCount for actual code
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},
	
		 -- difficulty level 2
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},
		 -- difficulty level 3
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 4
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 5
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 6
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 7
		{ 
			additionalWaves = 1,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 8
		{ 
			additionalWaves = 2,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 9
		{ 
			additionalWaves = 2,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
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
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",	
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	}

    return rules;
end