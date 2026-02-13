return function()
    local rules = require("lua/missions/campaigns/open/headquarters/dom_headquarters_caverns_rules_default.lua")()	
		
	rules.timeToNextDifficultyLevel = 
	{			
		900, -- difficulty level 1
		1200, -- difficulty level 2
		1200, -- difficulty level 3	
		1200, -- difficulty level 4
		1200, -- difficulty level 5
		1200, -- difficulty level 6
		1200, -- difficulty level 7
		1200, -- difficulty level 8
		1200, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		720,  -- difficulty level 1
		720,  -- difficulty level 2
		720,  -- difficulty level 3
		720,  -- difficulty level 4	
		720,  -- difficulty level 5	
		720,  -- difficulty level 6	
		720,  -- difficulty level 7
		720,  -- difficulty level 8	
		720,  -- difficulty level 9	
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		2,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		3,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		4,  -- difficulty level 8
		4,  -- difficulty level 9
	}	
	
	rules.waves = 
	{
		["default"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_caverns_brutal.lua"),		
	}

    return rules;
end