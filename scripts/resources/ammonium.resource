GameplayResourceDef
{
	id					"ammonium_vein"
	localization_id 	"resource_name/ammonium_vein"
	bp  				"resources/resource_ammonium"
	type 				"vein"
	ore					"ammonium"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/ammonium_vein"
	bigger_icon			"gui/hud/resource_icons/ammonium_vein_bigger"
	
	//missing_effect	"voice_over/announcement/carbonium_depleted"
	//hud_visible 		"build_menu"

	terrain_material	"ground/resources/ammonium"
	spawn_type			"deposit"
	order   			"29"

	volume_minimap_color
	{
		r "1.5"
		g "1.4"
		b "1.2"
		a "1"
	}
}

GameplayResourceDef
{
	id				"ammonium"
	localization_id "resource_name/ammonium"
	bp  			"items/loot/resources/shard_ammonium_item"
	type 			"global"
	icon			"gui/hud/resource_icons/ammonium"
	bigger_icon		"gui/hud/resource_icons/ammonium_bigger"
	order   		"2"
	hud_visible 	"always"
}