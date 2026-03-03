rules_gen_lock = {}
waves_gen_lock = waves_gen_lock or require("lua/missions/v2/waves_gen.lua")

function PrepareDefaultRules(rules, params, missionType, difficulty)
	-- missionType: { "hq", "outpost", "resource", "survival", "scout", "exploration","temp" }
	-- difficulty:  { "easy", "default", "hard", "brutal" }
	
	params = params or rules.params or {}
	if not params.rulesPosfix		 then params.rulesPosfix    = difficulty or DifficultyService:GetWaveStrength() end
	if not params.difficulty		 then params.difficulty     = difficulty or DifficultyService:GetCurrentDifficultyName() end
	if not params.threat			 then params.threat         = 8 end
	if not params.missionType		 then params.missionType    = missionType or "exploration" end
	if not params.biome 			 then params.biome          = MissionService:GetCurrentBiomeName() end
	if not params.biomeVisitors1	 then params.biomeVisitors1 = "none" end
	if not params.biomeVisitors2	 then params.biomeVisitors2 = "none" end
	if params.difficulty == "custom" then params.difficulty     = DifficultyService:GetWaveStrength() end
	rules.params = params or {}
	
	local effectiveDiff = GetEffectiveDifficulty( rules.params.difficulty, rules.params.threat )
	local missionType   = rules.params.missionType
	local difficulty    = rules.params.difficulty
	
	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 1
	rules.eventsPerPrepareState = 1
	rules.eventsPerPrepareStateChance = 25        -- chance to spawn events with objectives
	rules.pauseAttacks   = (effectiveDiff == "none")
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 5                -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.55 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 25        -- chance in percent

	rules.gameEvents                = Default_GameEvents(           rules.params )
	rules.objectivesLogic           = Default_ObjectivesLogic(      rules.params )
	rules.addResourcesOnRunOut      = Default_AddResourcesOnRunOut( rules.params )
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 35, 20, 20 }
	
	
	rules.buildingsUpgradeStartsLogic = Default_BuildingsUpgradeStartsLogic(missionType, difficulty )
	rules.majorAttackLogic            = Default_MajorAttackLogic(           missionType, difficulty )
	rules.prepareAttackDefinitions    = Default_PrepareAttackDefinitions(   missionType, difficulty )
	rules.wavesEntryDefinitions       = Default_WavesEntryDefinitions(      missionType, difficulty, biome )
	
	rules.prepareSpawnTime            = Default_PrepareSpawnTime(           missionType, difficulty, 1)
	rules.cooldownAfterAttacks        = Default_CooldownAfterAttacks(       missionType, difficulty, 1)
	rules.idleTime                    = Default_IdleTime(                   missionType, difficulty, 1)
	rules.timeToNextDifficultyLevel   = Default_TimeToNextDifficultyLevel(  missionType, difficulty, 1)

	rules.attackCountPerDifficulty    = Default_AttackCountPerDifficulty(   rules.params)
	rules.waveRepeatChances           = Default_WaveRepeatChances(          rules.params)
	rules                             = Default_WaveChanceReroll( rules,    rules.params )
	
	rules.maxAttackCountPerDifficulty = { } -- outdated by this mod, but _custom map scrips scale this
	
	rules.waves      = {}
	rules.extraWaves = {}
	rules.bosses     = {}
	
	--LogService:Log( PrintTable( rules ))
	
	return rules
end

function PrepareCustomRules(rules, missionTypeOrParam)
	local missionType = missionTypeOrParam or rules.params
	if type (missionTypeOrParam) == "table" then 
		local params = missionTypeOrParam
		missionType  = params.missionType
	end
	
	local attackCountMultiplier			= DifficultyService:GetAttacksCountMultiplier()
	local prepareAttackTimeMultiplier	= DifficultyService:GetPrepareAttackTimeMultiplier()
	local idleTimeMultiplier			= DifficultyService:IdleTimeMultiplier()
	local buildingSpeedMultiplier 		= DifficultyService:GetBuildingSpeedMultiplier()
	local progressionMultiplier 		= math.sqrt(buildingSpeedMultiplier) -- this should be a product of building speed and building cost multipliers. the squareroot is used because the overall gameplay-progress speed depends on more then just those two apsects

	rules.prepareSpawnTime            = ScaleTable(rules.prepareSpawnTime, prepareAttackTimeMultiplier)
	rules.maxAttackCountPerDifficulty = ScaleTable(rules.maxAttackCountPerDifficulty, attackCountMultiplier)
	if rules.attackCountPerDifficulty then
		for i = 1, #rules.attackCountPerDifficulty, 1 do
			local counts = rules.attackCountPerDifficulty[i]
			if counts then
				counts.minCount = counts.minCount * attackCountMultiplier
				counts.maxCount = counts.maxCount * attackCountMultiplier
			end
			rules.attackCountPerDifficulty[i] = counts
		end
	end
	
	for i = 1, #rules.idleTime, 1 do
		rules.idleTime[i] = rules.idleTime[i] * idleTimeMultiplier * (1 + (progressionMultiplier-1)*(9-i)/8.0)
	end
	
	for i = 1, #rules.cooldownAfterAttacks, 1 do
		rules.cooldownAfterAttacks[i] = rules.cooldownAfterAttacks[i] * idleTimeMultiplier * (1 + (progressionMultiplier-1)*(9-i)/8.0)
	end

	for i = 1, #rules.timeToNextDifficultyLevel, 1 do
		rules.timeToNextDifficultyLevel[i] = rules.timeToNextDifficultyLevel[i] * (1 + (progressionMultiplier-1)*(9-i)/8.0)
	end
	return rules
end

function Default_BuildingsUpgradeStartsLogic(missionTypeOrParam, difficulty)
	local missionType = missionTypeOrParam
	if type (missionTypeOrParam) == "table" then 
		local params = missionTypeOrParam
		missionType  = params.missionType
	end
	
	if Contains({"hq"}, missionType) then
		return {
			{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
			{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
			{ name = "headquarters_lvl_4", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
			{ name = "headquarters_lvl_5", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
			{ name = "headquarters_lvl_6", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
			{ name = "headquarters_lvl_7", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		}
	rules.majorAttackLogic = {
		{ minLevel = 5, level = 1, prepareTime = 120, entryLogic = "logic/hq_upgrade/upgrade_entry_lvl1.logic", exitLogic = "logic/hq_upgrade/upgrade_exit_lvl1.logic" },
	}
	else
		return { }
	end
end

function Default_MajorAttackLogic(missionTypeOrParam, difficulty)
	local missionType = missionTypeOrParam
	if type (missionTypeOrParam) == "table" then 
		local params = missionTypeOrParam
		missionType  = params.missionType
	end
	
	if Contains({"outpost"}, missionType) then
		return {
			{ minLevel = 5, level = 1, prepareTime = 120, entryLogic = "logic/hq_upgrade/upgrade_entry_lvl1.logic", exitLogic = "logic/hq_upgrade/upgrade_exit_lvl1.logic" },
		}
	else
		return { }
	end
end

function Default_PrepareAttackDefinitions( missionType, difficulty )
	local defs = {
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
	return defs
end

function Default_WavesEntryDefinitions( missionType, difficulty, biome )
	local defs = {}
	if Contains({"caverns"}, biome) then 
		defs = {
			"logic/missions/survival/caverns/attack_level_1_caverns_entry.logic", -- difficulty level 1
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 2
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 3
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 4
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 5
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 6
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 7
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 8
			"logic/missions/survival/caverns/attack_level_2_caverns_entry.logic", -- difficulty level 9
		}
	else 
		defs = {
			"logic/dom/attack_level_1_entry.logic", -- difficulty level 1
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 2
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 3
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 4
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 5
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 6
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 7
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 8
			"logic/dom/attack_level_2_entry.logic", -- difficulty level 9
		}
	end
	
	return defs
end

function Default_WaveRepeatChances(missionTypeOrParam, difficulty)
	local threat = 8
	local missionType = missionTypeOrParam
	if type (missionTypeOrParam) == "table" then 
		local params = missionTypeOrParam
		threat       = params.threat
		difficulty   = params.difficulty
		missionType  = params.missionType
		biome        = params.biome
	end
	difficulty = GetEffectiveDifficulty( difficulty, threat - 2)
	
	local waveRepeatChances = {}
	if Contains({"hq","outpost","resource","survival"}, missionType) then
		if Contains({"brutal", "extreme"}, difficulty) then
			waveRepeatChances = {
				{10},                   -- consecutive chances of wave repeating at level 1
				{25},                   -- consecutive chances of wave repeating at level 2
				{50, 50},               -- consecutive chances of wave repeating at level 3
				{50, 50},               -- consecutive chances of wave repeating at level 4
				{60, 50},               -- consecutive chances of wave repeating at level 5
				{75, 60, 20},           -- consecutive chances of wave repeating at level 6
				{90, 60, 40},           -- consecutive chances of wave repeating at level 7
				{100, 70, 60, 20},      -- consecutive chances of wave repeating at level 8
				{100, 70, 65, 35, 30},  -- consecutive chances of wave repeating at level 9
			}
		elseif (difficulty == "hard")    then
			waveRepeatChances = {
				{10},                   -- consecutive chances of wave repeating at level 1
				{25},                   -- consecutive chances of wave repeating at level 2
				{35},                   -- consecutive chances of wave repeating at level 3
				{45,  25},              -- consecutive chances of wave repeating at level 4
				{60,  45},              -- consecutive chances of wave repeating at level 5
				{75,  50, 20},          -- consecutive chances of wave repeating at level 6
				{90,  60, 40},          -- consecutive chances of wave repeating at level 7
				{100, 70, 50, 20},      -- consecutive chances of wave repeating at level 8
				{100, 70, 55, 25, 15},  -- consecutive chances of wave repeating at level 9
			}
		elseif (difficulty == "easy")    then 
			waveRepeatChances = {
				{},                 -- consecutive chances of wave repeating at level 1
				{},                 -- consecutive chances of wave repeating at level 2
				{15},               -- consecutive chances of wave repeating at level 3
				{40},               -- consecutive chances of wave repeating at level 4
				{50,  10},          -- consecutive chances of wave repeating at level 5
				{60,  20},          -- consecutive chances of wave repeating at level 6
				{70,  40, 20},      -- consecutive chances of wave repeating at level 7
				{80,  50, 40},      -- consecutive chances of wave repeating at level 8
				{100, 60, 50, 25},  -- consecutive chances of wave repeating at level 9
			}
		elseif (difficulty == "none")    then 
			waveRepeatChances = {
				{},                 -- consecutive chances of wave repeating at level 1
				{},                 -- consecutive chances of wave repeating at level 2
				{},                 -- consecutive chances of wave repeating at level 3
				{20},               -- consecutive chances of wave repeating at level 4
				{40,  10},          -- consecutive chances of wave repeating at level 5
				{50,  20},          -- consecutive chances of wave repeating at level 6
				{60,  30, 15},      -- consecutive chances of wave repeating at level 7
				{80,  40, 30},      -- consecutive chances of wave repeating at level 8
				{100, 50, 30, 15},  -- consecutive chances of wave repeating at level 9
			}
		else  -- including difficulty: normal, default
			waveRepeatChances = {
				{},                 -- consecutive chances of wave repeating at level 1
				{},                 -- consecutive chances of wave repeating at level 2
				{25},               -- consecutive chances of wave repeating at level 3
				{50},               -- consecutive chances of wave repeating at level 4
				{60, 15},           -- consecutive chances of wave repeating at level 5
				{70, 25},           -- consecutive chances of wave repeating at level 6
				{80, 50, 20},       -- consecutive chances of wave repeating at level 7
				{90, 60, 40},       -- consecutive chances of wave repeating at level 8
				{100, 60, 50, 25},  -- consecutive chances of wave repeating at level 9
			}
		end
	else -- including missionType: scout, exploration, temp
		if (difficulty == "brutal")      then
			waveRepeatChances = {
				{},                    -- concecutive chances of wave repeating at level 1
				{},                    -- concecutive chances of wave repeating at level 2
				{},                    -- concecutive chances of wave repeating at level 3
				{10},                  -- concecutive chances of wave repeating at level 4
				{20},                  -- concecutive chances of wave repeating at level 5
				{30},                  -- concecutive chances of wave repeating at level 6
				{60, 20},              -- concecutive chances of wave repeating at level 7
				{70, 50, 15},          -- concecutive chances of wave repeating at level 8
				{80, 30, 80, 50, 20},  -- concecutive chances of wave repeating at level 9
			}
		elseif (difficulty == "hard")    then
			waveRepeatChances = {
				{},                -- concecutive chances of wave repeating at level 1
				{},                -- concecutive chances of wave repeating at level 2
				{},                -- concecutive chances of wave repeating at level 3
				{},                -- concecutive chances of wave repeating at level 4
				{10},              -- concecutive chances of wave repeating at level 5
				{20},              -- concecutive chances of wave repeating at level 6
				{60, 5},           -- concecutive chances of wave repeating at level 7
				{70, 50, 10},      -- concecutive chances of wave repeating at level 8
				{80, 20, 80, 50},  -- concecutive chances of wave repeating at level 9

			}
		else  -- including difficulty: normal, default, easy
			waveRepeatChances = {
				{},                -- concecutive chances of wave repeating at level 1
				{},                -- concecutive chances of wave repeating at level 2
				{},                -- concecutive chances of wave repeating at level 3
				{},                -- concecutive chances of wave repeating at level 4
				{},                -- concecutive chances of wave repeating at level 5
				{10},              -- concecutive chances of wave repeating at level 6
				{30},              -- concecutive chances of wave repeating at level 7
				{40, 50},          -- concecutive chances of wave repeating at level 8
				{60, 40, 20, 35},  -- concecutive chances of wave repeating at level 9
			}
		end
	end
	return waveRepeatChances
end

function Default_AttackCountPerDifficulty(missionTypeOrParam, difficulty)
	local threat = 8
	local missionType  = missionTypeOrParam
	if type (missionTypeOrParam) == "table" then 
		local params = missionTypeOrParam
		threat       = params.threat
		difficulty   = params.difficulty
		missionType  = params.missionType
		biome        = params.biome
	end
	difficulty = GetEffectiveDifficulty( difficulty, threat - 1)
	
	local attackCountPerDifficulty = {}
	if Contains({"hq","outpost","resource","survival"}, missionType) then
		if (difficulty == "brutal" or difficulty == "extreme")  then
			attackCountPerDifficulty =  {
				{ minCount = 1, maxCount = 2 },  -- difficulty level 1
				{ minCount = 1, maxCount = 2 },  -- difficulty level 2
				{ minCount = 2, maxCount = 2 },  -- difficulty level 3
				{ minCount = 2, maxCount = 3 },  -- difficulty level 4
				{ minCount = 2, maxCount = 3 },  -- difficulty level 5
				{ minCount = 2, maxCount = 3 },  -- difficulty level 6
				{ minCount = 3, maxCount = 3 },  -- difficulty level 7
				{ minCount = 3, maxCount = 4 },  -- difficulty level 8
				{ minCount = 3, maxCount = 5 },  -- difficulty level 9
			}
		elseif (difficulty == "hard")    then
			attackCountPerDifficulty = {
				{ minCount = 1, maxCount = 2 },  -- difficulty level 1
				{ minCount = 1, maxCount = 2 },  -- difficulty level 2
				{ minCount = 2, maxCount = 2 },  -- difficulty level 3
				{ minCount = 2, maxCount = 2 },  -- difficulty level 4
				{ minCount = 2, maxCount = 3 },  -- difficulty level 5
				{ minCount = 2, maxCount = 3 },  -- difficulty level 6
				{ minCount = 3, maxCount = 3 },  -- difficulty level 7
				{ minCount = 3, maxCount = 4 },  -- difficulty level 8
				{ minCount = 3, maxCount = 4 },  -- difficulty level 9
			}
		elseif (difficulty == "easy")    then 
			attackCountPerDifficulty =  {
				{ minCount = 1, maxCount = 1 },  -- difficulty level 1
				{ minCount = 1, maxCount = 1 },  -- difficulty level 2
				{ minCount = 1, maxCount = 1 },  -- difficulty level 3
				{ minCount = 1, maxCount = 1 },  -- difficulty level 4
				{ minCount = 1, maxCount = 2 },  -- difficulty level 5
				{ minCount = 1, maxCount = 2 },  -- difficulty level 6
				{ minCount = 2, maxCount = 2 },  -- difficulty level 7
				{ minCount = 2, maxCount = 3 },  -- difficulty level 8
				{ minCount = 2, maxCount = 3 },  -- difficulty level 9
			}
		elseif (difficulty == "none")    then 
			attackCountPerDifficulty =  {
				{ minCount = 1, maxCount = 1 },  -- difficulty level 1
				{ minCount = 1, maxCount = 1 },  -- difficulty level 2
				{ minCount = 1, maxCount = 1 },  -- difficulty level 3
				{ minCount = 1, maxCount = 1 },  -- difficulty level 4
				{ minCount = 1, maxCount = 1 },  -- difficulty level 5
				{ minCount = 1, maxCount = 1 },  -- difficulty level 6
				{ minCount = 1, maxCount = 2 },  -- difficulty level 7
				{ minCount = 1, maxCount = 2 },  -- difficulty level 8
				{ minCount = 2, maxCount = 2 },  -- difficulty level 9
			}
		else -- including difficulty: normal, default
			attackCountPerDifficulty =  {
				{ minCount = 1, maxCount = 1 },  -- difficulty level 1
				{ minCount = 1, maxCount = 1 },  -- difficulty level 2
				{ minCount = 1, maxCount = 2 },  -- difficulty level 3
				{ minCount = 1, maxCount = 2 },  -- difficulty level 4
				{ minCount = 2, maxCount = 2 },  -- difficulty level 5
				{ minCount = 2, maxCount = 3 },  -- difficulty level 6
				{ minCount = 2, maxCount = 3 },  -- difficulty level 7
				{ minCount = 2, maxCount = 3 },  -- difficulty level 8
				{ minCount = 3, maxCount = 4 },  -- difficulty level 9
			}
		end
	else -- including missionType: scout, exploration, temp
		if (difficulty == "brutal")      then
			attackCountPerDifficulty =  {
				{ minCount = 0, maxCount = 0 },  -- difficulty level 1
				{ minCount = 0, maxCount = 0 },  -- difficulty level 2
				{ minCount = 0, maxCount = 0 },  -- difficulty level 3
				{ minCount = 1, maxCount = 1 },  -- difficulty level 4
				{ minCount = 1, maxCount = 1 },  -- difficulty level 5
				{ minCount = 1, maxCount = 2 },  -- difficulty level 6
				{ minCount = 2, maxCount = 2 },  -- difficulty level 7
				{ minCount = 2, maxCount = 3 },  -- difficulty level 8
				{ minCount = 2, maxCount = 4 },  -- difficulty level 9
			}
		elseif (difficulty == "hard")    then
			attackCountPerDifficulty = {
				{ minCount = 0, maxCount = 0 },  -- difficulty level 1
				{ minCount = 0, maxCount = 0 },  -- difficulty level 2
				{ minCount = 0, maxCount = 0 },  -- difficulty level 3
				{ minCount = 0, maxCount = 0 },  -- difficulty level 4
				{ minCount = 1, maxCount = 1 },  -- difficulty level 5
				{ minCount = 1, maxCount = 1 },  -- difficulty level 6
				{ minCount = 1, maxCount = 2 },  -- difficulty level 7
				{ minCount = 2, maxCount = 2 },  -- difficulty level 8
				{ minCount = 2, maxCount = 3 },  -- difficulty level 9
			}
		elseif (difficulty == "easy")    then 
			attackCountPerDifficulty =  {
				{ minCount = 0, maxCount = 0 },  -- difficulty level 1
				{ minCount = 0, maxCount = 0 },  -- difficulty level 2
				{ minCount = 0, maxCount = 0 },  -- difficulty level 3
				{ minCount = 0, maxCount = 0 },  -- difficulty level 4
				{ minCount = 0, maxCount = 0 },  -- difficulty level 5
				{ minCount = 1, maxCount = 1 },  -- difficulty level 6
				{ minCount = 1, maxCount = 1 },  -- difficulty level 7
				{ minCount = 1, maxCount = 1 },  -- difficulty level 8
				{ minCount = 1, maxCount = 1 },  -- difficulty level 9
			}
		else -- including difficulty: normal, default
			attackCountPerDifficulty =  {
				{ minCount = 0, maxCount = 0 },  -- difficulty level 1
				{ minCount = 0, maxCount = 0 },  -- difficulty level 2
				{ minCount = 0, maxCount = 0 },  -- difficulty level 3
				{ minCount = 0, maxCount = 0 },  -- difficulty level 4
				{ minCount = 0, maxCount = 0 },  -- difficulty level 5
				{ minCount = 1, maxCount = 1 },  -- difficulty level 6
				{ minCount = 1, maxCount = 2 },  -- difficulty level 7
				{ minCount = 1, maxCount = 2 },  -- difficulty level 8
				{ minCount = 1, maxCount = 2 },  -- difficulty level 9
			}
		end
	end
	return attackCountPerDifficulty
end

function Default_TimeToNextDifficultyLevel(missionType, difficulty, factor)
	local times = {}
	if (missionType == "survival") then	
		times =  {			
			200, -- difficulty level 1
			600, -- difficulty level 2
			600, -- difficulty level 3	
			660, -- difficulty level 4
			660, -- difficulty level 5
			720, -- difficulty level 6
			720, -- difficulty level 7
			720, -- difficulty level 8
			720, -- difficulty level 9
		}
	elseif Contains({"hq"}, missionType) then
		times = {
			1800, -- difficulty level 1
			1800, -- difficulty level 2
			2400, -- difficulty level 3	
			2400, -- difficulty level 4
			2400, -- difficulty level 5
			2400, -- difficulty level 6
			3600, -- difficulty level 7
			3600, -- difficulty level 8
			3600, -- difficulty level 9
		}
	elseif Contains({"outpost","resource"}, missionType) then
		times = {			
			600, -- difficulty level 1
			780, -- difficulty level 2
			900, -- difficulty level 3	
			1020, -- difficulty level 4
			1200, -- difficulty level 5
			1500, -- difficulty level 6
			1800, -- difficulty level 7
			2400, -- difficulty level 8
			3600, -- difficulty level 9
		}
	elseif Contains({"scout","exploration","temp"}, missionType) then
		times = {
			1200, -- difficulty level 1
			1200, -- difficulty level 2
			1800, -- difficulty level 3	
			2400, -- difficulty level 4
			2400, -- difficulty level 5
			3600, -- difficulty level 6
			3600, -- difficulty level 7
			5200, -- difficulty level 8
			7200, -- difficulty level 9
		}
	else 
		times = {			
			180,  -- difficulty level 1
			180,  -- difficulty level 2
			180,  -- difficulty level 3
			300,  -- difficulty level 4
			900,  -- difficulty level 5
			1020, -- difficulty level 6
			1200, -- difficulty level 7
			1500, -- difficulty level 8
			1800, -- difficulty level 9
		}
	end
	if factor == nil then factor = 1 end
	if (difficulty == "brutal")      then factor = factor * 0.9
	elseif (difficulty == "hard")    then factor = factor * 0.95
	elseif (difficulty == "default") then factor = factor * 1.00
	elseif (difficulty == "easy")    then factor = factor * 1.1
	end
	
	times = ScaleTable(times, factor)
	return times
end

function Default_PrepareSpawnTime(missionType, difficulty, factor)
	local times = {}
	if (missionType == "survival") then									times = RepeatingValueTable(120, 9)
	elseif Contains({"scout","exploration","temp"}, missionType) then	times = RepeatingValueTable(60, 9)
	elseif Contains({"outpost","resource","hq"}, missionType) then
		times =  {
			 60, -- difficulty level 1
			 72, -- difficulty level 2
			 84, -- difficulty level 3
			 96, -- difficulty level 4
			108, -- difficulty level 5
			114, -- difficulty level 6
			120, -- difficulty level 7
			120, -- difficulty level 8
			120, -- difficulty level 9
		}
	else times = RepeatingValueTable(60, 9)
	end
	
	if factor == nil then factor = 1 end
	if (not missionType == "survival") then	
		if (difficulty == "brutal")      then factor = factor * 0.75
		elseif (difficulty == "hard")    then factor = factor * 0.85
		elseif (difficulty == "default") then factor = factor * 1.00
		elseif (difficulty == "easy")    then factor = factor * 1.00
		end
	end
	
	times = ScaleTable(times, factor)
	return times
end

function Default_CooldownAfterAttacks(missionType, difficulty, factor)
	local times = {}
	if (missionType == "hq") then
		times = RepeatingValueTable(180, 9)
		times[3] = 120
		times[4] = 120
		times[8] = 240
		times[9] = 240
	else 
		times = RepeatingValueTable(120, 9)
	end 
	times[1] = 60
	times[2] = 90
	
	if factor == nil then factor = 1 end
	
	times = ScaleTable(times, factor)
	return times
end

function Default_IdleTime(missionType, difficulty, factor)
	local times = {}
	if (missionType == "survival") then	
		times = RepeatingValueTable(0, 9)
	elseif Contains({"outpost","resource"}, missionType) then
		times = {
			 450,  -- difficulty level 1
			 600,  -- difficulty level 2
			 660,  -- difficulty level 3
			 660,  -- difficulty level 4
			 900,  -- difficulty level 5
			 900,  -- difficulty level 6
			 900,  -- difficulty level 7
			1200,  -- difficulty level 8
			1200,  -- difficulty level 9
		}
	elseif Contains({"scout","exploration","temp"}, missionType) then
		times  = RepeatingValueTable(1200, 9)
	else times = RepeatingValueTable(1200, 9)
	end
	
	if factor == nil then factor = 1 end
	if (difficulty == "brutal")      then factor = factor * 0.9
	elseif (difficulty == "hard")    then factor = factor * 0.95
	elseif (difficulty == "default") then factor = factor * 1.00
	elseif (difficulty == "easy")    then factor = factor * 1.2
	end
	
	times = ScaleTable(times, factor)
	return times
end

function Default_GameEvents(missionTypeOrParam, difficulty, threat, biome, part)
	local missionType  = missionTypeOrParam
	local biomeVisit1  = "none"
	local biomeVisit2  = "none"
	part = part or "full"
	if type (missionTypeOrParam) == "table" then 
		local params = missionTypeOrParam
		threat       = params.threat
		difficulty   = params.difficulty
		missionType  = params.missionType
		biome        = params.biome
		biomeVisit1  = params.biomeVisitors1
		biomeVisit2  = params.biomeVisitors2
	end
	
	LogService:Log("Default_GameEvents (missionType '"..tostring(missionType).. "' difficulty '"..tostring(difficulty).."' threat '"..tostring(threat)..  "' biome '"..tostring(biome).. "' part '"..tostring(part).. "')")
	local gameEvents = {}
	
	if part == "full" then
		Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, biome, "general"))
		Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, biome, "attacks"))
		Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, biome, "biome"))
		if ((biomeVisit1 or "none") ~= "none") and biome ~= "caverns" then
			Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, biomeVisit1, "biome_core"))
		end
		
	elseif part == "general" then
		return {
			{ action = "new_objective",             type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
			{ action = "change_time_of_day",        type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
			{ action = "add_resource",              type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
			{ action = "remove_resource",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
			{ action = "cancel_the_attack",         type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1 },
			{ action = "unlock_research",           type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1 },
			{ action = "full_ammo",                 type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
			{ action = "remove_ammo",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },	

			{ action = "stronger_attack",           type = "NEGATIVE", gameStates="ATTACK",                minEventLevel = 1, amount = 2 },
			{ action = "boss_attack",               type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 4 },
		}
		
	elseif part == "attacks" then
		local weights = {
			acid     = { shegret = 1.5, kermon = 0.7, phirian = 0.7 },
			desert   = { shegret = 1.0, kermon = 0.2, phirian = 0.5 },
			caverns  = { shegret = 2.0, kermon = 0,   phirian = 0   },
			ice      = { shegret = 0.5, kermon = 3.0, phirian = 0.2 },
			jungle   = { shegret = 1.0, kermon = 1.5, phirian = 1.0 },
			magma    = { shegret = 0.2, kermon = 1.0, phirian = 0.7 },
			metallic = { shegret = 0.5, kermon = 1.0, phirian = 0.5 },
			swamp    = { shegret = 0.5, kermon = 1.0, phirian = 1.5 },
		}
		
		if Contains({"normal", "default"}, difficulty) then
			return {
				{ action = "shegret_attack",            type = "NEGATIVE", gameStates="ATTACK",        minEventLevel = 8, logicFile="logic/event/shegret_attack.logic",              weight = weights[biome].shegret * 1 },
				{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 6, logicFile="logic/event/shegret_attack.logic",              weight = weights[biome].shegret * 1 },
				{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 7, logicFile="logic/event/shegret_attack_hard.logic",         weight = weights[biome].shegret * 0.75 },
				{ action = "kermon_attack",             type = "NEGATIVE", gameStates="ATTACK",        minEventLevel = 9, logicFile="logic/event/kermon_attack.logic",               weight = weights[biome].kermon  * 1 },
				{ action = "kermon_attack",             type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 7, logicFile="logic/event/kermon_attack.logic",               weight = weights[biome].kermon  * 1 },
				{ action = "kermon_attack_hard",        type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 8, logicFile="logic/event/kermon_attack_hard.logic",          weight = weights[biome].kermon  * 0.75 },
				{ action = "phirian_attack",            type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 5, logicFile="logic/event/phirian_attack.logic",              weight = weights[biome].phirian * 0.5 },
				{ action = "phirian_attack_hard",       type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 5, logicFile="logic/event/phirian_attack_hard.logic",         weight = weights[biome].phirian * 0.25 },
			}
		elseif difficulty == "hard" then
			return {
				{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",              weight = weights[biome].shegret * 1 },
				{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 6, logicFile="logic/event/shegret_attack_hard.logic",         weight = weights[biome].shegret * 0.75 },
				{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="ATTACK",        minEventLevel = 8, logicFile="logic/event/shegret_attack_hard.logic",         weight = weights[biome].shegret * 0.75 },
				{ action = "shegret_attack_very_hard",  type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 7, logicFile="logic/event/shegret_attack_very_hard.logic",    weight = weights[biome].shegret * 0.5 },
				{ action = "kermon_attack",             type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 6, logicFile="logic/event/kermon_attack.logic",               weight = weights[biome].kermon  * 1 },
				{ action = "kermon_attack_hard",        type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 7, logicFile="logic/event/kermon_attack_hard.logic",          weight = weights[biome].kermon  * 0.75 },
				{ action = "kermon_attack_hard",        type = "NEGATIVE", gameStates="ATTACK",        minEventLevel = 9, logicFile="logic/event/kermon_attack_hard.logic",          weight = weights[biome].kermon  * 0.75 },
				{ action = "kermon_attack_very_hard",   type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 8, logicFile="logic/event/kermon_attack_very_hard.logic",     weight = weights[biome].kermon  * 0.5 },
				{ action = "phirian_attack",            type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 4, logicFile="logic/event/phirian_attack.logic",              weight = weights[biome].phirian * 0.5 },
				{ action = "phirian_attack_hard",       type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 5, logicFile="logic/event/phirian_attack_hard.logic",         weight = weights[biome].phirian * 0.5 },
			}
		elseif Contains({"brutal", "extreme"}, difficulty) then
			return {
				{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",              weight = weights[biome].shegret * 1 },
				{ action = "shegret_attack_hard",       type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 6, logicFile="logic/event/shegret_attack_hard.logic",         weight = weights[biome].shegret * 0.75 },
				{ action = "shegret_attack_very_hard",  type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 7, logicFile="logic/event/shegret_attack_very_hard.logic",    weight = weights[biome].shegret * 0.5 },
				{ action = "shegret_attack_very_hard",  type = "NEGATIVE", gameStates="ATTACK",        minEventLevel = 9, logicFile="logic/event/shegret_attack_very_hard.logic",    weight = weights[biome].shegret * 0.5 },
				{ action = "kermon_attack",             type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 6, logicFile="logic/event/kermon_attack.logic",               weight = weights[biome].kermon  * 1 },
				{ action = "kermon_attack_hard",        type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 7, logicFile="logic/event/kermon_attack_hard.logic",          weight = weights[biome].kermon  * 0.75 },
				{ action = "kermon_attack_very_hard",   type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 7, logicFile="logic/event/kermon_attack_very_hard.logic",     weight = weights[biome].kermon  * 0.5 },
				{ action = "kermon_attack_very_hard",   type = "NEGATIVE", gameStates="ATTACK",        minEventLevel = 9, logicFile="logic/event/kermon_attack_very_hard.logic",     weight = weights[biome].kermon  * 0.5 },
				{ action = "phirian_attack",            type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 3, logicFile="logic/event/phirian_attack.logic",              weight = weights[biome].phirian * 0.5 },
				{ action = "phirian_attack_hard",       type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 5, logicFile="logic/event/phirian_attack_hard.logic",         weight = weights[biome].phirian * 0.5 },
				{ action = "phirian_attack_very_hard",  type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 8, logicFile="logic/event/phirian_attack_very_hard.logic",    weight = weights[biome].phirian * 0.5 },
		}
		else --if difficulty == "easy" then
			return {
				{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",              weight = weights[biome].shegret * 1 },
				{ action = "kermon_attack",             type = "NEGATIVE", gameStates="IDLE|ATTACK",   minEventLevel = 8, logicFile="logic/event/kermon_attack.logic",               weight = weights[biome].kermon  * 1 },
				{ action = "phirian_attack",            type = "NEGATIVE", gameStates="IDLE",          minEventLevel = 9, logicFile="logic/event/phirian_attack.logic",              weight = weights[biome].phirian * 0.5 },
			}
		end
		
	elseif part == "biome_core" then
		if biome == "acid" then
			return {
				{ action = "spawn_acid_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3,                    logicFile="logic/weather/acid_rain.logic",     minTime = 30, maxTime = 60,  weight = 0.5 },
				{ action = "spawn_acid_fissures",            type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/acid_fissures.logic", minTime = 30, maxTime = 60,  weight = 1 },
				{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/meteor_shower.logic", minTime = 40, maxTime = 90,  weight = 0.5 },
				{ action = "spawn_tornado_acid_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_acid_near_player.logic",                   weight = 0.5 },
				{ action = "spawn_tornado_acid_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/tornado_acid_near_base.logic",                     weight = 0.5 },
			}
		elseif biome == "caverns" then
			return {
				{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3,                    logicFile="logic/weather/earthquake.logic", minTime = 60, maxTime = 60, weight = 0.5 },
				{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE",           minEventLevel = 5,                    logicFile="logic/weather/resource_earthquake.logic",                    weight = 1 },
				{ action = "spawn_cave_in",                  type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 5,                    logicFile="logic/weather/cave_in.logic",                                weight = 1 },
				{ action = "spawn_crystal_growth",           type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/crystal_growth.logic",                         weight = 1  },
				{ action = "spawn_falling_stalactites",      type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/falling_stalactites.logic",                    weight = 1 },
			}
		elseif biome == "desert" then
			return {
				{ action = "spawn_solar_burn",               type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/solar_burn.logic",          minTime = 20, maxTime = 45,   weight = 4,    weather = "SUN"  },
				{ action = "spawn_dust_storm",               type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/dust_storm.logic",          minTime = 60, maxTime = 120,  weight = 2,    weather = "WIND" },
				{ action = "spawn_wind_strong",              type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/wind_strong.logic",         minTime = 60, maxTime = 120,  weight = 0.5,  weather = "WIND" },
			}
		elseif biome == "ice" then
			return {
				{ action = "spawn_heavy_snow",               type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/heavy_snow.logic",        minTime = 60, maxTime = 120, weight = 1 },
				{ action = "spawn_blizzard",                 type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/blizzard.logic",          minTime = 60, maxTime = 120, weight = 1 },
				{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/meteor_shower.logic",     minTime = 40, maxTime = 90,  weight = 0.5 },
				{ action = "spawn_ice_meteor_shower",        type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3,                    logicFile="logic/weather/ice_meteor_shower.logic", minTime = 30, maxTime = 60,  weight = 1 },
				{ action = "spawn_ice_rock_rain",            type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/ice_rock_rain.logic",     minTime = 30, maxTime = 60,  weight = 1 },
				{ action = "spawn_ice_falling_rocks",        type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 5,                    logicFile="logic/weather/ice_falling_rocks.logic", minTime = 30, maxTime = 60,  weight = 1 },
				{ action = "spawn_tornado_ice_near_player",  type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_ice_near_player.logic",                        weight = 1 },
				{ action = "spawn_tornado_ice_near_base",    type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/tornado_ice_near_base.logic",                          weight = 1 },
			}
		elseif biome == "jungle" then
			return {
				{ action = "spawn_blue_hail",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",              minTime = 30, maxTime = 60,  weight = 0.2 },
				{ action = "spawn_thunderstorm",             type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",           minTime = 60, maxTime = 120 },
				{ action = "spawn_fog",                      type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/fog.logic",                    minTime = 60, maxTime = 120 },
				{ action = "spawn_rain",                     type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/rain.logic",                   minTime = 120, maxTime = 120 },
				{ action = "spawn_wind_strong",              type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",            minTime = 60, maxTime = 120 },
				{ action = "spawn_tornado_near_player",      type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic",                                 weight = 0.35 },
				{ action = "spawn_tornado_near_base",        type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3,                    logicFile="logic/weather/tornado_near_base.logic",                                   weight = 0.35 },
				{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/meteor_shower.logic",          minTime = 30, maxTime = 60,  weight = 0.3 },
				{ action = "spawn_firestorm",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/firestorm.logic",              minTime = 60, maxTime = 120, weight = 0.5 },
				{ action = "spawn_fireflies",                type = "POSITIVE", gameStates="IDLE",           minEventLevel = 1,                    logicFile="logic/weather/fireflies.logic",              minTime = 60, maxTime = 120, weight = 1 },
			}
		elseif biome == "magma" then
			return {
				{ action = "spawn_volcanic_rock_rain",       type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/volcanic_rock_rain.logic",  minTime = 30, maxTime = 60,   weight = 0.5 },
				{ action = "spawn_volcanic_ash_clouds",      type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120,  weight = 1.0 },
				{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_fire_near_player.logic",                          weight = 0.5 },
				{ action = "spawn_tornado_fire_near_base",   type = "NEGATIVE", gameStates="IDLE",           minEventLevel = 4,                    logicFile="logic/weather/tornado_fire_near_base.logic",                            weight = 0.5 },
				{ action = "spawn_firestorm",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/firestorm.logic",           minTime = 60, maxTime = 120,  weight = 1 },
			}
		elseif biome == "metallic" then
			return {
				{ action = "spawn_blue_hail",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",        minTime = 30, maxTime = 60,   weight = 0.25 },
				{ action = "spawn_thunderstorm",             type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",     minTime = 60, maxTime = 120 },
				{ action = "spawn_wind_strong",              type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",      minTime = 60,  maxTime = 120, weight = 1 },
			}
		elseif biome == "swamp" then
			return {
				{ action = "spawn_blue_hail",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",  minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",        minTime = 30,  maxTime = 60,  weight = 0.25 },
				{ action = "spawn_thunderstorm",               type = "NEGATIVE", gameStates="ATTACK|IDLE",  minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",     minTime = 60,  maxTime = 120 },
				{ action = "spawn_fog",                        type = "NEGATIVE", gameStates="IDLE",         minEventLevel = 1,                    logicFile="logic/weather/fog.logic",              minTime = 60,  maxTime = 120, weight = 0.5  },
				{ action = "spawn_rain",                       type = "NEGATIVE", gameStates="ATTACK|IDLE",  minEventLevel = 1,                    logicFile="logic/weather/rain.logic",             minTime = 120, maxTime = 120, weight = 0.5 },
				{ action = "spawn_wind_strong",                type = "POSITIVE", gameStates="ATTACK|IDLE",  minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",      minTime = 60,  maxTime = 120 },
				{ action = "spawn_meteor_shower",              type = "NEGATIVE", gameStates="ATTACK|IDLE",  minEventLevel = 2,                    logicFile="logic/weather/meteor_shower.logic",    minTime = 30,  maxTime = 60,  weight = 0.5 },
				{ action = "spawn_fireflies",                  type = "POSITIVE", gameStates="IDLE",         minEventLevel = 1,                    logicFile="logic/weather/fireflies.logic",        minTime = 60,  maxTime = 120, weight = 4 },
				{ action = "spawn_blooming_air",               type = "POSITIVE", gameStates="IDLE",         minEventLevel = 5,                    logicFile="logic/weather/blooming_air.logic",     minTime = 120, maxTime = 180, weight = 4 },
				{ action = "spawn_monsoon",                    type = "NEGATIVE", gameStates="ATTACK|IDLE",  minEventLevel = 1,                    logicFile="logic/weather/monsoon.logic",          minTime = 60,  maxTime = 120, weight = 2 },
				{ action = "spawn_tornado_acid_near_player",   type = "NEGATIVE", gameStates="ATTACK|IDLE",  minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
				{ action = "spawn_tornado_acid_near_base",     type = "NEGATIVE", gameStates="IDLE",         minEventLevel = 4,                    logicFile="logic/weather/tornado_acid_near_base.logic",                         weight = 0.5 },
				{ action = "spawn_comet_boss_mudroner_acid",   type = "NEGATIVE", gameStates="IDLE",         minEventLevel = 5,                    logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
				{ action = "spawn_comet_boss_mudroner_cryo",   type = "NEGATIVE", gameStates="IDLE",         minEventLevel = 5,                    logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
				{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates="IDLE",         minEventLevel = 5,                    logicFile="logic/event/comet_boss_mudroner_energy.logic"  },
				{ action = "spawn_comet_boss_mudroner_fire",   type = "NEGATIVE", gameStates="IDLE",         minEventLevel = 5,                    logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
			}
		else
			return {
				{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/earthquake.logic",        minTime = 30, maxTime = 60,  weight = 0.5 },
				{ action = "spawn_blood_moon",               type = "NEGATIVE", gameStates="IDLE",           minEventLevel = 4,                    logicFile="logic/weather/blood_moon.logic",        minTime = 60, maxTime = 120, weight = 2 },
				{ action = "spawn_blue_moon",                type = "POSITIVE", gameStates="IDLE",           minEventLevel = 4,                    logicFile="logic/weather/blue_moon.logic",         minTime = 60, maxTime = 120, weight = 0.5 },
				{ action = "spawn_solar_eclipse",            type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 5,                    logicFile="logic/weather/solar_eclipse.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
				{ action = "spawn_super_moon",               type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",        minTime = 60, maxTime = 120, weight = 0.5 },
				{ action = "spawn_wind_weak",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/wind_weak.logic",         minTime = 60, maxTime = 120, weight = 1 },
				{ action = "spawn_wind_none",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/wind_none.logic",         minTime = 30, maxTime = 120, weight = 3 },
				{ action = "spawn_ion_storm",                type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 3,                    logicFile="logic/weather/ion_storm.logic",         minTime = 30, maxTime = 60,  weight = 1 },
				{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE",           minEventLevel = 1,                    logicFile="logic/weather/comet_silent.logic",                                   weight = 2 },
				{ action = "spawn_resource_comet",           type = "POSITIVE", gameStates="IDLE",           minEventLevel = 3,                    logicFile="logic/weather/resource_comet.logic"  },
				{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE",           minEventLevel = 3,                    logicFile="logic/weather/resource_earthquake.logic" },
			}
		end
		
	elseif part == "biome" then
		if biome == "caverns" then
			return Default_GameEvents( missionType, difficulty, threat, "general", "biome_core")
		else
			Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, "general", "biome_core"))
			Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, biome,     "biome_core"))
		end
		
	else
		LogService:Log("Default_GameEvents: invalid parameters")
	end
	
	return gameEvents
end

function Default_ObjectivesLogic(params)
	if params.biome == "acid" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic",                     minDifficultyLevel = 3 },
			{ name = "logic/objectives/destroy_nest_granan_single.logic",       minDifficultyLevel = 4 },
			{ name = "logic/objectives/destroy_nest_granan_multiple.logic",     minDifficultyLevel = 6 },
			{ name = "logic/objectives/destroy_creeper.logic",                  minDifficultyLevel = 3 },
		}
	elseif params.biome == "caverns" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 5 },
		}
	elseif params.biome == "desert" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 3 },
			{ name = "logic/objectives/destroy_nest_mushbit_single.logic",      minDifficultyLevel = 3, maxDifficultyLevel = 8 },
			{ name = "logic/objectives/destroy_nest_mushbit_multiple.logic",    minDifficultyLevel = 6 },
		}
	elseif params.biome == "ice" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 4 },
			{ name = "logic/objectives/destroy_nest_granan_ice_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
			{ name = "logic/objectives/destroy_nest_granan_ice_multiple.logic", minDifficultyLevel = 6 },
		}
	elseif params.biome == "jungle" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 5 },
			{ name = "logic/objectives/destroy_nest_canoptrix_single.logic",    minDifficultyLevel = 3, maxDifficultyLevel = 8 },
			{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic",  minDifficultyLevel = 5 },
			{ name = "logic/objectives/destroy_creeper.logic",                  minDifficultyLevel = 8 }, 
			{ name = "logic/objectives/destroy_fire_gnerot.logic",              minDifficultyLevel = 7 },
		}
	elseif params.biome == "magma" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 3 },
			{ name = "logic/objectives/destroy_nest_morirot_single.logic",      minDifficultyLevel = 3, maxDifficultyLevel = 8 }, 
			{ name = "logic/objectives/destroy_nest_morirot_multiple.logic",    minDifficultyLevel = 6 },
			{ name = "logic/objectives/destroy_fire_gnerot.logic",              minDifficultyLevel = 7 },
		}
	elseif params.biome == "metallic" then
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 3 },
			{ name = "logic/objectives/destroy_nest_wingmite_single.logic",     minDifficultyLevel = 4 }, 
			{ name = "logic/objectives/destroy_nest_wingmite_multiple.logic",   minDifficultyLevel = 6 },
			{ name = "logic/objectives/destroy_nest_bradron_single.logic",      minDifficultyLevel = 4 }, 
			{ name = "logic/objectives/destroy_nest_bradron_multiple.logic",    minDifficultyLevel = 6 },
			{ name = "logic/objectives/destroy_nest_octabit_single.logic",      minDifficultyLevel = 5 }, 
			{ name = "logic/objectives/destroy_nest_octabit_multiple.logic",    minDifficultyLevel = 7 },
			{ name = "logic/objectives/destroy_nest_flurian_single.logic",      minDifficultyLevel = 6 }, 
			{ name = "logic/objectives/destroy_nest_flurian_multiple.logic",    minDifficultyLevel = 8 },
		}
	elseif params.biome == "swamp" then
		return {
			{ name = "logic/objectives/kill_elite_baxmoth.logic",               minDifficultyLevel = 3 },
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 6 },
			{ name = "logic/objectives/destroy_nest_stickrid_single.logic",     minDifficultyLevel = 3 }, 
			{ name = "logic/objectives/destroy_nest_stickrid_multiple.logic",   minDifficultyLevel = 5 },
			{ name = "logic/objectives/destroy_nest_plutrodon_single.logic",    minDifficultyLevel = 4 }, 
			{ name = "logic/objectives/destroy_nest_plutrodon_multiple.logic",  minDifficultyLevel = 6 },
			{ name = "logic/objectives/destroy_nest_fungor_single.logic",       minDifficultyLevel = 5 }, 
			{ name = "logic/objectives/destroy_nest_fungor_multiple.logic",     minDifficultyLevel = 7 },
		}
	else
		return {
			{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 3 },
		}
	end
end
	
function Default_AddResourcesOnRunOut(params)
	if params.biome == "acid" then
		return {
			{ name = "palladium_vein",       runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 3000,  maxToSpawn = 5000,  chance = 50 },
			{ name = "palladium_deepvein",   runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 40000, maxToSpawn = 80000,                                                events = { "spawn_resource_earthquake" } },
			{ name = "uranium_ore_vein",     runOutPercentageOnMap =  5, minEventLevel = 4, minToSpawn = 1000,  maxToSpawn = 2000,  chance = 5,  eventGroup = "uranium_completed"  },
			{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, minEventLevel = 4, isInfinite = 1,                         chance = 25, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" },      blueprint = "weather/alien_comet_flying"  },
			{ name = "magma_deepvein",       runOutPercentageOnMap = 10, minEventLevel = 4, isInfinite = 1,                         chance = 15, eventGroup = "titanium_unlocked", events = { "spawn_resource_earthquake" }  },
		}
	elseif params.biome == "caverns" then
		return {
			{ name = "cobalt_vein",          runOutPercentageOnMap = 20, minEventLevel = 4, minToSpawn = 20000, maxToSpawn = 40000, chance = 35 },
			{ name = "carbon_vein",          runOutPercentageOnMap = 20, minEventLevel = 4, minToSpawn = 30000, maxToSpawn = 60000, chance = 45 },
			{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
			--{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, minEventLevel = 4, isInfinite = 1,                         chance = 65, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
		}
	elseif params.biome == "desert" then
		return {
			{ name = "uranium_ore_vein",     runOutPercentageOnMap =  5, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  5000, chance = 35 },
			{ name = "uranium_ore_deepvein", runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 20000, maxToSpawn = 90000,                                                events = { "spawn_resource_earthquake" }},
			{ name = "carbon_vein",          runOutPercentageOnMap =  5, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  5000, chance = 45 },
			{ name = "carbon_deepvein",      runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
			{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
			{ name = "ammonium_deepvein",    runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
			{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, minEventLevel = 4, isInfinite = 1,                         chance = 65, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
		}
	elseif params.biome == "ice" then
		return {
			{ name = "palladium_vein",       runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 3000,  maxToSpawn = 5000, chance = 50 },
			{ name = "palladium_deepvein",   runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 40000, maxToSpawn = 80000,                                                events = { "spawn_resource_earthquake" } },
			{ name = "titanium_vein",        runOutPercentageOnMap =  5, minEventLevel = 4, minToSpawn = 1000,  maxToSpawn = 2000, chance = 5,   eventGroup = "titanium_completed"  },
			{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, minEventLevel = 4, isInfinite = 1,                        chance = 25,  eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" },      blueprint = "weather/alien_comet_flying"  },
		}
	elseif params.biome == "jungle" then
		return {
			{ name = "cobalt_vein",          runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  4000, chance = 75,                                   events = { "spawn_resource_comet" }, },
			{ name = "cobalt_deepvein",      runOutPercentageOnMap = 30, minEventLevel = 7, minToSpawn = 30000, maxToSpawn = 80000,                                                events = { "spawn_resource_earthquake" }, },
			{ name = "cobalt_vein",          runOutPercentageOnMap = 10, minEventLevel = 5, minToSpawn =  3000, maxToSpawn =  5000, chance =  5 },
			{ name = "iron_vein",            runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  3000, maxToSpawn =  5000, chance = 15 },
			{ name = "iron_deepvein",        runOutPercentageOnMap = 20, minEventLevel = 5, minToSpawn = 30000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }, },
			{ name = "petroleum_deepvein",   runOutPercentageOnMap = 10, minEventLevel = 6, isInfinite = 1,                         chance = 10, eventGroup = "uranium_unlocked",  events = { "spawn_resource_earthquake" }, },
		}
	elseif params.biome == "magma" then
		return {
			{ name = "titanium_vein",        runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  4000, chance = 75 },
			{ name = "titanium_deepvein",    runOutPercentageOnMap = 30, minEventLevel = 7, minToSpawn = 30000, maxToSpawn = 80000,                                                events = { "spawn_resource_earthquake" }, },
			{ name = "cobalt_vein",          runOutPercentageOnMap = 10, minEventLevel = 5, minToSpawn =  3000, maxToSpawn =  5000, chance =  5 },
			{ name = "iron_vein",            runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  3000, maxToSpawn =  5000, chance = 15 },
			{ name = "iron_deepvein",        runOutPercentageOnMap = 20, minEventLevel = 5, minToSpawn = 30000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }, },
			{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, minEventLevel = 8, isInfinite = 1,                         chance = 25, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" },   blueprint = "weather/alien_comet_flying"  },
		}
	elseif params.biome == "metallic" then
		return {
			{ name = "cobalt_vein",          runOutPercentageOnMap = 10, minEventLevel = 5, minToSpawn =  3000, maxToSpawn =  5000, chance =  5 },
			{ name = "cobalt_vein",          runOutPercentageOnMap = 10, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  4000, chance = 75,                                   events = { "spawn_resource_comet" }, },
			{ name = "cobalt_deepvein",      runOutPercentageOnMap = 10, minEventLevel = 7, minToSpawn = 30000, maxToSpawn = 80000,                                                events = { "spawn_resource_earthquake" }, },
			{ name = "iron_vein",            runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  3000, maxToSpawn =  5000, chance = 15 },
			{ name = "iron_deepvein",        runOutPercentageOnMap = 20, minEventLevel = 5, minToSpawn = 30000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }, },
			{ name = "titanium_deepvein",    runOutPercentageOnMap = 20, minEventLevel = 6, minToSpawn = 30000, maxToSpawn = 90000, chance = 25, eventGroup = "titanium_unlocked", events = { "spawn_resource_earthquake" }, },
			{ name = "titanium_deepvein",    runOutPercentageOnMap = 20, minEventLevel = 6, isInfinite = 1,                         chance =  5, eventGroup = "titanium_unlocked", events = { "spawn_resource_earthquake" }, },
		}
	elseif params.biome == "swamp" then
		return {
			{ name = "cobalt_vein",          runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 10000, maxToSpawn = 20000, chance = 30 },
			{ name = "palladium_vein",       runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  1000, maxToSpawn =  5000, chance = 15, eventGroup = "palladium_completed" },
			{ name = "titanium_vein",        runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  1000, maxToSpawn =  5000, chance = 15, eventGroup = "titanium_completed" },
		}
	else
		return {
			{ name = "carbon_vein",          runOutPercentageOnMap =  5, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  5000, chance = 45 },
			{ name = "carbon_deepvein",      runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
			{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
			{ name = "ammonium_deepvein",    runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
			{ name = "iron_vein",            runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  3000, maxToSpawn =  5000, chance = 15 },
			{ name = "iron_deepvein",        runOutPercentageOnMap = 20, minEventLevel = 5, minToSpawn = 30000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }, },
		}
	end
end

function Default_WaveChanceReroll(rules, params)
	local chances = {
		acid     = { waveChanceReroll = 40, waveChanceRerollSpawn = 10, waveChanceRerollSpawnGroup =  5 },
		caverns  = { waveChanceReroll = 40, waveChanceRerollSpawn = 20, waveChanceRerollSpawnGroup =  0 },
		desert   = { waveChanceReroll = 30, waveChanceRerollSpawn = 25, waveChanceRerollSpawnGroup = 20 },
		ice      = { waveChanceReroll = 30, waveChanceRerollSpawn = 20, waveChanceRerollSpawnGroup = 10 },
		jungle   = { waveChanceReroll = 40, waveChanceRerollSpawn = 25, waveChanceRerollSpawnGroup = 10 },
		magma    = { waveChanceReroll = 30, waveChanceRerollSpawn = 15, waveChanceRerollSpawnGroup =  0 },
		metallic = { waveChanceReroll = 30, waveChanceRerollSpawn = 15, waveChanceRerollSpawnGroup =  0 },
		swamp    = { waveChanceReroll = 30, waveChanceRerollSpawn = 15, waveChanceRerollSpawnGroup =  0 },
		general  = { waveChanceReroll = 30, waveChanceRerollSpawn = 20, waveChanceRerollSpawnGroup =  0 },
	}

	rules.waveChanceRerollSpawnGroup = chances[params.biome].waveChanceRerollSpawnGroup -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = chances[params.biome].waveChanceRerollSpawn      -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = chances[params.biome].waveChanceReroll           -- chance to reroll and replace an attack wave from its original wave pool
	return rules
end
