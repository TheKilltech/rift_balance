GameplayResourceDef
{
	id					"carbon_deepvein"
	localization_id 	"resource_name/carbon_deepvein"
	bp  				"resources/resource_carbon_deepvein"
	type 				"vein"
	ore					"carbonium"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/carbon_vein"
	bigger_icon			"gui/hud/resource_icons/carbon_vein_bigger"
	
	missing_effect 		"voice_over/announcement/carbonium_depleted"
	hud_visible 		"build_menu"	
	
	terrain_material	"ground/resources/carbonium"
	spawn_type			"single"
}

GameplayResourceDef
{
	id					"iron_deepvein"
	localization_id 	"resource_name/iron_deepvein"
	bp  				"resources/resource_iron_deepvein"
	type 				"vein"
	ore					"steel"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/iron_vein"
	bigger_icon			"gui/hud/resource_icons/iron_vein_bigger"
	order   			"29"
	
	missing_effect 		"voice_over/announcement/steel_depleted"
	hud_visible 		"build_menu"
	
	terrain_material	"ground/resources/ironium"
	spawn_type			"single"
}

GameplayResourceDef
{
	id					"ammonium_deepvein"
	localization_id 	"resource_name/ammonium_deepvein"
	bp  				"resources/resource_ammonium_deepvein"
	type 				"vein"
	specific_type		"local"
	ore					"ammonium"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/ammonium_vein"
	bigger_icon			"gui/hud/resource_icons/ammonium_vein_bigger"
	order   			"29"

	spawn_type			"single"
}


// rare resources

GameplayResourceDef
{
	id					"cobalt_deepvein"
	localization_id 	"resource_name/cobalt_deepvein"
	bp  				"resources/resource_cobalt_deepvein"
	type 				"vein"
	ore					"cobalt"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/cobalt"
	bigger_icon			"gui/hud/resource_icons/cobalt_bigger"
	order   			"30"
	
	terrain_material 	"ground/resources/cobalt"
	spawn_type			"single"
}

GameplayResourceDef
{
	id					"palladium_deepvein"
	localization_id 	"resource_name/palladium_deepvein"
	bp  				"resources/resource_palladium_deepvein"
	type 				"vein"
	ore					"palladium"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/palladium_vein"
	bigger_icon			"gui/hud/resource_icons/palladium_vein_bigger"
	order   			"31"

	terrain_material	"ground/resources/palladium"
	spawn_type			"single"
}

GameplayResourceDef
{
	id					"titanium_deepvein"
	localization_id 	"resource_name/titanium_deepvein"
	bp  				"resources/resource_titanium_deepvein"
	type 				"vein"
	ore					"titanium"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/titanium_vein"
	bigger_icon			"gui/hud/resource_icons/titanium_vein_bigger"
	order				"33"

	terrain_material	"ground/resources/titanium"
	spawn_type			"single"
}

GameplayResourceDef
{
	id					"uranium_ore_deepvein"
	localization_id 	"resource_name/uranium_ore_deepvein"
	bp  				"resources/resource_uranium_ore_deepvein"
	type 				"vein"
	ore					"uranium_ore"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/uranium_vein"
	bigger_icon			"gui/hud/resource_icons/uranium_vein_bigger"
	order   			"32"

	terrain_material	"ground/resources/uranium"
	spawn_type			"single"
}


// liquids

GameplayResourceDef
{
	id					"mud_deepvein"
	localization_id 	"resource_name/mud_deepvein"
	bp  				"resources/resource_mud_deepvein"
	type 				"vein"
	specific_type		"local"
	ore					"mud"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/mud_pool"
	bigger_icon			"gui/hud/resource_icons/mud_pool_bigger"
	order   			"21"

	spawn_type			"single"
}

GameplayResourceDef
{
	id					"water_deepvein"
	localization_id 	"resource_name/water_deepvein"
	bp  				"resources/resource_water_deepvein"
	type 				"vein"
	ore					"water"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/water_pool"
	bigger_icon			"gui/hud/resource_icons/water_pool_bigger"
	order   			"20"

	spawn_type			"single"
}

GameplayResourceDef
{
	id					"sludge_deepvein"
	localization_id 	"resource_name/sludge_deepvein"
	bp  				"resources/resource_sludge_deepvein"
	type 				"vein"
	ore					"sludge"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/sludge_pool"
	bigger_icon			"gui/hud/resource_icons/sludge_pool_bigger"
	order   			"36"

	spawn_type			"single"
}

GameplayResourceDef
{
	id					"magma_deepvein"
	localization_id 	"resource_name/magma_deepvein"
	bp  				"resources/resource_magma_deepvein"
	type 				"vein"
	ore					"magma"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/magma_pool"
	bigger_icon			"gui/hud/resource_icons/magma_pool_bigger"
	order   			"37"

	spawn_type			"single"
}

GameplayResourceDef
{
	id					"morphium_deepvein"
	localization_id 	"resource_name/morphium_deepvein"
	bp  				"resources/resource_morphium_deepvein"
	type 				"vein"
	ore					"morphium"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/morphium_pool"
	bigger_icon			"gui/hud/resource_icons/morphium_pool_bigger"
	order   			"35"

	spawn_type			"single"
}

GameplayResourceDef
{
	id					"petroleum_deepvein"
	localization_id 	"resource_name/petroleum_deepvein"
	bp  				"resources/resource_petroleum_deepvein"
	type 				"vein"
	ore					"petroleum"
	random_rotation 	"1"
	icon				"gui/hud/resource_icons/petroleum_pool"
	bigger_icon			"gui/hud/resource_icons/petroleum_pool_bigger"
	order   			"38"

	spawn_type			"single"
}
