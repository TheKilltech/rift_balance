require("lua/utils/rules_utils.lua")

return function()
	
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/story/v2/acid/dom_acid_find_rare_resource_rules_" )
	rules = require( rulesName )()	

	local attackCountMultiplier			= DifficultyService:GetAttacksCountMultiplier()
	local prepareAttackTimeMultiplier   = DifficultyService:GetPrepareAttackTimeMultiplier()
	local idleTimeMultiplier			= DifficultyService:IdleTimeMultiplier()
	local buildingSpeedMultiplier 		= DifficultyService:GetBuildingSpeedMultiplier()
	local progressionMultiplier 		= math.sqrt(buildingSpeedMultiplier) -- this should be a product of building speed and building cost multipliers. the squareroot is used because the overall gameplay-progress speed depends on more then just those two apsects

	for i = 1, #rules.maxAttackCountPerDifficulty, 1 do
		rules.maxAttackCountPerDifficulty[i] = rules.maxAttackCountPerDifficulty[i] * attackCountMultiplier
	end

	for i = 1, #rules.idleTime, 1 do
		rules.idleTime[i] = rules.idleTime[i] * idleTimeMultiplier * (1 + (progressionMultiplier-1)*(9-i)/8.0)
	end

	for i = 1, #rules.prepareSpawnTime, 1 do
		rules.prepareSpawnTime[i] = rules.prepareSpawnTime[i] * prepareAttackTimeMultiplier * (1 + (progressionMultiplier-1)*(9-i)/8.0)
	end
	
	for i = 1, #rules.timeToNextDifficultyLevel, 1 do
		rules.timeToNextDifficultyLevel[i] = rules.timeToNextDifficultyLevel[i] * (1 + (progressionMultiplier-1)*(9-i)/8.0)
	end

    return rules;
end

