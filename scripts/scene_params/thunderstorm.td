TimeOfDayPreset
{
	timeofday_sunrise
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			fog_height "25.000"
			fade_in_distance "50.000"
			fog_density "0.025"
			fade_in_falloff "10.000"
		}		
		skybox_specular_intensity "0.500"
		time_of_day "2"
		skybox_diffuse_intensity "0.148"
		light_color
		{
			z "0.982"
			x "0.552"
			y "0.982"
			w "4.218"
		}

		weather_effect
		light_size "0.075"
		fog_params
		{
			end "68.000"
			color
			{
				z "0.947"
				x "0.423"
				y "0.863"
				w "0.039"
			}

			start "48.000"
			density "1.000"
		}

	}

	weather_day
	{
		weather_sound "ambient/thunderstorm"
		time_of_day "0"
		weather_haptic "sound/samples/haptic/ambient_rain.wav"
		weather_effect "effects/weather/thunderstorm"
		weather_biome_mod "effects/biome_mod/thunderstorm"
		weather_wind "effects/wind/strong"
		weather_type "1"
	}

	timeofday_day
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			fog_height "0.000"
			fade_in_distance "50.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}		
		skybox_specular_intensity "1.000"
		time_of_day "0"
		skybox_diffuse_intensity "0.398"
		light_color
		{
			z "1.000"
			x "0.552"
			y "0.956"
			w "4.146"
		}

		weather_effect
		light_size "0.070"
		fog_params
		{
			end "68.000"
			color
			{
				z "1.000"
				x "0.328"
				y "0.823"
				w "0.039"
			}

			start "48.000"
			density "1.000"
		}

	}

	weather_night
	{
		weather_sound "ambient/thunderstorm"
		time_of_day "2"
		weather_haptic "sound/samples/haptic/ambient_rain.wav"
		weather_effect "effects/weather/thunderstorm"
		weather_biome_mod "effects/biome_mod/thunderstorm"
		weather_wind "effects/wind/strong"
		weather_type "1"
	}

	timeofday_night
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "0.500"
				x "0.283"
				y "0.479"
				w "4.218"
			}

			fog_height "0.000"
			fade_in_distance "50.000"
			fog_density "0.025"
			fade_in_falloff "10.000"
		}		
		skybox_specular_intensity "0.250"
		time_of_day "3"
		skybox_diffuse_intensity "0.096"
		light_color
		{
			z "0.000"
			x "0.000"
			y "0.000"
			w "0.000"
		}

		weather_effect
		light_size "0.070"
		fog_params
		{
			end "68.000"
			color
			{
				z "1.000"
				x "0.305"
				y "0.807"
				w "0.000"
			}

			start "48.000"
			density "1.000"
		}

	}

	timeofday_sunset
	{
		volumetric_fog_params
		{
			fog_height_falloff "0.085"
			albedo
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			max_distance "100.000"
			scattering_distribution "0.000"
			extinction_scale "0.750"
			emissive
			{
				z "1.000"
				x "0.552"
				y "0.956"
				w "4.218"
			}

			fog_height "0.100"
			fade_in_distance "50.000"
			fog_density "0.025"
			fade_in_falloff "20.000"
		}	
		skybox_specular_intensity "0.500"
		time_of_day "1"
		skybox_diffuse_intensity "0.154"
		light_color
		{
			z "1.000"
			x "0.552"
			y "0.956"
			w "4.218"
		}

		weather_effect
		light_size "0.075"
		fog_params
		{
			end "68.000"
			color
			{
				z "1.000"
				x "0.270"
				y "0.761"
				w "0.039"
			}

			start "48.000"
			density "1.000"
		}

	}

}

