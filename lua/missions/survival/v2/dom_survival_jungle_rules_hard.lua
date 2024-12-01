return function()
    local rules = require("lua/missions/survival/v2/dom_survival_jungle_rules_default.lua")()

	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )	
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "survival", "hard", 1)
	rules.cooldownAfterAttacks      = helper:Default_CooldownAfterAttacks(      "survival", "hard", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "survival", "hard", 1)
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "survival", "hard", 1)
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 35, 60, 20, 60, 25 }
	
	
	rules.attackCountPerDifficulty = -- number of attacks, for the first attack interation of a wave is a random number between the numbers below.
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 4 },  -- difficulty level 7
		{ minCount = 2, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
	}

	-- chances each attack from a wave to be repeated, the chance for an attack to be repeted for the n-th time is taken from this table and a dice roll is done to determine if it repeats.
	-- an attack can only be repeated for as many times as there are repeat chances.
	-- an attack once stopped will not continue, ignoring later chance in the table.
	rules.waveRepeatChances = 
	{
		{20},                     -- consecutive chances of wave repeating at level 1
		{90},                     -- consecutive chances of wave repeating at level 2
		{80, 50},                 -- consecutive chances of wave repeating at level 3
		{80, 50},                 -- consecutive chances of wave repeating at level 4
		{50, 50},                 -- consecutive chances of wave repeating at level 5
		{60, 60, 20},             -- consecutive chances of wave repeating at level 6
		{60, 60, 50},             -- consecutive chances of wave repeating at level 7
		{70, 70, 60, 20},         -- consecutive chances of wave repeating at level 8
		{80, 70, 70, 30, 50, 30}, -- consecutive chances of wave repeating at level 9
	}
		
	rules.waveChanceRerollSpawnGroup = 15  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 30  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 40  -- chance to reroll and replace an attack wave from its original wave pool
	
	rules.waves = {}
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = { 1, 2, 3 },                  biomes = { "" }, levels = { 1 },    ids = { 1, 2 },       suffixes = { "", "alpha", "ultra" },  weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {    2, 3, 4, 5},             biomes = { "" }, levels = { 1 },    ids = { 1, 2 },       suffixes = { "ultra" },               weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {       3, 4, 5, 6},          biomes = { "" }, levels = { 2 },    ids = { 1, 2 },       suffixes = { "", "alpha", "ultra" },  weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {          4, 5, 6, 7},       biomes = { "" }, levels = { 2 },    ids = { 1, 2 },       suffixes = { "ultra" },               weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {          4, 5, 6, 7},       biomes = { "" }, levels = { 3 },    ids = { 1, 2, 3 },    suffixes = { "", "alpha" },           weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {             5, 6, 7, 8},    biomes = { "" }, levels = { 3 },    ids = { 1, 2, 3 },    suffixes = { "alpha", "ultra" },      weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {                   7, 8, 9}, biomes = { "" }, levels = { 4 },    ids = { 1, 2, 3, 4 }, suffixes = { "", "alpha", "ultra"},   weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {                      8, 9}, biomes = { "" }, levels = { 5, 6 }, ids = { 1, 2, 3, 4 }, suffixes = { "" },                    weight = 1 },   rules.waves)
	
	
	rules.buildingsUpgradeStartsLogic = 
	{			
		{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		{ name = "headquarters_lvl_4", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_5", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_6", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_7", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },    
	}
	
	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic",                    minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic", minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_creeper.logic",               minDifficultyLevel = 5 } 
	}
	
	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_level_1_id_1_alpha.logic",
			"logic/missions/survival/attack_level_1_id_2_alpha.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_level_2_id_1_alpha.logic",
			"logic/missions/survival/attack_level_2_id_2_alpha.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_level_3_id_1_alpha.logic",
			"logic/missions/survival/attack_level_3_id_2_alpha.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_level_4_id_1_alpha.logic",
			"logic/missions/survival/attack_level_4_id_2_alpha.logic",
			--"logic/missions/survival/attack_level_4_id_3_alpha.logic",
			"logic/missions/survival/attack_level_4_id_4_alpha.logic",
			--"logic/missions/survival/attack_level_4_id_1_ultra.logic",
			--"logic/missions/survival/attack_level_4_id_2_ultra.logic",
			--"logic/missions/survival/attack_level_4_id_3_ultra.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_level_5_id_1_alpha.logic",
			"logic/missions/survival/attack_level_5_id_2_alpha.logic",
			"logic/missions/survival/attack_level_4_id_3_alpha.logic",
			"logic/missions/survival/attack_level_5_id_4_alpha.logic",
			"logic/missions/survival/attack_boss_arachnoid.logic",
			--"logic/missions/survival/attack_level_5_id_1_ultra.logic",
			--"logic/missions/survival/attack_level_5_id_2_ultra.logic",	
			--"logic/missions/survival/attack_level_5_id_3_ultra.logic",	
			--"logic/missions/survival/attack_level_5_id_4_ultra.logic",	
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_level_6_id_1_alpha.logic",
			"logic/missions/survival/attack_level_6_id_2_alpha.logic",
			"logic/missions/survival/attack_level_5_id_3_alpha.logic",
			"logic/missions/survival/attack_level_6_id_4_alpha.logic",
			"logic/missions/survival/attack_level_6_id_5_alpha.logic",
			"logic/missions/survival/attack_boss_arachnoid.logic",
			--"logic/missions/survival/attack_level_6_id_1_ultra.logic",
			--"logic/missions/survival/attack_level_6_id_2_ultra.logic",		
			--"logic/missions/survival/attack_level_6_id_3_ultra.logic",		
			--"logic/missions/survival/attack_level_6_id_4_ultra.logic",		
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_level_7_id_1_alpha.logic",
			"logic/missions/survival/attack_level_7_id_2_alpha.logic",
			"logic/missions/survival/attack_level_6_id_3_alpha.logic",
			"logic/missions/survival/attack_level_7_id_4_alpha.logic",
			"logic/missions/survival/attack_level_7_id_5_alpha.logic",
			"logic/missions/survival/attack_boss_arachnoid.logic",
			--"logic/missions/survival/attack_level_7_id_1_ultra.logic",
			--"logic/missions/survival/attack_level_7_id_2_ultra.logic",		
			--"logic/missions/survival/attack_level_7_id_3_ultra.logic",		
			--"logic/missions/survival/attack_level_7_id_4_ultra.logic",		
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_level_8_id_1_alpha.logic",
			"logic/missions/survival/attack_level_8_id_2_alpha.logic",
			"logic/missions/survival/attack_level_7_id_3_alpha.logic",
			"logic/missions/survival/attack_level_8_id_4_alpha.logic",
			"logic/missions/survival/attack_level_8_id_5_alpha.logic",
			"logic/missions/survival/attack_boss_arachnoid.logic",
			--"logic/missions/survival/attack_level_8_id_1_ultra.logic",
			--"logic/missions/survival/attack_level_8_id_2_ultra.logic",		
			--"logic/missions/survival/attack_level_8_id_3_ultra.logic",		
			--"logic/missions/survival/attack_level_8_id_4_ultra.logic",		
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_level_8_id_1_alpha.logic",
			"logic/missions/survival/attack_level_8_id_2_alpha.logic",
			"logic/missions/survival/attack_level_8_id_3_alpha.logic",
			"logic/missions/survival/attack_level_8_id_4_alpha.logic",
			"logic/missions/survival/attack_level_8_id_5_alpha.logic",
			"logic/missions/survival/attack_boss_arachnoid.logic",
			--"logic/missions/survival/attack_level_8_id_1_ultra.logic",
			--"logic/missions/survival/attack_level_8_id_2_ultra.logic",
			--"logic/missions/survival/attack_level_8_id_3_ultra.logic",
			--"logic/missions/survival/attack_level_8_id_4_ultra.logic",
		},
	}

    return rules;
end