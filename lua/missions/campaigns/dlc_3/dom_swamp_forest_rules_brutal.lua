return function()
    local rules = require("lua/missions/campaigns/dlc_3/dom_swamp_forest_rules_default.lua")()	
		
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		300, -- difficulty level 2
		450, -- difficulty level 3	
		500, -- difficulty level 4
		600, -- difficulty level 5
		700, -- difficulty level 6
		800, -- difficulty level 7
		800, -- difficulty level 8
		800, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		300,  -- difficulty level 1
		330,  -- difficulty level 2
		360,  -- difficulty level 3
		390,  -- difficulty level 4	
		420,  -- difficulty level 5	
		450,  -- difficulty level 6	
		480,  -- difficulty level 7
		510,  -- difficulty level 8	
		540,  -- difficulty level 9	
	}
	rules.maxAttackCountPerDifficulty = 
	{			
		3,  -- difficulty level 1
		3,  -- difficulty level 2
		4,  -- difficulty level 3		
		4,  -- difficulty level 4
		4,  -- difficulty level 5
		4,  -- difficulty level 6
		4,  -- difficulty level 7
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}

	rules.waves = 
	{
		["default"] =
		{
			-- difficulty level 1		
			{ 
				--{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				--{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				--{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				--{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				--{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				--{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/swamp/attack_level_3_id_1_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/swamp/attack_level_3_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/swamp/attack_level_3_id_2_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/swamp/attack_level_3_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/swamp/attack_level_3_id_3_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/swamp/attack_level_3_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/swamp/attack_level_4_id_1_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_2_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/swamp/attack_level_4_id_3_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
				{ name="logic/missions/survival/swamp/attack_level_4_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/swamp/attack_level_5_id_1_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_2_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/swamp/attack_level_5_id_3_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},						
				{ name="logic/missions/survival/swamp/attack_level_5_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/swamp/attack_level_6_id_4_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_7_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_7_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp_ultra.logic",								
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp_alpha.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_3_swamp_alpha.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp_ultra.logic",								
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp_alpha.logic",			
				"logic/missions/survival/swamp/attack_level_7_id_4_swamp_alpha.logic",			
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
			},

			 -- difficulty level 9
			{ 				
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_ultra.logic",
				"logic/missions/survival/swamp/attack_level_8_id_1_swamp_ultra.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_2_swamp_ultra.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_alpha.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_3_swamp_ultra.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_alpha.logic",				
				"logic/missions/survival/swamp/attack_level_8_id_4_swamp_ultra.logic",
			},
		},
	}

    return rules;
end