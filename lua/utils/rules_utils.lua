local function GetRulesScriptName( name, postfix )
	local script_name = name .. postfix .. ".lua"
	if ResourceManager:ResourceExists( "LuaScript", script_name ) then
		return script_name
	end

	LogService:Log( "GetRulesForDifficulty - missing dom rules script: '" .. script_name .. "'" )
	return nil
end

function GetRulesForDifficulty( name )
	if DifficultyService.GetDomRulesScriptPostfix then
		local postfix = DifficultyService:GetDomRulesScriptPostfix()
		if postfix ~= "" then
			local script_name = GetRulesScriptName( name, postfix )
			if script_name ~= nil then
				return script_name
			end
		end
	end

	if DifficultyService:IsCustomDifficulty() then
		local script_name = GetRulesScriptName( name, "custom" )
		if script_name ~= nil then
			return script_name
		end
	end

	local script_name = GetRulesScriptName( name, DifficultyService:GetCurrentDifficultyName() )
	if script_name ~= nil then
		return script_name
	end

	return name .. "default.lua";
end

function GetRulesForCustomDifficulty( name )
	local script_name = GetRulesScriptName( name, DifficultyService:GetWaveStrength() )
	if script_name ~= nil then
		return script_name
	end

	return name .. "default.lua";
end

function GetRulesPathForBiome(biomeName)
	local biomeSubdir  = nil
	if biomeName == "metallic"    then  biomeSubdir = "dlc_1"
	elseif biomeName == "caverns" then  biomeSubdir = "dlc_2"
	elseif biomeName == "swamp"   then  biomeSubdir = "dlc_3"
	else 
		biomeSubdir = "story/v2/" .. biomeName
	end
	
	return "lua/missions/campaigns/".. biomeSubdir .. "/"
end

function GetShiftedDifficulty( difficulty, shiftDiff )
	local effDiff = difficulty
	
	while shiftDiff ~= 0 do
		if shiftDiff > 0 then
			if difficulty     == "brutal"  then difficulty = "extreme"
			elseif difficulty == "hard"    then difficulty = "brutal"
			elseif difficulty == "normal"  then difficulty = "hard"
			elseif difficulty == "default" then difficulty = "hard"
			elseif difficulty == "easy"    then difficulty = "normal"
			end
			shiftDiff = shiftDiff - 1
		else 
			if difficulty     == "brutal"  then difficulty = "hard"
			elseif difficulty == "hard"    then difficulty = "normal"
			elseif difficulty == "normal"  then difficulty = "easy"
			elseif difficulty == "default" then difficulty = "easy"
			elseif difficulty == "easy"    then difficulty = "none"
			end
			shiftDiff = shiftDiff + 1
		end
	end
	
	return difficulty
end

function GetEffectiveDifficulty( difficulty, threat )
	if not threat then threat = 8 end
	
	local shiftDiff = 0
	if threat > 8  then     shiftDiff =  1
	elseif threat < 6 then  shiftDiff = -1
	elseif threat < 4 then  shiftDiff = -2
	elseif threat < 2 then  shiftDiff = -3
	end
	
	return GetShiftedDifficulty( difficulty, shiftDiff)
end