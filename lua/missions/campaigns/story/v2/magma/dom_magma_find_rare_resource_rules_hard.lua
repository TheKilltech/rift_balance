return function()
    local rules = require("lua/missions/campaigns/story/v2/magma/dom_magma_find_rare_resource_rules_default.lua")()
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "scout", "hard", 1)
	rules.cooldownAfterAttacks      = helper:Default_CooldownAfterAttacks(      "scout", "hard", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "scout", "hard", 1)
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "scout", "hard", 1)
	
	rules.attackCountPerDifficulty = 
	{
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 1 },  -- difficulty level 2
		{ minCount = 1, maxCount = 1 },  -- difficulty level 3
		{ minCount = 1, maxCount = 1 },  -- difficulty level 4
		{ minCount = 1, maxCount = 1 },  -- difficulty level 5
		{ minCount = 1, maxCount = 2 },  -- difficulty level 6
		{ minCount = 1, maxCount = 2 },  -- difficulty level 7
		{ minCount = 2, maxCount = 3 },  -- difficulty level 8
		{ minCount = 2, maxCount = 3 },  -- difficulty level 9
	}
	
	rules.waves = {}
	rules.waves = helper:Default_Waves("magma", "scout", "hard", rules.waves)

	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {                9}, biomes = { "group" },   levels = { 1, 2 },  suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {                9}, biomes = { "group" },   levels = { 2, 3 },  suffixes = { "", "" },          },   rules.waves)
	
    return rules;
end