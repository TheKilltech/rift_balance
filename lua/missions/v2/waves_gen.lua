
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

function wave_gen:Generate( wavesSetting, waves )
	-- e.g. make  { name="logic/missions/survival/attack_level_3_id_1_desert_alpha.logic",   spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0}, 
	
	if waves == nil                     then waves = {} end
	if wavesSetting.groups == nil       then wavesSetting.groups = { "default" } end
	if wavesSetting.biomes == nil       then wavesSetting.biomes = { "" } end
	if wavesSetting.suffixes == nil     then wavesSetting.suffixes = { "" } end
	if wavesSetting.weight == nil       then wavesSetting.weight = 1 end
	if wavesSetting.diffSettings == nil then wavesSetting.diffSettings = {{}, {}, {}, {}, {}, {}, {}, {}, {}} end
	
	for group in Iter( wavesSetting.groups ) do
	
		if group ~= "" then
			if waves[group] == nil then waves[group] = wave_gen:EmptyWaves( wavesSetting.mpAdditionalWaves~=nil ) end
		elseif waves == nil then        waves        = wave_gen:EmptyWaves( wavesSetting.mpAdditionalWaves~=nil )
		end
		
		local subwaves
		for d in Iter( wavesSetting.difficulty ) do
			if group == "" then
				subwaves = waves[d]
			else subwaves = waves[group][d]
			end
			if subwaves == nil then subwaves = {} end
			if subwaves.additionalWaves then subwaves = subwaves.waves end
			
			local bosses  = wavesSetting.bosses
			local ids     = wavesSetting.ids
			if bosses ~= nil then
				if ids == nil then ids = {} end -- do not generate waves in boss part unless explicity requested
				
				for boss in Iter( bosses ) do
					for w = 1, wavesSetting.weight do
						local logic = self:GetBossLogic( boss )
						local wave = { 
							name              = logic,
							spawn_type        = wavesSetting.spawn_type        or wavesSetting.diffSettings[d].spawn_type,
							spawn_type_value  = wavesSetting.spawn_type_value  or wavesSetting.diffSettings[d].spawn_type_value,
							target_type       = wavesSetting.target_type       or wavesSetting.diffSettings[d].target_type,
							target_type_value = wavesSetting.target_type_value or wavesSetting.diffSettings[d].target_type_value,
							target_min_radius = wavesSetting.target_min_radius or wavesSetting.diffSettings[d].target_min_radius,
							target_max_radius = wavesSetting.target_max_radius or wavesSetting.diffSettings[d].target_max_radius,
							repeatInterval    = wavesSetting.repeatInterval    or math.floor( 3 / ((wavesSetting.maxRepeats or 0)+1)),
							maxRepeats        = wavesSetting.maxRepeats,
							waveWeight        = wavesSetting.weight,
						}
						table.insert( subwaves, wave )
					end
				end	
			end
			
			for biomeBase in Iter( wavesSetting.biomes ) do 
				local biome = biomeBase
				if biomeBase == "group" then biome = group end
				
				local levels = wavesSetting.levels
				if levels == nil  then levels = { d } end
				for level in Iter( levels ) do
					if ids == nil then ids = self:GetBiomeWaveIds(biome, level) end
					for id in Iter( ids ) do 
						for suffix in Iter( wavesSetting.suffixes ) do 
							for w = 1, wavesSetting.weight do
								local logic = self:GetWaveLogic(level, id, biome, suffix)
								local wave = { 
									name              = logic,
									spawn_type        = wavesSetting.spawn_type        or wavesSetting.diffSettings[d].spawn_type,
									spawn_type_value  = wavesSetting.spawn_type_value  or wavesSetting.diffSettings[d].spawn_type_value,
									target_type       = wavesSetting.target_type       or wavesSetting.diffSettings[d].target_type,
									target_type_value = wavesSetting.target_type_value or wavesSetting.diffSettings[d].target_type_value,
									target_min_radius = wavesSetting.target_min_radius or wavesSetting.diffSettings[d].target_min_radius,
									target_max_radius = wavesSetting.target_max_radius or wavesSetting.diffSettings[d].target_max_radius,
									repeatInterval    = wavesSetting.repeatInterval    or math.floor( 3 / ((wavesSetting.maxRepeats or 0)+1)),
									maxRepeats        = wavesSetting.maxRepeats,
									waveWeight        = wavesSetting.weight,
								}
								table.insert( subwaves, wave )
							end
						end
					end	
				end
			end
			
			if wavesSetting.mpAdditionalWaves then -- structure for multiplayer waves
				subwaves = {
					additionalWaves = wavesSetting.mpAdditionalWaves,
					waves           = subwaves
				}
			end
			if group == "" then
				waves[d] = subwaves
			else waves[group][d] = subwaves
			end
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
	
	local waveFile = "logic/missions/survival/attack_boss_" .. boss .. ".logic"
	return waveFile
end

function wave_gen:GetWaveLogic( level, id, biome, suffix )
	-- e.g. make  "logic/missions/survival/attack_level_3_id_1_desert_alpha.logic"
	-- e.g. make  "logic/missions/survival/swamp/attack_level_3_id_3_swamp.logic"
	
	if biome == "jungle" then biome = "" end
	local oldbiomes = {"", "acid", "magma", "desert" }
	local waveFile = "logic/missions/survival/"
	if table.contains(oldbiomes, biome) then
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

function wave_gen:PrepareDefaultRules(rules, missionType, difficulty)
	-- missionType: { "hq", "outpost", "survival", "scout", "temp" }
	-- difficulty:  { "easy", "default", "hard", "brutal" }

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
	if waves == nil        then waves = wave_gen:EmptyWaves( false ) end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)

	if (missionType == "outpost") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3 },                  biomes = { biome },  levels = { 1, 2 }, suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5},             biomes = { biome },  levels = { 1, 2 }, suffixes = { "ultra" },          repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6},          biomes = { biome },  levels = { 2, 3 }, suffixes = { "", "", "alpha" },  repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { biome },  levels = { 2, 3 }, suffixes = { "ultra" },          repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7},       biomes = { biome },  levels = { 3, 4 }, suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8},    biomes = { biome },  levels = { 3, 4 }, suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 3, 4 }, suffixes = { "ultra" },          repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8,  }, biomes = { biome },  levels = { 4, 5 }, suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4, 5 }, suffixes = { "", "alpha" },      repeatInterval = 1.3, diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "ultra" },          repeatInterval = 1.8, diffSettings = ds},    waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "", "", "alpha" },  repeatInterval = 1.8, diffSettings = ds},    waves)
			
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { biome },  levels = { 1 },    suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7, 8},    biomes = { biome },  levels = { 1 },    suffixes = { "ultra" },          repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "", "", "alpha" },  repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "ultra" },          repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8 ,9}, biomes = { biome },  levels = { 3 },    suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "", "alpha" },      repeatInterval = 1.2, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "ultra" },          repeatInterval = 1.5, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "", "alpha" },      repeatInterval = 1.5, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                      8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "ultra" },          repeatInterval = 2,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                         9}, biomes = { biome },  levels = { 5 },    suffixes = { "" },               repeatInterval = 2,   diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 1, 2, 3, 4, 5, 6 },         biomes = { biome },  levels = { 1 },    suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    2, 3, 4, 5, 6, 7},       biomes = { biome },  levels = { 1 },    suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       3, 4, 5, 6, 7, 8},    biomes = { biome },  levels = { 2 },    suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },    suffixes = { "", "alpha" },      repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "" },               repeatInterval = 1,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             5, 6, 7, 8, 9}, biomes = { biome },  levels = { 3 },    suffixes = { "", "alpha" },      repeatInterval = 1.2, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                6, 7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "" },               repeatInterval = 1.3, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                   7, 8, 9}, biomes = { biome },  levels = { 4 },    suffixes = { "", "alpha" },      repeatInterval = 1.5, diffSettings = ds},   waves)
		end
		
	elseif (missionType == "scout" or missionType == "temp") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 4, 5, 6, 7, 8   }, biomes = { biome },  levels = { 1, 2 },   suffixes = { "" },               diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    5, 6, 7, 8   }, biomes = { biome },  levels = { 1 },      suffixes = { "", "alpha" },      diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "", "alpha" },      diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 1, 2 },   suffixes = { "ultra" },          diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "", "alpha" },      diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             8, 9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "", "alpha" },      diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "alpha", "ultra" }, diffSettings = ds},   waves)
		
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 4, 5, 6, 7, 8   }, biomes = { biome },  levels = { 1 },      suffixes = { "" },              diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "" },              diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       6, 7, 8   }, biomes = { biome },  levels = { 1 },      suffixes = { "", "alpha" },     diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "", "alpha" },     diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 1, 2 },   suffixes = { "ultra" },         diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             8, 9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "", "alpha" },     diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                9}, biomes = { biome },  levels = { 3, 4 },   suffixes = { "ultra" },         diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = { 4, 5, 6, 7, 8, 9}, biomes = { biome },  levels = { 1 },      suffixes = { "" },              diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {    5, 6, 7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "" },              diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {       6, 7, 8, 9}, biomes = { biome },  levels = { 1 },      suffixes = { "", "alpha" },     diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {          7, 8, 9}, biomes = { biome },  levels = { 2 },      suffixes = { "", "alpha" },     diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             8, 9}, biomes = { biome },  levels = { 1 },      suffixes = { "ultra" },         diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {             8, 9}, biomes = { biome },  levels = { 3 },      suffixes = { "" },              diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                9}, biomes = { biome },  levels = { 3 },      suffixes = { "", "alpha" },     diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "default" },   difficulty = {                9}, biomes = { biome },  levels = { 4 },      suffixes = { "" },              diffSettings = ds},   waves)
		end
	end
	
	return waves
end

function wave_gen:Default_ExtraWaves(biome, missionType, difficulty,  waves)
	if difficulty == nil then default = "default" end
	if waves == nil      then waves = wave_gen:EmptyWaves( false ) end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)

	if (missionType == "outpost") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                   maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                   maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                   maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "", "alpha", "ultra" }, maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "", "alpha", "ultra" }, maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "", "alpha", "ultra" }, maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "alpha", "ultra" }, maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "", "alpha", "ultra" }, maxRepeats = 0, diffSettings = ds },   waves)
	
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },                 maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },                 maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },                 maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "", "", "alpha" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "", "", "alpha" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "", "", "alpha" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "", "", "alpha" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "", "", "alpha" },    maxRepeats = 0, diffSettings = ds },   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
		end
		
	elseif (missionType == "scout" or missionType == "temp") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1 },    biomes = { biome }, levels = { 1 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 2 },    biomes = { biome }, levels = { 2 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 3 },    biomes = { biome }, levels = { 3 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 4 },    biomes = { biome }, levels = { 4 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 5 },    biomes = { biome }, levels = { 5 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 6 },    biomes = { biome }, levels = { 6 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 7 },    biomes = { biome }, levels = { 7 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 8, 9 }, biomes = { biome }, levels = { 8 },  suffixes = { "" },    maxRepeats = 0, diffSettings = ds },   waves)
	
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
		
	if (missionType == "outpost") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {    5, 6, 7,      }, bosses = { "dynamic" },   repeatInterval = 2.5, diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {             8, 9 }, bosses = { "dynamic" },   repeatInterval = 2,   diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {       6, 7, 8,   }, bosses = { "dynamic" },   repeatInterval = 3,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {                9 }, bosses = { "dynamic" },   repeatInterval = 2.5, diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {          7, 8, 9 }, bosses = { "dynamic" },   repeatInterval = 4,   diffSettings = ds},   waves)
		end
		
	elseif (missionType == "scout" or missionType == "temp") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {      6, 7, 8,   }, bosses = { "dynamic" },    repeatInterval = 3,   diffSettings = ds},   waves)
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {               9 }, bosses = { "dynamic" },    repeatInterval = 2.5, diffSettings = ds},   waves)
	
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {          7, 8, 9 }, bosses = { "dynamic" },   repeatInterval = 3,   diffSettings = ds},   waves)
			
		elseif (difficulty == "default" or difficulty == "easy") then 
			waves = wave_gen:Generate({ groups = { "" }, mpAdditionalWaves = 1, difficulty = {             8, 9 }, bosses = { "dynamic" },   repeatInterval = 4,   diffSettings = ds},   waves)
		end
	end
	return waves
end

function wave_gen:Default_Bosses(biome, missionType, difficulty,  waves)
	if difficulty == nil then default = "default" end
	if waves == nil      then waves = wave_gen:EmptyWaves( false ) end
	local ds = wave_gen:DefaultWaveDiffSettings( biome, missionType)

	if (missionType == "outpost") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  maxRepeats = 0,  diffSettings = ds },   waves)
			waves = wave_gen:Generate({ groups = { "" }, difficulty = {             5, 6, 7, 8, 9 }, bosses = { "dynamic" },  maxRepeats = 1,  diffSettings = ds },   waves)
		elseif (difficulty == "hard")    then
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  maxRepeats = 0,  diffSettings = ds },   waves)
	
		elseif (difficulty == "default" or difficulty == "easy") then 
		end
		
	elseif (missionType == "scout" or missionType == "temp") then
		if (difficulty == "brutal")      then
			waves = wave_gen:Generate({ groups = { "" }, difficulty = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, bosses = { "dynamic" },  maxRepeats = 0,  diffSettings = ds },   waves)

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
	elseif (missionType == "outpost") then
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
	elseif (missionType == "scout" or missionType == "temp") then
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
	if (missionType == "survival") then								times = self:RepeatingValueTable(360, 9)
	elseif (missionType == "outpost" or missionType == "hq") then	times = self:RepeatingValueTable(120, 9)
	elseif (missionType == "scout" or missionType == "temp") then	times = self:RepeatingValueTable(60, 9)
	else 															times = self:RepeatingValueTable(60, 9)
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
	elseif (missionType == "outpost") then
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
	elseif (missionType == "scout" or missionType == "temp") then
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

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

return wave_gen