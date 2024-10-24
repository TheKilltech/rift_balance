return function()
    local rules = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_default.lua")()
	
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		480, -- difficulty level 2
		480, -- difficulty level 3	
		480, -- difficulty level 4
		480, -- difficulty level 5
		480, -- difficulty level 6
		540, -- difficulty level 7
		540, -- difficulty level 8
		540, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		300,  -- difficulty level 1
		420,  -- difficulty level 2
		480,  -- difficulty level 3
		480,  -- difficulty level 4	
		480,  -- difficulty level 5	
		480,  -- difficulty level 6	
		540,  -- difficulty level 7
		540,  -- difficulty level 8	
		540,  -- difficulty level 9	
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
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}	
	
	rules.waves = 
	{
		["default"] =
		{
			 -- difficulty level 1		
			{ 
				--"logic/missions/survival/metallic/attack_level_1_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_1_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_1_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_1_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_1_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_1_id_2_metallic_ultra.logic",
			},
	
			 -- difficulty level 2
			{ 			
				--"logic/missions/survival/metallic/attack_level_2_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_2_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_2_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_2_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_2_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_2_id_2_metallic_ultra.logic",
			},

			 -- difficulty level 3
			{ 
				--"logic/missions/survival/metallic/attack_level_3_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_3_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_3_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_3_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_3_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_3_id_2_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_3_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_3_id_3_metallic_ultra.logic",
			},

			 -- difficulty level 4
			{ 			
				--"logic/missions/survival/metallic/attack_level_4_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_4_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_4_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_4_id_2_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_4_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_4_id_3_metallic_ultra.logic",				
			},

			 -- difficulty level 5
			{ 
				--"logic/missions/survival/metallic/attack_level_5_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_5_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_5_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_5_id_2_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_2_metallic_alpha.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_2_metallic_ultra.logic",	
				--"logic/missions/survival/metallic/attack_level_4_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_4_id_3_metallic_ultra.logic",
			},

			 -- difficulty level 6
			{ 
				--"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_6_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_6_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_6_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
				--"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
				--"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_6_id_2_metallic_alpha.logic",			
				"logic/missions/survival/metallic/attack_level_6_id_2_metallic_alpha.logic",			
				"logic/missions/survival/metallic/attack_level_6_id_2_metallic_ultra.logic",	
				--"logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic",			
				--"logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic",			
				--"logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_3_metallic_alpha.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_3_metallic_alpha.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_3_metallic_ultra.logic",							
			},

			 -- difficulty level 7
			{ 
				--"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_6_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_6_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_6_id_3_metallic_ultra.logic",				
			},

			 -- difficulty level 8
			{ 
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_3_metallic_ultra.logic",				
			},

			 -- difficulty level 9
			{ 
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_ultra.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_ultra.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_ultra.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				--"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_ultra.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_ultra.logic",				
			},
		},
	}	

    return rules;
end