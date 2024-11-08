return function()
    local rules = require("lua/missions/campaigns/story/v2/acid/dom_acid_scout_rules_default.lua")()
	
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
		{80, 20, 80, 50},  -- concecutive chances of wave repeating at level 9
	}
	
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = { 7, 8, 9 },  biomes = { "acid" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {    8, 9 },  biomes = { "acid" }, levels = { 2 },    ids = { 1, 2 }, suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {       9 },  biomes = { "acid" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {       9 },  biomes = { "acid" }, levels = { 3, 4 }, ids = { 1 },    suffixes = { "" },              },   rules.waves)
	
    return rules;
end