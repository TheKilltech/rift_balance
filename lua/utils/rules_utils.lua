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

--- Gets a valid difficulty string
--- new difficulty strings unknown to the mod may be introduced. this adjusts the name to something the mod can handle
function GetValidDifficulty( difficulty )
	if difficulty == nil or difficulty == "custom" then 
		difficulty = DifficultyService:GetCurrentDifficultyName()
	end
	if difficulty     == "brutal"  then return difficulty
	elseif difficulty == "hard"    then return difficulty
	elseif difficulty == "normal"  then return difficulty
	elseif difficulty == "default" then return "normal"
	elseif difficulty == "easy"    then return difficulty
	elseif difficulty == "none"    then return difficulty
	elseif difficulty == "sandbox" then return "none"
	elseif difficulty == "coop_brutal"  then return "brutal"
	elseif difficulty == "coop_hard"    then return "hard"
	elseif difficulty == "coop_normal"  then return "normal"
	elseif difficulty == "coop_easy"    then return "easy"
	elseif difficulty == "coop_campaign_brutal"  then return "brutal"
	elseif difficulty == "coop_campaign_hard"    then return "hard"
	elseif difficulty == "coop_campaign_normal"  then return "normal"
	elseif difficulty == "coop_campaign_easy"    then return "easy"
	elseif string.find(difficulty, "extreme")    then return "extreme"
	elseif string.find(difficulty, "brutal")     then return "brutal"
	elseif string.find(difficulty, "hard")       then return "hard"
	elseif string.find(difficulty, "normal")     then return "normal"
	elseif string.find(difficulty, "easy")       then return "easy"
	elseif string.find(difficulty, "none")       then return "none"
	end
	return "normal"
end

function GetShiftedDifficulty( difficulty, shiftDiff )
	local difficulty = GetValidDifficulty( difficulty )
	
	while shiftDiff ~= 0 do
		if shiftDiff > 0 then
			if difficulty     == "brutal"  then difficulty = "extreme"
			elseif difficulty == "hard"    then difficulty = "brutal"
			elseif difficulty == "normal"  then difficulty = "hard"
			elseif difficulty == "default" then difficulty = "normal"
			elseif difficulty == "easy"    then difficulty = "normal"
			elseif difficulty == "coop_campaign_brutal"  then difficulty = "extreme"
			elseif difficulty == "coop_campaign_hard"    then difficulty = "brutal"
			elseif difficulty == "coop_campaign_normal"  then difficulty = "hard"
			elseif difficulty == "coop_campaign_easy"    then difficulty = "normal"
			end
			shiftDiff = shiftDiff - 1
		else 
			if difficulty     == "brutal"  then difficulty = "hard"
			elseif difficulty == "hard"    then difficulty = "normal"
			elseif difficulty == "normal"  then difficulty = "easy"
			elseif difficulty == "default" then difficulty = "easy"
			elseif difficulty == "easy"    then difficulty = "none"
			elseif difficulty == "coop_campaign_brutal"  then difficulty = "hard"
			elseif difficulty == "coop_campaign_hard"    then difficulty = "normal"
			elseif difficulty == "coop_campaign_normal"  then difficulty = "easy"
			elseif difficulty == "coop_campaign_easy"    then difficulty = "none"
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
	elseif threat < 2 then  shiftDiff = -3
	elseif threat < 4 then  shiftDiff = -2
	elseif threat < 6 then  shiftDiff = -1
	end
	
	return GetShiftedDifficulty( difficulty, shiftDiff), threat - shiftDiff*2
end