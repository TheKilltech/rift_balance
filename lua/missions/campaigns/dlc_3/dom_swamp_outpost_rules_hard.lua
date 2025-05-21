return function()
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_outpost_rules_default.lua")()
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "hard", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "hard", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "hard", 1)
	
	rules.spawnCooldownEventChance = { 35, 60, 20 }
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 2, maxCount = 3 },  -- difficulty level 1
		{ minCount = 2, maxCount = 3 },  -- difficulty level 2
		{ minCount = 2, maxCount = 4 },  -- difficulty level 3
		{ minCount = 2, maxCount = 4 },  -- difficulty level 4
		{ minCount = 3, maxCount = 4 },  -- difficulty level 5
		{ minCount = 3, maxCount = 5 },  -- difficulty level 6
		{ minCount = 3, maxCount = 5 },  -- difficulty level 7
		{ minCount = 4, maxCount = 5 },  -- difficulty level 8
		{ minCount = 4, maxCount = 5 },  -- difficulty level 9
	}	
	
	rules.waveRepeatChances = 
	{
		{10},                   -- consecutive chances of wave repeating at level 1
		{25},                   -- consecutive chances of wave repeating at level 2
		{35},                   -- consecutive chances of wave repeating at level 3
		{45,  25},              -- consecutive chances of wave repeating at level 4
		{60,  45},              -- consecutive chances of wave repeating at level 5
		{75,  50, 20},          -- consecutive chances of wave repeating at level 6
		{90,  60, 40},          -- consecutive chances of wave repeating at level 7
		{100, 80, 50, 20},      -- consecutive chances of wave repeating at level 8
		{100, 80, 55, 25, 45},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 60
	rules.waveChanceRerollSpawn      = 25
	rules.waveChanceReroll           = 80
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { "swamp" },  levels = { 1 },   ids = { 1, 2 },       suffixes = { "", "alpha" },     spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0 },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7, 8},    biomes = { "swamp" },  levels = { 1 },   ids = { 1, 2 },       suffixes = { "ultra" },         spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0 },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8, 9}, biomes = { "swamp" },  levels = { 2 },   ids = { 1, 2 },       suffixes = { "", "", "alpha" }, spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0 },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "swamp" },  levels = { 2 },   ids = { 1, 2 },       suffixes = { "ultra" },         spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0 },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { "swamp" },  levels = { 3 },   ids = { 1, 2, 3 },    suffixes = { "" },              spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0 },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { "swamp" },  levels = { 3 },   ids = { 1, 2, 3 },    suffixes = { "", "alpha" },     spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0 },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "swamp" },  levels = { 3 },   ids = { 1, 2, 3 },    suffixes = { "ultra" },        },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "swamp" },  levels = { 4 },   ids = { 1, 2, 3 },    suffixes = { "" },             },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "swamp" },  levels = { 4 },   ids = { 1, 2, 3 },    suffixes = { "", "alpha" },    },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "swamp" },  levels = { 4 },   ids = { 1, 2, 3 },    suffixes = { "ultra" },        },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "swamp" },  levels = { 5 },   ids = { 1, 2, 3 },    suffixes = { "", "alpha" },    },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "swamp" },  levels = { 6 },   ids = { 1, 2, 3, 4 }, suffixes = { "" },             },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {          4, 5, 6, 7, 8},    biomes = { "jungle" }, levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {          4, 5, 6, 7, 8},    biomes = { "jungle" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {             5, 6, 7, 8, 9}, biomes = { "jungle" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {                6, 7, 8, 9}, biomes = { "jungle" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {                6, 7, 8, 9}, biomes = { "jungle" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {                   7, 8, 9}, biomes = { "jungle" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {                      8, 9}, biomes = { "jungle" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },  difficulty = {                         9}, biomes = { "jungle" }, levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end