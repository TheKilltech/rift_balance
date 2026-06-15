return function()
    local rules = require("lua/missions/survival/v2/dom_survival_desert_rules_default.lua")()		

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
		2,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		3,  -- difficulty level 9
	}

	--rules.extraWaves = 
	--{
	--	 -- difficulty level 1		
	--	{ 
	--		"logic/missions/survival/attack_level_1_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_1_id_2_alpha.logic",
	--	},
	--
	--	 -- difficulty level 2
	--	{ 			
	--		"logic/missions/survival/attack_level_2_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_2_id_2_alpha.logic",
	--	},
	--
	--	 -- difficulty level 3
	--	{ 
	--		"logic/missions/survival/attack_level_3_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_3_id_2_alpha.logic",
	--	},
	--
	--	 -- difficulty level 4
	--	{ 			
	--		"logic/missions/survival/attack_level_4_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_4_id_2_alpha.logic",
	--	},
	--
	--	 -- difficulty level 5
	--	{ 
	--		"logic/missions/survival/attack_level_5_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_5_id_2_alpha.logic",			
	--	},
	--
	--	 -- difficulty level 6
	--	{ 
	--		"logic/missions/survival/attack_level_6_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_6_id_2_alpha.logic",				
	--	},
	--
	--	 -- difficulty level 7
	--	{ 
	--		"logic/missions/survival/attack_level_7_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_7_id_2_alpha.logic",	
	--	},
	--
	--	 -- difficulty level 8
	--	{ 
	--		"logic/missions/survival/attack_level_8_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_8_id_2_alpha.logic",	
	--	},
	--
	--	 -- difficulty level 9
	--	{ 
	--		"logic/missions/survival/attack_level_8_id_1_alpha.logic",
	--		"logic/missions/survival/attack_level_8_id_2_alpha.logic",
	--	},
	--}

    return rules;
end