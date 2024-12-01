return function()
    local rules = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_default.lua")()
	
	rules.gameEvents = -- overwrite default to add shegret and kermon attacks during waves
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
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack.logic",                               weight = 1 },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack_hard.logic",                          weight = 0.75 },
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 6,                    logicFile="logic/event/shegret_attack_very_hard.logic",                     weight = 0.5 },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack.logic",                                weight = 1 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                           weight = 0.75 },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",                      weight = 0.5 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                               weight = 0.3 },
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

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20, 50, 25 }
	
	rules.idleTime = 
	{			
		 450,  -- difficulty level 1
		 600,  -- difficulty level 2
		 660,  -- difficulty level 3
		 660,  -- difficulty level 4
		 900,  -- difficulty level 5
		 900,  -- difficulty level 6
		 900,  -- difficulty level 7
		 900,  -- difficulty level 8
		 900,  -- difficulty level 9
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic",                   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_granan_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_granan_multiple.logic", minDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_creeper.logic",              minDifficultyLevel = 4 } 
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 4 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{30 },                -- concecutive chances of attack wave repeating at level 1
		{35, 5},              -- concecutive chances of attack wave repeating at level 2
		{40, 15},             -- concecutive chances of attack wave repeating at level 3
		{45, 25},             -- concecutive chances of attack wave repeating at level 4
		{50, 35, 20},         -- concecutive chances of attack wave repeating at level 5
		{60, 45, 35},         -- concecutive chances of attack wave repeating at level 6
		{70, 60, 45, 15},     -- concecutive chances of attack wave repeating at level 7
		{80, 70, 65, 25},     -- concecutive chances of attack wave repeating at level 8
		{90, 80, 70, 35, 90}, -- concecutive chances of attack wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 15  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 30  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 40  -- chance to reroll and replace an attack wave from its original wave pool
	
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "hard", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "hard", 1)
	
	rules.waves = {}
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "acid" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "acid" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "acid" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "acid" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "acid" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "acid" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "acid" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "acid" },  levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "acid" },  levels = { 6 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	
	 rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	 rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	 rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {             5, 6, 7, 8},    biomes = { "swamp" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	 rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "swamp" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	 rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8,  }, biomes = { "swamp" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	-- rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                   7, 8, 9}, biomes = { "swamp" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	-- rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                      8, 9}, biomes = { "swamp" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	-- rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                         9}, biomes = { "swamp" }, levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end