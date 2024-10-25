return function()
    local rules = require("lua/missions/campaigns/dlc_2/dom_caverns_outpost_rules_default.lua")()	
		
	rules.timeToNextDifficultyLevel = 
	{			
		500, -- difficulty level 1
		550, -- difficulty level 2
		550, -- difficulty level 3	
		750, -- difficulty level 4
		750, -- difficulty level 5
		850, -- difficulty level 6
		850, -- difficulty level 7
		850, -- difficulty level 8
		850, -- difficulty level 9
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		1,  -- difficulty level 3		
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