TimeOfDayPreset
{
	timeofday_sunrise
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.149"
				x "0.654"
				y "0.463"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.149"
				x "0.655"
				y "0.463"
				w "1.000"
			}

			fog_height "0.000"
			fade_in_distance "55.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}		
		skybox_specular_intensity "1.000"
		time_of_day "2"
		skybox_diffuse_intensity "0.100"
		light_color
		{
			z "0.250"
			x "1.000"
			y "0.753"
			w "50.000"
		}

		weather_effect
		light_size "0.030"
		fog_params
		{
			end "56.000"
			color
			{
				z "0.076"
				x "0.332"
				y "0.235"
				w "1.000"
			}

			start "42.000"
			density "0.297"
		}

	}

	weather_day
	{
		weather_sound
		time_of_day "0"
		weather_effect "effects/weather/solar_burn"
		weather_biome_mod "effects/biome_mod/solar_burn"
		weather_wind "effects/wind/none"
		weather_type "0"
	}

	timeofday_day
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.024"
				x "0.871"
				y "0.294"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.024"
				x "0.871"
				y "0.294"
				w "1.000"
			}

			fog_height "0.000"
			fade_in_distance "55.000"
			fog_density "0.025"
			fade_in_falloff "10.000"
		}		
		skybox_specular_intensity "1.000"
		time_of_day "0"
		skybox_diffuse_intensity "0.100"
		light_color
		{
			z "0.223"
			x "0.888"
			y "0.644"
			w "50.000"
		}

		weather_effect
		light_size "0.010"
		fog_params
		{
			end "56.000"
			color
			{
				z "0.025"
				x "0.871"
				y "0.292"
				w "1.000"
			}

			start "42.000"
			density "0.381"
		}

	}

	weather_night
	{
		weather_sound
		time_of_day "2"
		weather_effect "effects/weather/solar_burn"
		weather_biome_mod "effects/biome_mod/solar_burn"
		weather_wind "effects/wind/none"
		weather_type "0"
	}

	timeofday_night
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.045"
				x "0.437"
				y "0.293"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.007"
				x "0.076"
				y "0.051"
				w "1.000"
			}

			fog_height "10.000"
			fade_in_distance "50.000"
			fog_density "0.025"
			fade_in_falloff "10.000"
		}		
		skybox_specular_intensity "0.440"
		time_of_day "3"
		skybox_diffuse_intensity "0.201"
		light_color
		{
			z "0.000"
			x "0.000"
			y "0.000"
			w "0.000"
		}

		weather_effect
		light_size "0.200"
		fog_params
		{
			end "68.000"
			color
			{
				z "0.000"
				x "0.000"
				y "0.000"
				w "1.000"
			}

			start "52.000"
			density "0.000"
		}

	}

	timeofday_sunset
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.031"
				x "0.980"
				y "0.507"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.231"
				x "0.479"
				y "0.440"
				w "1.000"
			}

			fog_height "0.000"
			fade_in_distance "55.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}		
		skybox_specular_intensity "1.000"
		time_of_day "1"
		skybox_diffuse_intensity "0.100"
		light_color
		{
			z "0.102"
			x "0.982"
			y "0.361"
			w "50.000"
		}

		weather_effect
		light_size "0.030"
		fog_params
		{
			end "56.000"
			color
			{
				z "0.031"
				x "0.982"
				y "0.262"
				w "1.000"
			}

			start "42.000"
			density "0.298"
		}

	}

}

