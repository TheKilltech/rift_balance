return function()
    local rules = require("lua/missions/campaigns/story/v2/acid/dom_acid_find_rare_resource_rules_default.lua")()
	
	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		780,  -- difficulty level 6	
		1200,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1380,  -- difficulty level 9	
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
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{},  -- concecutive chances of wave repeating at level 4
		{},  -- concecutive chances of wave repeating at level 5
		{},  -- concecutive chances of wave repeating at level 6
		{50, 30},  -- concecutive chances of wave repeating at level 7
		{70, 50, 30},  -- concecutive chances of wave repeating at level 8
		{80, 60, 20, 80, 70},  -- concecutive chances of wave repeating at level 9
	}
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7,     },  biomes = { "acid" }, levels = { 1 },    ids = { 1, 2 },      suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8   },  biomes = { "acid" }, levels = { 2 },    ids = { 1, 2 },      suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "acid" }, levels = { 1 },    ids = { 1, 2 },      suffixes = { "ultra"},     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "acid" }, levels = { 3 },    ids = { 1, 2, 3 },   suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "acid" }, levels = { 4 },    ids = { 1, 2, 3 },   suffixes = { "" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "acid" }, levels = { 2 },    ids = { 1, 2 },      suffixes = { "alpha" },    },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          9},  biomes = { "acid" }, levels = { 5, 6 }, ids = { 1, 2, 3 },   suffixes = { "" },         },   rules.waves)
	
	rules.extraWaves = 
	{
	
	}

	rules.bosses = 
	{

	}

    return rules;
end