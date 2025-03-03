return function()
    local rules  = require("lua/missions/campaigns/story/v2/jungle/dom_jungle_resource_outpost_rules_default.lua")()
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
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { "" },  levels = { 1 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7, 8},    biomes = { "" },  levels = { 1 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8, 9}, biomes = { "" },  levels = { 2 },   ids = { 1, 2 },         suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "" },  levels = { 2 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { "" },  levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { "" },  levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "" },  levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { "" },  levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { "" },  levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { "" },  levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "" },  levels = { 5 },   ids = { 1, 2, 3, 4 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { "" },  levels = { 6 },   ids = { 1, 2, 3, 4 },   suffixes = { "" },              },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7, 8},    biomes = { "group" }, levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {          4, 5, 6, 7, 8},    biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {             5, 6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                      8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "swamp" },     difficulty = {                         9}, biomes = { "group" }, levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	

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