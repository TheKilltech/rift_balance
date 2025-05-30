return function()
    local rules = require("lua/missions/campaigns/dlc_3/dom_swamp_freedom_rules_default.lua")()	
		
	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		450, -- difficulty level 2
		450, -- difficulty level 3	
		450, -- difficulty level 4
		600, -- difficulty level 5
		600, -- difficulty level 6
		750, -- difficulty level 7
		900, -- difficulty level 8
		900, -- difficulty level 9
	}	
	
	rules.maxAttackCountPerDifficulty = 
	{			
		2,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}

    return rules;
end