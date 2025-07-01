return function()
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "outpost", "default")

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
		{ action = "spawn_comet_silent",           type = "POSITIVE", gameStates="IDLE",             minEventLevel = 1,                    logicFile="logic/weather/comet_silent.logic",                                        weight = 2 }
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 5, 1 }

	rules.addResourcesOnRunOut =     
	{
		{ name = "cobalt_vein", runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 1, minLevel = 5, prepareTime = 120, entryLogic = "logic/hq_upgrade/upgrade_entry_lvl1.logic", exitLogic = "logic/hq_upgrade/upgrade_exit_lvl1.logic" },     
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic", minDifficultyLevel = 4 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic", minDifficultyLevel = 3, maxDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic", minDifficultyLevel = 5 }
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 1 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 2 },  -- difficulty level 4
		{ minCount = 1, maxCount = 2 },  -- difficulty level 5
		{ minCount = 1, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 3 },  -- difficulty level 7
		{ minCount = 2, maxCount = 3 },  -- difficulty level 8
		{ minCount = 2, maxCount = 4 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},                    -- consecutive chances of wave repeating at level 1
		{},                    -- consecutive chances of wave repeating at level 2
		{15},                  -- consecutive chances of wave repeating at level 3
		{50},                  -- consecutive chances of wave repeating at level 4
		{50, 20},              -- consecutive chances of wave repeating at level 5
		{60, 40, 10},          -- consecutive chances of wave repeating at level 6
		{60, 40, 20},          -- consecutive chances of wave repeating at level 7
		{70, 50, 40, 10},      -- consecutive chances of wave repeating at level 8
		{80, 60, 50, 30, 30},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 10
	rules.waveChanceRerollSpawn      = 15
	rules.waveChanceReroll           = 40

	
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
			additionalWaves = 1,
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
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { "" },  levels = { 1 },   ids = { 1, 2 },         suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7},       biomes = { "" },  levels = { 1 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8},    biomes = { "" },  levels = { 2 },   ids = { 1, 2 },         suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "" },  levels = { 2 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "" },  levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { "" },  levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "" },  levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "" },  levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "alpha" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	
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