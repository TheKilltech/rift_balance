return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/jungle/dom_jungle_resource_outpost_rules_hard.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 6,                    logicFile="logic/event/shegret_attack_very_hard.logic",   weight = 0.5 },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",    weight = 0.5 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 7,                    logicFile="logic/event/phirian_attack.logic",				weight = 0.5 },
	})
	
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
	
	rules.waveRepeatChances = 
	{
		{},                    -- concecutive chances of wave repeating at level 1
		{20},                  -- concecutive chances of wave repeating at level 2
		{35},                  -- concecutive chances of wave repeating at level 3
		{70, 15},              -- concecutive chances of wave repeating at level 4
		{70, 60, 15},          -- concecutive chances of wave repeating at level 5
		{80, 70, 25},          -- concecutive chances of wave repeating at level 6
		{80, 80, 60, 15},      -- concecutive chances of wave repeating at level 7
		{90, 90, 80, 40},      -- concecutive chances of wave repeating at level 8
		{95, 90, 80, 50, 40},  -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 30
	rules.waveChanceRerollSpawn      = 50
	rules.waveChanceReroll           = 40
	
    return rules;
end