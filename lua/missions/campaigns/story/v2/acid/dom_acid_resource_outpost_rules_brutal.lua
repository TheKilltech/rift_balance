return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_hard.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,                    logicFile="logic/event/shegret_attack_very_hard.logic",                     weight = 0.5 },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",                      weight = 0.5 },
	})
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 7, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 2, maxCount = 2 },  -- difficulty level 3
		{ minCount = 2, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 3, maxCount = 3 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 20
	rules.waveChanceRerollSpawn      = 40
	rules.waveChanceReroll           = 40
	
    return rules;
end