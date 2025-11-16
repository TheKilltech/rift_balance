return function(params)
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "outpost", nil, params)

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.eventsPerPrepareStateChance = 25        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.spawnAttackEventProbability = 0.33
	rules.spawn2ndAttackEventProbability = 0.33
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 5                -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.55 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 25        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "new_objective",             type = "POSITIVE", gameStates="IDLE|STREAMING",           minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",        type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3 },
		{ action = "add_resource",              type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 1 },
		{ action = "unlock_research",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 1 },
		{ action = "full_ammo",                 type = "POSITIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "remove_ammo",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 2 },
		{ action = "boss_attack",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",         minEventLevel = 4 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING",    minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|NO_STREAMING", minEventLevel = 3, logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|ATTACK",              minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",                           weight = 1,    bindingParams = { attack_strength = "normal" } },
		{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",                           weight = 0.75, bindingParams = { attack_strength = "hard" } },
		{ action = "shegret_attack_very_hard",  type = "NEGATIVE", gameStates="IDLE",                     minEventLevel = 6, logicFile="logic/event/shegret_attack_hard.logic",                      weight = 0.5,  bindingParams = { attack_strength = "very_hard" } },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE",                     minEventLevel = 5, logicFile="logic/weather/resource_earthquake.logic",                    weight = 1 },
        { action = "spawn_cave_in",             type = "POSITIVE", gameStates="ATTACK|IDLE",              minEventLevel = 5, logicFile="logic/weather/cave_in.logic",                                weight = 1 },
        { action = "spawn_falling_stalactites", type = "NEGATIVE", gameStates="ATTACK|IDLE",              minEventLevel = 4, logicFile="logic/weather/falling_stalactites.logic",                    weight = 1 },
	}
	
	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",          runOutPercentageOnMap = 20, minToSpawn = 20000, maxToSpawn = 40000, chance = 35 },
		{ name = "carbon_vein",          runOutPercentageOnMap = 20, minToSpawn = 30000, maxToSpawn = 60000, chance = 45 },
		{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
		--{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, isInfinite = 1,                         chance = 65, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20 }

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic", minDifficultyLevel = 5 },
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 1 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 2 },  -- difficulty level 4
		{ minCount = 1, maxCount = 2 },  -- difficulty level 5
		{ minCount = 1, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 3 },  -- difficulty level 7
		{ minCount = 2, maxCount = 3 },  -- difficulty level 8
		{ minCount = 2, maxCount = 3 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},                    -- consecutive chances of wave repeating at level 1
		{},                    -- consecutive chances of wave repeating at level 2
		{15},                  -- consecutive chances of wave repeating at level 3
		{50},                  -- consecutive chances of wave repeating at level 4
		{50, 20},              -- consecutive chances of wave repeating at level 5
		{60, 40, 10},          -- consecutive chances of wave repeating at level 6
		{60, 40, 20},          -- consecutive chances of wave repeating at level 7
		{70, 50, 40, 10},      -- consecutive chances of wave repeating at level 8
		{80, 60, 50, 30, 30},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 10
	rules.waveChanceRerollSpawn      = 15
	rules.waveChanceReroll           = 40

	rules.waves            = helper:Default_Waves(     "caverns", "outpost", rules.params.difficulty, nil)
	rules.extraWaves       = helper:Default_ExtraWaves("caverns", "outpost", rules.params.difficulty, nil)
	rules.multiplayerWaves = helper:Default_MpWaves(   "caverns", "outpost", rules.params.difficulty, nil)
	rules.bosses           = helper:Default_Bosses(    "caverns", "outpost", rules.params.difficulty, nil)

	rules.waves = helper:GenerateGrouped({ groups = { "desert" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 2 },   suffixes = { "ultra" },         repeatInterval = 1,   weightDyn = 1.0, },   rules.waves)
	rules.waves = helper:GenerateGrouped({ groups = { "desert" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   suffixes = { "alpha" },         repeatInterval = 1,   weightDyn = 1.0, },   rules.waves)
	rules.waves = helper:GenerateGrouped({ groups = { "desert" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 4 },   suffixes = { "" },              repeatInterval = 1.5, weightDyn = 1.5, },   rules.waves)
	rules.waves = helper:GenerateGrouped({ groups = { "desert" },   difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   suffixes = { "alpha" },         repeatInterval = 1.5, weightDyn = 1.0, },   rules.waves)
	
	if Contains({"hard", "brutal"}, rules.params.difficulty) then
		rules.waves = helper:GenerateGrouped({ groups = { "desert" },  difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   suffixes = { "ultra" },      repeatInterval = 1,    weightDynHd = 1.0, },   rules.waves)
		rules.waves = helper:GenerateGrouped({ groups = { "desert" },  difficulty = {                      8, 9}, biomes = { "group" }, levels = { 4 },   suffixes = { "ultra" },      repeatInterval = 1.5,  weightDynHd = 1.0, },   rules.waves)
		rules.waves = helper:GenerateGrouped({ groups = { "desert" },  difficulty = {                         9}, biomes = { "group" }, levels = { 5 },   suffixes = { "", "alpha" },  repeatInterval = 1.5,  weightDynHd = 1.0, },   rules.waves)
		
	elseif Contains({"brutal"}, rules.params.difficulty) then
		rules.waves = helper:GenerateGrouped({ groups = { "desert" },  difficulty = {                      8, 9}, biomes = { "group" }, levels = { 4 },  suffixes = { "ultra" },       repeatInterval = 1.2,  weightDynBr = 1.5, },   rules.waves)
		rules.waves = helper:GenerateGrouped({ groups = { "desert" },  difficulty = {                         9}, biomes = { "group" }, levels = { 5 },  suffixes = { "", "alpha" },   repeatInterval = 1.4,  weightDynBr = 1.0, },   rules.waves)
	end

    return rules;
end