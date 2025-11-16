return function(params)
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_outpost_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
		
	Concat( rules.gameEvents, {
		{ action = "phirian_attack",                   type = "NEGATIVE", gameStates="ATTACK",                  minEventLevel = 3, logicFile="logic/event/phirian_attack.logic",                                weight = 1 },
		{ action = "phirian_attack_hard",              type = "NEGATIVE", gameStates="ATTACK",                  minEventLevel = 5, logicFile="logic/event/phirian_attack_hard.logic",                           weight = 3 },
	})

	rules.spawnCooldownEventChance = { 35, 60, 20 }
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 2, maxCount = 3 },  -- difficulty level 1
		{ minCount = 2, maxCount = 3 },  -- difficulty level 2
		{ minCount = 2, maxCount = 3 },  -- difficulty level 3
		{ minCount = 2, maxCount = 3 },  -- difficulty level 4
		{ minCount = 3, maxCount = 4 },  -- difficulty level 5
		{ minCount = 3, maxCount = 4 },  -- difficulty level 6
		{ minCount = 3, maxCount = 4 },  -- difficulty level 7
		{ minCount = 3, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 5 },  -- difficulty level 9
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
	
	rules.waveChanceRerollSpawnGroup = 60
	rules.waveChanceRerollSpawn      = 25
	rules.waveChanceReroll           = 80
	
    return rules;
end