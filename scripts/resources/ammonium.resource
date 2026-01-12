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

	volume_unpack_blueprint "resources/volume_resource_ammonium"
}

GameplayResourceDef
{
	id				"ammonium"
	localization_id "resource_name/ammonium"
	bp  			"items/loot/resources/shard_ammonium_item"
	type 			"global"
	icon			"gui/hud/resource_icons/ammonium"
	bigger_icon		"gui/hud/resource_icons/ammonium_bigger"
	hud_visible 	"always"
	order   		"3"
}