GameplayResourceDef
{
	id						"uranium_ore_vein"
	localization_id 		"resource_name/uranium_vein"
	bp  					"resources/resource_uranium_ore"
	type 					"vein"
	ore						"uranium_ore"
	random_rotation 		"1"
	icon					"gui/hud/resource_icons/uranium_ore"
	bigger_icon				"gui/hud/resource_icons/uranium_ore_bigger"

	terrain_material		"ground/resources/uranium"
	spawn_type 				"deposit"
	order   				"32"

	volume_unpack_blueprint "resources/volume_resource_uranium_ore"
}

GameplayResourceDef
{
	id				"uranium_ore"
	localization_id "resource_name/uranium_ore"
	bp  			"items/loot/resources/shard_uranium_ore_item"
	type 			"global"
	icon			"gui/hud/resource_icons/uranium_ore"
	bigger_icon		"gui/hud/resource_icons/uranium_ore_bigger"
	hud_visible 	"never"
	order   		"11"
	specific_type	"metals"
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
	order   		"9"
	specific_type	"metals"
}

GameplayResourceDef
{
	id				"uranium_depleted"
	localization_id "resource_name/uranium_depleted"
	bp  			"items/loot/resources/shard_uranium_ore_item"
	type 			"global"
	icon			"gui/hud/resource_icons/uranium_depleted"
	bigger_icon		"gui/hud/resource_icons/uranium_depleted_bigger"
	hud_visible 	"never"
	order   		"10"
	specific_type	"metals"
}