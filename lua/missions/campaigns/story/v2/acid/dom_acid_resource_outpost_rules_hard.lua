return function()
    local rules = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_default.lua")()
	
	rules.idleTime = 
	{			
		300,  -- difficulty level 1
		420,  -- difficulty level 2
		480,  -- difficulty level 3
		480,  -- difficulty level 4	
		520,  -- difficulty level 5	
		520,  -- difficulty level 6	
		600,  -- difficulty level 7
		600,  -- difficulty level 8	
		600,  -- difficulty level 9	
	}
	
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		480, -- difficulty level 2
		480, -- difficulty level 3	
		480, -- difficulty level 4
		480, -- difficulty level 5
		480, -- difficulty level 6
		600, -- difficulty level 7
		600, -- difficulty level 8
		600, -- difficulty level 9
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		3,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}
	
	rules.waves = 
	{
		["default"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/attack_level_1_id_1_acid.logic",
				"logic/missions/survival/attack_level_1_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_1_id_2_acid.logic",
				"logic/missions/survival/attack_level_1_id_2_acid_alpha.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1_acid.logic",
				"logic/missions/survival/attack_level_2_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_2_id_2_acid.logic",
				"logic/missions/survival/attack_level_2_id_2_acid_alpha.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1_acid.logic",
				"logic/missions/survival/attack_level_3_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_acid.logic",
				"logic/missions/survival/attack_level_3_id_2_acid_alpha.logic",				
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1_acid.logic",
				"logic/missions/survival/attack_level_4_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_acid.logic",
				"logic/missions/survival/attack_level_4_id_2_acid_alpha.logic",				
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1_acid.logic",
				"logic/missions/survival/attack_level_5_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_5_id_2_acid.logic",			
				"logic/missions/survival/attack_level_5_id_2_acid_alpha.logic",							
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1_acid.logic",
				"logic/missions/survival/attack_level_6_id_1_acid.logic",
				"logic/missions/survival/attack_level_6_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_6_id_2_acid.logic",			
				"logic/missions/survival/attack_level_6_id_2_acid.logic",			
				"logic/missions/survival/attack_level_6_id_2_acid_alpha.logic",					
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1_acid.logic",
				"logic/missions/survival/attack_level_7_id_1_acid.logic",
				"logic/missions/survival/attack_level_7_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_7_id_2_acid.logic",
				"logic/missions/survival/attack_level_7_id_2_acid.logic",
				"logic/missions/survival/attack_level_7_id_2_acid_alpha.logic",				
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",
				"logic/missions/survival/attack_level_8_id_2_acid_alpha.logic",				
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_1_acid.logic",
				"logic/missions/survival/attack_level_8_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_acid_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_acid_ultra.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",
				"logic/missions/survival/attack_level_8_id_2_acid.logic",				
				"logic/missions/survival/attack_level_8_id_2_acid_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_acid_alpha.logic",				
				"logic/missions/survival/attack_level_8_id_2_acid_ultra.logic",				
			},
		},
	}

    return rules;
end