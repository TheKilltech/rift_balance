return function()
    local rules = require("lua/missions/campaigns/story/v2/jungle/dom_jungle_resource_outpost_rules_hard.lua")()
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{},  -- concecutive chances of wave repeating at level 4
		{},  -- concecutive chances of wave repeating at level 5
		{30},  -- concecutive chances of wave repeating at level 6
		{60},  -- concecutive chances of wave repeating at level 7
		{70, 50},  -- concecutive chances of wave repeating at level 8
		{80, 30, 80, 50},  -- concecutive chances of wave repeating at level 9
	}
	
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = { 6, 7, 8, 9 },  biomes = { "" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {    7, 8, 9 },  biomes = { "" }, levels = { 2 },    ids = { 1, 2 }, suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {       8, 9 },  biomes = { "" }, levels = { 3 },    ids = { 1, 2 }, suffixes = { "ultra" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {          9 },  biomes = { "" }, levels = { 4, 5 }, ids = { 1 },    suffixes = { "", "alpha" },          },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "acid" },    difficulty = {       8, 9 },  biomes = { "" }, levels = { 1, 2 }, ids = { 2 },    suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	
    return rules;
end