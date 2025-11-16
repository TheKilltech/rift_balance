require("lua/utils/table_utils.lua")

class 'wave_gen'

function wave_gen:EmptyWaves( isMultiplayer )
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

function wave_gen:GenerateGrouped( wavesSetting, waves )
	if wavesSetting.groups == nil       then wavesSetting.groups = { "default" } end
	if wavesSetting.biomes == nil       then wavesSetting.biomes = { "" } end
	
	local idxReplaceGroup = IndexOf( wavesSetting.biomes, "group")
	
	for group in Iter( wavesSetting.groups ) do	
		if idxReplaceGroup then wavesSetting.biomes[idxReplaceGroup] = group end
		
		if waves[group] == nil then waves[group] = wave_gen:EmptyWaves( wavesSetting.mpAdditionalWaves~=nil ) end
		waves[group] = wave_gen:Generate(wavesSetting, waves[group], true)
	end
	if idxReplaceGroup then wavesSetting.biomes[idxReplaceGroup] = "group" end
	return waves
end

function wave_gen:Generate( wavesSetting, waves, ignoreGroup )
	-- e.g. make  { name="logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",   spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0}, 
	
	if waves == nil                     then waves = {} end
	if wavesSetting.biomes == nil       then wavesSetting.biomes = { "" } end
	if wavesSetting.suffixes == nil     then wavesSetting.suffixes = { "" } end
	if wavesSetting.weight == nil       then wavesSetting.weight = 1 end
	if wavesSetting.diffSettings == nil then wavesSetting.diffSettings = {{}, {}, {}, {}, {}, {}, {}, {}, {}} end
	
	if (wavesSetting.groups ~= nil) and wavesSetting.groups[1] ~= "" and (not ignoreGroup) then -- this is just temporary for compatiblity until the splitting Generate and GenerateGrouped is not cleaned up
		return self:GenerateGrouped( wavesSetting, waves )
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
		return { 
			name              = logicFile,                                                                            -- logic file to execute doing the mobs spawning
			spawn_type        = wavesSetting.spawn_type        or wavesSetting.diffSettings[tdiff].spawn_type,        -- vanilla wave setting
			spawn_type_value  = wavesSetting.spawn_type_value  or wavesSetting.diffSettings[tdiff].spawn_type_value,  -- vanilla wave setting
			target_type       = wavesSetting.target_type       or wavesSetting.diffSettings[tdiff].target_type,       -- vanilla wave setting
			target_type_value = wavesSetting.target_type_value or wavesSetting.diffSettings[tdiff].target_type_value, -- vanilla wave setting
			target_min_radius = wavesSetting.target_min_radius or wavesSetting.diffSettings[tdiff].target_min_radius, -- vanilla wave setting
			target_max_radius = wavesSetting.target_max_radius or wavesSetting.diffSettings[tdiff].target_max_radius, -- vanilla wave setting
			repeatInterval    = wavesSetting.repeatInterval    or 5 / ((wavesSetting.maxRepeats or 0)+1),             -- count interval at which wave is spawned during repeats.maxRepeats is for downwards compatibility, now replaced by repeatInterval
			spawnDelay        = wavesSetting.spawnDelay        or 0,                                                  -- repeat count at which the wave is spawned first
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
				local logic = self:GetBossLogic( boss )
				local wave  = createWaveData(d, d, "omega", 1, wavesSetting, logic)
				table.insert( subwaves, wave )
			end	
		end
		
		for biome in Iter( wavesSetting.biomes ) do
			local levels = wavesSetting.levels
			if levels == nil  then levels = { d } end
			for level in Iter( levels ) do
				if ids == nil then ids = self:GetBiomeWaveIds(biome, level) end
				for id in Iter( ids ) do 
					for suffix in Iter( wavesSetting.suffixes ) do
						local logic = self:GetWaveLogic(level, id, biome, suffix)
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

function wave_gen:GetBiomeWaveIds(biome, level) 
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
	end
	
	return {1, 2}
end

function wave_gen:GetBossLogic( boss )
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

function wave_gen:GetWaveLogic( level, id, biome, suffix )
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

function wave_gen:PrepareDefaultRules(rules, missionType, difficulty, params)
	-- missionType: { "hq", "outpost", "resource", "survival", "scout", "exploration","temp" }
	-- difficulty:  { "easy", "default", "hard", "brutal" }
	
	rules.params = params or {}
	if not rules.params.difficulty	then rules.params.difficulty  = difficulty or DifficultyService:GetCurrentDifficultyName() end
	if not rules.params.threat		then rules.params.threat      = 10 end
	if not rules.params.missionType	then rules.params.missionType = missionType or "temp" end
	
	missionType = rules.params.missionType
	difficulty  = rules.params.difficulty
	
	rules.prepareAttackDefinitions = self:Default_PrepareAttackDefinitions(   missionType, difficulty )
	rules.wavesEntryDefinitions    = self:Default_WavesEntryDefinitions(      missionType, difficulty )
	
	rules.prepareSpawnTime          = self:Default_PrepareSpawnTime(          missionType, difficulty, 1)
	rules.cooldownAfterAttacks      = self:Default_CooldownAfterAttacks(      missionType, difficulty, 1)
	rules.idleTime                  = self:Default_IdleTime(                  missionType, difficulty, 1)
	rules.timeToNextDifficultyLevel = self:Default_TimeToNextDifficultyLevel( missionType, difficulty, 1)

	rules.waveChanceRerollSpawnGroup =  0  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 15  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 30  -- chance to reroll and replace an attack wave from its original wave pool
	
	rules.addResourcesOnRunOut = { }
	rules.buildingsUpgradeStartsLogic = { }
	rules.maxAttackCountPerDifficulty = { } -- outdated by this mod, but _custom map scrips scale this
	
	rules.waves = {}
	rules.extraWaves = { }
	rules.bosses = { }
	
	return rules
end

function wave_gen:PrepareCustomRules(rules, missionType)
	local attackCountMultiplier			= DifficultyService:GetAttacksCountMultiplier()
	local prepareAttackTimeMultiplier	= DifficultyService:GetPrepareAttackTimeMultiplier()
	local idleTimeMultiplier			= DifficultyService:IdleTimeMultiplier()
	local buildingSpeedMultiplier 		= DifficultyService:GetBuildingSpeedMultiplier()
	local progressionMultiplier 		= math.sqrt(buildingSpeedMultiplier) -- this should be a product of building speed and building cost multipliers. the squareroot is used because the overall gameplay-progress speed depends on more then just those two apsects

	rules.prepareSpawnTime            = self:ScaleTable(rules.prepareSpawnTime, prepareAttackTimeMultiplier)
	rules.maxAttackCountPerDifficulty = self:ScaleTable(rules.maxAttackCountPerDifficulty, attackCountMultiplier)
	if rules.attackCountPerDifficulty then
		for i = 1, #rules.attackCountPerDifficulty, 1 do
			local counts = rules.attackCountPerDifficulty[i]
			if counts then
				counts.minCount = counts.minCount * attackCountMultiplier
				counts.maxCount = counts.maxCount * attackCountMultiplier
			end
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

function wave_gen:DefaultWaveDiffSettings( biome, missionType)
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

function wave_gen:Default_Waves(biome, missionType, difficulty,  waves)
	if difficulty == nil   then default = "default" end
	if waves == nil        then waves = {["default"] = wave_gen:EmptyWaves( false )} end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)
	
	if Contains({"outpost","resource"}, missionType) then
		if (difficulty == "brutal")      then
			waves = self:GenerateGrouped({ difficulty = { 1, 2, 3, 4 },               biomes = { biome },  levels = { 1, 2 }, suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {    2, 3, 4, 5, 6},          biomes = { biome },  levels = { 1, 2 }, suffixes = { "ultra" },      repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {       3, 4, 5, 6, 7},       biomes = { biome },  levels = { 2, 3 }, suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {          4, 5, 6, 7, 8},    biomes = { biome },  levels = { 2, 3 }, suffixes = { "ultra" },      repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {          4, 5, 6, 7, 8},    biomes = { biome },  levels = { 3, 4 }, suffixes = { "" },           repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3, 4 }, suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 3, 4 }, suffixes = { "ultra" },      repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {                6, 7, 8,  }, biomes = { biome },  levels = { 4, 5 }, suffixes = { "" },           repeatInterval = 1,   weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4, 5 }, suffixes = { "", "alpha" },  repeatInterval = 1.3, weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {                      8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "ultra" },      repeatInterval = 1.8, weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "",  },         repeatInterval = 1.8, weightDynBr = 1.0, diffSettings = ds},    waves)
			waves = self:GenerateGrouped({ difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "alpha" },      repeatInterval = 2.0, weightDynBr = 1.0, diffSettings = ds},    waves)
			
		elseif (difficulty == "hard")    then
			waves = self:GenerateGrouped({ difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { biome },  levels = { 1 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {    2, 3, 4, 5, 6, 7, 8},    biomes = { biome },  levels = { 1 },    suffixes = { "ultra" },      repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {       3, 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "ultra" },      repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { biome },  levels = { 3 },    suffixes = { "" },           repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "", "alpha" },  repeatInterval = 1.2, weightDynHd = 1.5, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "ultra" },      repeatInterval = 1.5, weightDynHd = 1.5, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "" },           repeatInterval = 1,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "", "alpha" },  repeatInterval = 1.5, weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                      8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "ultra" },      repeatInterval = 2,   weightDynHd = 1.0, diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "" },           repeatInterval = 2,   weightDynHd = 1.0, diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = self:GenerateGrouped({ difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { biome },  levels = { 1 },    suffixes = { "" },           repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {    2, 3, 4, 5, 6, 7},       biomes = { biome },  levels = { 1 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {       3, 4, 5, 6, 7, 8},    biomes = { biome },  levels = { 2 },    suffixes = { "" },           repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "", "alpha" },  repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "" },           repeatInterval = 1,   weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "", "alpha" },  repeatInterval = 1.2, weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "" },           repeatInterval = 1.3, weightDyn = 1.0,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "", "alpha" },  repeatInterval = 1.5, weightDyn = 1.0,   diffSettings = ds},   waves)
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = self:GenerateGrouped({ difficulty = { 4, 5, 6, 7, 8   }, biomes = { biome },  levels = { 1, 2 },   suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {    5, 6, 7, 8   }, biomes = { biome },  levels = { 1 },      suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 1, 2 },   suffixes = { "ultra" },          repeatInterval = 1,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {             8, 9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "alpha", "ultra" }, repeatInterval = 1,   diffSettings = ds},   waves)
		
		elseif (difficulty == "hard")    then
			waves = self:GenerateGrouped({ difficulty = { 4, 5, 6, 7, 8   }, biomes = { biome },  levels = { 1 },      suffixes = { "" },               repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {    5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "" },               repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {       6, 7, 8   }, biomes = { biome },  levels = { 1 },      suffixes = { "", "alpha" },      repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "", "alpha" },      repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 1, 2 },   suffixes = { "ultra" },          repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {             8, 9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "", "alpha" },      repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "ultra" },          repeatInterval = 1,  diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = self:GenerateGrouped({ difficulty = { 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 1 },      suffixes = { "" },               repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {    5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "" },               repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 1 },      suffixes = { "", "alpha" },      repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "", "alpha" },      repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {             8, 9}, biomes = { biome },  levels = { 1 },      suffixes = { "ultra" },          repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {             8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "" },               repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                9}, biomes = { biome },  levels = { 3 },      suffixes = { "", "alpha" },      repeatInterval = 1,  diffSettings = ds},   waves)
			waves = self:GenerateGrouped({ difficulty = {                9}, biomes = { biome },  levels = { 4 },      suffixes = { "" },               repeatInterval = 1,  diffSettings = ds},   waves)
		end
	end
	
	return waves
end

function wave_gen:Default_ExtraWaves(biome, missionType, difficulty,  waves)
	if difficulty == nil then default = "default" end
	if waves == nil      then waves = wave_gen:EmptyWaves( false ) end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)

	if Contains({"outpost","resource"}, missionType) then
		if (difficulty == "brutal")      then
			waves = self:Generate({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "", "alpha" },          repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "", "alpha" },          repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "", "alpha", "ultra" }, repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "alpha", "ultra" }, repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "", "alpha", "ultra" }, repeatInterval = 9, diffSettings = ds },   waves)
	
		elseif (difficulty == "hard")    then
			waves = self:Generate({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 8 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "", "alpha" },      repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 9 },    biomes = { biome }, levels = { 8 },  suffixes = { "", "alpha" },          repeatInterval = 9, diffSettings = ds },   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = self:Generate({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = self:Generate({ difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
			waves = self:Generate({ difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "" },                   repeatInterval = 9, diffSettings = ds },   waves)
	
		elseif (difficulty == "hard")    then
		elseif (difficulty == "default" or difficulty == "easy") then
		end
	end
	return waves
end

function wave_gen:Default_MpWaves(biome, missionType, difficulty,  waves)
	if difficulty == nil then default = "default" end
	if waves == nil      then waves = wave_gen:EmptyWaves( true ) end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)
	
	if Contains({"hq"}, missionType) then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ difficulty = { 4, 5, 6, 7       }, bosses = { "hq_boss" },                                      repeatInterval = 2.5, spawnDelay = 1, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {       6, 7, 8    }, bosses = { "hq_boss" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {             8, 9 }, bosses = { "hq_boss" },                                      repeatInterval = 2,   spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, biomes = { biome }, levels = { 7 }, suffixes = { "ultra" },  repeatInterval = 2.1, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ difficulty = {    5, 6, 7, 8    }, bosses = { "hq_boss" },                                      repeatInterval = 3,   spawnDelay = 1, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, bosses = { "hq_boss" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, bosses = { "hq_boss" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ difficulty = {       6, 7, 8, 9 }, bosses = { "hq-boss" },                                      repeatInterval = 4,   spawnDelay = 0, weightDyn = 2.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDyn = 1.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
		end
		
	elseif Contains({"outpost","resource"}, missionType) then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ difficulty = { 4, 5, 6, 7       }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 1, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {       6, 7, 8    }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {             8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 2,   spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, biomes = { biome }, levels = { 7 }, suffixes = { "ultra" },  repeatInterval = 2.1, spawnDelay = 0, weightDynBr = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ difficulty = {    5, 6, 7, 8    }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 1, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.5, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, biomes = { biome }, levels = { 6 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ difficulty = {       6, 7, 8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 4,   spawnDelay = 0, weightDyn = 2.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, biomes = { biome }, levels = { 5 }, suffixes = { "ultra" },  repeatInterval = 1.8, spawnDelay = 0, weightDyn = 1.0,   mpAdditionalWaves = 1, diffSettings = ds},   waves)
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ difficulty = {       6, 7, 8,   }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ difficulty = {                9 }, bosses = { "dynamic" },                                      repeatInterval = 2.5, spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ difficulty = {          7, 8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 3,   spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ difficulty = {             8, 9 }, bosses = { "dynamic" },                                      repeatInterval = 4,   spawnDelay = 0, weightDynHd = 1.0, mpAdditionalWaves = 1, diffSettings = ds},   waves)
		end
	end
	return waves
end

function wave_gen:Default_Bosses(biome, missionType, difficulty,  waves)
	if difficulty == nil then default = "default" end
	if waves == nil      then waves = wave_gen:EmptyWaves( false ) end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)

	if Contains({"hq"}, missionType) then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 4,    diffSettings = ds },   waves)
			waves = wave_gen:Generate({ difficulty = {             5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 2.5,  diffSettings = ds },   waves)
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 3.3,  diffSettings = ds },   waves)
	
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "hq_boss" },  repeatInterval = 4,    diffSettings = ds },   waves)
		end
		
	elseif Contains({"outpost","resource"}, missionType) then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 4,    diffSettings = ds },   waves)
			waves = wave_gen:Generate({ difficulty = {             5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 2.5,  diffSettings = ds },   waves)
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 4,    diffSettings = ds },   waves)
	
		elseif (difficulty == "default" or difficulty == "easy") then 
		end
		
	elseif Contains({"scout","exploration","temp"}, missionType) then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  repeatInterval = 4,  diffSettings = ds },   waves)

		elseif (difficulty == "hard")    then
		elseif (difficulty == "default" or difficulty == "easy") then 
		end
	end
	return waves
end

function wave_gen:Default_PrepareAttackDefinitions( missionType, difficulty )
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

function wave_gen:Default_WavesEntryDefinitions( missionType, difficulty )
	local defs = {
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
	return defs
end

function wave_gen:Default_TimeToNextDifficultyLevel(missionType, difficulty, factor)
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
	
	times = self:ScaleTable(times, factor)
	return times
end

function wave_gen:Default_PrepareSpawnTime(missionType, difficulty, factor)
	local times = {}
	if (missionType == "survival") then									times = self:RepeatingValueTable(360, 9)
	elseif Contains({"outpost","resource","hq"}, missionType) then		times = self:RepeatingValueTable(120, 9)
	elseif Contains({"scout","exploration","temp"}, missionType) then	times = self:RepeatingValueTable(60, 9)
	else 																times = self:RepeatingValueTable(60, 9)
	end
	
	if factor == nil then factor = 1 end
	if (not missionType == "survival") then	
		if (difficulty == "brutal")      then factor = factor * 0.75
		elseif (difficulty == "hard")    then factor = factor * 0.85
		elseif (difficulty == "default") then factor = factor * 1.00
		elseif (difficulty == "easy")    then factor = factor * 1.00
		end
	end
	
	times = self:ScaleTable(times, factor)
	return times
end

function wave_gen:Default_CooldownAfterAttacks(missionType, difficulty, factor)
	local times = {}
	if (missionType == "hq") then
		times = self:RepeatingValueTable(180, 9)
		times[3] = 120
		times[4] = 120
		times[8] = 240
		times[9] = 240
	else 
		times = self:RepeatingValueTable(120, 9)
	end 
	times[1] = 60
	times[2] = 90
	
	if factor == nil then factor = 1 end
	
	times = self:ScaleTable(times, factor)
	return times
end

function wave_gen:Default_IdleTime(missionType, difficulty, factor)
	local times = {}
	if (missionType == "survival") then	
		times = self:RepeatingValueTable(0, 9)
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
		times  = self:RepeatingValueTable(1200, 9)
	else times = self:RepeatingValueTable(1200, 9)
	end
	
	if factor == nil then factor = 1 end
	if (difficulty == "brutal")      then factor = factor * 0.9
	elseif (difficulty == "hard")    then factor = factor * 0.95
	elseif (difficulty == "default") then factor = factor * 1.00
	elseif (difficulty == "easy")    then factor = factor * 1.2
	end
	
	times = self:ScaleTable(times, factor)
	return times
end

function wave_gen:ScaleTable(array, factor)
	if array then
		for i = 1, #array, 1 do
			if array[i] then
				array[i] = array[i] * factor;
			end
		end
	end
	return array
end

function wave_gen:RepeatingValueTable(value, repeats)
	local array = {}
	for i = repeats, 1, -1 do
		array[i] = value;
	end
	return array
end

return wave_gen