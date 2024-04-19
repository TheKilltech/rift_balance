return function()
    local rules = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_default.lua")()
	
	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		840,  -- difficulty level 6	
		900,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
	}
	
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		900, -- difficulty level 2
		900, -- difficulty level 3	
		900, -- difficulty level 4
		900, -- difficulty level 5
		900, -- difficulty level 6
		900, -- difficulty level 7
		900, -- difficulty level 8
		900, -- difficulty level 9
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		2,  -- difficulty level 5
		2,  -- difficulty level 6
		2,  -- difficulty level 7
		2,  -- difficulty level 8
		3,  -- difficulty level 9
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 1, minLevel = 4, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

    return rules;
end