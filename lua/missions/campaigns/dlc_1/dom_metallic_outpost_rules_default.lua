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
		{ action = "spawn_wind_weak",           type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 1, logicFile="logic/weather/wind_weak.logic",     minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_wind_none",           type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/wind_none.logic",     minTime = 180, maxTime = 240, weight = 3 },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 4, logicFile="logic/weather/ion_storm.logic",     minTime = 30,  maxTime = 60, weight = 1 },
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		--{ action = "shegret_attack",            type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 4, logicFile="logic/event/shegret_attack.logic",  weight = 0.3 },
		--{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 0.5  },
		--{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/fog.logic", minTime = 60, maxTime = 120, weight = 0.5  },
		--{ action = "spawn_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 0.5 },
		--{ action = "spawn_rain",                type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/rain.logic", minTime = 120, maxTime = 120, weight = 0.5 },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic", weight = 0.5 },
		--{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic", weight = 0.5 },
		--{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/tornado_near_base.logic", weight = 0.5 },		
	}

	rules.spawnCooldownEventChance = -- events spawn chance during/after attack (cooldown). values should be descending
	{
		20,  -- 1st event probability in percent
		 5,  -- 2nd event probability in percent
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_deepvein", runOutPercentageOnMap = 10, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.timeToNextDifficultyLevel = 
	{			
		600, -- difficulty level 1
		600, -- difficulty level 2
		600, -- difficulty level 3	
		600, -- difficulty level 4
		900, -- difficulty level 5
		1200, -- difficulty level 6
		1800, -- difficulty level 7
		2400, -- difficulty level 8
		2400, -- difficulty level 9
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
		{ name = "logic/objectives/kill_elite_krocoon.logic",             minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_wingmite_single.logic",   minDifficultyLevel = 4 }, 
		{ name = "logic/objectives/destroy_nest_wingmite_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_bradron_single.logic",    minDifficultyLevel = 4 }, 
		{ name = "logic/objectives/destroy_nest_bradron_multiple.logic",  minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_octabit_single.logic",    minDifficultyLevel = 5 }, 
		{ name = "logic/objectives/destroy_nest_octabit_multiple.logic",  minDifficultyLevel = 7 },
		{ name = "logic/objectives/destroy_nest_flurian_single.logic",    minDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_flurian_multiple.logic",  minDifficultyLevel = 8 }
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
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 1		
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 3				
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 5					
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 6			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 7			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 8					
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 9		
	}

	rules.wavesEntryDefinitions =
	{		 
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 1		 
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 2			
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 3			
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 4				
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 5			
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 6					
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 7				
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 8					
		"logic/dom/attack_level_2_entry.logic", -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},                       -- concecutive chances of wave repeating at level 1
		{},                       -- concecutive chances of wave repeating at level 2
		{},                       -- concecutive chances of wave repeating at level 3
		{10 },                    -- concecutive chances of wave repeating at level 4
		{25, 40, 20},             -- concecutive chances of wave repeating at level 5
		{40, 55, 40},             -- concecutive chances of wave repeating at level 6
		{55, 50, 40, 20},         -- concecutive chances of wave repeating at level 7
		{70, 60, 80, 20},         -- concecutive chances of wave repeating at level 8
		{85, 70, 80, 35, 90},     -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 0
	rules.waveChanceRerollSpawn      = 15
	rules.waveChanceReroll           = 30

	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "metallic" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "metallic" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "metallic" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "metallic" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "magma" },    levels = { 2 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "magma" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "", "" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "magma" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "alpha" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8,  }, biomes = { "magma" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                   7, 8, 9}, biomes = { "magma" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	

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