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
		
		["desert"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_1_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_1_id_2_desert.logic",
				"logic/missions/survival/attack_level_1_id_2_desert_alpha.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1_desert.logic",
				"logic/missions/survival/attack_level_2_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_2_id_2_desert.logic",
				"logic/missions/survival/attack_level_2_id_2_desert_alpha.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1_desert.logic",
				"logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_desert.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",				
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",				
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1_desert.logic",
				"logic/missions/survival/attack_level_5_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_5_id_2_desert.logic",			
				"logic/missions/survival/attack_level_5_id_2_desert_alpha.logic",							
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1_desert.logic",
				"logic/missions/survival/attack_level_6_id_1_desert.logic",
				"logic/missions/survival/attack_level_6_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_6_id_2_desert.logic",			
				"logic/missions/survival/attack_level_6_id_2_desert.logic",			
				"logic/missions/survival/attack_level_6_id_2_desert_alpha.logic",					
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1_desert.logic",
				"logic/missions/survival/attack_level_7_id_1_desert.logic",
				"logic/missions/survival/attack_level_7_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_7_id_2_desert.logic",
				"logic/missions/survival/attack_level_7_id_2_desert.logic",
				"logic/missions/survival/attack_level_7_id_2_desert_alpha.logic",				
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",
				"logic/missions/survival/attack_level_8_id_2_desert_alpha.logic",				
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_1_desert.logic",
				"logic/missions/survival/attack_level_8_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_desert_ultra.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",
				"logic/missions/survival/attack_level_8_id_2_desert.logic",				
				"logic/missions/survival/attack_level_8_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_desert_alpha.logic",				
				"logic/missions/survival/attack_level_8_id_2_desert_ultra.logic",				
			},
		},

		["acid"] =
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

		["magma"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/attack_level_1_id_1_magma.logic",
				"logic/missions/survival/attack_level_1_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_1_id_2_magma.logic",
				"logic/missions/survival/attack_level_1_id_2_magma_alpha.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/attack_level_2_id_1_magma.logic",
				"logic/missions/survival/attack_level_2_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_2_id_2_magma.logic",
				"logic/missions/survival/attack_level_2_id_2_magma_alpha.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/attack_level_3_id_1_magma.logic",
				"logic/missions/survival/attack_level_3_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_magma.logic",
				"logic/missions/survival/attack_level_3_id_2_magma_alpha.logic",				
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/attack_level_4_id_1_magma.logic",
				"logic/missions/survival/attack_level_4_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_magma.logic",
				"logic/missions/survival/attack_level_4_id_2_magma_alpha.logic",				
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/attack_level_5_id_1_magma.logic",
				"logic/missions/survival/attack_level_5_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_5_id_2_magma.logic",			
				"logic/missions/survival/attack_level_5_id_2_magma_alpha.logic",							
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/attack_level_6_id_1_magma.logic",
				"logic/missions/survival/attack_level_6_id_1_magma.logic",
				"logic/missions/survival/attack_level_6_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_6_id_2_magma.logic",			
				"logic/missions/survival/attack_level_6_id_2_magma.logic",			
				"logic/missions/survival/attack_level_6_id_2_magma_alpha.logic",					
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/attack_level_7_id_1_magma.logic",
				"logic/missions/survival/attack_level_7_id_1_magma.logic",
				"logic/missions/survival/attack_level_7_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_7_id_2_magma.logic",
				"logic/missions/survival/attack_level_7_id_2_magma.logic",
				"logic/missions/survival/attack_level_7_id_2_magma_alpha.logic",				
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",
				"logic/missions/survival/attack_level_8_id_2_magma_alpha.logic",				
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_1_magma.logic",
				"logic/missions/survival/attack_level_8_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_magma_alpha.logic",
				"logic/missions/survival/attack_level_8_id_1_magma_ultra.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",
				"logic/missions/survival/attack_level_8_id_2_magma.logic",				
				"logic/missions/survival/attack_level_8_id_2_magma_alpha.logic",
				"logic/missions/survival/attack_level_8_id_2_magma_alpha.logic",				
				"logic/missions/survival/attack_level_8_id_2_magma_ultra.logic",				
			},
		},
		
		["metallic"] =
		{
			 -- difficulty level 1		
			{ 
				"logic/missions/survival/metallic/attack_level_1_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_1_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_1_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_1_id_2_metallic_alpha.logic",
			},
	
			 -- difficulty level 2
			{ 			
				"logic/missions/survival/metallic/attack_level_2_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_2_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_2_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_2_id_2_metallic_alpha.logic",
			},

			 -- difficulty level 3
			{ 
				"logic/missions/survival/metallic/attack_level_3_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_3_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_3_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_3_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_3_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_3_id_3_metallic_alpha.logic",
			},

			 -- difficulty level 4
			{ 			
				"logic/missions/survival/metallic/attack_level_4_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_4_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_4_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_4_id_3_metallic_alpha.logic",
			},

			 -- difficulty level 5
			{ 
				"logic/missions/survival/metallic/attack_level_5_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_5_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_5_id_2_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_2_metallic_alpha.logic",	
				"logic/missions/survival/metallic/attack_level_5_id_3_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_5_id_3_metallic_alpha.logic",				
			},

			 -- difficulty level 6
			{ 
				"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_6_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_6_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_6_id_2_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_6_id_2_metallic_alpha.logic",	
				"logic/missions/survival/metallic/attack_level_6_id_3_metallic.logic",			
				"logic/missions/survival/metallic/attack_level_6_id_3_metallic_alpha.logic",
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_7_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_7_id_3_metallic_alpha.logic",
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_alpha.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_1_metallic_ultra.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_alpha.logic",
				"logic/missions/survival/metallic/attack_level_8_id_2_metallic_ultra.logic",
				"logic/missions/survival/metallic/attack_level_8_id_3_metallic_ultra.logic",				
			},
		},
		
		["caverns"] =
		{
			-- difficulty level 1		
			{ 
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/caverns/attack_level_1_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/caverns/attack_level_2_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
			},

			 -- difficulty level 3
			{ 
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
				{ name="logic/missions/survival/caverns/attack_level_3_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0},				
			},

			 -- difficulty level 4
			{ 			
				{ name="logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
				{ name="logic/missions/survival/caverns/attack_level_4_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0},				
			},

			 -- difficulty level 5
			{ 
				{ name="logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},
				{ name="logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
				{ name="logic/missions/survival/caverns/attack_level_5_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0},							
			},

			 -- difficulty level 6
			{ 
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_1_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_2_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
				{ name="logic/missions/survival/caverns/attack_level_6_id_3_caverns_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=0, target_max_radius=700.0},							
			},

			 -- difficulty level 7
			{ 
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_7_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_7_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns.logic",			
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns.logic",			
				"logic/missions/survival/caverns/attack_level_7_id_3_caverns_alpha.logic",			
			},

			 -- difficulty level 8
			{ 
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
			},

			 -- difficulty level 9
			{ 
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_1_caverns_ultra.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_8_id_2_caverns_ultra.logic",
				"logic/missions/survival/caverns/attack_level_8_id_3_caverns_ultra.logic",
			},
		},
		
		["swamp"] =
		{
			-- difficulty level 1		
			{ 
				{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				{ name="logic/missions/survival/swamp/attack_level_1_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				--{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
				--{ name="logic/missions/survival/swamp/attack_level_1_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
			},
	
			 -- difficulty level 2
			{ 			
				{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_1_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				{ name="logic/missions/survival/swamp/attack_level_2_id_2_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				--{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
				--{ name="logic/missions/survival/swamp/attack_level_2_id_3_swamp_alpha.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0},
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