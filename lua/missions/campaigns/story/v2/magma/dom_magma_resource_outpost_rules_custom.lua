require("lua/utils/rules_utils.lua")

return function()
	
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/story/v2/magma/dom_magma_resource_outpost_rules_" )
	rules = require( rulesName )()	

	local attackCountMultiplier			= DifficultyService:GetAttacksCountMultiplier()
	local prepareAttackTimeMultiplier	= DifficultyService:GetPrepareAttackTimeMultiplier()
	local idleTimeMultiplier			= DifficultyService:IdleTimeMultiplier()

	for i = 1, #rules.maxAttackCountPerDifficulty, 1 do
		rules.maxAttackCountPerDifficulty[i] = rules.maxAttackCountPerDifficulty[i] * attackCountMultiplier
	end

	for i = 1, #rules.idleTime, 1 do
		rules.idleTime[i] = rules.idleTime[i] * idleTimeMultiplier
	end

	for i = 1, #rules.prepareSpawnTime, 1 do
		rules.prepareSpawnTime[i] = rules.prepareSpawnTime[i] * prepareAttackTimeMultiplier
	end

    return rules;
end