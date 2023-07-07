GameplayResourceDef
{
	id				"ammo_mech_low_caliber_lvl3"
	localization_id "Low caliber top end M" //"resource_name/ammo_mech_low_caliber_lvl3"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_lowcaliber"
	icon			"gui/hud/resource_icons/ammo_mech_low_caliber_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_low_caliber_lvl3_icon_bigger"
	base_storage	"80"
	hud_visible 	"never"
	order			"35"
}

GameplayResourceDef
{
	id				"ammo_mech_high_caliber_lvl3"
	localization_id "High caliber top end M" //"resource_name/ammo_mech_high_caliber_lvl3"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_highcaliber"
	icon			"gui/hud/resource_icons/ammo_mech_high_caliber_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_high_caliber_lvl3_icon_bigger"
	base_storage	"30"
	hud_visible 	"never"
	order			"36"
}

GameplayResourceDef
{
	id				"ammo_mech_liquid_lvl3"
	localization_id "Liquid top end M" //"resource_name/ammo_mech_liquid_lvl3"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_liquid"
	icon			"gui/hud/resource_icons/ammo_mech_liquid_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_liquid_lvl3_icon_bigger"
	base_storage	"250"
	hud_visible 	"never"
	order			"37"
}

GameplayResourceDef
{
	id				"ammo_mech_explosive_lvl3"
	localization_id "Explosive top end M" //"resource_name/ammo_mech_explosive_lvl3"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_explosive"
	icon			"gui/hud/resource_icons/ammo_mech_explosive_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_explosive_lvl3_icon_bigger"
	base_storage	"3"
	hud_visible 	"never"
	order			"38"
}

GameplayResourceDef
{
	id				"ammo_mech_energy_cell_lvl3"
	localization_id "Energy cell top end" //"resource_name/ammo_mech_energy_lvl3"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_energy"
	icon			"gui/hud/resource_icons/ammo_mech_energy_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_mech_energy_lvl3_icon_bigger"
	base_storage	"20"
	hud_visible 	"never"
	order			"39"
}

// --------- tower ammo ---------

GameplayResourceDef
{
	id				"ammo_tower_liquid_lvl3"
	localization_id "Liquid top end" //"resource_name/ammo_tower_liquid"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_liquid"
	icon			"gui/hud/resource_icons/ammo_tower_liquid_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_tower_liquid_lvl3_icon_bigger"
	base_storage	"2000"
	production		"250"
	hud_visible 	"build_menu"
	order			"14"
}

GameplayResourceDef
{
	id				"ammo_tower_explosive_lvl3"
	localization_id "Explosive top end" //"resource_name/ammo_tower_explosive"
	bp  			""
	type 			"global"
	specific_type 	"ammo" // "ammo_explosive"
	icon			"gui/hud/resource_icons/ammo_tower_explosive_lvl3_icon"	
	bigger_icon		"gui/hud/resource_icons/ammo_tower_explosive_lvl3_icon_bigger"
	base_storage	"100"
	production		"1"
	allow_overflow 	"0"
	hud_visible 	"build_menu"
	order			"13"
}

GameplayResourceDef
{
	id				"ammo_tower_low_caliber_lvl3"
	localization_id "Low caliber top end" //"resource_name/ammo_tower_low_caliber"
	bp  			""
	type 			"global"
	specific_type 	"ammo"  // "ammo_lowcaliber"
	icon			"gui/hud/resource_icons/ammo_tower_low_caliber_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_tower_low_caliber_lvl3_icon_bigger"
	base_storage	"1000"
	production		"200"
	hud_visible 	"build_menu"
	order			"11"
}

GameplayResourceDef
{
	id				"ammo_tower_high_caliber_lvl3"
	localization_id "High caliber top end" //"resource_name/ammo_tower_high_caliber"
	bp  			""
	type 			"global"
	specific_type 	"ammo"  // "ammo_highcaliber"
	icon			"gui/hud/resource_icons/ammo_tower_high_caliber_lvl3_icon"
	bigger_icon		"gui/hud/resource_icons/ammo_tower_high_caliber_lvl3_icon_bigger"
	base_storage	"500"
	production		"100"
	hud_visible 	"build_menu"
	order			"12"
}
