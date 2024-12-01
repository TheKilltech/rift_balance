return function()
    local rules = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_default.lua")()
		
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	-- param factor:      a decimal number scaling each element of the table. 1 is default (no scaling)
	local helper = require( "lua/missions/v2/waves_gen.lua" )	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "survival", "hard", 1)
	--rules.idleTime                  = helper:Default_IdleTime(                  "survival", "hard", 1)
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 35, 60, 20, 60, 25 }
	
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 2, maxCount = 2 },  -- difficulty level 3
		{ minCount = 2, maxCount = 2 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 3, maxCount = 3 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 4 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},                       -- concecutive chances of wave repeating at level 1
		{},                       -- concecutive chances of wave repeating at level 2
		{},                       -- concecutive chances of wave repeating at level 3
		{50, 20},                 -- concecutive chances of wave repeating at level 4
		{80, 50, 20},             -- concecutive chances of wave repeating at level 5
		{90, 75, 70},             -- concecutive chances of wave repeating at level 6
		{90, 90, 70, 20},         -- concecutive chances of wave repeating at level 7
		{90, 80, 80, 80},         -- concecutive chances of wave repeating at level 8
		{80, 80, 80, 35, 50, 90}, -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 20 -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 30 -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 40 -- chance to reroll and replace an attack wave from its original wave pool
			
	rules.waves = {}
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { "metallic" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { "metallic" }, levels = { 1 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { "metallic" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "metallic" }, levels = { 2 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "metallic" }, levels = { 3 },   ids = { 1, 2, 3 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "metallic" }, levels = { 4 },   ids = { 1, 2, 3 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "metallic" }, levels = { 5 },   ids = { 1, 2, 3 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "metallic" }, levels = { 6 },   ids = { 1, 2, 3 },   suffixes = { "" },              },   rules.waves)
	
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "magma" },    levels = { 2 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {          4, 5, 6, 7},       biomes = { "magma" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {             5, 6, 7, 8},    biomes = { "magma" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8, 9}, biomes = { "magma" },    levels = { 3 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                6, 7, 8,  }, biomes = { "magma" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "" },              },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                   7, 8, 9}, biomes = { "magma" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                      8, 9}, biomes = { "magma" },    levels = { 4 },   ids = { 1, 2 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = helper:Generate({ groups = { "magma" },     difficulty = {                         9}, biomes = { "magma" },    levels = { 5 },   ids = { 1, 2 },      suffixes = { "", "alpha" },     },   rules.waves)
	
    return rules;
end