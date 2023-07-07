GameplayResourceDef
{
	id				"ammo_mech_low_caliber_lvl2"
	localization_id "Low caliber advanced M" //"resource_name/ammo_mech_low_caliber_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_lowcaliber"
	icon			"gui/hud/resource_icons/ammo_mech_low_caliber_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_low_caliber_lvl2_icon_bigger"
	base_storage	"80"
	hud_visible 	"never"
	order			"30"
}

GameplayResourceDef
{
	id				"ammo_mech_high_caliber_lvl2"
	localization_id "High caliber advanced M" //"resource_name/ammo_mech_high_caliber_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_highcaliber"
	icon			"gui/hud/resource_icons/ammo_mech_high_caliber_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_high_caliber_lvl2_icon_bigger"
	base_storage	"30"
	hud_visible 	"never"
	order			"31"
}

GameplayResourceDef
{
	id				"ammo_mech_liquid_lvl2"
	localization_id "Liquid advanced M" //"resource_name/ammo_mech_liquid_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_liquid"
	icon			"gui/hud/resource_icons/ammo_mech_liquid_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_liquid_lvl2_icon_bigger"
	base_storage	"250"
	hud_visible 	"never"
	order			"32"
}

GameplayResourceDef
{
	id				"ammo_mech_explosive_lvl2"
	localization_id "Explosive advanced M" //"resource_name/ammo_mech_explosive_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_explosive"
	icon			"gui/hud/resource_icons/ammo_mech_explosive_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_explosive_lvl2_icon_bigger"
	base_storage	"3"
	hud_visible 	"never"
	order			"33"
}

GameplayResourceDef
{
	id				"ammo_mech_energy_cell_lvl2"
	localization_id "Energy cell advanced" //"resource_name/ammo_mech_energy_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_energy"
	icon			"gui/hud/resource_icons/ammo_mech_energy_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_energy_lvl2_icon_bigger"
	base_storage	"20"
	hud_visible 	"never"
	order			"34"
}


// --------- tower ammo ---------

GameplayResourceDef
{
	id				"ammo_tower_liquid_lvl2"
	localization_id "Liquid advanced" //"resource_name/ammo_tower_liquid_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_liquid"
	icon			"gui/hud/resource_icons/ammo_tower_liquid_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_tower_liquid_lvl2_icon_bigger"
	base_storage	"2000"
	production		"250"
	hud_visible 	"build_menu"
	order			"14"
	
		
	manufacture_cost "1"
}

GameplayResourceDef
{
	id				"ammo_tower_explosive_lvl2"
	localization_id "Explosive advanced" //"resource_name/ammo_tower_explosive_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_explosive"
	icon			"gui/hud/resource_icons/ammo_tower_explosive_lvl2_icon"	
	bigger_icon		"gui/hud/resource_icons/ammo_tower_explosive_lvl2_icon_bigger"
	base_storage	"100"
	production		"1"
	allow_overflow 	"0"
	hud_visible 	"build_menu"
	order			"13"
}

GameplayResourceDef
{
	id				"ammo_tower_low_caliber_lvl2"
	localization_id "Low caliber advanced" //"resource_name/ammo_tower_low_caliber_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo"  // "ammo_lowcaliber"
	icon			"gui/hud/resource_icons/ammo_tower_low_caliber_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_tower_low_caliber_lvl2_icon_bigger"
	base_storage	"1000"
	production		"200"
	hud_visible 	"build_menu"
	order			"11"
}

GameplayResourceDef
{
	id				"ammo_tower_high_caliber_lvl2"
	localization_id "High caliber advanced" //"resource_name/ammo_tower_high_caliber_lvl2"
	bp  			""
	type 			"global"
	specific_type 	"ammo"  // "ammo_highcaliber"
	icon			"gui/hud/resource_icons/ammo_tower_high_caliber_lvl2_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_tower_high_caliber_lvl2_icon_bigger"
	base_storage	"500"
	production		"100"
	hud_visible 	"build_menu"
	order			"12"
}


