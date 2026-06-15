return function()
    local rules = require("lua/missions/survival/v2/dom_survival_swamp_rules_default.lua")()

	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		600, -- difficulty level 2
		600, -- difficulty level 3	
		600, -- difficulty level 4
		600, -- difficulty level 5
		600, -- difficulty level 6
		600, -- difficulty level 7
		600, -- difficulty level 8
		600, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		420,  -- difficulty level 1
		420,  -- difficulty level 2
		420,  -- difficulty level 3
		420,  -- difficulty level 4	
		420,  -- difficulty level 5	
		420,  -- difficulty level 6	
		420,  -- difficulty level 7
		420,  -- difficulty level 8	
		420,  -- difficulty level 9	
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		2,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}
	
	rules.buildingsUpgradeStartsLogic = 
	{			
		--{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		--{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		--{ name = "headquarters_lvl_4", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_5", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_6", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_7", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },    
	}
	
	rules.creatureDifficultyIncrementPerDOMDifficulty =
	{
		[1] =
		{	
			0,	 -- initial difficulty
			0, -- difficulty level 2
			0, -- difficulty level 3	
			0.5, -- difficulty level 4
			0.5, -- difficulty level 5
			0.5, -- difficulty level 6
			0.5, -- difficulty level 7
			0.5, -- difficulty level 8
			1.5, -- difficulty level 9
		},
		[2] =
		{	
			2, -- initial difficulty
			0, -- difficulty level 2
			1, -- difficulty level 3	
			1, -- difficulty level 4
			0, -- difficulty level 5
			1, -- difficulty level 6
			0, -- difficulty level 7
			1, -- difficulty level 8
			1, -- difficulty level 9
		},
		[3] =
		{	
			3,	 -- initial difficulty
			0, -- difficulty level 2
			1, -- difficulty level 3	
			0, -- difficulty level 4
			1, -- difficulty level 5
			0, -- difficulty level 6
			1, -- difficulty level 7
			1, -- difficulty level 8
			1, -- difficulty level 9
		},
		[4] =
		{	
			3,	 -- initial difficulty
			0, -- difficulty level 2
			1, -- difficulty level 3	
			1, -- difficulty level 4
			1, -- difficulty level 5
			0, -- difficulty level 6
			1, -- difficulty level 7
			1, -- difficulty level 8
			1, -- difficulty level 9
		},
	}
	
	rules.waves = 
	{
		["default"] =
		{
			-- difficulty level 1		
			{ 
				{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/swamp/attack_level_3_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/swamp/attack_level_3_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/swamp/attack_level_3_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/swamp/attack_level_3_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/swamp/attack_level_3_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/swamp/attack_level_3_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},										
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/swamp/attack_level_4_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
				{ name="logic/missions/survival/swamp/attack_level_4_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/swamp/attack_level_5_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
				{ name="logic/missions/survival/swamp/attack_level_5_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp_alpha.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp_alpha.logic",		
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_ultra.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_ultra.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_ultra.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_ultra.logic",
			},
		},
	}
	
    return rules;
end