return function()
	
	local waveStrength = DifficultyService:GetWaveStrength()

	local rules = "default"
	LogService:Log( waveStrength )
	if  waveStrength == "easy" then
		rules = require("lua/missions/survival/v2/dom_survival_acid_rules_easy.lua")()	
	elseif waveStrength == "normal" then
		rules = require("lua/missions/survival/v2/dom_survival_acid_rules_normal.lua")()		
	elseif waveStrength == "hard" then
		rules = require("lua/missions/survival/v2/dom_survival_acid_rules_hard.lua")()	
	elseif waveStrength == "brutal" then
		rules = require("lua/missions/survival/v2/dom_survival_acid_rules_brutal.lua")()	
	else
		rules = require("lua/missions/survival/v2/dom_survival_acid_rules_default.lua")()		
	end
	LogService:Log( tostring(rules) )
	
	local waveTime = DifficultyService:GetWaveIntermissionTime()
	LogService:Log( "Wave interval: " .. tostring(waveTime))
	local attackCountMultiplier = DifficultyService:GetAttacksCountMultiplier()
	
	rules.prepareSpawnTime = 
	{			
		waveTime,  -- difficulty level 1
		waveTime,  -- difficulty level 2
		waveTime,  -- difficulty level 3
		waveTime,  -- difficulty level 4	
		waveTime,  -- difficulty level 5	
		waveTime,  -- difficulty level 6	
		waveTime,  -- difficulty level 7
		waveTime,  -- difficulty level 8	
		waveTime,  -- difficulty level 9	
	}

	for i = 1, #rules.maxAttackCountPerDifficulty, 1 do
		rules.maxAttackCountPerDifficulty[i] = rules.maxAttackCountPerDifficulty[i] * attackCountMultiplier
	end

    return rules;
end