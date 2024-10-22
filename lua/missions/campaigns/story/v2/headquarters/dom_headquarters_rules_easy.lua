return function()
    local rules = require("lua/missions/campaigns/story/v2/headquarters/dom_headquarters_rules_default.lua")()
	
	rules.idleTime = 
	{			
		1200,  -- difficulty level 1
		1200,  -- difficulty level 2
		1200,  -- difficulty level 3
		1200,  -- difficulty level 4	
		900,  -- difficulty level 5	
		900,  -- difficulty level 6	
		900,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
	}
	
	rules.timeToNextDifficultyLevel = 
	{			
		1200, -- difficulty level 1
		1800, -- difficulty level 2
		1800, -- difficulty level 3	
		2400, -- difficulty level 4
		2400, -- difficulty level 5
		2400, -- difficulty level 6
		2400, -- difficulty level 7
		2400, -- difficulty level 8
		2400, -- difficulty level 9
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		1,  -- difficulty level 3		
		1,  -- difficulty level 4
		1,  -- difficulty level 5
		2,  -- difficulty level 6
		2,  -- difficulty level 7
		2,  -- difficulty level 8
		2,  -- difficulty level 9
	}

    return rules;
end