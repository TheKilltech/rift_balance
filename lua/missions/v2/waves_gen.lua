require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")


function GetEmptyWaves( isMultiplayer )
	if isMultiplayer then
		return {
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
			{ waves = {}, additionalWaves = -1 },
		}
	end
	return {{}, {}, {}, {}, {}, {}, {}, {}, {}}
end

function GenerateGroupedWaves( wavesSetting, waves )
	if wavesSetting.groups == nil       then wavesSetting.groups = { "default" } end
	if wavesSetting.biomes == nil       then wavesSetting.biomes = { "" } end
	
	local idxReplaceGroup = IndexOf( wavesSetting.biomes, "group")
	
	for group in Iter( wavesSetting.groups ) do	
		if idxReplaceGroup then wavesSetting.biomes[idxReplaceGroup] = group end
		
		if waves[group] == nil then waves[group] = GetEmptyWaves( wavesSetting.mpAdditionalWaves~=nil ) end
		waves[group] = GenerateWavesBlock(wavesSetting, waves[group], true)
	end
	if idxReplaceGroup then wavesSetting.biomes[idxReplaceGroup] = "group" end
	return waves
end

function GenerateWavesBlock( wavesSetting, waves, ignoreGroup )
	-- e.g. make  { name="logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",   spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0}, 
	
	if waves == nil                     then waves = {} end
	if wavesSetting.biomes == nil       then wavesSetting.biomes = { "" } end
	if wavesSetting.suffixes == nil     then wavesSetting.suffixes = { "" } end
	if wavesSetting.weight == nil       then wavesSetting.weight = 1 end
	if wavesSetting.diffSettings == nil then wavesSetting.diffSettings = {{}, {}, {}, {}, {}, {}, {}, {}, {}} end
	
	if (wavesSetting.groups ~= nil) and wavesSetting.groups[1] ~= "" and (not ignoreGroup) then -- this is just temporary for compatiblity until the splitting Generate and GenerateGrouped is not cleaned up
		return GenerateGroupedWaves( wavesSetting, waves )
	end
	
	function getWeight( tdiff, level, suffix, elmCount, wavesSetting, logicFile ) -- option to calculate wave weight adjusted to parameters
		local dfactorWave = 1.0
		if suffix == ""          then dfactorWave = 0.8
		elseif suffix == "alpha" then dfactorWave = 1.0
		elseif suffix == "ultra" then dfactorWave = 1.5
		elseif suffix == "omega" then dfactorWave = 1.5
		end
		
		local weightDynamic = wavesSetting.weightDyn or wavesSetting.weightDynHd or wavesSetting.weightDynBr
		if weightDynamic then
			local dfactorTarget = 1.0
			if wavesSetting.weightDynHd     then dfactorTarget = 1.2
			elseif wavesSetting.weightDynBr then dfactorTarget = 1.5
			end
		
			local waveDiff   = math.pow(level * dfactorWave, 2.1) * (1-(wavesSetting.spawnDelay or 0)/9) / (wavesSetting.repeatInterval or 1) -- magic formula how i feel difficulty scales
			local targetDiff = tdiff * dfactorTarget
			
			local weight = 1.0
			if waveDiff < targetDiff then
				weight =  math.floor( weightDynamic/elmCount * waveDiff / targetDiff * 1000 ) / 1000
			else weight =  math.floor( weightDynamic/elmCount * targetDiff / waveDiff  * 1000 ) / 1000 
			end
			
			-- LogService:Log("auto-weight:" .. string.format("%6.3f", weight) .. " d-wave:" ..string.format("%6.3f", waveDiff) .. " d-target:" .. string.format("%6.3f", targetDiff) .. " ".. logicFile)
			return weight
		else 
			return (wavesSetting.weight or 1) / elmCount
		end
	end
	
	function createWaveData( tdiff, level, suffix, elmCount, wavesSetting, logicFile ) -- setup of wave attack metadata to use for the spawn system in dom_manager
		local repeatInterval = wavesSetting.repeatInterval
		if not repeatInterval and wavesSetting.maxRepeats then repeatInterval = 5 / ((wavesSetting.maxRepeats or 1)+0.1)
		elseif suffix == "omega" then repeatInterval = 5 
		else repeatInterval = 1
		end
		return { 
			name              = logicFile,                                                                            -- logic file to execute doing the mobs spawning
			spawn_type        = wavesSetting.spawn_type        or wavesSetting.diffSettings[tdiff].spawn_type,        -- vanilla wave setting
			spawn_type_value  = wavesSetting.spawn_type_value  or wavesSetting.diffSettings[tdiff].spawn_type_value,  -- vanilla wave setting
			target_type       = wavesSetting.target_type       or wavesSetting.diffSettings[tdiff].target_type,       -- vanilla wave setting
			target_type_value = wavesSetting.target_type_value or wavesSetting.diffSettings[tdiff].target_type_value, -- vanilla wave setting
			target_min_radius = wavesSetting.target_min_radius or wavesSetting.diffSettings[tdiff].target_min_radius, -- vanilla wave setting
			target_max_radius = wavesSetting.target_max_radius or wavesSetting.diffSettings[tdiff].target_max_radius, -- vanilla wave setting
			spawnDelay        = wavesSetting.spawnDelay        or 0,                                                  -- repeat count at which the wave is spawned first
			repeatInterval    = repeatInterval,                                                                       -- count interval at which wave is spawned during repeats.maxRepeats is for downwards compatibility, now replaced by repeatInterval
			weight            = getWeight( tdiff, level, suffix, elmCount, wavesSetting, logicFile),                  -- weight for the random roll that picks out random waves from the pool
		}
	end
		
	local subwaves
	for d in Iter( wavesSetting.difficulty ) do
		subwaves = waves[d]
		if subwaves == nil then subwaves = {} end
		if subwaves.additionalWaves then subwaves = subwaves.waves end
		
		local bosses  = wavesSetting.bosses
		local ids     = wavesSetting.ids
		if bosses ~= nil then
			if ids == nil then ids = {} end -- do not generate waves in boss part unless explicity requested
			
			for boss in Iter( bosses ) do
				local logic = GetBossLogic( boss )
				local wave  = createWaveData(d, d, "omega", 1, wavesSetting, logic)
				table.insert( subwaves, wave )
			end	
		end
		
		for biome in Iter( wavesSetting.biomes ) do
			local levels = wavesSetting.levels
			if levels == nil  then levels = { d } end
			for level in Iter( levels ) do
				if ids == nil then ids = GetBiomeWaveIds(biome, level) end
				for id in Iter( ids ) do 
					for suffix in Iter( wavesSetting.suffixes ) do
						local logic = GetWaveLogic(level, id, biome, suffix)
						local wave  = createWaveData(d, level, suffix, #ids, wavesSetting, logic)
						table.insert( subwaves, wave )
					end
				end	
			end
		end
		
		if wavesSetting.mpAdditionalWaves then -- structure for multiplayer waves
			waves[d] = {
				additionalWaves = wavesSetting.mpAdditionalWaves,
				waves           = subwaves
			}
		else waves[d] = subwaves
		end
	end
	
	return waves
end

function GetBiomeWaveIds(biome, level) 
	if (biome == "desert" or biome == "acid" or biome == "magma") then
		return { 1, 2 }
		
	elseif (biome == "" or biome == "jungle") then
		if (level <= 3) then     return { 1, 2 }
		elseif (level <= 5) then return { 1, 2, 3, 4 }
		else                     return { 1, 2, 3, 4, 5 }
		end
	
	elseif (biome == "swamp") then
		if (level <= 5) then return { 1, 2, 3 }
		else                 return { 1, 2, 3, 4 }
		end
	
	elseif (biome == "metallic") then
		if (level <= 2) then return { 1, 2 }
		else                 return { 1, 2, 3 }
		end
	
	elseif (biome == "caverns") then
		if (level <= 3) then return { 1, 2 }
		else                 return { 1, 2, 3 }
		end
		
	elseif (biome == "ice") then
		return { 1, 2, 3 }
		
	end
	
	return {1, 2}
end

function GetBossLogic( boss )
	-- e.g. make  "logic/missions/survival/attack_boss_baxmoth.logic"
	-- e.g. make  "logic/missions/campaigns/story/headquarters_boss_attack.logic"
	
	local waveFile = ""
	if Contains({"hq","hq_boss"}, boss) then
		waveFile = "logic/missions/campaigns/story/headquarters_boss_attack.logic"
	else
		waveFile = "logic/missions/survival/attack_boss_" .. boss .. ".logic"
	end
	return waveFile
end

function GetWaveLogic( level, id, biome, suffix )
	-- e.g. make  "logic/missions/survival/attack_level_3_id_1_desert_alpha.logic"
	-- e.g. make  "logic/missions/survival/swamp/attack_level_3_id_3_swamp.logic"
	
	if biome == "jungle" then biome = "" end
	local oldbiomes = {"", "acid", "magma", "desert" }
	local waveFile = "logic/missions/survival/"
	if Contains(oldbiomes, biome) then
		waveFile = waveFile .. "attack"
	else waveFile = waveFile .. biome .. "/attack"
	end
	if level ~= nil and level ~= 0 then
		if type(level) == "string"     then waveFile = waveFile .. "_" .. level
		elseif type(level) == "number" then waveFile = waveFile .. "_level_" .. tostring(level)
		end
	end 
	if id ~= nil     and id ~= 0      then waveFile = waveFile .. "_id_" .. tostring(id) end
	if biome ~= nil  and biome ~= ""  then waveFile = waveFile .. "_" .. biome  end
	if suffix ~= nil and suffix ~= "" then waveFile = waveFile .. "_" .. suffix end
	waveFile = waveFile .. ".logic"
	return waveFile
end


function PrepareDefaultRules(rules, missionType, difficulty, params)
	-- missionType: { "hq", "outpost", "resource", "survival", "scout", "exploration","temp" }
	-- difficulty:  { "easy", "default", "hard", "brutal" }
	
	local biome = "unknown"
	if type( missionType ) == "table" then
		biome		= missionType.biome or MissionService:GetCurrentBiomeName()
		missionType	= missionType.missionType or "temp"
	end
	
	rules.params = params or {}
	if not rules.params.rulesPosfix		then rules.params.rulesPosfix = difficulty or DifficultyService:GetWaveStrength() end
	if not rules.params.difficulty		then rules.params.difficulty  = difficulty or DifficultyService:GetCurrentDifficultyName() end
	if not rules.params.threat			then rules.params.threat      = 8 end
	if not rules.params.missionType		then rules.params.missionType = missionType or "temp" end
	if not rules.params.biome 			then rules.params.biome       = MissionService:GetCurrentBiomeName() end
	if rules.params.difficulty == "custom"	then rules.params.difficulty  = DifficultyService:GetWaveStrength() end
	
	local effectiveDiff = GetEffectiveDifficulty( rules.params.difficulty, rules.params.threat )
	
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

	rules.gameEvents = Default_GameEvents( rules.params )
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 35, 20, 20 }
	
	missionType = rules.params.missionType
	difficulty  = rules.params.difficulty
	
	rules.prepareAttackDefinitions  = Default_PrepareAttackDefinitions(   missionType, difficulty )
	rules.wavesEntryDefinitions     = Default_WavesEntryDefinitions(      missionType, difficulty, biome )
	
	rules.prepareSpawnTime          = Default_PrepareSpawnTime(          missionType, difficulty, 1)
	rules.cooldownAfterAttacks      = Default_CooldownAfterAttacks(      missionType, difficulty, 1)
	rules.idleTime                  = Default_IdleTime(                  missionType, difficulty, 1)
	rules.timeToNextDifficultyLevel = Default_TimeToNextDifficultyLevel( missionType, difficulty, 1)

	rules.attackCountPerDifficulty  = Default_AttackCountPerDifficulty(  rules.params)
	rules.waveRepeatChances         = Default_WaveRepeatChances(         rules.params)
	
	rules.waveChanceRerollSpawnGroup =  0  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 15  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 30  -- chance to reroll and replace an attack wave from its original wave pool
	
	rules.addResourcesOnRunOut = { }
	rules.buildingsUpgradeStartsLogic = { }
	rules.maxAttackCountPerDifficulty = { } -- outdated by this mod, but _custom map scrips scale this
	
	rules.waves      = {}
	rules.extraWaves = {}
	rules.bosses     = {}
	
	rules.majorAttackLogic = {
		{ level = 1, minLevel = 5, prepareTime = 120, entryLogic = "logic/hq_upgrade/upgrade_entry_lvl1.logic", exitLogic = "logic/hq_upgrade/upgrade_exit_lvl1.logic" },
	}
	
	--LogService:Log( PrintTable( rules ))
	
	return rules
end

function PrepareCustomRules(rules, missionType)
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

function DefaultWaveDiffSettings( biome, missionType)
	local diffSettings = {{}, {}, {}, {}, {}, {}, {}, {}, {}}
	if (biome == "swamp" or biome == "caverns") then
		diffSettings[1] = { spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0 }
		diffSettings[2] = { spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=384.0 }
		diffSettings[3] = { spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=420.0 }
		diffSettings[4] = { spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=500.0 }
		diffSettings[5] = { spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=600.0 }
		diffSettings[6] = { spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=700.0 }
	end
	return diffSettings
end

function Default_Waves(biomeOrParam, missionType, difficulty,  waves)
	local threat = 8
	local biomeVisitors1 = "none"
	local biomeVisitors2 = "none"
	local biome = biomeOrParam
	if type (biomeOrParam) == "table" then 
		local params   = biomeOrParam
		threat         = params.threat
		difficulty     = params.difficulty
		missionType    = params.missionType
		biome          = params.biome
		biomeVisitors1 = params.biomeVisitors1
		biomeVisitors2 = params.biomeVisitors2
	end
	
	if not waves then waves = {["default"] = GetEmptyWaves( false )} end
	
	local mainWaves = Default_UnboxedWaves(biome, missionType, difficulty, nil)
	if (biomeVisitors1 or "none") ~= "none" then
		mainWaves = Default_UnboxedWaves( biomeVisitors1, "scout", difficulty, mainWaves )
	end
	if (biomeVisitors2 or "none") ~= "none" then
		mainWaves = Default_UnboxedWaves( biomeVisitors2, "scout", difficulty, mainWaves )
	end
	
	waves = {
		default	= mainWaves,
		--acid		= Default_UnboxedWaves("acid",          "late", difficulty, nil),
		--caverns		= Default_UnboxedWaves("caverns",       "late", difficulty, nil),
		--desert		= Default_UnboxedWaves("desert",        "late", difficulty, nil),
		--ice			= Default_UnboxedWaves("ice",           "late", difficulty, nil),
		--jungle		= Default_UnboxedWaves("jungle",        "late", difficulty, nil),
		--magma		= Default_UnboxedWaves("magma",         "late", difficulty, nil),
		--metallic	= Default_UnboxedWaves("metallic",      "late", difficulty, nil),
		--swamp		= Default_UnboxedWaves("swamp",         "late", difficulty, nil),
	}
	
	return waves
end

function Default_UnboxedWaves(biomeOrParam, missionType, difficulty,  waves)
	local threat = 8
	local biome  = biomeOrParam
	if type (biomeOrParam) == "table" then 
		local params   = biomeOrParam
		threat         = params.threat
		difficulty     = params.difficulty
		missionType    = params.missionType
		biome          = params.biome
	end
	if difficulty == nil or difficulty == "custom" then difficulty = DifficultyService:GetWaveStrength() end
	if waves == nil        then waves = GetEmptyWaves( false ) end
	local ds = DefaultWaveDiffSettings( biome, missionType)
	difficulty = GetEffectiveDifficulty( difficulty, threat )
	
	if Contains({"outpost","resource", "hq"}, missionType) then
		if Contains({"brutal", "extreme"}, difficulty)    then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4 },               biomes = { biome },  levels = { 1, 2 }, suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {    2, 3, 4, 5, 6},          biomes = { biome },  levels = { 1, 2 }, suffixes = { "ultra" },      repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {       3, 4, 5, 6, 7},       biomes = { biome },  levels = { 2, 3 }, suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {          4, 5, 6, 7, 8},    biomes = { biome },  levels = { 2, 3 }, suffixes = { "ultra" },      repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {          4, 5, 6, 7, 8},    biomes = { biome },  levels = { 3, 4 }, suffixes = { "" },           repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3, 4 }, suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 3, 4 }, suffixes = { "ultra" },      repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {                6, 7, 8,  }, biomes = { biome },  levels = { 4, 5 }, suffixes = { "" },           repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4, 5 }, suffixes = { "", "alpha" },  repeatInterval = 1.3, weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {                      8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "ultra" },      repeatInterval = 1.8, weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "",  },         repeatInterval = 1.8, weightDynBr = 1.0, diffSettings = ds},    waves, true)
			waves = GenerateWavesBlock({ difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "alpha" },      repeatInterval = 2.0, weightDynBr = 1.0, diffSettings = ds},    waves, true)
			
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { biome },  levels = { 1 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {    2, 3, 4, 5, 6, 7, 8},    biomes = { biome },  levels = { 1 },    suffixes = { "ultra" },      repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {       3, 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "ultra" },      repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { biome },  levels = { 3 },    suffixes = { "" },           repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "", "alpha" },  repeatInterval = 1.2, weightDynHd = 1.5, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "ultra" },      repeatInterval = 1.5, weightDynHd = 1.5, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "" },           repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "", "alpha" },  repeatInterval = 1.5, weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                      8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "ultra" },      repeatInterval = 2,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "" },           repeatInterval = 2,   weightDynHd = 1.0, diffSettings = ds},   waves, true)
		
		elseif Contains({"normal","default", "easy"}, difficulty) then 
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { biome },  levels = { 1 },    suffixes = { "" },           repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {    2, 3, 4, 5, 6, 7},       biomes = { biome },  levels = { 1 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {       3, 4, 5, 6, 7, 8},    biomes = { biome },  levels = { 2 },    suffixes = { "" },           repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "" },           repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "", "alpha" },  repeatInterval = 1.2, weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "" },           repeatInterval = 1.3, weightDyn = 1.0,   diffSettings = ds},   waves, true)
			waves = GenerateWavesBlock({ difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "", "alpha" },  repeatInterval = 1.5, weightDyn = 1.0,   diffSettings = ds},   waves, true)
		end
		
	elseif Contains({"late"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7},       biomes = { biome },  levels = { 2 },      suffixes = { "ultra" },          repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7},       biomes = { biome },  levels = { 3 },      suffixes = { "" },               repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {    5, 6, 7, 8},    biomes = { biome },  levels = { 3 },      suffixes = { "alpha" },          repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "ultra" },          repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8,  }, biomes = { biome },  levels = { 4 },      suffixes = { "" },               repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "alpha" },          repeatInterval = 1.2, weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {             8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "ultra" },          repeatInterval = 1.2, weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {                9}, biomes = { biome },  levels = { 5 },      suffixes = { "alpha" },          repeatInterval = 1.5, weightDynBr = 1.0, },  waves, true)
		
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "ultra" },          repeatInterval = 1,   weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "" },               repeatInterval = 1,   weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {    5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "alpha" },          repeatInterval = 1,   weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "ultra" },          repeatInterval = 1.2, weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "" },               repeatInterval = 1.2, weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "alpha" },          repeatInterval = 1.2, weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {             8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "ultra" },          repeatInterval = 1.5, weightDynHd = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {                9}, biomes = { biome },  levels = { 5 },      suffixes = { "" },               repeatInterval = 1.5, weightDynHd = 1.0, },  waves, true)
			
		elseif Contains({"normal","default", "easy"}, difficulty) then 
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "ultra" },          repeatInterval = 1,   weightDyn = 1.0,   },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {    5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "", },              repeatInterval = 1,   weightDyn = 2.0,   },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "alpha" },          repeatInterval = 1,   weightDyn = 1.0,   },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "" },               repeatInterval = 1,   weightDyn = 1.5,   },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "alpha" },          repeatInterval = 1,   weightDyn = 1.0,   },  waves, true)
		end
	end
	
	return waves
end

function Default_ExtraWaves(biomeOrParam, missionType, difficulty,  waves)
	local threat = 8
	local biome  = biomeOrParam
	if type (biomeOrParam) == "table" then 
		local params   = biomeOrParam
		threat         = params.threat
		difficulty     = params.difficulty
		missionType    = params.missionType
		biome          = params.biome
	end
	if difficulty == nil or difficulty == "custom" then difficulty = DifficultyService:GetWaveStrength() end
	if waves == nil      then waves = GetEmptyWaves( false ) end
	local ds = DefaultWaveDiffSettings( biome, missionType)
	--difficulty = GetEffectiveDifficulty( difficulty, threat )

	if Contains({"outpost","resource","hq"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "", "alpha" },          repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "", "alpha" },          repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "", "alpha", "ultra" }, repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "alpha", "ultra" }, repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "", "alpha", "ultra" }, repeatInterval = 9, diffSettings = ds },   waves)
	
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 8 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 9 },    biomes = { biome }, levels = { 8 },  suffixes = { "", "alpha" },          repeatInterval = 9, diffSettings = ds },   waves)
			
		elseif Contains({"normal","default", "easy"}, difficulty) then 
			waves = GenerateWavesBlock({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
	
		elseif (difficulty == "hard")    then
		elseif Contains({"normal","default", "easy"}, difficulty) then
		end
	end
	return waves
end

function Default_MpWaves(biomeOrParam, missionType, difficulty,  waves)
	local threat = 8
	local biome  = biomeOrParam
	if type (biomeOrParam) == "table" then 
		local params   = biomeOrParam
		threat         = params.threat
		difficulty     = params.difficulty
		missionType    = params.missionType
		biome          = params.biome
	end
	if difficulty == nil or difficulty == "custom" then difficulty = DifficultyService:GetWaveStrength() end
	if waves == nil      then waves = GetEmptyWaves( true ) end
	local ds = DefaultWaveDiffSettings( biome, missionType)
	--difficulty = GetEffectiveDifficulty( difficulty, threat )
	
	if Contains({"hq"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7       }, bosses = { "hq_boss" },                                      repeatInterval = 2.5, spawnDelay = 1, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8    }, bosses = { "hq_boss" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {             8, 9 }, bosses = { "hq_boss" },                                      repeatInterval = 2,   spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, biomes = { biome }, levels = { 7 }, suffixes = { "ultra" },  repeatInterval = 2.1, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = {    5, 6, 7, 8    }, bosses = { "hq_boss" },                                      repeatInterval = 3,   spawnDelay = 1, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, bosses = { "hq_boss" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, bosses = { "hq_boss" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			
		elseif Contains({"normal","default", "easy"}, difficulty) then 
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9 }, bosses = { "hq_boss" },                                      repeatInterval = 4,   spawnDelay = 0, weightDyn = 2.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDyn = 1.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
		end
		
	elseif Contains({"outpost","resource"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7       }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 1, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8    }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {             8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 2,   spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, biomes = { biome }, levels = { 7 }, suffixes = { "ultra" },  repeatInterval = 2.1, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = {    5, 6, 7, 8    }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 1, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 4,   spawnDelay = 0, weightDyn = 2.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDyn = 1.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8,   }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = GenerateWavesBlock({ difficulty = {                9 }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			
		elseif Contains({"normal","default", "easy"}, difficulty) then 
			waves = GenerateWavesBlock({ difficulty = {             8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 4,   spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
		end
	end
	return waves
end

function Default_Bosses(biomeOrParam, missionType, difficulty,  waves)
	local threat = 8
	local biome  = biomeOrParam
	if type (biomeOrParam) == "table" then 
		local params   = biomeOrParam
		threat         = params.threat
		difficulty     = params.difficulty
		missionType    = params.missionType
		biome          = params.biome
	end
	if difficulty == nil or difficulty == "custom" then difficulty = DifficultyService:GetWaveStrength() end
	if waves == nil      then waves = GetEmptyWaves( false ) end
	local ds = DefaultWaveDiffSettings( biome, missionType)
	--difficulty = GetEffectiveDifficulty( difficulty, threat )

	if Contains({"hq"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 4,    diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = {             5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 2.5,  diffSettings = ds },   waves)
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 3.3,  diffSettings = ds },   waves)
	
		elseif Contains({"normal","default", "easy"}, difficulty) then 
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 4,    diffSettings = ds },   waves)
		end
		
	elseif Contains({"outpost","resource"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 4,    diffSettings = ds },   waves)
			waves = GenerateWavesBlock({ difficulty = {             5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 2.5,  diffSettings = ds },   waves)
		elseif (difficulty == "hard")    then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 4,    diffSettings = ds },   waves)
	
		elseif Contains({"normal","default", "easy"}, difficulty) then 
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 4,  diffSettings = ds },   waves)

		elseif (difficulty == "hard")    then
		elseif Contains({"normal","default", "easy"}, difficulty) then 
		end
	end
	return waves
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
		if (biomeVisit1 or "none") ~= "none" then
			Concat( gameEvents, Default_GameEvents( missionType, difficulty, threat, biomeVisit1, "biome"))
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
				{ action = "spawn_blue_hail",                type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",     minTime = 30, maxTime = 60, weight = 0.25 },
				{ action = "spawn_thunderstorm",             type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",  minTime = 60, maxTime = 120 },
				{ action = "spawn_wind_strong",              type = "POSITIVE", gameStates="ATTACK|IDLE",    minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",   minTime = 60,  maxTime = 120, weight = 1 },
			}
		elseif biome == "swamp" then
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
			return Default_GameEvents(missionType, difficulty, threat, "general", "biome_core")
		else
			Concat( gameEvents, Default_GameEvents(missionType, difficulty, threat, "general", "biome_core"))
			Concat( gameEvents, Default_GameEvents(missionType, difficulty, threat, biome,    "biome_core"))
		end
		
	else
		LogService:Log("Default_GameEvents: invalid parameters")
	end
	
	return gameEvents
end


class 'wave_gen'

function wave_gen:EmptyWaves( isMultiplayer )
	return GetEmptyWaves(  isMultiplayer )
end

function wave_gen:GenerateGrouped( wavesSetting, waves )
	return GenerateGroupedWaves( wavesSetting, waves )
end

function wave_gen:Generate( wavesSetting, waves, ignoreGroup )
	return GenerateWavesBlock( wavesSetting, waves, ignoreGroup )
end

function wave_gen:GetBiomeWaveIds(biome, level) 
	return GetBiomeWaveIds( biome, level) 
end

function wave_gen:GetBossLogic( boss )
	return GetBossLogic( boss )
end

function wave_gen:GetWaveLogic( level, id, biome, suffix )
	return GetWaveLogic( level, id, biome, suffix )
end


function wave_gen:PrepareDefaultRules(rules, missionType, difficulty, params)
	return PrepareDefaultRules( rules, missionType, difficulty, params)
end

function wave_gen:PrepareCustomRules(rules, missionType)
	return PrepareCustomRules( rules, missionType)
end

function wave_gen:DefaultWaveDiffSettings( biome, missionType)
	return DefaultWaveDiffSettings( biome, missionType)
end

function wave_gen:Default_Waves(biomeOrParam, missionType, difficulty,  waves)
	return Default_Waves(biomeOrParam, missionType, difficulty,  waves)
end

function wave_gen:Default_UnboxedWaves(biomeOrParam, missionType, difficulty,  waves)
	return Default_UnboxedWaves(biomeOrParam, missionType, difficulty,  waves)
end

function wave_gen:Default_ExtraWaves(biomeOrParam, missionType, difficulty,  waves)
	return Default_ExtraWaves(biomeOrParam, missionType, difficulty,  waves)
end

function wave_gen:Default_MpWaves(biomeOrParam, missionType, difficulty,  waves)
	return Default_MpWaves(biomeOrParam, missionType, difficulty,  waves)
end

function wave_gen:Default_Bosses(biomeOrParam, missionType, difficulty,  waves)
	return Default_Bosses(biomeOrParam, missionType, difficulty,  waves)
end

function wave_gen:Default_PrepareAttackDefinitions( missionType, difficulty )
	return Default_PrepareAttackDefinitions(missionType, difficulty )
end

function wave_gen:Default_WavesEntryDefinitions( missionType, difficulty, biome )
	return Default_WavesEntryDefinitions(missionType, difficulty, biome )
end

function wave_gen:Default_WaveRepeatChances(missionTypeOrParam, difficulty)
	return Default_WaveRepeatChances(missionTypeOrParam, difficulty)
end

function wave_gen:Default_AttackCountPerDifficulty(missionTypeOrParam, difficulty)
	return Default_AttackCountPerDifficulty(missionTypeOrParam, difficulty)
end

function wave_gen:Default_TimeToNextDifficultyLevel(missionType, difficulty, factor)
	return Default_TimeToNextDifficultyLevel(missionTypeOrParam, difficulty)
end

function wave_gen:Default_PrepareSpawnTime(missionType, difficulty, factor)
	return Default_PrepareSpawnTime(missionType, difficulty, factor)
end

function wave_gen:Default_CooldownAfterAttacks(missionType, difficulty, factor)
	return Default_CooldownAfterAttacks(missionType, difficulty, factor)
end

function wave_gen:Default_IdleTime(missionType, difficulty, factor)
	return Default_IdleTime(missionType, difficulty, factor)
end



return wave_gen