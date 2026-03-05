return function()
    local rules = require("lua/missions/campaigns/story/v2/ice/dom_template_ice_resource_rules_default.lua")()
		
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		300, -- difficulty level 2
		300, -- difficulty level 3	
		300, -- difficulty level 4
		450, -- difficulty level 5
		450, -- difficulty level 6
		450, -- difficulty level 7
		450, -- difficulty level 8
		450, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		450,  -- difficulty level 2
		450,  -- difficulty level 3
		600,  -- difficulty level 4	
		600,  -- difficulty level 5	
		600,  -- difficulty level 6	
		720,  -- difficulty level 7
		720,  -- difficulty level 8	
		720,  -- difficulty level 9	
	}
	
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
	
	rules.waves = 
	{
		["default"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_ice_hard.lua"),					
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/ice/attack_level_1_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_1_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_1_id_3_ice_alpha.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/ice/attack_level_2_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_2_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_2_id_3_ice_alpha.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/ice/attack_level_3_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_3_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_3_id_3_ice_alpha.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/ice/attack_level_4_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_4_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_4_id_3_ice_alpha.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/ice/attack_level_5_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_5_id_2_ice_alpha.logic",			
			"logic/missions/survival/ice/attack_level_5_id_3_ice_alpha.logic",				
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/ice/attack_level_6_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_6_id_2_ice_alpha.logic",			
			"logic/missions/survival/ice/attack_level_6_id_3_ice_alpha.logic",						
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/ice/attack_level_7_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_7_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_7_id_3_ice_alpha.logic",			
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/ice/attack_level_8_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_8_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_8_id_3_ice_alpha.logic",			
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/ice/attack_level_8_id_1_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_8_id_2_ice_alpha.logic",
			"logic/missions/survival/ice/attack_level_8_id_3_ice_alpha.logic",			
		},
	}

    return rules;
end