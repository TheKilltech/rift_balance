return function()
    local rules = require("lua/missions/campaigns/story/v2/magma/dom_magma_scout_rules_default.lua")()
	
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
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7,     },  biomes = { "magma" }, levels = { 1 },   ids = {    2 },      suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8   },  biomes = { "magma" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "magma" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "ultra"},     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "magma" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "magma" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "magma" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "alpha" },    },   rules.waves)
	

	rules.extraWaves = 
	{
	
	}

	rules.bosses = 
	{

	}

    return rules;
end