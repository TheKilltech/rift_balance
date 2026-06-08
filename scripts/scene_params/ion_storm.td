TimeOfDayPreset
{
	weather_night
	{
		weather_sound "ambient/ion_storm"
		weather_effect "effects/weather/ion_storm"
		weather_biome_mod "effects/biome_mod/ion_storm"
		weather_wind "effects/wind/rain"
		weather_type "0"
		time_of_day "0"
	}

	timeofday_sunset
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.525"
				x "0.223"
				y "0.274"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.791"
				x "0.015"
				y "0.146"
				w "1.000"
			}

			fog_height "10.000"
			fade_in_distance "55.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}		
		skybox_specular_intensity "0.500"
		fog_params
		{
			color
			{
				w "0.039"
				y "0.823"
				x "0.328"
				z "1.000"
			}

			start "20.000"
			end "68.000"
			density "1.000"
		}
		light_size "0.010"
		light_color
		{
			w "15.073"
			y "0.658"
			x "0.000"
			z "1.000"
		}

		time_of_day "1"
		skybox_diffuse_intensity "0.100"
	}

	timeofday_day
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.929"
				x "0.012"
				y "0.500"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.929"
				x "0.012"
				y "0.082"
				w "1.000"
			}

			fog_height "0.000"
			fade_in_distance "55.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}		
		skybox_specular_intensity "1.000"
		fog_params
		{
			color
			{
				w "0.039"
				y "0.823"
				x "0.328"
				z "1.000"
			}

			start "20.000"
			end "68.000"
			density "1.000"
		}
		light_size "0.010"
		light_color
		{
			w "30.000"
			y "0.624"
			x "0.000"
			z "1.000"
		}

		time_of_day "0"
		skybox_diffuse_intensity "0.100"
	}

	weather_day
	{
		weather_sound "ambient/ion_storm"
		weather_effect "effects/weather/ion_storm"
		weather_biome_mod "effects/biome_mod/ion_storm"
		weather_wind "effects/wind/rain"
		weather_type "0"
		time_of_day "0"
	}

	timeofday_night
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.734"
				x "0.100"
				y "0.394"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.551"
				x "0.034"
				y "0.085"
				w "1.000"
			}

			fog_height "10.000"
			fade_in_distance "50.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}		
		skybox_specular_intensity "0.250"
		fog_params
		{
			color
			{
				w "0.039"
				y "0.584"
				x "0.000"
				z "1.000"
			}

			start "20.000"
			end "68.000"
			density "1.000"
		}
		light_size "0.010"
		light_color
		{
			w "15.091"
			y "0.539"
			x "0.000"
			z "1.000"
		}

		time_of_day "3"
		skybox_diffuse_intensity "0.1"
	}

	timeofday_sunrise
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "0.856"
				x "0.055"
				y "0.262"
				w "1.000"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.479"
				x "0.029"
				y "0.073"
				w "1.000"
			}

			fog_height "15.000"
			fade_in_distance "55.000"
			fog_density "0.025"
			fade_in_falloff "10.000"
		}		
		skybox_specular_intensity "0.500"
		fog_params
		{
			color
			{
				w "0.039"
				y "0.839"
				x "0.168"
				z "1.000"
			}

			start "20.000"
			end "68.000"
			density "1.000"
		}
		light_size "0.010"
		light_color
		{
			w "15.091"
			y "0.539"
			x "0.000"
			z "1.000"
		}

		time_of_day "2"
		skybox_diffuse_intensity "0.100"
	}

}

