return function()
    local rules  = require("lua/missions/campaigns/story/v2/magma/dom_magma_resource_outpost_rules_default.lua")()
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "hard", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "hard", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "hard", 1)
	
	rules.spawnCooldownEventChance = { 35, 60, 20 }
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 4 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
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
	
	rules.waveChanceRerollSpawnGroup = 25
	rules.waveChanceRerollSpawn      = 45
	rules.waveChanceReroll           = 40
	
	rules.waves            = helper:Default_Waves(     "magma", "outpost", "hard", nil)
	rules.extraWaves       = helper:Default_ExtraWaves("magma", "outpost", "hard", nil)
	rules.multiplayerWaves = helper:Default_MpWaves(   "magma", "outpost", "hard", nil)
	
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {          4, 5, 6, 7, 8},    biomes = { "group" }, levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },       repeatInterval = 1,   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {          4, 5, 6, 7, 8},    biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },            repeatInterval = 1,   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {             5, 6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },   repeatInterval = 1,   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },       repeatInterval = 1,   },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },            repeatInterval = 1.2, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },   repeatInterval = 1.2, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {                      8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },       repeatInterval = 1.4, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },  difficulty = {                         9}, biomes = { "group" }, levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },   repeatInterval = 1.5, },   rules.waves)
	
    return rules;
end