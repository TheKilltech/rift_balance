return function()
    local rules = require("lua/missions/campaigns/story/v2/desert/dom_desert_resource_outpost_rules_default.lua")()
	
	rules.spawnCooldownEventChance = -- events spawn chance during/after attack (cooldown). values should be descending
	{
		40,  -- 1st event probability in percent
		20,  -- 2nd event probability in percent
		10,  -- 3rd event probability in percent
	}
	
	rules.idleTime = 
	{			
		 450,  -- difficulty level 1
		 600,  -- difficulty level 2
		 660,  -- difficulty level 3
		 660,  -- difficulty level 4	
		 900,  -- difficulty level 5	
		 900,  -- difficulty level 6	
		 900,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1200,  -- difficulty level 9	
	}

	rules.timeToNextDifficultyLevel = 
	{			
		600, -- difficulty level 1
		780, -- difficulty level 2
		900, -- difficulty level 3	
		1020, -- difficulty level 4
		1200, -- difficulty level 5
		1500, -- difficulty level 6
		1800, -- difficulty level 7
		2400, -- difficulty level 8
		3600, -- difficulty level 9
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
	
	rules.waveRepeatChances = 
	{
		{},                    -- concecutive chances of wave repeating at level 1
		{},                    -- concecutive chances of wave repeating at level 2
		{},                    -- concecutive chances of wave repeating at level 3
		{60},                  -- concecutive chances of wave repeating at level 4
		{60, 50},              -- concecutive chances of wave repeating at level 5
		{70, 60, 30},          -- concecutive chances of wave repeating at level 6
		{70, 70, 60},          -- concecutive chances of wave repeating at level 7
		{80, 70, 70, 30},      -- concecutive chances of wave repeating at level 8
		{90, 80, 80, 40, 40, 10},  -- concecutive chances of wave repeating at level 9
	}
	
	rules.waves = 
	{
		["default"] =
		{
			{  -- difficulty level 1
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_1_id_2_desert.logic",
			},
			{ -- difficulty level 2			
				"logic/missions/survival/attack_level_2_id_1_desert.logic",
				"logic/missions/survival/attack_level_2_id_2_desert.logic",
			},
			{  -- difficulty level 3
				"logic/missions/survival/attack_level_3_id_1_desert.logic",
				"logic/missions/survival/attack_level_3_id_1_desert.logic",
				"logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_desert.logic",
				"logic/missions/survival/attack_level_3_id_2_desert.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",
			},
			{  -- difficulty level 4			
				"logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
			},
			{  -- difficulty level 5
				"logic/missions/survival/attack_level_3_id_1_desert.logic",
				"logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_desert.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",
			},
			{  -- difficulty level 6
				"logic/missions/survival/attack_level_2_id_1_desert_ultra.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",
			},
			{  -- difficulty level 7
				"logic/missions/survival/attack_level_2_id_1_desert_ultra.logic",
				"logic/missions/survival/attack_level_2_id_2_desert_ultra.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",
			},
			{  -- difficulty level 8
				"logic/missions/survival/attack_level_2_id_1_desert_ultra.logic",
				"logic/missions/survival/attack_level_2_id_2_desert_ultra.logic",
				"logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",
			},
			{  -- difficulty level 9
				"logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_1_desert_ultra.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_3_id_2_desert_ultra.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_1_desert_ultra.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_4_id_2_desert_alpha.logic",
				"logic/missions/survival/attack_level_5_id_1_desert.logic",
				"logic/missions/survival/attack_level_5_id_1_desert.logic",
				"logic/missions/survival/attack_level_5_id_2_desert.logic",
				"logic/missions/survival/attack_level_5_id_2_desert_alpha.logic",
			},
		},
		["caverns"] =
		{
			{}, -- difficulty level 1
			{}, -- difficulty level 2
			{}, -- difficulty level 3
			{}, -- difficulty level 4
			{}, -- difficulty level 5
			{}, -- difficulty level 6
			{}, -- difficulty level 7
			{}, -- difficulty level 8
			{  -- difficulty level 9
				"logic/missions/survival/caverns/attack_level_3_id_1_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_3_id_2_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_3_id_3_caverns_alpha.logic",
				"logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",
			},
		},
	}

    return rules;
end