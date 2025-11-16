return function(params)
    local rules  = require("lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,         logicFile="logic/event/shegret_attack.logic",             weight = 1.2,  bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 5,         logicFile="logic/event/shegret_attack_hard.logic",        weight = 0.8,  bindingParams = { attack_strength = "hard" } },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 8,         logicFile="logic/event/kermon_attack.logic",              weight = 1,    bindingParams = { attack_strength = "normal" } },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="ATTACK",           minEventLevel = 6,         logicFile="logic/event/kermon_attack_hard.logic",         weight = 0.75, bindingParams = { attack_strength = "hard" } },
	})
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 35, 60, 20, 60, 25 }
	
	
	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 2, maxCount = 2 },  -- difficulty level 3
		{ minCount = 2, maxCount = 2 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 3 },  -- difficulty level 7
		{ minCount = 3, maxCount = 3 },  -- difficulty level 8
		{ minCount = 3, maxCount = 4 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},                    -- concecutive chances of wave repeating at level 1
		{},                    -- concecutive chances of wave repeating at level 2
		{},                    -- concecutive chances of wave repeating at level 3
		{50, 20},              -- concecutive chances of wave repeating at level 4
		{80, 50, 20},          -- concecutive chances of wave repeating at level 5
		{90, 75, 70},          -- concecutive chances of wave repeating at level 6
		{90, 90, 70, 20},      -- concecutive chances of wave repeating at level 7
		{90, 80, 80, 80},      -- concecutive chances of wave repeating at level 8
		{80, 80, 80, 35, 50 }, -- concecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 20 -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 30 -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 40 -- chance to reroll and replace an attack wave from its original wave pool
			
    return rules;
end