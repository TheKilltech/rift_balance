return function()
    local rules = require("lua/missions/campaigns/story/v2/magma/dom_magma_find_rate_resource_rules_hard.lua")()
	
	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		780,  -- difficulty level 6	
		780,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
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
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7,     },  biomes = { "magma" }, levels = { 1, 2 },    ids = { 1, 2 },  suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8   },  biomes = { "magma" }, levels = { 2, 3 },    ids = { 1, 2 },  suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8   },  biomes = { "magma" }, levels = { 1, 2 },    ids = { 1, 2 },  suffixes = { "ultra"},     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "magma" }, levels = { 3, 4 },    ids = { 1, 2 },  suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "magma" }, levels = { 4, 5 },    ids = { 1, 2 },  suffixes = { "" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "magma" }, levels = { 2, 3 },    ids = { 1, 2 },  suffixes = { "alpha" },    },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          9},  biomes = { "magma" }, levels = { 6, 7 },    ids = { 1, 2 },  suffixes = { "" },         },   rules.waves)
	
	rules.extraWaves = 
	{
	
	}

	rules.bosses = 
	{

	}

    return rules;
end