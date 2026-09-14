require("lua/missions/v2/rules_gen.lua" )

-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "scout")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	
	rules.waves = {
		["default"]		= Default_UnboxedWaves( rules.params ),
	}
	
	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_deepvein",      runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_deepvein",    runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
	}
	
	return rules
end