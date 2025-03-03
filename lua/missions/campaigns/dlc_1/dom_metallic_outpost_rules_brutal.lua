return function()
    local rules  = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_hard.lua")()	
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "brutal", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "brutal", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "brutal", 1)
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 2, maxCount = 2 },  -- difficulty level 3
		{ minCount = 2, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 3, maxCount = 3 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}	
	
	rules.waveRepeatChances = 
	{
		{},                       -- concecutive chances of wave repeating at level 1
		{},                       -- concecutive chances of wave repeating at level 2
		{15},                     -- concecutive chances of wave repeating at level 3
		{50, 20},                 -- concecutive chances of wave repeating at level 4
		{80, 50, 20},             -- concecutive chances of wave repeating at level 5
		{90, 75, 70},             -- concecutive chances of wave repeating at level 6
		{90, 90, 70, 20},         -- concecutive chances of wave repeating at level 7
		{90, 80, 80, 80},         -- concecutive chances of wave repeating at level 8
		{80, 80, 80, 35, 50, 90}, -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 25
	rules.waveChanceRerollSpawn      = 45
	rules.waveChanceReroll           = 40
		
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "metallic" }, levels = { 1, 2 }, ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "metallic" }, levels = { 1, 2 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "metallic" }, levels = { 2, 3 }, ids = { 1, 2 },      suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "metallic" }, levels = { 2, 3 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "metallic" }, levels = { 3, 4 }, ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "metallic" }, levels = { 3, 4 }, ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "metallic" }, levels = { 3, 5 }, ids = { 1, 2, 3 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "metallic" }, levels = { 4, 5 }, ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "metallic" }, levels = { 4, 5 }, ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "metallic" }, levels = { 4, 5 }, ids = { 1, 2, 3 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "metallic" }, levels = { 6 },    ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "group" },    levels = { 2, 3 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "group" },    levels = { 3, 4 }, ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {             5, 6, 7, 8},    biomes = { "group" },    levels = { 3, 4 }, ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" },    levels = { 3, 4 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8,  }, biomes = { "group" },    levels = { 4, 5 }, ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                   7, 8, 9}, biomes = { "group" },    levels = { 4, 5 }, ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                      8, 9}, biomes = { "group" },    levels = { 4, 5 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                         9}, biomes = { "group" },    levels = { 6 },    ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end