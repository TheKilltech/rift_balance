return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 0
	rules.eventsPerIdleState = 1
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
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_blue_hail", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/blue_hail.logic", minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_thunderstorm", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120 , weight = 2 },
		{ action = "spawn_blood_moon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/blood_moon.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/blue_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/super_moon.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 0.5  },
		{ action = "spawn_fog", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 0.5  },		
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 1 },
		{ action = "phirian_attack", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 9, logicFile="logic/event/phirian_attack.logic", weight = 1 },		
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 0.5 },
		{ action = "spawn_rain", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_weak.logic", minTime = 120, maxTime = 180, weight = 1 },
		{ action = "spawn_wind_weak", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/wind_weak.logic", minTime = 120, maxTime = 180, weight = 1 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/wind_strong.logic", minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/wind_none.logic", minTime = 90, maxTime = 150, weight = 1 },
		{ action = "spawn_wind_none", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/wind_none.logic", minTime = 90, maxTime = 150, weight = 1 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 1 },
		{ action = "spawn_ion_storm", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic", minTime = 30, maxTime = 60, weight = 1 },		
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },		
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },			
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 60, maxTime = 120, weight = 4 },
		{ action = "spawn_fireflies", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fireflies.logic", minTime = 60, maxTime = 120, weight = 4 },
		{ action = "spawn_blooming_air", type = "POSITIVE", gameStates="IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/blooming_air.logic", minTime = 120, maxTime = 180, weight = 4 },
		{ action = "spawn_blooming_air", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/weather/blooming_air.logic", minTime = 120, maxTime = 180, weight = 4 },		
		{ action = "spawn_monsoon", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/monsoon.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_monsoon", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/monsoon.logic", minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4, logicFile="logic/weather/tornado_acid_near_base.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 4, logicFile="logic/weather/tornado_acid_near_base.logic", weight = 0.5 },				
		--{ action = "spawn_comet_boss_mudroner_acid", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		--{ action = "spawn_comet_boss_mudroner_acid", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		--{ action = "spawn_comet_boss_mudroner_cryo", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		--{ action = "spawn_comet_boss_mudroner_cryo", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		--{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_energy.logic"  },
		--{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_energy.logic"  },
		--{ action = "spawn_comet_boss_mudroner_fire", type = "NEGATIVE", gameStates = "IDLE|STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
		--{ action = "spawn_comet_boss_mudroner_fire", type = "NEGATIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
		{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/comet_silent.logic", weight = 1 },
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
		600, -- difficulty level 7
		750, -- difficulty level 8
		750, -- difficulty level 9
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
		{ name = "logic/objectives/destroy_nest_stickrid_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 5 }, 
		{ name = "logic/objectives/destroy_nest_stickrid_multiple.logic", minDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_plutrodon_single.logic", minDifficultyLevel = 4, maxDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_plutrodon_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_fungor_single.logic", minDifficultyLevel = 5, maxDifficultyLevel = 7 }, 
		{ name = "logic/objectives/destroy_nest_fungor_multiple.logic", minDifficultyLevel = 7 }		
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
		360,  -- difficulty level 1
		480,  -- difficulty level 2
		540,  -- difficulty level 3
		600,  -- difficulty level 4	
		660,  -- difficulty level 5	
		720,  -- difficulty level 6	
		900,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
	}
	rules.maxAttackCountPerDifficulty = 
	{			
		3,  -- difficulty level 1
		4,  -- difficulty level 2
		4,  -- difficulty level 3		
		4,  -- difficulty level 4
		4,  -- difficulty level 5
		4,  -- difficulty level 6
		4,  -- difficulty level 7
		4,  -- difficulty level 8
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

		 -- difficulty level 6 - start of canceroth waves - this is when boss attacks start
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
			"logic/missions/survival/swamp/attack_level_1_id_1_swamp.logic",
			"logic/missions/survival/swamp/attack_level_1_id_2_swamp.logic",
			--"logic/missions/survival/swamp/attack_level_1_id_3_swamp.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/swamp/attack_level_2_id_1_swamp.logic",
			"logic/missions/survival/swamp/attack_level_2_id_2_swamp.logic",
			--"logic/missions/survival/swamp/attack_level_2_id_3_swamp.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/swamp/attack_level_3_id_1_swamp.logic",
			"logic/missions/survival/swamp/attack_level_3_id_2_swamp.logic",
			"logic/missions/survival/swamp/attack_level_3_id_3_swamp.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/swamp/attack_level_4_id_1_swamp.logic",
			"logic/missions/survival/swamp/attack_level_4_id_2_swamp.logic",
			"logic/missions/survival/swamp/attack_level_4_id_3_swamp.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/swamp/attack_level_5_id_1_swamp.logic",
			"logic/missions/survival/swamp/attack_level_5_id_2_swamp.logic",			
			"logic/missions/survival/swamp/attack_level_5_id_3_swamp.logic",			
			--"logic/missions/survival/swamp/attack_level_5_id_4_swamp.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/swamp/attack_level_6_id_1_swamp.logic",
			"logic/missions/survival/swamp/attack_level_6_id_2_swamp.logic",			
			"logic/missions/survival/swamp/attack_level_6_id_3_swamp.logic",			
			"logic/missions/survival/swamp/attack_level_6_id_4_swamp.logic",			
			--"logic/missions/survival/swamp/attack_level_6_id_5_swamp.logic",			
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