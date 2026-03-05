require("lua/missions/v2/rules_gen.lua" )
require("lua/utils/rules_utils.lua")
require("lua/utils/table_utils.lua")
	
return function(params)
	local rules  = PrepareDefaultRules( {}, params)

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	rules.waves            = Default_Waves(      rules.params )

	--LogService:Log( PrintTable ( rules ))
	
    return rules
end