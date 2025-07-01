return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 0
	rules.eventsPerIdleState = 0
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.spawnAttackEventProbability = 0.2
	rules.spawn2ndAttackEventProbability = 0.2

	rules.gameEvents = 
	{		
	}

	rules.addResourcesOnRunOut = 
	{		
	}

	rules.majorAttackLogic =
	{				
	}

	rules.timeToNextDifficultyLevel = 
	{			
		180, -- difficulty level 1
		180, -- difficulty level 2
		180, -- difficulty level 3
		300, -- difficulty level 4
		900, -- difficulty level 5
		1020, -- difficulty level 6
		1200, -- difficulty level 7
		1500, -- difficulty level 8
		1500, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		120,  -- difficulty level 1
		120,  -- difficulty level 2
		120,  -- difficulty level 3
		120,  -- difficulty level 4	
		120,  -- difficulty level 5	
		120,  -- difficulty level 6	
		120,  -- difficulty level 7
		120,  -- difficulty level 8	
		120,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
   
	}

	rules.objectivesLogic = 
	{	
	}

	rules.cooldownAfterAttacks = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		90,  -- difficulty level 3
		120,  -- difficulty level 4	
		120,  -- difficulty level 5	
		180,  -- difficulty level 6	
		180,  -- difficulty level 7
		240,  -- difficulty level 8	
		240,  -- difficulty level 9	
	}

	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		1200,  -- difficulty level 6	
		1200,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1200,  -- difficulty level 9	
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3		
		0,  -- difficulty level 4
		0,  -- difficulty level 5
		0,  -- difficulty level 6
		0,  -- difficulty level 7
		1,  -- difficulty level 8
		2,  -- difficulty level 9
	}

	rules.prepareAttackDefinitions =
	{		
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 1		
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 3				
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 5					
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 6			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 7			
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 8					
		"logic/dom/attack_level_1_prepare.logic", -- difficulty level 9		
	}

	rules.wavesEntryDefinitions =
	{		 
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 1		 
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 2			
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 3			
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 4				
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 5			
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 6					
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 7				
		"logic/dom/attack_level_1_caverns_entry.logic", -- difficulty level 8					
		"logic/dom/attack_level_2_caverns_entry.logic", -- difficulty level 9
	}

	rules.waves = 
	{
		["default"] =
		{			
			{}, -- difficulty level 1
			{}, -- difficulty level 2
			{}, -- difficulty level 3
			{}, -- difficulty level 4
			{}, -- difficulty level 5			
			{}, -- difficulty level 6		
			{}, -- difficulty level 7
						 
			{ -- difficulty level 8
				"logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
			},
			 
			{ -- difficulty level 9
				"logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_1_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",
				"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
				"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
			},
		},
	}

	rules.extraWaves = 
	{
		{}, -- difficulty level 1
		{}, -- difficulty level 2
		{}, -- difficulty level 3
		{}, -- difficulty level 4
		{}, -- difficulty level 5			
		{}, -- difficulty level 6
		{}, -- difficulty level 7
		
		{ -- difficulty level 8
			"logic/missions/survival/caverns/attack_level_2_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_2_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
		},
		  
		{ -- difficulty level 9
			"logic/missions/survival/caverns/attack_level_3_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_3_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_4_id_3_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_1_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_2_caverns.logic",
			"logic/missions/survival/caverns/attack_level_5_id_3_caverns.logic",
		},	
	}


	rules.bosses = 
	{	
	}

    return rules;
end