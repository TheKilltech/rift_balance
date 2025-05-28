return function()
    local rules = require("lua/missions/campaigns/story/v2/desert/dom_desert_find_rare_resource_rules_hard.lua")()
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	rules.prepareSpawnTime          = helper:Default_PrepareSpawnTime(          "scout", "brutal", 1)
	rules.cooldownAfterAttacks      = helper:Default_CooldownAfterAttacks(      "scout", "brutal", 1)
	rules.idleTime                  = helper:Default_IdleTime(                  "scout", "brutal", 1)
	rules.timeToNextDifficultyLevel = helper:Default_TimeToNextDifficultyLevel( "scout", "brutal", 1)
	
	rules.waves = {}
	rules.waves = helper:Default_Waves("desert", "scout", "brutal", rules.waves)
	
	rules.waves = helper:Generate({ groups = { "caverns" },   difficulty = {            8, 9}, biomes = { "group" },   levels = { 1, 2 },  suffixes = { "", "alpha", "ultra" }, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "caverns" },   difficulty = {               9}, biomes = { "group" },   levels = { 2, 3 },  suffixes = { "", "alpha" },          },   rules.waves)
	
    return rules;
end