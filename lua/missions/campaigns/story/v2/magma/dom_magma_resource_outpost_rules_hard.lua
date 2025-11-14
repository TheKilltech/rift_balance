return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/magma/dom_magma_resource_outpost_rules_default.lua")(params)
	local helper = require( "lua/missions/v2/waves_gen.lua" )

	Concat( rules.gameEvents, {
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack_hard.logic",                          weight = 0.75 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                           weight = 0.75 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                               weight = 0.3 },
	})

	-- rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", rules.params.difficulty, 1)
	-- rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", rules.params.difficulty, 1)
	-- rules.idleTime                  = helper:Default_IdleTime(                  "outpost", rules.params.difficulty, 1)
	
	rules.spawnCooldownEventChance = { 35, 60, 20 }
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 3 },  -- difficulty level 7
		{ minCount = 2, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 4 },  -- difficulty level 9
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
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
	
	rules.waveChanceRerollSpawnGroup = 25
	rules.waveChanceRerollSpawn      = 45
	rules.waveChanceReroll           = 40
	
    return rules;
end