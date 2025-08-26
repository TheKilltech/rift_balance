return function()
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_forest_rules_default.lua")()
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "hard", 1.2)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "hard", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "hard", 1)
	
	rules.spawnCooldownEventChance = { 20, 5 }
	
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
		{ minCount = 4, maxCount = 5 },  -- difficulty level 9
	}	
	
	rules.waveRepeatChances = 
	{
		{10},                   -- consecutive chances of wave repeating at level 1
		{25},                   -- consecutive chances of wave repeating at level 2
		{35},                   -- consecutive chances of wave repeating at level 3
		{45,  25},              -- consecutive chances of wave repeating at level 4
		{60,  45},              -- consecutive chances of wave repeating at level 5
		{75,  50, 20},          -- consecutive chances of wave repeating at level 6
		{90,  60, 40},          -- consecutive chances of wave repeating at level 7
		{100, 80, 50, 20},      -- consecutive chances of wave repeating at level 8
		{100, 80, 55, 25, 45},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 10
	rules.waveChanceRerollSpawn      = 30
	rules.waveChanceReroll           = 40
	
	rules.waves = {}
	rules.waves = helper:Default_Waves("swamp", "outpost", "hard", rules.waves)
	
    return rules;
end