return function()
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_outpost_rules_hard.lua")()
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "brutal", 1.2)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "brutal", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "brutal", 1.1)
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 2, maxCount = 3 },  -- difficulty level 1
		{ minCount = 2, maxCount = 3 },  -- difficulty level 2
		{ minCount = 2, maxCount = 4 },  -- difficulty level 3
		{ minCount = 2, maxCount = 4 },  -- difficulty level 4
		{ minCount = 3, maxCount = 4 },  -- difficulty level 5
		{ minCount = 3, maxCount = 5 },  -- difficulty level 6
		{ minCount = 3, maxCount = 5 },  -- difficulty level 7
		{ minCount = 4, maxCount = 5 },  -- difficulty level 8
		{ minCount = 4, maxCount = 6 },  -- difficulty level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 15
	rules.waveChanceRerollSpawn      = 30
	rules.waveChanceReroll           = 40
	
	rules.waves = {}
	rules.waves = helper:Default_Waves("swamp", "outpost", "brutal", rules.waves)
	
    return rules;
end