return function()
    local rules = require("lua/missions/campaigns/dlc_2/dom_caverns_outpost_rules_default.lua")()	
		
	rules.timeToNextDifficultyLevel = 
	{			
		300, -- difficulty level 1
		350, -- difficulty level 2
		350, -- difficulty level 3	
		450, -- difficulty level 4
		450, -- difficulty level 5
		550, -- difficulty level 6
		550, -- difficulty level 7
		550, -- difficulty level 8
		550, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		330,  -- difficulty level 1
		380,  -- difficulty level 2
		380,  -- difficulty level 3
		480,  -- difficulty level 4	
		480,  -- difficulty level 5	
		580,  -- difficulty level 6	
		580,  -- difficulty level 7
		580,  -- difficulty level 8	
		680,  -- difficulty level 9	
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		2,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}
	
	rules.waves = 
	{
		["default"] =
		{
			-- difficulty level 1		
			{ 
				--{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				--{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=220.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				--{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				--{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=200.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/caverns/attack_level_4_id_1_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/caverns/attack_level_5_id_1_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_2_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_3_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},						
				{ name="logic/missions/survival/caverns/attack_level_5_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns_ultra.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns_ultra.logic",				
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns_ultra.logic",				
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns_ultra.logic",								
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns_alpha.logic",			
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns_alpha.logic",			
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_ultra.logic",				
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_ultra.logic",				
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_ultra.logic",				
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
			},

			 -- difficulty level 9
			{ 				
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_ultra.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_ultra.logic",				
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_ultra.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",				
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_ultra.logic",
			},
		},
	}

    return rules;
end