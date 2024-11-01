return function()
    local rules = require("lua/missions/campaigns/story/v2/jungle/dom_jungle_find_rare_resource_rules_default.lua")()
	
	if not table.unpack then
		table.unpack = unpack
	end

	rules.gameEvents = {
		{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE",              minEventLevel = 8, logicFile="logic/event/shegret_attack_hard.logic", weight = 0.8 },
		table.unpack(rules.gameEvents)
	}
		
	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic", minDifficultyLevel = 5 },
		table.unpack(rules.objectivesLogic)
	}
	
	rules.spawnCooldownEventChance = -- events spawn chance during/after attack (cooldown). values should be descending
	{
		25,  -- 1st event probability in percent
		15,  -- 2nd event probability in percent
		5,  -- 3rd event probability in percent
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
		{20},  -- concecutive chances of wave repeating at level 6
		{60},  -- concecutive chances of wave repeating at level 7
		{70, 50},  -- concecutive chances of wave repeating at level 8
		{80, 20, 80, 50},  -- concecutive chances of wave repeating at level 9
	}
	
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = { 6, 7, 8, 9 },  biomes = { "" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {    7, 8, 9 },  biomes = { "" }, levels = { 2 },    ids = { 1, 2 }, suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {       8, 9 },  biomes = { "" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {          9 },  biomes = { "" }, levels = { 3, 4 }, ids = { 1, 3 }, suffixes = { "" },              },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "acid" },    difficulty = {       8, 9 },  biomes = { "" }, levels = { 1, 2 }, ids = { 2 },    suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end