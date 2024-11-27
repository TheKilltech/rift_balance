return function()
    local rules = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_hard.lua")()
	
	
	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		660,  -- difficulty level 4	
		660,  -- difficulty level 5	
		660,  -- difficulty level 6	
		660,  -- difficulty level 7
		660,  -- difficulty level 8	
		660,  -- difficulty level 9	
	}
	
	
	rules.timeToNextDifficultyLevel = 
	{			
		600, -- difficulty level 1
		600, -- difficulty level 2
		660, -- difficulty level 3	
		780, -- difficulty level 4
		900, -- difficulty level 5
		1020, -- difficulty level 6
		1200, -- difficulty level 7
		1500, -- difficulty level 8
		1800, -- difficulty level 9
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		2,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		3,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 7, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}
	
	
	rules.waveRepeatChances = 
	{
		{30 },                    -- concecutive chances of wave repeating at level 1
		{40, 20},                 -- concecutive chances of wave repeating at level 2
		{50, 20},                 -- concecutive chances of wave repeating at level 3
		{60, 45},                 -- concecutive chances of wave repeating at level 4
		{80, 50, 20},             -- concecutive chances of wave repeating at level 5
		{90, 75, 70},             -- concecutive chances of wave repeating at level 6
		{90, 90, 70, 20},         -- concecutive chances of wave repeating at level 7
		{90, 80, 80, 80},         -- concecutive chances of wave repeating at level 8
		{80, 80, 80, 35, 50, 90}, -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 20
	rules.waveChanceRerollSpawn      = 40
	rules.waveChanceReroll           = 40
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "acid" },  levels = { 1, 2 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "acid" },  levels = { 1, 2 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "acid" },  levels = { 2, 3 },   ids = { 1, 2 },   suffixes = { "", "", "alpha" },      },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 2, 3 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "acid" },  levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "acid" },  levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "acid" },  levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "acid" },  levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "acid" },  levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "acid" },  levels = { 5 },      ids = { 1, 2 },   suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "acid" },  levels = { 6 },      ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 2, 3 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {             5, 6, 7, 8},    biomes = { "swamp" }, levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "swamp" }, levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8,  }, biomes = { "swamp" }, levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                   7, 8, 9}, biomes = { "swamp" }, levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                      8, 9}, biomes = { "swamp" }, levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                         9}, biomes = { "swamp" }, levels = { 5 },      ids = { 1, 2 },   suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	
    return rules;
end