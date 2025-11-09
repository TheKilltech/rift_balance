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