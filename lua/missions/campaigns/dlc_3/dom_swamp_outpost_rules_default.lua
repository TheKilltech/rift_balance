require("lua/missions/v2/rules_gen.lua" )

-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "outpost")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	
	rules.waves = {
		["default"]		= Default_UnboxedWaves( rules.params ),
	}
	
	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",    runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000, chance = 30 },
		{ name = "palladium_vein", runOutPercentageOnMap = 30, minToSpawn =  1000, maxToSpawn =  5000, chance = 15, eventGroup = "palladium_completed" },
		{ name = "titanium_vein",  runOutPercentageOnMap = 30, minToSpawn =  1000, maxToSpawn =  5000, chance = 15, eventGroup = "titanium_completed" }
	}
	
	return rules
end
