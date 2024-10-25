return function()
    local rules = require("lua/missions/campaigns/story/v2/jungle/dom_jungle_resource_outpost_rules_default.lua")()
	
	for i = 1, 9 do
		rules.timeToNextDifficultyLevel[i] = rules.timeToNextDifficultyLevel[i] * 0.7
		rules.idleTime[i]                  = rules.idleTime[i] * 0.7
	end
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
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
				"logic/missions/survival/attack_level_1_id_1.logic",
				"logic/missions/survival/attack_level_1_id_1_alpha.logic",
				"logic/missions/survival/attack_level_1_id_2.logic",
				"logic/missions/survival/attack_level_1_id_2_alpha.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1.logic",
				"logic/missions/survival/attack_level_2_id_1_alpha.logic",
				"logic/missions/survival/attack_level_2_id_2.logic",
				"logic/missions/survival/attack_level_2_id_2_alpha.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1.logic",
				"logic/missions/survival/attack_level_3_id_1_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2.logic",
				"logic/missions/survival/attack_level_3_id_2_alpha.logic",
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1.logic",
				"logic/missions/survival/attack_level_4_id_1_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2.logic",
				"logic/missions/survival/attack_level_4_id_2_alpha.logic",
				"logic/missions/survival/attack_level_4_id_3.logic",
				"logic/missions/survival/attack_level_4_id_3_alpha.logic",
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1.logic",
				"logic/missions/survival/attack_level_5_id_1_alpha.logic",
				"logic/missions/survival/attack_level_5_id_2.logic",			
				"logic/missions/survival/attack_level_5_id_2_alpha.logic",	
				"logic/missions/survival/attack_level_5_id_3.logic",			
				"logic/missions/survival/attack_level_5_id_3_alpha.logic",
				"logic/missions/survival/attack_level_5_id_4.logic",			
				"logic/missions/survival/attack_level_5_id_4_alpha.logic",
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1.logic",
				"logic/missions/survival/attack_level_6_id_1.logic",
				"logic/missions/survival/attack_level_6_id_1_alpha.logic",
				"logic/missions/survival/attack_level_6_id_2.logic",			
				"logic/missions/survival/attack_level_6_id_2.logic",			
				"logic/missions/survival/attack_level_6_id_2_alpha.logic",	
				"logic/missions/survival/attack_level_6_id_3.logic",			
				"logic/missions/survival/attack_level_6_id_3_alpha.logic",
				"logic/missions/survival/attack_level_6_id_4.logic",			
				"logic/missions/survival/attack_level_6_id_4_alpha.logic",
				"logic/missions/survival/attack_level_6_id_5.logic",			
				"logic/missions/survival/attack_level_6_id_5_alpha.logic",
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1.logic",
				"logic/missions/survival/attack_level_7_id_1.logic",
				"logic/missions/survival/attack_level_7_id_1_alpha.logic",
				"logic/missions/survival/attack_level_7_id_2.logic",
				"logic/missions/survival/attack_level_7_id_2.logic",
				"logic/missions/survival/attack_level_7_id_2_alpha.logic",
				"logic/missions/survival/attack_level_7_id_3.logic",
				"logic/missions/survival/attack_level_7_id_3_alpha.logic",
				"logic/missions/survival/attack_level_7_id_4.logic",
				"logic/missions/survival/attack_level_7_id_4_alpha.logic",
				"logic/missions/survival/attack_level_7_id_5.logic",
				"logic/missions/survival/attack_level_7_id_5_alpha.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_1_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_8_id_2_alpha.logic",
				"logic/missions/survival/attack_level_8_id_3.logic",
				"logic/missions/survival/attack_level_8_id_3_alpha.logic",
				"logic/missions/survival/attack_level_8_id_4.logic",
				"logic/missions/survival/attack_level_8_id_4_alpha.logic",
				"logic/missions/survival/attack_level_8_id_5.logic",
				"logic/missions/survival/attack_level_8_id_5_alpha.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_1.logic",
				"logic/missions/survival/attack_level_8_id_1_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_ultra.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_8_id_2.logic",
				"logic/missions/survival/attack_level_8_id_3.logic",
				"logic/missions/survival/attack_level_8_id_3.logic",
				"logic/missions/survival/attack_level_8_id_4.logic",
				"logic/missions/survival/attack_level_8_id_4.logic",
				"logic/missions/survival/attack_level_8_id_5.logic",
				"logic/missions/survival/attack_level_8_id_5.logic",
				"logic/missions/survival/attack_level_8_id_2_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_alpha.logic",
				"logic/missions/survival/attack_level_8_id_3_alpha.logic",
				"logic/missions/survival/attack_level_8_id_3_alpha.logic",
				"logic/missions/survival/attack_level_8_id_4_alpha.logic",
				"logic/missions/survival/attack_level_8_id_4_alpha.logic",
				"logic/missions/survival/attack_level_8_id_5_alpha.logic",
				"logic/missions/survival/attack_level_8_id_5_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_ultra.logic",
				"logic/missions/survival/attack_level_8_id_3_ultra.logic",
				"logic/missions/survival/attack_level_8_id_4_ultra.logic",
				"logic/missions/survival/attack_level_8_id_5_ultra.logic",
			},
		},
		
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