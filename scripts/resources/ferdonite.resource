GameplayResourceDef
{
	id				"ferdonite"
	localization_id "resource_name/ferdonite"
	bp  			"items/loot/resources/shard_ferdonite_item"
	type 			"global"
	specific_type	"rare"
	icon			"gui/hud/resource_icons/ferdonite"
	bigger_icon		"gui/hud/resource_icons/ferdonite_bigger"
	allow_overflow 	"0"
	hud_visible 	"build_menu"
	order   		"18"
	
	//missing_effect "voice_over/announcement/not_enough_ferdonite"	
}

GameplayResourceDef
{
	id				"ferdonite_crystal"
	localization_id "resource_name/ferdonite_crystal"
	bp  			""
	type 			"vein"
	icon			"gui/hud/resource_icons/ferdonite"
	bigger_icon		"gui/hud/resource_icons/ferdonite_bigger"
	ore				"ferdonite"

	//missing_effect "voice_over/announcement/not_enough_ferdonite"		
}