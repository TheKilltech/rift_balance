require("lua/missions/v2/rules_gen.lua" )
require("lua/utils/rules_utils.lua")
require("lua/utils/table_utils.lua")
	
return function(params)
	local rules  = PrepareDefaultRules( {}, params)

	rules.addResourcesOnRunOut = 
	{
		{ name = "uranium_ore_vein",     runOutPercentageOnMap =  5, minToSpawn =  2000, maxToSpawn =  5000, chance = 35 },
		{ name = "uranium_ore_deepvein", runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000,                                                events = { "spawn_resource_earthquake" }},
		{ name = "carbon_vein",          runOutPercentageOnMap =  5, minToSpawn =  2000, maxToSpawn =  5000, chance = 45 },
		{ name = "carbon_deepvein",      runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_deepvein",    runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
		{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, isInfinite = 1,                         chance = 65, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
	}
	
	rules.extraWaves       = Default_ExtraWaves( params )
	rules.multiplayerWaves = Default_MpWaves(    params )
	rules.bosses           = Default_Bosses(     params )
	rules.waves            = Default_Waves(      params )

	--LogService:Log( PrintTable ( rules ))
	
    return rules
end