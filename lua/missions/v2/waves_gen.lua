require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")
waves_gen_lock = {}

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

function ApplyDifficultyOffsetToWaves( waves, offset )
	
	local offsetWaves = {}
	for i = 1, 9 do
		offsetWaves[i] = Copy( waves[i-offset] or {})
	end

    return offsetWaves
end

function ConcatWaves( waves, waves2 )
	if waves.default or waves2.default then
		return ConcatWaves( waves.default or {}, waves2.default or {})
	end
	
	for i = 1, 9 do
		Concat( waves[i], waves2[i] )
	end
    return waves
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
	
	LogService:Log("Default_Waves (biome '"..tostring(biome).. "' missionType '"..tostring(missionType).. "' difficulty '"..tostring(difficulty).."' threat '"..tostring(threat).. "')")
	
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
	local threat = nil
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
	
	LogService:Log("Default_UnboxedWaves (biome '"..tostring(biome).. "' missionType '"..tostring(missionType).. "' difficulty '"..tostring(difficulty).."' threat '"..tostring(threat).. "')")
	
	if Contains({"outpost","resource", "hq", "survival"}, missionType) then
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
		
	elseif Contains({"exploration"}, missionType) then
		if (difficulty == "brutal")      then
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7},       biomes = { biome },  levels = { 2 },      suffixes = { "ultra" },          repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = { 4, 5, 6, 7},       biomes = { biome },  levels = { 3 },      suffixes = { "" },               repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {    5, 6, 7, 8},    biomes = { biome },  levels = { 3 },      suffixes = { "alpha" },          repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "ultra" },          repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {       6, 7, 8,  }, biomes = { biome },  levels = { 4 },      suffixes = { "" },               repeatInterval = 1,   weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "alpha" },          repeatInterval = 1.2, weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {             8, 9}, biomes = { biome },  levels = { 4 },      suffixes = { "ultra" },          repeatInterval = 1.2, weightDynBr = 1.0, },  waves, true)
			waves = GenerateWavesBlock({ difficulty = {                9}, biomes = { biome },  levels = { 5 },      suffixes = { "" },               repeatInterval = 1.2, weightDynBr = 1.0, },  waves, true)
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
		
	elseif Contains({"late"}, missionType) then
		ConcatWaves(waves, ApplyDifficultyOffsetToWaves( Default_UnboxedWaves(biome, "outpost", difficulty, nil), 3))
	
	elseif Contains({"scout"}, missionType) then
		ConcatWaves(waves, ApplyDifficultyOffsetToWaves( Default_UnboxedWaves(biome, "outpost", difficulty, nil), 4))
		
	elseif Contains({"peaceful"}, missionType) then
		ConcatWaves(waves, ApplyDifficultyOffsetToWaves( Default_UnboxedWaves(biome, "outpost", difficulty, nil), 5))
		
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




-- old code, maintain for compatibility for now
rules_gen_lock = rules_gen_lock or require("lua/missions/v2/rules_gen.lua")

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