return function()
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_outpost_rules_default.lua")()
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", "brutal", 1)
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", "brutal", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "outpost", "brutal", 1)
	
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
	
	rules.waveRepeatChances = 
	{
		{},                        -- concecutive chances of wave repeating at level 1
		{20},                      -- concecutive chances of wave repeating at level 2
		{35},                      -- concecutive chances of wave repeating at level 3
		{70, 15},                  -- concecutive chances of wave repeating at level 4
		{70, 60, 15},              -- concecutive chances of wave repeating at level 5
		{80, 70, 30, 15},          -- concecutive chances of wave repeating at level 6
		{80, 80, 60, 15},          -- concecutive chances of wave repeating at level 7
		{90, 90, 80, 30, 10},      -- concecutive chances of wave repeating at level 8
		{95, 90, 80, 50, 40, 10},  -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 60
	rules.waveChanceRerollSpawn      = 25
	rules.waveChanceReroll           = 80
	
	rules.waves            = helper:Default_Waves(     "swamp", "outpost", "brutal")
	rules.extraWaves       = helper:Default_ExtraWaves("swamp", "outpost", "brutal")
	rules.multiplayerWaves = helper:Default_MpWaves(   "swamp", "outpost", "brutal")
	rules.bosses           = {} -- bosses via mp waves
	
    return rules;
end