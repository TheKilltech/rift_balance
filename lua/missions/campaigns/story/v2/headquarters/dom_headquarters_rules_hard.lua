return function()
    local rules = require("lua/missions/campaigns/story/v2/headquarters/dom_headquarters_rules_default.lua")()
	
	rules.timeToNextDifficultyLevel = 
	{			
		900, -- difficulty level 1
		1500, -- difficulty level 2
		1500, -- difficulty level 3	
		1500, -- difficulty level 4
		1500, -- difficulty level 5
		1500, -- difficulty level 6
		1500, -- difficulty level 7
		1500, -- difficulty level 8
		1500, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		900,  -- difficulty level 1
		900,  -- difficulty level 2
		900,  -- difficulty level 3
		900,  -- difficulty level 4	
		900,  -- difficulty level 5	
		900,  -- difficulty level 6	
		900,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}	
	
	rules.waveRepeatChances = 
	{
		{10},                   -- consecutive chances of wave repeating at level 1
		{25},                   -- consecutive chances of wave repeating at level 2
		{50, 50},               -- consecutive chances of wave repeating at level 3
		{50, 50},               -- consecutive chances of wave repeating at level 4
		{60, 50},               -- consecutive chances of wave repeating at level 5
		{75, 60, 20},           -- consecutive chances of wave repeating at level 6
		{90, 60, 40},           -- consecutive chances of wave repeating at level 7
		{100, 70, 60, 20},      -- consecutive chances of wave repeating at level 8
		{100, 70, 65, 35, 30},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 10
	rules.waveChanceRerollSpawn      = 25
	rules.waveChanceReroll           = 30
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = { 1, 2, 3 },                  biomes = { "" },      levels = { 1 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {    2, 3, 4, 5},             biomes = { "" },      levels = { 1 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {       3, 4, 5, 6},          biomes = { "" },      levels = { 2 },   ids = { 1, 2 },         suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {          4, 5, 6, 7},       biomes = { "" },      levels = { 2 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {          4, 5, 6, 7},       biomes = { "" },      levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {             5, 6, 7, 8},    biomes = { "" },      levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {                6, 7, 8, 9}, biomes = { "" },      levels = { 3 },   ids = { 1, 2, 3 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {                6, 7, 8,  }, biomes = { "" },      levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {                   7, 8, 9}, biomes = { "" },      levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {                      8, 9}, biomes = { "" },      levels = { 4 },   ids = { 1, 2, 3, 4 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },                      difficulty = {                         9}, biomes = { "" },      levels = { 5 },   ids = { 1, 2, 3, 4 },   suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {          4, 5, 6, 7},       biomes = { "group" }, levels = { 2 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {          4, 5, 6, 7},       biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },         suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {             5, 6, 7, 8},    biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {                6, 7, 8,  }, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },         suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {                      8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert", "acid", "magma" },      difficulty = {                         9}, biomes = { "group" }, levels = { 5 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {          4, 5, 6, 7},       biomes = { "group" }, levels = { 2 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {          4, 5, 6, 7},       biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },         suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {             5, 6, 7, 8},    biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },         suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   ids = { 1, 2 },         suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {                6, 7, 8,  }, biomes = { "group" }, levels = { 4 },   ids = { 1, 2, 3 },      suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2, 3 },      suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {                      8, 9}, biomes = { "group" }, levels = { 4 },   ids = { 1, 2, 3 },      suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "metallic", "caverns", "swamp" }, difficulty = {                         9}, biomes = { "group" }, levels = { 5 },   ids = { 1, 2, 3 },      suffixes = { "", "alpha" },     },   rules.waves)
	
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