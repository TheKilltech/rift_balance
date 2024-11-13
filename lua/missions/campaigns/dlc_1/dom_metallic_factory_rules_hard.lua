return function()
    local rules = require("lua/missions/campaigns/dlc_1/dom_metallic_factory_rules_default.lua")()
		
	rules.waveRepeatChances = 
	{
		{},                   -- concecutive chances of wave repeating at level 1
		{},                   -- concecutive chances of wave repeating at level 2
		{},                   -- concecutive chances of wave repeating at level 3
		{15 },                -- concecutive chances of wave repeating at level 4
		{30 },                -- concecutive chances of wave repeating at level 5
		{35, 25},             -- concecutive chances of wave repeating at level 6
		{50, 30, 20},         -- concecutive chances of wave repeating at level 7
		{65, 45, 25},         -- concecutive chances of wave repeating at level 8
		{80, 60, 40, 40},     -- concecutive chances of wave repeating at level 9
	}


	rules.maxAttackCountPerDifficulty = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3		
		1,  -- difficulty level 4
		1,  -- difficulty level 5
		1,  -- difficulty level 6
		2,  -- difficulty level 7
		2,  -- difficulty level 8
		3,  -- difficulty level 9
	}


	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 3 },                  biomes = { "metallic" }, levels = { 1 },   ids = { 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 3, 4, 5},             biomes = { "metallic" }, levels = { 1 },   ids = { 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 3, 4, 5, 6},          biomes = { "metallic" }, levels = { 2 },   ids = { 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    4, 5, 6, 7},       biomes = { "metallic" }, levels = { 2 },   ids = { 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    4, 5, 6, 7},       biomes = { "metallic" }, levels = { 3 },   ids = { 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       5, 6, 7, 8},    biomes = { "metallic" }, levels = { 3 },   ids = { 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          6, 7, 8,  }, biomes = { "metallic" }, levels = { 4 },   ids = { 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             7, 8, 9}, biomes = { "metallic" }, levels = { 4 },   ids = { 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end