return function(params)
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_forest_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )	
	
	rules.maxAttackCountPerDifficulty = 
	{			
		2,  -- difficulty level 1
		2,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}

    return rules;
end