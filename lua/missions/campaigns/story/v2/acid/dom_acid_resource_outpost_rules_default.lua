return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 15        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 2400
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 5                -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.55 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 25        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "new_objective",                  type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",             type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
		{ action = "add_resource",                   type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",                type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",                type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",              type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1 },
		{ action = "unlock_research",                type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1 },
		{ action = "full_ammo",                      type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "remove_ammo",                    type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "boss_attack",                    type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 4 },
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack.logic",                               weight = 3 },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack_hard.logic",                          weight = 3 },
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack_very_hard.logic",                     weight = 3 },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/kermon_attack.logic",                                weight = 0.5 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                           weight = 0.5 },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",                      weight = 0.5 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                               weight = 0.5 },
		{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/earthquake.logic",    minTime = 30, maxTime = 60,  weight = 0.5 },	
		{ action = "spawn_blood_moon",               type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",                type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 5,                    logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon",               type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",                      type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/fog.logic",           minTime = 30, maxTime = 60 },
		{ action = "spawn_wind_weak",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_weak.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_none",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_none.logic",     minTime = 30, maxTime = 120, weight = 0.5 },
		{ action = "spawn_ion_storm",                type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_acid_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/acid_rain.logic",     minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_acid_fissures",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/acid_fissures.logic", minTime = 30, maxTime = 60,  weight = 1 },
		{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/meteor_shower.logic", minTime = 40, maxTime = 90,  weight = 0.5 },
		{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 1,                    logicFile="logic/weather/comet_silent.logic",                               weight = 2 },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_acid_near_player.logic",                   weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/tornado_acid_near_base.logic",                     weight = 0.5 },
		{ action = "spawn_resource_comet",           type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/resource_earthquake.logic" },
	}

	rules.spawnCooldownEventChance = -- events spawn chance during/after attack (cooldown). values should be descending
	{
		30,  -- 1st event probability in percent
		10,  -- 2nd event probability in percent
		 3,  -- 3rd event probability in percent
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "palladium_deepvein", runOutPercentageOnMap = 30, minToSpawn = 40000, maxToSpawn = 60000 },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}
	
	rules.timeToNextDifficultyLevel = 
	{			
		600, -- difficulty level 1
		780, -- difficulty level 2
		900, -- difficulty level 3	
		1020, -- difficulty level 4
		1200, -- difficulty level 5
		1500, -- difficulty level 6
		1800, -- difficulty level 7
		2400, -- difficulty level 8
		3600, -- difficulty level 9
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
		{ name = "logic/objectives/kill_elite.logic",                   minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_granan_single.logic",   minDifficultyLevel = 4 },
		{ name = "logic/objectives/destroy_nest_granan_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_creeper.logic",              minDifficultyLevel = 3 } 
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
		 660,  -- difficulty level 4	
		 900,  -- difficulty level 5	
		 900,  -- difficulty level 6	
		 900,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1200,  -- difficulty level 9	
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
		{},                    -- consecutive chances of wave repeating at level 1
		{},                    -- consecutive chances of wave repeating at level 2
		{},                    -- consecutive chances of wave repeating at level 3
		{50},                  -- consecutive chances of wave repeating at level 4
		{50, 50},              -- consecutive chances of wave repeating at level 5
		{60, 60, 20},          -- consecutive chances of wave repeating at level 6
		{60, 60, 50},          -- consecutive chances of wave repeating at level 7
		{70, 70, 60, 20},      -- consecutive chances of wave repeating at level 8
		{80, 70, 70, 30, 30},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 5
	rules.waveChanceRerollSpawn      = 10
	rules.waveChanceReroll           = 40

	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "acid" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "acid" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "acid" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "acid" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "acid" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "swamp" }, levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "swamp" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "alpha" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8,  }, biomes = { "swamp" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                   7, 8, 9}, biomes = { "swamp" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	

	rules.extraWaves = 
	{		 
		{ -- difficulty level 1		
			"logic/missions/survival/attack_level_1_id_1_acid.logic",
			"logic/missions/survival/attack_level_1_id_2_acid.logic",
		},
		{ -- difficulty level 2			
			"logic/missions/survival/attack_level_2_id_1_acid.logic",
			"logic/missions/survival/attack_level_2_id_2_acid.logic",
		},
		{  -- difficulty level 3
			"logic/missions/survival/attack_level_3_id_1_acid.logic",
			"logic/missions/survival/attack_level_3_id_2_acid.logic",
		},
		{ -- difficulty level 4
			"logic/missions/survival/attack_level_4_id_1_acid.logic",
			"logic/missions/survival/attack_level_4_id_2_acid.logic",
		},
		{ -- difficulty level 5
			"logic/missions/survival/attack_level_5_id_1_acid.logic",
			"logic/missions/survival/attack_level_5_id_2_acid.logic",
		},
		{ -- difficulty level 6
			"logic/missions/survival/attack_level_6_id_1_acid.logic",
			"logic/missions/survival/attack_level_6_id_2_acid.logic",
		},
		{ -- difficulty level 7 
			"logic/missions/survival/attack_level_7_id_1_acid.logic",
			"logic/missions/survival/attack_level_7_id_2_acid.logic",
		},
		{ -- difficulty level 8 
			"logic/missions/survival/attack_level_8_id_1_acid.logic",
			"logic/missions/survival/attack_level_8_id_2_acid.logic",
		},
		{ -- difficulty level 9 
			"logic/missions/survival/attack_level_8_id_1_acid.logic",
			"logic/missions/survival/attack_level_8_id_2_acid.logic",
		},
	}

	rules.bosses = 
	{
		{ -- difficulty level 1
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
		{ -- difficulty level 2
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
		{ -- difficulty level 3 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
		{ -- difficulty level 4
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
		{ -- difficulty level 5
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",		
		},
		{ -- difficulty level 6
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},
		{ -- difficulty level 7
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
		{ -- difficulty level 8
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
		{ -- difficulty level 9
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	}

    return rules;
end