return function()
    local rules  = require("lua/missions/campaigns/dlc_2/dom_caverns_outpost_rules_default.lua")()	
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
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6 },         biomes = { "caverns" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8},    biomes = { "caverns" },  levels = { 1 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9}, biomes = { "caverns" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9}, biomes = { "caverns" },  levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8 ,9}, biomes = { "caverns" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9}, biomes = { "caverns" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9}, biomes = { "caverns" },  levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 6, 7, 8, 9}, biomes = { "caverns" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    7, 8, 9}, biomes = { "caverns" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       8, 9}, biomes = { "caverns" },  levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          9}, biomes = { "caverns" },  levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          9}, biomes = { "caverns" },  levels = { 6 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
																			   
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = { 6, 7, 8},    biomes = { "group" },    levels = { 2 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = { 6, 7, 8},    biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = { 6, 7, 8, 9}, biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = { 6, 7, 8, 9}, biomes = { "group" },    levels = { 3 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = { 6, 7, 8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },   suffixes = { "" },              },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = {    7, 8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = {       8, 9}, biomes = { "group" },    levels = { 4 },   ids = { 1, 2 },   suffixes = { "ultra" },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "desert" },    difficulty = {          9}, biomes = { "group" },    levels = { 5 },   ids = { 1, 2 },   suffixes = { "", "alpha" },     },   rules.waves)
	
	rules.waves = 
	{
		["default"] =
		{
			{ -- difficulty level 1
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			{  -- difficulty level 2			
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},
			
			{  -- difficulty level 3
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
			},
			
			{  -- difficulty level 4			
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
			},

			{  -- difficulty level 5
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic",       spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
			},
		},
	}

    return rules;
end