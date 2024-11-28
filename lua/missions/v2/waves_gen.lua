
class 'wave_gen'

function wave_gen:Generate( wavesSetting, waves )
	if waves == nil                 then waves = {} end
	if wavesSetting.groups == nil   then wavesSetting.groups = { "default" } end
	if wavesSetting.levels == nil   then wavesSetting.levels = wavesSetting.difficulty end
	if wavesSetting.ids == nil      then wavesSetting.ids = { 1, 2 } end
	if wavesSetting.biomes == nil   then wavesSetting.biomes = { "" } end
	if wavesSetting.suffixes == nil then wavesSetting.suffixes = { "" } end
	if wavesSetting.weight == nil   then wavesSetting.weight = 1 end
	
	local subwaves
	for group in Iter( wavesSetting.groups ) do
		if group ~= "" then
			if waves[group] == nil then waves[group] = {{}, {}, {}, {}, {}, {}, {}, {}, {}} end
		elseif waves == nil then        waves        = {{}, {}, {}, {}, {}, {}, {}, {}, {}}
		end
		for d in Iter( wavesSetting.difficulty ) do
			subwaves = waves[group][d]
			if subwaves == nil then subwaves = {} end
			for biomeBase in Iter( wavesSetting.biomes ) do 
				local biome = biomeBase
				if biomeBase == "group" then biome = group end
				for level in Iter( wavesSetting.levels ) do 
					for id in Iter( wavesSetting.ids ) do 
						for suffix in Iter( wavesSetting.suffixes ) do 
							for w = 1, wavesSetting.weight do
								table.insert( subwaves, self:GetWaveLogic(level, id, biome, suffix) )
							end
						end
					end	
				end
			end
			if group == "" then
				waves[d] = subwaves
			else waves[group][d] = subwaves
			end
		end
	end
	
	return waves
end

function wave_gen:GetWaveLogic( level, id, biome, suffix )
	-- e.g. make  "logic/missions/survival/attack_level_3_id_1_desert_alpha.logic"
	-- consider rework to produce e.g  { name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
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
	-- missionType: { "outpost", "survival", "scout", "temp" }
	-- difficulty:  { "easy", "default", "hard", "brutal" }

	rules.prepareAttackDefinitions = self:PrepareAttackDefinitions(          missionType, difficulty )
	rules.wavesEntryDefinitions    = self:WavesEntryDefinitions(             missionType, difficulty )
	
	rules.prepareSpawnTime          = self:DefaultPrepareSpawnTime(          missionType, difficulty )
	rules.timeToNextDifficultyLevel = self:DefaultTimeToNextDifficultyLevel( missionType, difficulty )

	-- to do: pack the below into a script
	rules.cooldownAfterAttacks = 
	{			
		60,  -- difficulty level 1
		90,  -- difficulty level 2
		120,  -- difficulty level 3
		180,  -- difficulty level 4	
		180,  -- difficulty level 5	
		180,  -- difficulty level 6	
		240,  -- difficulty level 7
		240,  -- difficulty level 8	
		240,  -- difficulty level 9	
	}

	rules.idleTime = 
	{			
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
	return rules
end

function wave_gen:PrepareAttackDefinitions( missionType, difficulty )
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

function wave_gen:WavesEntryDefinitions( missionType, difficulty )
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

function wave_gen:DefaultTimeToNextDifficultyLevel(missionType, difficulty, factor)
	local times = {}
	if (missionType == "outpost") then
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
			200, -- difficulty level 1
			200, -- difficulty level 2
			200, -- difficulty level 3	
			1200, -- difficulty level 4
			1200, -- difficulty level 5
			1500, -- difficulty level 6
			2400, -- difficulty level 7
			3600, -- difficulty level 8
			3600, -- difficulty level 9
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

function wave_gen:DefaultPrepareSpawnTime(missionType, difficulty, factor)
	local times = {}
	if (missionType == "survival") then								times = self:RepeatingValueTable(120, 9)
	elseif (missionType == "outpost") then							times = self:RepeatingValueTable(120, 9)
	elseif (missionType == "scout" or missionType == "temp") then	times = self:RepeatingValueTable(60, 9)
	else 															times = self:RepeatingValueTable(60, 9)
	end
	
	if factor == nil then factor = 1 end
	if (difficulty == "brutal")      then factor = factor * 0.75
	elseif (difficulty == "hard")    then factor = factor * 0.85
	elseif (difficulty == "default") then factor = factor * 1.00
	elseif (difficulty == "easy")    then factor = factor * 1.00
	end
	
	times = self:ScaleTable(times, factor)
	return times
end


function wave_gen:ScaleTable(array, factor)
	for i = 1, #array, 1 do
		array[i] = array[i] * factor;
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