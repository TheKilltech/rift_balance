return function()
    local rules = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_hard.lua")()
	
	rules.timeToNextDifficultyLevel = 
	{
		660,  -- difficulty level 1
		660,  -- difficulty level 2
		720,  -- difficulty level 3
		840,  -- difficulty level 4	
		840,  -- difficulty level 5	
		900,  -- difficulty level 6	
		1080,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1500,  -- difficulty level 9	
	}
	
	rules.idleTime = 
	{			
		300,  -- difficulty level 1
		420,  -- difficulty level 2
		480,  -- difficulty level 3
		480,  -- difficulty level 4	
		480,  -- difficulty level 5	
		480,  -- difficulty level 6	
		540,  -- difficulty level 7
		540,  -- difficulty level 8	
		540,  -- difficulty level 9	
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		2,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}	
	
	rules.waveRepeatChances = 
	{
		{},                       -- concecutive chances of wave repeating at level 1
		{},                       -- concecutive chances of wave repeating at level 2
		{},                       -- concecutive chances of wave repeating at level 3
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
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
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
	
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "magma" },    levels = { 2, 3 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "magma" },    levels = { 3, 4 }, ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {             5, 6, 7, 8},    biomes = { "magma" },    levels = { 3, 4 }, ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "magma" },    levels = { 3, 4 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8,  }, biomes = { "magma" },    levels = { 4, 5 }, ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                   7, 8, 9}, biomes = { "magma" },    levels = { 4, 5 }, ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                      8, 9}, biomes = { "magma" },    levels = { 4, 5 }, ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "magma" },     difficulty = {                         9}, biomes = { "magma" },    levels = { 6 },    ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end