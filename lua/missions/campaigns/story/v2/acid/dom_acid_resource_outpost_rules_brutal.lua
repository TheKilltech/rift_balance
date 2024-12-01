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
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 7, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

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
	
	rules.waveChanceRerollSpawnGroup = 20
	rules.waveChanceRerollSpawn      = 40
	rules.waveChanceReroll           = 40
	
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "brutal", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "brutal", 1)
	
	rules.waves = {}
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "acid" },  levels = { 1, 2 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "acid" },  levels = { 1, 2 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "acid" },  levels = { 2, 3 },   ids = { 1, 2 },   suffixes = { "", "", "alpha" },      },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 2, 3 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "acid" },  levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "acid" },  levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "acid" },  levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "acid" },  levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "acid" },  levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "acid" },  levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "acid" },  levels = { 5 },      ids = { 1, 2 },   suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "acid" },  levels = { 6 },      ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 2, 3 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7},       biomes = { "swamp" }, levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {             5, 6, 7, 8},    biomes = { "swamp" }, levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "swamp" }, levels = { 3, 4 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8,  }, biomes = { "swamp" }, levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "" },                   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                   7, 8, 9}, biomes = { "swamp" }, levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },          },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                      8, 9}, biomes = { "swamp" }, levels = { 4, 5 },   ids = { 1, 2 },   suffixes = { "ultra" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "swamp" },     difficulty = {                         9}, biomes = { "swamp" }, levels = { 5 },      ids = { 1, 2 },   suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	
    return rules;
end