return function()
    local rules = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_default.lua")()	
		
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		450, -- difficulty level 2
		450, -- difficulty level 3	
		450, -- difficulty level 4
		600, -- difficulty level 5
		600, -- difficulty level 6
		600, -- difficulty level 7
		600, -- difficulty level 8
		600, -- difficulty level 9
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
		{ level = 1, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

    return rules;
end