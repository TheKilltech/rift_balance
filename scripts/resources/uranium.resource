GameplayResourceDef
{
	id				"uranium_ore_vein"
	localization_id "resource_name/uranium_vein"
	bp  			"resources/resource_uranium_ore"
	type 			"vein"
	ore				"uranium_ore"
	random_rotation "1"
	icon			"gui/hud/resource_icons/uranium_vein"
	bigger_icon		"gui/hud/resource_icons/uranium_vein_bigger"

	terrain_material	"ground/resources/uranium"
	spawn_type 		"deposit"
	order   		"32"
	volume_minimap_color
	{
		r "0"
		g "2"
		b "0"
		a "1"
	}
}

GameplayResourceDef
{
	id				"uranium_ore"
	localization_id "resource_name/uranium_ore"
	bp  			"items/loot/resources/shard_uranium_ore_item"
	type 			"global"	
	icon			"gui/hud/resource_icons/uranium_ore"
	bigger_icon		"gui/hud/resource_icons/uranium_ore_bigger"
	hud_visible 	"build_menu"
	order   		"7"
}

GameplayResourceDef
{
	id				"uranium"
	localization_id "resource_name/uranium"
	bp  			"items/loot/resources/shard_uranium_item"
	type 			"global"	
	icon			"gui/hud/resource_icons/uranium"
	bigger_icon		"gui/hud/resource_icons/uranium_bigger"
	hud_visible 	"build_menu"
	missing_effect 	"voice_over/announcement/uranium_depleted"
	order   		"6"	
}