GameplayResourceDef
{
	id				"tanzanite"
	localization_id "resource_name/tanzanite"
	bp  			"items/loot/resources/shard_tanzanite_item"
	type 			"loot"
	icon			"gui/hud/resource_icons/tanzanite"
	bigger_icon		"gui/hud/resource_icons/tanzanite_bigger"
	hud_visible 	"never"
	allow_overflow 	"1"
	specific_type	"rare"
}

GameplayResourceDef
{
	id				"tanzanite_crystal"
	localization_id "resource_name/tanzanite_crystal"
	bp  			""
	type 			"vein"
	icon			"gui/hud/resource_icons/tanzanite"
	bigger_icon		"gui/hud/resource_icons/tanzanite_bigger"
	ore				"tanzanite"
}

GameplayResourceDef
{
	id				"hazenite"
	localization_id "resource_name/hazenite"
	bp  			"items/loot/resources/shard_hazenite_item"
	type 			"loot"
	icon			"gui/hud/resource_icons/hazenite"
	bigger_icon		"gui/hud/resource_icons/hazenite_bigger"
	hud_visible 	"never"
	allow_overflow 	"1"
	specific_type	"rare"
}

GameplayResourceDef
{
	id				"hazenite_crystal"
	localization_id "resource_name/hazenite_crystal"
	bp  			""
	type 			"vein"
	icon			"gui/hud/resource_icons/hazenite"
	bigger_icon		"gui/hud/resource_icons/hazenite_bigger"
	ore				"hazenite"
}

GameplayResourceDef
{
	id				"biomass_plant"
	localization_id "resource_name/biomass_plant"
	bp  			"items/loot/resources/biomass_plant_item"
	type 			"loot"
	icon			"gui/hud/resource_icons/biomas_plant"
	bigger_icon		"gui/hud/resource_icons/biomas_plant_bigger"
	hud_visible 	"build_menu"
	allow_overflow 	"1"
	missing_effect "voice_over/announcement/not_enough_plant_biomass"
	order   		"9"		
}

GameplayResourceDef
{
	id				"biomass_animal"
	localization_id "resource_name/biomass_animal"
	bp  			"items/loot/resources/biomass_animal_item"
	type 			"loot"
	icon			"gui/hud/resource_icons/biomas_animal"
	bigger_icon		"gui/hud/resource_icons/biomas_animal_bigger"
	hud_visible 	"build_menu"
	allow_overflow 	"1"
	missing_effect "voice_over/announcement/not_enough_animal_biomass"
	order   		"10"		
}