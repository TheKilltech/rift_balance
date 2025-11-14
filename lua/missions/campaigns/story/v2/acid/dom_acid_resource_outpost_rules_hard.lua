return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack.logic",                               weight = 1 },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack_hard.logic",                          weight = 0.75 },
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,                    logicFile="logic/event/shegret_attack_very_hard.logic",                     weight = 0.5 },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack.logic",                                weight = 1 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                           weight = 0.75 },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",                      weight = 0.5 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                               weight = 0.3 },
	})

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20, 50, 25 }
	
	-- rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "outpost", rules.params.difficulty, 1)
	-- rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "outpost", rules.params.difficulty, 1)
	-- rules.idleTime                  = helper:Default_IdleTime(                  "outpost", rules.params.difficulty, 1)

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic",                   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_granan_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_granan_multiple.logic", minDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_creeper.logic",              minDifficultyLevel = 4 } 
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 4 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{30 },                -- concecutive chances of attack wave repeating at level 1
		{35, 5},              -- concecutive chances of attack wave repeating at level 2
		{40, 15},             -- concecutive chances of attack wave repeating at level 3
		{45, 25},             -- concecutive chances of attack wave repeating at level 4
		{50, 35, 20},         -- concecutive chances of attack wave repeating at level 5
		{60, 45, 35},         -- concecutive chances of attack wave repeating at level 6
		{70, 60, 45, 15},     -- concecutive chances of attack wave repeating at level 7
		{80, 70, 65, 25},     -- concecutive chances of attack wave repeating at level 8
		{90, 80, 70, 35, 90}, -- concecutive chances of attack wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 15  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 30  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 40  -- chance to reroll and replace an attack wave from its original wave pool
	
    return rules;
end