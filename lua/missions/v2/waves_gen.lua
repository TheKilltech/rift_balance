
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
	-- consider rework for return e.g  { name="logic/missions/survival/caverns/attack_level_1_id_1_caverns.logic", spawn_type="RandomBorderInDistance", spawn_type_value=nil, target_type="Type", target_type_value="headquarters", target_min_radius=180.0, target_max_radius=350.0},
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

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

return wave_gen