return function()
    local rules  = require("lua/missions/campaigns/story/v2/magma/dom_magma_scout_rules_hard.lua")()
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "scout", "brutal", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "scout", "brutal", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "scout", "brutal", 1)
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{},  -- concecutive chances of wave repeating at level 4
		{},  -- concecutive chances of wave repeating at level 5
		{50},  -- concecutive chances of wave repeating at level 6
		{50, 50},  -- concecutive chances of wave repeating at level 7
		{70, 50, 40},  -- concecutive chances of wave repeating at level 8
		{80, 60, 20, 80, 70},  -- concecutive chances of wave repeating at level 9
	}
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7,     },  biomes = { "magma" }, levels = { 1, 2 },   ids = {    2 },      suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8   },  biomes = { "magma" }, levels = { 2, 3 },   ids = { 1, 2 },      suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "magma" }, levels = { 1, 2 },   ids = { 1, 2 },      suffixes = { "ultra"},     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "magma" }, levels = { 3, 4 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha"}, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9},  biomes = { "magma" }, levels = { 4, 5 },   ids = { 1, 2, 3 },   suffixes = { "", },        },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9},  biomes = { "magma" }, levels = { 2, 3 },   ids = { 1, 2 },      suffixes = { "alpha" },    },   rules.waves)
	
    return rules;
end