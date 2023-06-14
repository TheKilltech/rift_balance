GameplayResourceDef
{
	id				"rhodonite"
	localization_id "resource_name/rhodonite"
	bp  			"items/loot/resources/shard_rhodonite_item"
	type 			"global" //"loot"
	specific_type 	"rare"
	icon			"gui/hud/resource_icons/rhodonite"
	bigger_icon		"gui/hud/resource_icons/rhodonite_bigger"
	allow_overflow 	"0"
	hud_visible 	"build_menu"
	
	//missing_effect "voice_over/announcement/not_enough_rhodonite"	
}

GameplayResourceDef
{
	id				"rhodonite_crystal"
	localization_id "resource_name/rhodonite_crystal"
	bp  			""
	type 			"vein"
	icon			"gui/hud/resource_icons/rhodonite"
	bigger_icon		"gui/hud/resource_icons/rhodonite_bigger"
	ore				"rhodonite"
	
	//missing_effect "voice_over/announcement/not_enough_rhodonite"		
}