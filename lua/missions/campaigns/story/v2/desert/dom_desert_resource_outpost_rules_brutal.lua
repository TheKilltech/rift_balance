return function()
    local rules  = require("lua/missions/campaigns/story/v2/desert/dom_desert_resource_outpost_rules_hard.lua")()
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "brutal", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "brutal", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "brutal", 1)
	
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
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 7, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}
	
	
	rules.waveRepeatChances = 
	{
		{},                        -- concecutive chances of wave repeating at level 1
		{20},                      -- concecutive chances of wave repeating at level 2
		{35},                      -- concecutive chances of wave repeating at level 3
		{70, 15},                  -- concecutive chances of wave repeating at level 4
		{70, 60, 15},              -- concecutive chances of wave repeating at level 5
		{80, 70, 30, 15},          -- concecutive chances of wave repeating at level 6
		{80, 80, 60, 15},          -- concecutive chances of wave repeating at level 7
		{90, 90, 80, 30, 10},      -- concecutive chances of wave repeating at level 8
		{95, 90, 80, 50, 40, 10},  -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 30
	rules.waveChanceRerollSpawn      = 50
	rules.waveChanceReroll           = 40
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { "desert" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7, 8},    biomes = { "desert" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8, 9}, biomes = { "desert" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "desert" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { "desert" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { "desert" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "desert" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "desert" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "desert" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "desert" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "desert" },  levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "desert" },  levels = { 6 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { "group" },   levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "group" },   levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { "group" },   levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" },   levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" },   levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {                   7, 8, 9}, biomes = { "group" },   levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {                      8, 9}, biomes = { "group" },   levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "caverns" },   difficulty = {                         9}, biomes = { "group" },   levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)

    return rules;
end