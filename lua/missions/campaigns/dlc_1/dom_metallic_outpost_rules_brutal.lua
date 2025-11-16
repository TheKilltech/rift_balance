return function(params)
    local rules  = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_hard.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,       logicFile="logic/event/shegret_attack_very_hard.logic",     weight = 0.5, bindingParams = { attack_strength = "very_hard" } },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 8,       logicFile="logic/event/kermon_attack_very_hard.logic",      weight = 0.5, bindingParams = { attack_strength = "very_hard" } },
	})
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 2, maxCount = 2 },  -- difficulty level 3
		{ minCount = 2, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 3, maxCount = 4 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 2, maxCount = 5 },  -- difficulty level 9
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}	
	
	rules.waveRepeatChances = 
	{
		{},                       -- concecutive chances of wave repeating at level 1
		{},                       -- concecutive chances of wave repeating at level 2
		{15},                     -- concecutive chances of wave repeating at level 3
		{50, 20},                 -- concecutive chances of wave repeating at level 4
		{80, 50, 20},             -- concecutive chances of wave repeating at level 5
		{90, 75, 70},             -- concecutive chances of wave repeating at level 6
		{90, 90, 70, 20},         -- concecutive chances of wave repeating at level 7
		{90, 80, 80, 80},         -- concecutive chances of wave repeating at level 8
		{80, 80, 80, 35, 60, 40}, -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 25
	rules.waveChanceRerollSpawn      = 45
	rules.waveChanceReroll           = 40
	
    return rules;
end