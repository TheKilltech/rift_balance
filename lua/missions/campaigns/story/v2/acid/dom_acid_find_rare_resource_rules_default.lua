return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 25        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 900
	rules.spawnAttackEventProbability = 0.33
	rules.spawn2ndAttackEventProbability = 0.33
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 15               -- chance in percent
	rules.preparationTimeRelativeVariation = 0.35 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 15        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "cancel_the_attack",              type = "POSITIVE", gameStates="ATTACK",                minEventLevel = 1 },
		{ action = "boss_attack",                    type = "NEGATIVE", gameStates="ATTACK",                minEventLevel = 8 },
		{ action = "stronger_attack", 	             type = "NEGATIVE", gameStates="ATTACK", 		       minEventLevel = 7, amount = 2 },
		{ action = "stronger_attack", 	             type = "NEGATIVE", gameStates="ATTACK", 		       minEventLevel = 8, amount = 3 },
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",                                           weight = 2},
		{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/earthquake.logic",               minTime = 60, maxTime = 60,   weight = 1},
		{ action = "spawn_blood_moon",               type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/blood_moon.logic",               minTime = 60, maxTime = 120,  weight = 0.2,  weather = "SUN" },
		{ action = "spawn_blue_moon",                type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/blue_moon.logic",                minTime = 60, maxTime = 120,  weight = 0.2,  weather = "SUN" },
		{ action = "spawn_solar_eclipse",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/solar_eclipse.logic",            minTime = 60, maxTime = 120,  weight = 0.25, weather = "SUN" },
		{ action = "spawn_super_moon",               type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/super_moon.logic",               minTime = 60, maxTime = 120,  weight = 1,    weather = "SUN"  },
		{ action = "spawn_wind_weak",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/wind_weak.logic",                minTime = 60, maxTime = 120,  weight = 0.5,  weather = "WIND" },
		{ action = "spawn_wind_strong",              type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/wind_strong.logic",              minTime = 60, maxTime = 120,  weight = 0.1,  weather = "WIND" },
		{ action = "spawn_wind_none",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/wind_none.logic",                minTime = 60, maxTime = 120,  weight = 0.5,  weather = "WIND"  },
		{ action = "spawn_ion_storm",                type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",                minTime = 30, maxTime = 60,   weight = 1.25, weather = "SUN|WIND" },
		{ action = "spawn_acid_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/acid_rain.logic",                minTime = 30, maxTime = 60,   weight = 1,    weather = "SUN|WIND" },
		{ action = "spawn_acid_fissures",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/acid_fissures.logic",            minTime = 30, maxTime = 60,   weight = 2 },
		{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 8, logicFile="logic/weather/meteor_shower.logic",            minTime = 30, maxTime = 60,   weight = 0.5  },
		{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 8, logicFile="logic/weather/meteor_shower.logic",            minTime = 30, maxTime = 60,   weight = 0.2  },	
		{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/comet_silent.logic",                                           weight = 1.2  },
		{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/tornado_acid_near_player.logic", minTime = 30, maxTime = 30,   weight = 0.5, weather = "SUN|WIND" },
		{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/resource_earthquake.logic",                                    weight = 0.5 },
		{ action = "spawn_resource_comet",           type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/resource_comet.logic",                                         weight = 0.25 }
	}

	rules.spawnCooldownEventChance = -- events spawn chance during/after attack (cooldown). values should be descending
	{
		20,  -- 1st event probability in percent
		10,  -- 2nd event probability in percent
	}
	
	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_vein",        runOutPercentageOnMap =  5, minToSpawn =  2000, maxToSpawn =  5000,  chance = 25 },
		{ name = "carbon_deepvein",    runOutPercentageOnMap =  5, minToSpawn = 20000, maxToSpawn = 90000,  chance = 15,                                    events = { "spawn_resource_earthquake" }},
		{ name = "palladium_vein",     runOutPercentageOnMap =  5, minToSpawn =  2000, maxToSpawn =  5000,  chance = 25, eventGroup = "palladium_unlocked" },
		{ name = "palladium_deepvein", runOutPercentageOnMap =  5, minToSpawn = 20000, maxToSpawn = 90000,  chance = 2,  eventGroup = "palladium_unlocked", events = { "spawn_resource_earthquake" }},
		--{ name = "morphium_deepvein",  runOutPercentageOnMap = 10, isInfinite = 1,                         chance = 65, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
	}

	rules.timeToNextDifficultyLevel = 
	{			
		180, -- difficulty level 1
		180, -- difficulty level 2
		180, -- difficulty level 3
		300, -- difficulty level 4
		900, -- difficulty level 5
		1020, -- difficulty level 6
		1200, -- difficulty level 7
		1500, -- difficulty level 8
		1800, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		60,  -- difficulty level 1
		60,  -- difficulty level 2
		60,  -- difficulty level 3
		60,  -- difficulty level 4	
		60,  -- difficulty level 5	
		60,  -- difficulty level 6	
		60,  -- difficulty level 7
		60,  -- difficulty level 8	
		60,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
  
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/destroy_nest_granan_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_granan_single.logic",   minDifficultyLevel = 3 },
		{ name = "logic/objectives/kill_elite.logic",                   minDifficultyLevel = 4 }
	}

	rules.cooldownAfterAttacks = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		90,  -- difficulty level 3
		120,  -- difficulty level 4	
		120,  -- difficulty level 5	
		180,  -- difficulty level 6	
		180,  -- difficulty level 7
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
		1200,  -- difficulty level 6	
		1200,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1200,  -- difficulty level 9	
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3		
		0,  -- difficulty level 4
		0,  -- difficulty level 5
		1,  -- difficulty level 6
		1,  -- difficulty level 7
		2,  -- difficulty level 8
		3,  -- difficulty level 9
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
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 3			
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 5			
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 6					
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 7				
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 8					
		"logic/dom/attack_level_1_entry.logic", -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{},  -- concecutive chances of wave repeating at level 4
		{},  -- concecutive chances of wave repeating at level 5
		{},  -- concecutive chances of wave repeating at level 6
		{50},  -- concecutive chances of wave repeating at level 7
		{70, 50},  -- concecutive chances of wave repeating at level 8
		{80, 50, 20, 80, 70},  -- concecutive chances of wave repeating at level 9
	}
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8,  }, biomes = { "acid" },  levels = { 1 },   ids = { 1, 2 },         suffixes = { "", "alpha" },  },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8   }, biomes = { "acid" },  levels = { 2 },   ids = { 1, 2 },         suffixes = { "", "" },       },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9}, biomes = { "acid" },  levels = { 2 },   ids = { 1, 2 },         suffixes = { "alpha" },      },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9}, biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },         suffixes = { "" },           },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       8, 9}, biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },         suffixes = { "", "alpha" },  },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          9}, biomes = { "acid" },  levels = { 4,5 }, ids = { 1, 2 },         suffixes = { "" },           },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          9}, biomes = { "group" }, levels = { 1,2 }, ids = { 1, 2 },         suffixes = { "", "alpha" },  },   rules.waves)
	

	rules.extraWaves = 
	{
		{}, -- difficulty level 1
		{}, -- difficulty level 2
		{}, -- difficulty level 3
		{}, -- difficulty level 4
		{}, -- difficulty level 5			
		{}, -- difficulty level 6
		{}, -- difficulty level 7
		
		{ -- difficulty level 8
			"logic/missions/survival/attack_level_1_id_1_acid_alpha.logic",
			"logic/missions/survival/attack_level_1_id_2_acid_alpha.logic",
			"logic/missions/survival/attack_level_1_id_1_acid_ultra.logic",
			"logic/missions/survival/attack_level_1_id_2_acid_ultra.logic",
			"logic/missions/survival/attack_level_2_id_1_acid.logic",
		},		
		 
		{ -- difficulty level 9
			"logic/missions/survival/attack_level_1_id_1_acid_alpha.logic",
			"logic/missions/survival/attack_level_1_id_2_acid_alpha.logic",
			"logic/missions/survival/attack_level_1_id_1_acid_ultra.logic",
			"logic/missions/survival/attack_level_1_id_2_acid_ultra.logic",
			"logic/missions/survival/attack_level_4_id_1_acid_alpha.logic",
			"logic/missions/survival/attack_level_4_id_2_acid_ultra.logic",
		},	
	}

	rules.bosses = 
	{
		{}, -- difficulty level 1
		{}, -- difficulty level 2
		{}, -- difficulty level 3
		{}, -- difficulty level 4
		{}, -- difficulty level 5			
		{}, -- difficulty level 6
		{}, -- difficulty level 7
		{}, -- difficulty level 8	
		 
		{ -- difficulty level 9
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_nerilian.logic",
			"logic/missions/survival/attack_boss_nurglax.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

	}

    return rules;
end