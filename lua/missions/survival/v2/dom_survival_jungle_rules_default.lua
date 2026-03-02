require("lua/missions/v2/rules_gen.lua" )
require("lua/utils/rules_utils.lua")
require("lua/utils/table_utils.lua")
	
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "survival")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	rules.waves            = Default_Waves(      rules.params )

	rules.gameEvents = Concat( rules.gameEvents,  {
		{ action = "spawn_tornado_fire_near_base",     type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,                    logicFile="logic/weather/tornado_fire_near_base.logic",                              weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base",     type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,                    logicFile="logic/weather/tornado_acid_near_base.logic",                              weight = 0.5 },
		{ action = "spawn_comet_boss_mudroner_acid",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		{ action = "spawn_comet_boss_mudroner_cryo",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_energy.logic" },
		{ action = "spawn_comet_boss_mudroner_fire",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
	})

	rules.creatureDifficultyIncrementPerDOMDifficulty =
	{
		[1] =
		{	
			0,	 -- initial difficulty
			0, -- difficulty level 2
			0, -- difficulty level 3	
			0, -- difficulty level 4
			0, -- difficulty level 5
			0.5, -- difficulty level 6
			0.5, -- difficulty level 7
			0.5, -- difficulty level 8
			1.5, -- difficulty level 9
		},
		[2] =
		{	
			0, -- initial difficulty
			2, -- difficulty level 2
			0, -- difficulty level 3	
			1, -- difficulty level 4
			0, -- difficulty level 5
			1, -- difficulty level 6
			0, -- difficulty level 7
			1, -- difficulty level 8
			0, -- difficulty level 9
		},
		[3] =
		{	
			2,	 -- initial difficulty
			0, -- difficulty level 2
			1, -- difficulty level 3	
			0, -- difficulty level 4
			1, -- difficulty level 5
			0, -- difficulty level 6
			1, -- difficulty level 7
			0, -- difficulty level 8
			1, -- difficulty level 9
		},
		[4] =
		{	
			2,	 -- initial difficulty
			1, -- difficulty level 2
			0, -- difficulty level 3	
			1, -- difficulty level 4
			0, -- difficulty level 5
			1, -- difficulty level 6
			0, -- difficulty level 7
			1, -- difficulty level 8
			1, -- difficulty level 9
		},
	}
	
	LogService:Log( PrintTable ( rules ))
	
    return rules
end