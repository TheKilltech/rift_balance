return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 15        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 15               -- chance in percent
	rules.preparationTimeRelativeVariation = 0.35 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 15        -- chance in percent

	local helper = require( "lua/missions/v2/waves_gen.lua" )
	rules = helper:PrepareDefaultRules( rules, "outpost", "default")

	rules.gameEvents = 
	{
		{ action = "new_objective",             type = "POSITIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",        type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3 },
		{ action = "add_resource",              type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK",                   minEventLevel = 1, amount = 2 },
		{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK",                   minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1 },
		{ action = "unlock_research",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1 },
		{ action = "full_ammo",                 type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "remove_ammo",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "boss_attack",               type = "NEGATIVE", gameStates="ATTACK",                   minEventLevel = 4 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 3, logicFile="logic/weather/earthquake.logic",    minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_blue_hail",           type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 4, logicFile="logic/weather/blue_hail.logic",     minTime = 30, maxTime = 60, weight = 0.25 },
		{ action = "spawn_thunderstorm",        type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic",  minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 5, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 3, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 4, logicFile="logic/event/shegret_attack.logic",  weight = 1,   bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 6, logicFile="logic/event/shegret_attack.logic",  weight = 2,   bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_very_hard",  type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 8, logicFile="logic/event/shegret_attack.logic",  weight = 2,   bindingParams = { attack_strength = "very_hard" } },
		{ action = "kermon_attack",             type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/event/kermon_attack.logic",   weight = 0.5, bindingParams = { attack_strength = "normal" } },
		{ action = "kermon_attack_hard",        type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 7, logicFile="logic/event/kermon_attack.logic",   weight = 0.5, bindingParams = { attack_strength = "hard" } },
		{ action = "kermon_attack_very_hard",   type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 9, logicFile="logic/event/kermon_attack.logic",   weight = 0.5, bindingParams = { attack_strength = "very_hard" } },
		{ action = "spawn_wind_weak",           type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 1, logicFile="logic/weather/wind_weak.logic",     minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_wind_none",           type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/wind_none.logic",     minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 4, logicFile="logic/weather/ion_storm.logic",     minTime = 30,  maxTime = 60, weight = 1 },
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		--{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 0.5  },
		--{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 0.5  },
		--{ action = "spawn_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 0.5 },
		--{ action = "spawn_rain",                type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 0.5 },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		--{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic", weight = 0.5 },
		--{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic", weight = 0.5 },		
	}
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20 }

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic",             minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_wingmite_single.logic",   minDifficultyLevel = 4 }, 
		{ name = "logic/objectives/destroy_nest_wingmite_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_bradron_single.logic",    minDifficultyLevel = 4 }, 
		{ name = "logic/objectives/destroy_nest_bradron_multiple.logic",  minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_octabit_single.logic",    minDifficultyLevel = 5 }, 
		{ name = "logic/objectives/destroy_nest_octabit_multiple.logic",  minDifficultyLevel = 7 },
		{ name = "logic/objectives/destroy_nest_flurian_single.logic",    minDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_flurian_multiple.logic",  minDifficultyLevel = 8 }
	}
	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_deepvein", runOutPercentageOnMap = 10, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
   
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
		{},                       -- concecutive chances of wave repeating at level 1
		{},                       -- concecutive chances of wave repeating at level 2
		{10 },                    -- concecutive chances of wave repeating at level 3
		{15,  5},                 -- concecutive chances of wave repeating at level 4
		{25, 40, 20},             -- concecutive chances of wave repeating at level 5
		{40, 55, 40},             -- concecutive chances of wave repeating at level 6
		{55, 50, 40, 20},         -- concecutive chances of wave repeating at level 7
		{70, 60, 80, 20},         -- concecutive chances of wave repeating at level 8
		{85, 70, 80, 35, 90},     -- concecutive chances of wave repeating at level 9
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
	
	rules.waveChanceRerollSpawnGroup = 0
	rules.waveChanceRerollSpawn      = 15
	rules.waveChanceReroll           = 30
	
	rules.waves = {}
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { "metallic" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7},       biomes = { "metallic" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8},    biomes = { "metallic" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "metallic" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)

	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" },    levels = { 2 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "", "" },          },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "alpha" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                   7, 8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	

	rules.extraWaves = 
	{
		{  -- difficulty level 1		
			"logic/missions/survival/metallic/attack_level_1_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_1_id_2_metallic.logic",
		},
		{  -- difficulty level 2			
			"logic/missions/survival/metallic/attack_level_2_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_2_id_2_metallic.logic",
		},
		{  -- difficulty level 3
			"logic/missions/survival/metallic/attack_level_3_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_3_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic",
		},
		{  -- difficulty level 4			
			"logic/missions/survival/metallic/attack_level_4_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_4_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_4_id_3_metallic.logic",
		},
		{  -- difficulty level 5
			"logic/missions/survival/metallic/attack_level_5_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_5_id_2_metallic.logic",			
			"logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic",								
		},
		{  -- difficulty level 6
			"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
			"logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic",								
		},
		{  -- difficulty level 7
			"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",			
		},
		{  -- difficulty level 8
			"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",			
		},
		{  -- difficulty level 9
			"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
			"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",			
		},
	}

	rules.bosses = 
	{
		{  -- difficulty level 1		
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 2			
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 3
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 4			
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 5
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 6
			"logic/missions/survival/attack_boss_dynamic.logic",				
		},
		{  -- difficulty level 7
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 8
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
		{  -- difficulty level 9
			"logic/missions/survival/attack_boss_dynamic.logic",			
		},
	}

    return rules;
end