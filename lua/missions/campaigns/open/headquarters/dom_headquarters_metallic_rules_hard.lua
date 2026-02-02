return function()
    local rules = require("lua/missions/campaigns/open/headquarters/dom_headquarters_metallic_rules_default.lua")()
	
	rules.timeToNextDifficultyLevel = 
	{			
		900, -- difficulty level 1
		1500, -- difficulty level 2
		1500, -- difficulty level 3	
		1500, -- difficulty level 4
		1500, -- difficulty level 5
		1500, -- difficulty level 6
		1500, -- difficulty level 7
		1500, -- difficulty level 8
		1500, -- difficulty level 9
	}
	
	rules.idleTime = 
	{			
		900,  -- difficulty level 1
		900,  -- difficulty level 2
		900,  -- difficulty level 3
		900,  -- difficulty level 4	
		900,  -- difficulty level 5	
		900,  -- difficulty level 6	
		900,  -- difficulty level 7
		900,  -- difficulty level 8	
		900,  -- difficulty level 9	
	}
	
	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		2,  -- difficulty level 3		
		2,  -- difficulty level 4
		3,  -- difficulty level 5
		3,  -- difficulty level 6
		3,  -- difficulty level 7
		3,  -- difficulty level 8
		4,  -- difficulty level 9
	}		
		
	rules.waves = 
	{
		["default"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_metallic_hard.lua"),			
		["acid"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_acid_hard.lua"),		
		["caverns"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_caverns_hard.lua"),	
		["desert"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_desert_hard.lua"),		
		["ice"]			= require("lua/missions/campaigns/open/headquarters/dom_waves_ice_hard.lua"),	
		["jungle"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_jungle_hard.lua"),	
		["magma"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_magma_hard.lua"),		
		["metallic"]	= require("lua/missions/campaigns/open/headquarters/dom_waves_metallic_hard.lua"),
		["swamp"]		= require("lua/missions/campaigns/open/headquarters/dom_waves_swamp_hard.lua"),
	}

    return rules;
end