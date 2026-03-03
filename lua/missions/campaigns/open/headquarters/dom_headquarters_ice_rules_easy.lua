return function()
    local rules = require("lua/missions/campaigns/open/headquarters/dom_headquarters_ice_rules_default.lua")()
	
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
	
	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic", minDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_granan_ice_single.logic", minDifficultyLevel = 4, maxDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_granan_ice_multiple.logic", minDifficultyLevel = 6 },		
		{ name = "logic/objectives/destroy_nest_kermon_ice_single.logic", minDifficultyLevel = 5, maxDifficultyLevel = 7 }, 
		{ name = "logic/objectives/destroy_nest_kermon_ice_multiple.logic", minDifficultyLevel = 7 },		
		{ name = "logic/objectives/destroy_nest_plutrodon_ice_single.logic", minDifficultyLevel = 6, maxDifficultyLevel = 8 }, 
		{ name = "logic/objectives/destroy_nest_plutrodon_ice_multiple.logic", minDifficultyLevel = 8 },		
	}

    return rules;
end