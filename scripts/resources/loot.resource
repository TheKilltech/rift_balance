GameplayResourceDef
{
	id				"tanzanite"
	localization_id "resource_name/tanzanite"
	bp  			"items/loot/resources/shard_tanzanite_item"
	type 			"global"
	icon			"gui/hud/resource_icons/tanzanite"
	bigger_icon		"gui/hud/resource_icons/tanzanite_bigger"
	hud_visible 	"build_menu"
	allow_overflow 	"0"
	specific_type	"rare"
	order   		"10"
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
	type 			"global"
	icon			"gui/hud/resource_icons/hazenite"
	bigger_icon		"gui/hud/resource_icons/hazenite_bigger"
	hud_visible 	"build_menu"
	allow_overflow 	"0"
	specific_type	"rare"
	order   		"11"
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
	type 			"global"
	icon			"gui/hud/resource_icons/biomas_plant"
	bigger_icon		"gui/hud/resource_icons/biomas_plant_bigger"
	hud_visible 	"never"
	allow_overflow 	"0"
	missing_effect "voice_over/announcement/not_enough_plant_biomass"
	order   		"21"		
}

GameplayResourceDef
{
	id				"biomass_animal"
	localization_id "resource_name/biomass_animal"
	bp  			"items/loot/resources/biomass_animal_item"
	type 			"global"
	icon			"gui/hud/resource_icons/biomas_animal"
	bigger_icon		"gui/hud/resource_icons/biomas_animal_bigger"
	hud_visible 	"never"
	allow_overflow 	"0"
	missing_effect "voice_over/announcement/not_enough_animal_biomass"
	order   		"20"		
}

GameplayResourceDef
{
	id				"biomass_water"
	localization_id "resource_name/biomass_water"
	bp  			"items/loot/resources/biomass_water_item"
	type 			"global"
	icon			"gui/hud/resource_icons/biomass_water"
	bigger_icon		"gui/hud/resource_icons/biomass_water_bigger"
	hud_visible 	"never"
	allow_overflow 	"0"
	missing_effect  "voice_over/announcement/not_enough_plant_biomass"
	order   		"22"		
}

GameplayResourceDef
{
	id				"biomass_mycelium"
	localization_id "resource_name/biomass_mycelium"
	bp  			"items/loot/resources/biomass_mycelium"
	type 			"global"
	icon			"gui/hud/resource_icons/biomass_mycelium"
	bigger_icon		"gui/hud/resource_icons/biomass_mycelium_bigger"
	hud_visible 	"never"
	allow_overflow 	"0"
	missing_effect  "voice_over/announcement/not_enough_plant_biomass"
	order   		"23"
}

GameplayResourceDef
{
	id				"biomass_morphed"
	localization_id "resource_name/biomass_morphed"
	bp  			"items/loot/resources/biomass_morphed_item"
	type 			"global"
	icon			"gui/hud/resource_icons/biomass_morphed"
	bigger_icon		"gui/hud/resource_icons/biomass_morphed_bigger"
	hud_visible 	"never"
	allow_overflow 	"0"
	missing_effect  "voice_over/announcement/not_enough_plant_biomass"
	order   		"24"
}