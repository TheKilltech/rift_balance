return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.pauseAttacks = false
	rules.prepareAttacks = true

	rules.gameEvents = 
	{
		{ action = "spawn_earthquake",    type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/earthquake.logic",    minTime = 30, maxTime = 60 },
		{ action = "spawn_earthquake",    type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/earthquake.logic",    minTime = 30, maxTime = 60 },
		{ action = "spawn_solar_burn",    type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/solar_burn.logic",    minTime = 15, maxTime = 30, weight = 4 },
		{ action = "spawn_solar_burn",    type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/solar_burn.logic",    minTime = 15, maxTime = 30, weight = 4 },
		{ action = "spawn_blood_moon",    type = "NEGATIVE", gameStates="IDLE|STREAMING",        minEventLevel = 4, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blood_moon",    type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/blood_moon.logic",    minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",     type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 4, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",     type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/blue_moon.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_solar_eclipse", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 5, logicFile="logic/weather/solar_eclipse.logic", minTime = 60, maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon",    type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120 },
		{ action = "spawn_super_moon",    type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/super_moon.logic",    minTime = 60, maxTime = 120 },
		{ action = "spawn_dust_storm",    type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/dust_storm.logic",    minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_dust_storm",    type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/dust_storm.logic",    minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_ion_storm",     type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60 },
		{ action = "spawn_ion_storm",     type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30, maxTime = 60 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_meteor_shower", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30, maxTime = 60, weight = 0.5 },
		{ action = "spawn_comet_silent",  type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/comet_silent.logic",  weight = 2 }
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_player.logic" },
		--{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_player.logic" },
		--{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_base.logic" },
		--{ action = "spawn_tornado_near_base", type = "NEGATIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/tornado_near_base.logic" },
		--{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/resource_comet.logic"  },
		--{ action = "spawn_resource_comet", type = "POSITIVE", gameStates = "IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/resource_comet.logic"  },
		--{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/resource_earthquake.logic" },
		--{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/resource_earthquake.logic" },
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
	}

	rules.addResourcesOnRunOut = 
	{

	}

	rules.timeToNextDifficultyLevel = 
	{			
		200, -- difficulty level 1
		200, -- difficulty level 2
		200, -- difficulty level 3	
		600, -- difficulty level 4
		1200, -- difficulty level 5
		1200, -- difficulty level 6
		1500, -- difficulty level 7
		1500, -- difficulty level 8
		1500, -- difficulty level 9
	}

	rules.prepareSpawnTime = 
	{			
		60,  -- difficulty level 1
		60,  -- difficulty level 2
		60,  -- difficulty level 3
		60,  -- difficulty level 4	
		60,  -- difficulty level 5	
		60,  -- difficulty level 6	
		60,  -- difficulty level 7
		60,  -- difficulty level 8	
		60,  -- difficulty level 9	
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
  
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/destroy_nest_mushbit_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_mushbit_single.logic",   minDifficultyLevel = 3 }
	}

	rules.cooldownAfterAttacks = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3
		0,  -- difficulty level 4	
		0,  -- difficulty level 5	
		0,  -- difficulty level 6	
		0,  -- difficulty level 7
		0,  -- difficulty level 8	
		0,  -- difficulty level 9	
	}

	rules.idleTime = 
	{			
		450,  -- difficulty level 1
		600,  -- difficulty level 2
		660,  -- difficulty level 3
		720,  -- difficulty level 4	
		780,  -- difficulty level 5	
		1200,  -- difficulty level 6	
		1200,  -- difficulty level 7
		1200,  -- difficulty level 8	
		1200,  -- difficulty level 9	
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3		
		0,  -- difficulty level 4
		0,  -- difficulty level 5
		0,  -- difficulty level 6
		1,  -- difficulty level 7
		2,  -- difficulty level 8
		3,  -- difficulty level 9
	}
	
	rules.prepareAttackDefinitions =
	{		
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 1		
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 2			
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 3				
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 4				
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 5					
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 6			
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 7			
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 8					
			"logic/dom/attack_level_1_prepare.logic", -- difficulty level 9		
	}

	rules.wavesEntryDefinitions =
	{		 
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 1		 
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 2			
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 3			
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 4				
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 5			
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 6					
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 7				
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 8					
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 9
	}
	
	rules.waves = 
	{
		["default"] =
		{	
			{}, -- difficulty level 1
			{}, -- difficulty level 2
			{}, -- difficulty level 3
			{}, -- difficulty level 4
			{}, -- difficulty level 5			
			{}, -- difficulty level 6
			
			{ -- difficulty level 7
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_1_id_2_desert.logic",
			},

			{ -- difficulty level 8 
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_1_id_2_desert.logic",
				"logic/missions/survival/attack_level_2_id_1_desert.logic",
			},

			{ -- difficulty level 9 
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_1_id_2_desert.logic",
				"logic/missions/survival/attack_level_1_id_1_desert.logic",
				"logic/missions/survival/attack_level_2_id_2_desert.logic",
				"logic/missions/survival/attack_level_5_id_2_desert_alpha.logic",
			},
		},
	}
	
	rules.extraWaves = 
	{
	
	}

	rules.bosses = 
	{

	}

    return rules;
end