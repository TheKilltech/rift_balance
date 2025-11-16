return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/headquarters/dom_headquarters_rules_default.lua")(params)
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack.logic",                               weight = 1 },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,                    logicFile="logic/event/shegret_attack_hard.logic",                          weight = 0.75 },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 8,                    logicFile="logic/event/kermon_attack.logic",                                weight = 1 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                           weight = 0.75 },
	})

	rules.idleTime  = helper:RepeatingValueTable( 900, 9)
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 2, maxCount = 2 },  -- difficulty level 3
		{ minCount = 2, maxCount = 2 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 3, maxCount = 3 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 4 },  -- difficulty level 9
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
		{100, 70, 50, 20},      -- consecutive chances of wave repeating at level 8
		{100, 70, 55, 25, 15},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 10
	rules.waveChanceRerollSpawn      = 25
	rules.waveChanceReroll           = 30
	
    return rules;
end