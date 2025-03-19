return function()
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "outpost", "default")

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.eventsPerPrepareStateChance = 25        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.spawnAttackEventProbability = 0.33
	rules.spawn2ndAttackEventProbability = 0.33
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 5                -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.55 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 25        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "new_objective",             type = "POSITIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",        type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3 },
		{ action = "add_resource",              type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1 },
		{ action = "unlock_research",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1 },
		{ action = "full_ammo",                 type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "remove_ammo",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "boss_attack",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 4 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|ATTACK",              minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",                           weight = 1 },
		{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/event/shegret_attack_hard.logic",                      weight = 0.75 },
		{ action = "shegret_attack_very_hard",  type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 6, logicFile="logic/event/shegret_attack_very_hard.logic",                 weight = 0.5 },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic",                    weight = 1 },
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20 }

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein", runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
   
	}

	rules.objectivesLogic = 
	{
		--{ name = "logic/objectives/kill_elite_krocoon.logic", minDifficultyLevel = 3 },
		--{ name = "logic/objectives/destroy_nest_wingmite_single.logic", minDifficultyLevel = 4, maxDifficultyLevel = 6 }, 
		--{ name = "logic/objectives/destroy_nest_wingmite_multiple.logic", minDifficultyLevel = 6 },
		--{ name = "logic/objectives/destroy_nest_bradron_single.logic", minDifficultyLevel = 4, maxDifficultyLevel = 6 }, 
		--{ name = "logic/objectives/destroy_nest_bradron_multiple.logic", minDifficultyLevel = 6 },
		--{ name = "logic/objectives/destroy_nest_octabit_single.logic", minDifficultyLevel = 5, maxDifficultyLevel = 7 }, 
		--{ name = "logic/objectives/destroy_nest_octabit_multiple.logic", minDifficultyLevel = 7 },
		--{ name = "logic/objectives/destroy_nest_flurian_single.logic", minDifficultyLevel = 6, maxDifficultyLevel = 8 }, 
		--{ name = "logic/objectives/destroy_nest_flurian_multiple.logic", minDifficultyLevel = 8 }
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

	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}

	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6 },         biomes = { "caverns" },  levels = { 1 },   ids = { 1, 2 },    suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7},       biomes = { "caverns" },  levels = { 1 },   ids = { 1, 2 },    suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7, 8},    biomes = { "caverns" },  levels = { 2 },   ids = { 1, 2 },    suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7, 8, 9}, biomes = { "caverns" },  levels = { 2 },   ids = { 1, 2 },    suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7, 8, 9}, biomes = { "caverns" },  levels = { 3 },   ids = { 1, 2 },    suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7, 8, 9}, biomes = { "caverns" },  levels = { 3 },   ids = { 1, 2 },    suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7, 8, 9}, biomes = { "caverns" },  levels = { 4 },   ids = { 1, 2, 3 }, suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {  6, 7, 8, 9}, biomes = { "caverns" },  levels = { 4 },   ids = { 1, 2, 3 }, suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "desert" },   difficulty = {   6, 7, 8, 9}, biomes = { "group" },    levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },   difficulty = {   6, 7, 8, 9}, biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },   difficulty = {   6, 7, 8, 9}, biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },   suffixes = { "alpha" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },   difficulty = {   6, 7, 8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },   difficulty = {      7, 8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	
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
		},
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic",			
			--"logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic",			
			--"logic/missions/survival/caverns/attack_level_5_id_4_caverns.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/caverns/attack_level_6_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_6_id_2_caverns.logic",			
			--"logic/missions/survival/caverns/attack_level_6_id_3_caverns.logic",			
			--"logic/missions/survival/caverns/attack_level_6_id_4_caverns.logic",			
			--"logic/missions/survival/caverns/attack_level_6_id_5_caverns.logic",			
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/caverns/attack_level_7_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_7_id_2_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_7_id_3_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_7_id_4_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_7_id_5_caverns.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_8_id_4_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_8_id_5_caverns.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_8_id_4_caverns.logic",
			--"logic/missions/survival/caverns/attack_level_8_id_5_caverns.logic",
		},
	}



	rules.bosses = 
	{
		{  -- difficulty level 1		
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 2			
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 3
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 4			
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 5
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 6
			"logic/missions/survival/attack_boss_krocoon.logic",				
		},
		{  -- difficulty level 7
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 8
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{  -- difficulty level 9
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
	}

    return rules;
end