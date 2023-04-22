CUSTOM_TALENTS_DATA = {
	talent_stats_bonus = {
		icon = "talents/bonus_all_stats",
		cost = 20,
		group = 9,
		max_level = 10,
		special_values = {
			bonus_all_stats = {50, 100, 150, 200, 250, 300, 350, 400, 450, 500}
		},
		effect = {
			modifiers = {
				modifier_talent_bonus_all_stats = "bonus_all_stats",
			},
		}
	},
	talent_experience_pct1 = {
		icon = "talents/experience",
		cost = 2,
		group = 1,
		max_level = 1,
		special_values = {
			experience_pct = {5}
		},
		effect = {
			unit_keys = {
				bonus_experience_percentage = "experience_pct",
			}
		}
	},
	talent_experience_pct2 = {
		icon = "talents/experience",
		cost = 2,
		group = 2,
		max_level = 1,
		special_values = {
			experience_pct = {10}
		},
		effect = {
			unit_keys = {
				bonus_experience_percentage = "experience_pct",
			}
		}
	},
	talent_experience_pct3 = {
		icon = "talents/experience",
		cost = 2,
		group = 3,
		max_level = 1,
		special_values = {
			experience_pct = {15}
		},
		effect = {
			unit_keys = {
				bonus_experience_percentage = "experience_pct",
			}
		}
	},
	talent_bonus_creep_gold = {
		icon = "talents/gold10",
		cost = 2,
		group = 1,
		max_level = 1,
		special_values = {
			gold_for_creep = {10}
		},
		effect = {
			modifiers = {
				modifier_talent_creep_gold = "gold_for_creep",
			},
		}
	},
	talent_passive_experience_income1 = {
		icon = "talents/experience_per_minute",
		cost = 2,
		group = 1,
		max_level = 1,
		special_values = {
			xp_per_minute = {500}
		},
		effect = {
			unit_keys = {
				bonus_xp_per_minute = "xp_per_minute",
			}
		}
	},
	talent_passive_experience_income2 = {
		icon = "talents/experience_per_minute",
		cost = 2,
		group = 2,
		max_level = 1,
		special_values = {
			xp_per_minute = {1000}
		},
		effect = {
			unit_keys = {
				bonus_xp_per_minute = "xp_per_minute",
			}
		}
	},
	talent_passive_experience_income3 = {
		icon = "talents/experience_per_minute",
		cost = 2,
		group = 3,
		max_level = 1,
		special_values = {
			xp_per_minute = {1500}
		},
		effect = {
			unit_keys = {
				bonus_xp_per_minute = "xp_per_minute",
			}
		}
	},
	talent_passive_gold_income1 = {
		icon = "talents/gold_per_minute",
		cost = 2,
		group = 1,
		max_level = 1,
		special_values = {
			gold_per_minute = {150}
		},
		effect = {
			unit_keys = {
				bonus_gold_per_minute = "gold_per_minute",
			}
		}
	},
	talent_passive_gold_income2 = {
		icon = "talents/gold_per_minute",
		cost = 2,
		group = 2,
		max_level = 1,
		special_values = {
			gold_per_minute = {300}
		},
		effect = {
			unit_keys = {
				bonus_gold_per_minute = "gold_per_minute",
			}
		}
	},
	talent_passive_gold_income3 = {
		icon = "talents/gold_per_minute",
		cost = 2,
		group = 3,
		max_level = 1,
		special_values = {
			gold_per_minute = {450}
		},
		effect = {
			unit_keys = {
				bonus_gold_per_minute = "gold_per_minute",
			}
		}
	},
	talent_spell_amplify = {
		icon = "talents/spell_amplify",
		cost = 5,
		group = 7,
		max_level = 4,
		special_values = {
			spell_amplify = {7, 14, 21, 28}
		},
		effect = {
			use_modifier_applier = true,
			modifiers = {
				modifier_talent_spell_amplify = "spell_amplify",
			},
		}
	},
	talent_respawn_time_reduction = {
		icon = "talents/respawn_time_reduction",
		cost = 10,
		group = 8,
		max_level = 6,
		special_values = {
			respawn_time_reduction = {-15, -30, -45, -60, -75, -90}
		},
		effect = {
			unit_keys = {
				respawn_time_reduction = "respawn_time_reduction",
			}
		}
	},
	talent_attack_damage = {
		icon = "talents/damage",
		cost = 5,
		group = 7,
		max_level = 4,
		special_values = {
			damage = {100, 200, 300, 400}
		},
		effect = {
			modifiers = {
				modifier_talent_damage = "damage",
			},
		}
	},
	--[[talent_evasion = {
		icon = "talents/evasion",
		cost = 4,
		group = 5,
		max_level = 4,
		special_values = {
			evasion = {5, 10, 15, 20}
		},
		effect = {
			modifiers = {
				modifier_talent_evasion = "evasion",
			},
		}
	},]]
	talent_health = {
		icon = "talents/health",
		cost = 3,
		group = 6,
		max_level = 3,
		special_values = {
			health = {500, 1000, 1500}
		},
		effect = {
			calculate_stat_bonus = true,
			modifiers = {
				modifier_talent_health = "health",
			},
		}
	},
	talent_mana = {
		icon = "talents/mana",
		cost = 3,
		group = 3,
		max_level = 3,
		special_values = {
			mana = {300, 600, 900}
		},
		effect = {
			calculate_stat_bonus = true,
			modifiers = {
				modifier_talent_mana = "mana",
			},
		}
	},
	talent_health_regen = {
		icon = "talents/health_regen",
		cost = 3,
		group = 5,
		max_level = 3,
		special_values = {
			health_regen = {15, 30, 45}
		},
		effect = {
			modifiers = {
				modifier_talent_health_regen = "health_regen",
			},
		}
	},
	talent_mana_regen = {
		icon = "talents/mana_regen",
		cost = 3,
		group = 3,
		max_level = 3,
		special_values = {
			mana_regen = {4, 8, 12}
		},
		effect = {
			modifiers = {
				modifier_talent_mana_regen = "mana_regen",
			},
		}
	},
	--[[talent_lifesteal = {
		icon = "talents/lifesteal",
		cost = 5,
		group = 8,
		max_level = 4,
		special_values = {
			lifesteal = {10, 15, 20, 25}
		},
		effect = {
			modifiers = {
				modifier_talent_lifesteal = "lifesteal",
			},
		}
	},]]
	talent_armor = {
		icon = "talents/armor",
		cost = 3,
		group = 6,
		max_level = 3,
		special_values = {
			armor = {10, 20, 30}
		},
		effect = {
			modifiers = {
				modifier_talent_armor = "armor",
			},
		}
	},
	talent_magic_resistance_pct = {
		icon = "talents/magic_resistance",
		cost = 3,
		group = 6,
		max_level = 3,
		special_values = {
			magic_resistance_pct = {10, 15, 20}
		},
		effect = {
			modifiers = {
				modifier_talent_magic_resistance_pct = "magic_resistance_pct",
			},
		}
	},
	talent_vision_day = {
		icon = "talents/day",
		cost = 3,
		group = 4,
		max_level = 3,
		special_values = {
			vision_day = {100, 200, 300}
		},
		effect = {
			modifiers = {
				modifier_talent_vision_day = "vision_day",
			},
		}
	},
	talent_vision_night = {
		icon = "talents/night",
		cost = 3,
		group = 4,
		max_level = 3,
		special_values = {
			vision_night = {100, 200, 300}
		},
		effect = {
			modifiers = {
				modifier_talent_vision_night = "vision_night",
			},
		}
	},
	talent_cooldown_reduction_pct = {
		icon = "talents/cooldown_reduction",
		cost = 3,
		group = 5,
		max_level = 3,
		special_values = {
			cooldown_reduction_pct = {5, 10, 15}
		},
		effect = {
			modifiers = {
				modifier_talent_cooldown_reduction_pct = "cooldown_reduction_pct",
			},
		}
	},
	talent_movespeed_pct = {
		icon = "talents/movespeed",
		cost = 3,
		group = 4,
		max_level = 3,
		special_values = {
			movespeed_pct = {10, 15, 20}
		},
		effect = {
			modifiers = {
				modifier_talent_movespeed_pct = "movespeed_pct",
			},
		}
	},
	--[[talent_true_strike = {
		icon = "talents/true_strike",
		cost = 20,
		group = 9,
		effect = {
			modifiers = {
				"modifier_talent_true_strike"
			},
		}
	},]]

	--Unique
	talent_hero_pudge_hook_splitter = {
		icon = "talents/heroes/pudge_hook_splitter",
		cost = 1,
		group = 9,
		requirement = "pudge_meat_hook_lua",
		special_values = {
			hook_amount = 3
		}
	},
	talent_hero_arthas_vsolyanova_bunus_chance = {
		icon = "talents/heroes/arthas_vsolyanova_bunus_chance",
		cost = 5,
		group = 9,
		max_level = 5,
		requirement = "arthas_vsolyanova",
		special_values = {
			chance_multiplier = {1.1, 1.2, 1.3, 1.4, 1.5}
		}
	},
	talent_hero_arc_warden_double_spark = {
		icon = "talents/heroes/arc_warden_double_spark",
		cost = 5,
		group = 9,
		requirement = "arc_warden_spark_wraith",
		effect = {
			multicast_abilities = {
				arc_warden_spark_wraith = 2
			}
		}
	},
	talent_hero_apocalypse_apocalypse_no_death = {
		icon = "talents/heroes/apocalypse_apocalypse_no_death",
		cost = 1,
		group = 9,
		requirement = "apocalypse_apocalypse",
	},
	talent_hero_sai_release_of_forge_unlimited_attack_range = {
		icon = "arena/sai_release_of_forge",
		cost = 300,
		group = 9,
		max_level = 1,
		requirement = "sai_release_of_forge",
	},
	talent_hero_sai_release_of_forge_enemy_heroes_vision = {
		icon = "arena/sai_release_of_forge",
		cost = 300,
		group = 9,
		max_level = 1,
		requirement = "sai_release_of_forge",
	},
	--[[talent_hero_sai_release_of_forge_bonus_respawn_time_reduction = {
		icon = "arena/sai_release_of_forge",
		cost = 10,
		group = 8,
		max_level = 4,
		requirement = "sai_release_of_forge",
		special_values = {
			reduction_pct = {25, 50, 75, 100}
		}
	},]]

	--[[talent_hero_sara_evolution_bonus_health = {
		icon = "talents/heroes/sara_evolution_bonus_health",
		cost = 4,
		group = 2,
		max_level = 8,
		special_values = {
			health = {300, 600, 900, 1200, 1500, 1800, 2100, 2400}
		},
		effect = {
			calculate_stat_bonus = true,
			special_values_multiplier = 1 / (1 - GetAbilitySpecial("sara_evolution", "health_reduction_pct") * 0.01),
			modifiers = {
				modifier_talent_health = "health",
			},
		}
	},]]
	--Tinker - Rearm = Purge
}

-- A list of heroes, which have Changed flag, but some native talents for them are still relevant
-- Value should be a table, where irrelevant talents should have a `true` value
PARTIALLY_CHANGED_HEROES = {
	npc_dota_hero_ogre_magi = {},
	npc_dota_hero_huskar = {
		special_bonus_unique_huskar_2 = true,
	},
	npc_dota_hero_doom_bringer = {
		special_bonus_unique_doom_2 = true,
		special_bonus_unique_doom_3 = true,
	},
}

NATIVE_TALENTS = {
	--[[special_bonus_unique_abaddon = {
		group = 1,
	},
	special_bonus_unique_abaddon_2 = {
		group = 1,
	},
	special_bonus_unique_abaddon_3 = {
		group = 1,
	},
	special_bonus_unique_abaddon_4 = {
		group = 1,
	},
	special_bonus_unique_abaddon_5 = {
		group = 1,
	},
	special_bonus_unique_abaddon_6 = {
		group = 1,
	},
	special_bonus_unique_alchemist = {
		group = 1,
	},
	special_bonus_unique_alchemist_2 = {
		group = 1,
	},
	special_bonus_unique_alchemist_3 = {
		group = 1,
	},
	special_bonus_unique_alchemist_4 ={
		group = 1,
	},
	special_bonus_unique_alchemist_5 ={
		group = 1,
	},
	special_bonus_unique_alchemist_6 ={
		group = 1,
	},
	special_bonus_unique_alchemist_7 ={
		group = 1,
	},
	special_bonus_unique_alchemist_8 ={
		group = 1,
	},
	special_bonus_unique_axe = {
		group = 1,
	},
	special_bonus_unique_axe_2 = {
		group = 1,
	},
	special_bonus_unique_axe_3 = {
		group = 1,
	},
	special_bonus_unique_axe_4 = {
		group = 1,
	},
	special_bonus_unique_axe_5 = {
		group = 1,
	},
	special_bonus_unique_axe_6 = {
		group = 1,
	},
	special_bonus_unique_axe_7 = {
		group = 1,
	},
	special_bonus_unique_axe_8 = {
		group = 1,
	},
	special_bonus_unique_beastmaster_wild_axe_cooldown = {
		group = 1,
	},
	special_bonus_unique_beastmaster_2 = {
		group = 1,
	},
	special_bonus_unique_beastmaster_4 = {
		group = 1,
	},
	special_bonus_unique_beastmaster_5 = {
		group = 1,
	},
	special_bonus_unique_beastmaster_6 = {
		group = 1,
	},
	special_bonus_unique_beastmaster_7 = {
		group = 1,
	},
	special_bonus_unique_beastmaster_9 = {
		group = 1,
	},
	special_bonus_unique_clinkz_1 = {
		group = 1,
	},
	special_bonus_unique_clinkz_2 = {
		group = 1,
	},
	special_bonus_unique_clinkz_3 = {
		group = 1,
	},
	special_bonus_unique_clinkz_4 = {
		group = 1,
	},
	special_bonus_unique_clinkz_8 = {
		group = 1,
	},
	special_bonus_unique_clinkz_10 = {
		group = 1,
	},
	special_bonus_unique_clinkz_12 = {
		group = 1,
	},
	special_bonus_unique_juggernaut_blade_dance_lifesteal = {
		group = 1,
	},
	special_bonus_unique_juggernaut_omnislash_duration = {
		group = 1,
	},
	special_bonus_unique_juggernaut = {
		group = 1,
	},
	special_bonus_unique_juggernaut_2 = {
		group = 1,
	},
	special_bonus_unique_juggernaut_3 = {
		group = 1,
	},
	special_bonus_unique_juggernaut_4 = {
		group = 1,
	},
	special_bonus_unique_juggernaut_5 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_1 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_2 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_3 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_4 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_5 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_6 = {
		group = 1,
	},
	special_bonus_unique_winter_wyvern_7 = {
		group = 1,
	},
	special_bonus_unique_terrorblade = {
		group = 1,
	},
	special_bonus_unique_terrorblade_2 = {
		group = 1,
	},
	special_bonus_unique_terrorblade_3 = {
		group = 1,
	},
	special_bonus_unique_terrorblade_4 = {
		group = 1,
	},
	special_bonus_unique_terrorblade_5 = {
		group = 1,
	},
	special_bonus_unique_terrorblade_6 = {
		group = 1,
	},
	special_bonus_unique_luna_1 = {
		group = 1,
	},
	special_bonus_unique_luna_2 = {
		group = 1,
	},
	special_bonus_unique_luna_3 = {
		group = 1,
	},
	special_bonus_unique_luna_4 = {
		group = 1,
	},
	special_bonus_unique_luna_5 = {
		group = 1,
	},
	special_bonus_unique_luna_6 = {
		group = 1,
	},
	special_bonus_unique_luna_7 = {
		group = 1,
	},
	special_bonus_unique_luna_8 = {
		group = 1,
	},
	special_bonus_unique_medusa = {
		group = 1,
	},
	special_bonus_unique_medusa_2 = {
		group = 1,
	},
	special_bonus_unique_medusa_3 = {
		group = 1,
	},
	special_bonus_unique_medusa_4 = {
		group = 1,
	},
	special_bonus_unique_medusa_5 = {
		group = 1,
	},
	special_bonus_unique_medusa_6 = {
		group = 1,
	},
	special_bonus_unique_medusa_7 = {
		group = 1,
	},
	special_bonus_unique_night_stalker_hunter_status_resist = {
		group = 1,
	},
	special_bonus_unique_night_stalker = {
		group = 1,
	},
	special_bonus_unique_night_stalker_2 = {
		group = 1,
	},
	special_bonus_unique_night_stalker_3 = {
		group = 1,
	},
	special_bonus_unique_night_stalker_4 = {
		group = 1,
	},
	special_bonus_unique_night_stalker_6 = {
		group = 1,
	},
	special_bonus_unique_night_stalker_7 = {
		group = 1,
	},
	special_bonus_unique_nyx_carapace_reflect_duration = {
		group = 1,
	},
	special_bonus_unique_nyx = {
		group = 1,
	},
	special_bonus_unique_nyx_2 = {
		group = 1,
	},
	special_bonus_unique_nyx_3 = {
		group = 1,
	},
	special_bonus_unique_nyx_4 = {
		group = 1,
	},
	special_bonus_unique_nyx_5 = {
		group = 1,
	},
	special_bonus_unique_nyx_6 = {
		group = 1,
	},
	special_bonus_unique_weaver_1 = {
		group = 1,
	},
	special_bonus_unique_weaver_2 = {
		group = 1,
	},
	special_bonus_unique_weaver_3 = {
		group = 1,
	},
	special_bonus_unique_weaver_4 = {
		group = 1,
	},
	special_bonus_unique_weaver_5 = {
		group = 1,
	},
	special_bonus_unique_weaver_6 = {
		group = 1,
	},
	special_bonus_unique_ursa_earthshock_furyswipes = {
		group = 1,
	},
	special_bonus_unique_ursa_enrage_radius = {
		group = 1,
	},
	special_bonus_unique_ursa = {
		group = 1,
	},
	special_bonus_unique_ursa_2 = {
		group = 1,
	},
	special_bonus_unique_ursa_4 = {
		group = 1,
	},
	special_bonus_unique_ursa_7 = {
		group = 1,
	},
	special_bonus_unique_ursa_8 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_2 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_3 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_4 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_5 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_6 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_7 = {
		group = 1,
	},
	special_bonus_unique_chaos_knight_8 = {
		group = 1,
	},
	special_bonus_unique_lycan_1 = {
		group = 1,
	},
	special_bonus_unique_lycan_2 = {
		group = 1,
	},
	special_bonus_unique_lycan_3 = {
		group = 1,
	},
	special_bonus_unique_lycan_4 = {
		group = 1,
	},
	special_bonus_unique_lycan_5 = {
		group = 1,
	},
	special_bonus_unique_lycan_6 = {
		group = 1,
	},
	special_bonus_unique_lycan_7 = {
		group = 1,
	},
	special_bonus_unique_lycan_8 = {
		group = 1,
	},
	special_bonus_unique_windranger_windrun_undispellable = {
		group = 1,
	},
	special_bonus_unique_windranger = {
		group = 1,
	},
	special_bonus_unique_windranger_2 = {
		group = 1,
	},
	special_bonus_unique_windranger_3 = {
		group = 1,
	},
	special_bonus_unique_windranger_4 = {
		group = 1,
	},
	special_bonus_unique_windranger_6 = {
		group = 1,
	},
	special_bonus_unique_windranger_8 = {
		group = 1,
	},
	special_bonus_unique_windranger_9 = {
		group = 1,
	},
	special_bonus_unique_slark = {
		group = 1,
	},
	special_bonus_unique_slark_2 = {
		group = 1,
	},
	special_bonus_unique_slark_3 = {
		group = 1,
	},
	special_bonus_unique_slark_4 = {
		group = 1,
	},
	special_bonus_unique_slark_5 = {
		group = 1,
	},
	special_bonus_unique_slark_6 = {
		group = 1,
	},
	special_bonus_unique_slark_7 = {
		group = 1,
	},
	special_bonus_unique_slark_8 = {
		group = 1,
	},
	special_bonus_unique_spectre = {
		group = 1,
	},
	special_bonus_unique_spectre_2 = {
		group = 1,
	},
	special_bonus_unique_spectre_3 = {
		group = 1,
	},
	special_bonus_unique_spectre_4 = {
		group = 1,
	},
	special_bonus_unique_spectre_5 = {
		group = 1,
	},
	special_bonus_unique_spectre_6 = {
		group = 1,
	},
	special_bonus_unique_spirit_breaker_1 = {
		group = 1,
	},
	special_bonus_unique_spirit_breaker_2 = {
		group = 1,
	},
	special_bonus_unique_spirit_breaker_3 = {
		group = 1,
	},
	special_bonus_unique_spirit_breaker_4 = {
		group = 1,
	},
	special_bonus_unique_storm_spirit = {
		group = 1,
	},
	special_bonus_unique_storm_spirit_4 = {
		group = 1,
	},
	special_bonus_unique_storm_spirit_5 = {
		group = 1,
	},
	special_bonus_unique_storm_spirit_7 = {
		group = 1,
	},
	special_bonus_unique_storm_spirit_8 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_2 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_3 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_4 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_5 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_7 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_8 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_9 = {
		group = 1,
	},
	special_bonus_unique_tidehunter_10 = {
		group = 1,
	},
	special_bonus_unique_tinker_defense_matrix_cdr = {
		group = 1,
	},
	special_bonus_unique_tinker = {
		group = 1,
	},
	special_bonus_unique_tinker_3 = {
		group = 1,
	},
	special_bonus_unique_tinker_4 = {
		group = 1,
	},
	special_bonus_unique_tinker_5 = {
		group = 1,
	},
	special_bonus_unique_tinker_6 = {
		group = 1,
	},
	special_bonus_unique_tinker_7 = {
		group = 1,
	},
	special_bonus_unique_tiny = {
		group = 1,
	},
	special_bonus_unique_tiny_2 = {
		group = 1,
	},
	special_bonus_unique_tiny_3 = {
		group = 1,
	},
	special_bonus_unique_tiny_5 = {
		group = 1,
	},
	special_bonus_unique_tiny_7 = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_whirling_axes_debuff_duration = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_battle_trance_movespeed = {
		group = 1,
	},
	special_bonus_unique_troll_warlord = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_2 = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_3 = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_4 = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_5 = {
		group = 1,
	},
	special_bonus_unique_troll_warlord_6 = {
		group = 1,
	},
	special_bonus_unique_undying = {
		group = 1,
	},
	special_bonus_unique_undying_2 = {
		group = 1,
	},
	special_bonus_unique_undying_3 = {
		group = 1,
	},
	special_bonus_unique_undying_5 = {
		group = 1,
	},
	special_bonus_unique_undying_6 = {
		group = 1,
	},
	special_bonus_unique_undying_7 = {
		group = 1,
	},
	special_bonus_unique_undying_8 = {
		group = 1,
	},
	special_bonus_unique_viper_1 = {
		group = 1,
	},
	special_bonus_unique_viper_2 = {
		group = 1,
	},
	special_bonus_unique_viper_3 = {
		group = 1,
	},
	special_bonus_unique_viper_4 = {
		group = 1,
	},
	special_bonus_unique_viper_5 = {
		group = 1,
	},
	special_bonus_unique_viper_6 = {
		group = 1,
	},
	special_bonus_unique_viper_7 = {
		group = 1,
	},
	special_bonus_unique_viper_8 = {
		group = 1,
	},
	special_bonus_unique_zeus_jump_cooldown = {
		group = 1,
	},
	special_bonus_unique_zeus_jump_postjump_movespeed = {
		group = 1,
	},
	special_bonus_unique_zeus = {
		group = 1,
	},
	special_bonus_unique_zeus_2 = {
		group = 1,
	},
	special_bonus_unique_zeus_3 = {
		group = 1,
	},
	special_bonus_unique_zeus_4 = {
		group = 1,
	},
	special_bonus_unique_zeus_5 = {
		group = 1,
	},
	special_bonus_unique_elder_titan_bonus_spirit_speed = {
		group = 1,
	},
	special_bonus_unique_elder_titan = {
		group = 1,
	},
	special_bonus_unique_elder_titan_2 = {
		group = 1,
	},
	special_bonus_unique_elder_titan_3 = {
		group = 1,
	},
	special_bonus_unique_elder_titan_4 = {
		group = 1,
	},
	special_bonus_unique_elder_titan_5 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_1 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_2 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_3 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_4 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_5 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_6 = {
		group = 1,
	},
	special_bonus_unique_ember_spirit_7 = {
		group = 1,
	},
	special_bonus_unique_lifestealer_infest_target_bonus = {
		group = 1,
	},
	special_bonus_unique_lifestealer_infest_damage = {
		group = 1,
	},
	special_bonus_unique_lifestealer = {
		group = 1,
	},
	special_bonus_unique_lifestealer_2 = {
		group = 1,
	},
	special_bonus_unique_lifestealer_3 = {
		group = 1,
	},
	special_bonus_unique_lifestealer_6 = {
		group = 1,
	},
	special_bonus_unique_lion_manadrain_damage = {
		group = 1,
	},
	special_bonus_unique_lion_3 = {
		group = 1,
	},
	special_bonus_unique_lion_4 = {
		group = 1,
	},
	special_bonus_unique_lion_5 = {
		group = 1,
	},
	special_bonus_unique_lion_6 = {
		group = 1,
	},
	special_bonus_unique_lion_8 = {
		group = 1,
	},
	special_bonus_unique_lion_10 = {
		group = 1,
	},
	special_bonus_unique_lion_11 = {
		group = 1,
	},
	special_bonus_unique_skywrath = {
		group = 1,
	},
	special_bonus_unique_skywrath_2 = {
		group = 1,
	},
	special_bonus_unique_skywrath_3 = {
		group = 1,
	},
	special_bonus_unique_skywrath_4 = {
		group = 1,
	},
	special_bonus_unique_skywrath_5 = {
		group = 1,
	},
	special_bonus_unique_skywrath_6 = {
		group = 1,
	},
	special_bonus_unique_ogre_magi = {
		group = 1,
	},
	special_bonus_unique_ogre_magi_2 = {
		group = 1,
	},
	special_bonus_unique_ogre_magi_3 = {
		group = 1,
	},
	special_bonus_unique_ogre_magi_4 = {
		group = 1,
	},
	special_bonus_unique_ogre_magi_5 = {
		group = 1,
	},
	special_bonus_unique_silencer_glaives_bounces = {
		group = 1,
	},
	special_bonus_unique_silencer_arcane_curse_undispellable = {
		group = 1,
	},
	special_bonus_unique_silencer = {
		group = 1,
	},
	special_bonus_unique_silencer_2 = {
		group = 1,
	},
	special_bonus_unique_silencer_3 = {
		group = 1,
	},
	special_bonus_unique_silencer_4 = {
		group = 1,
	},
	special_bonus_unique_silencer_7 = {
		group = 1,
	},
	special_bonus_unique_death_prophet = {
		group = 1,
	},
	special_bonus_unique_death_prophet_2 = {
		group = 1,
	},
	special_bonus_unique_death_prophet_3 = {
		group = 1,
	},
	special_bonus_unique_death_prophet_4 = {
		group = 1,
	},
	special_bonus_unique_death_prophet_5 = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_strike_aspd = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_2 = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_3 = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_4 = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_5 = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_6 = {
		group = 1,
	},
	special_bonus_unique_phantom_assassin_7 = {
		group = 1,
	},
	special_bonus_unique_snapfire_mortimer_kisses_impact_damage = {
		group = 1,
	},
	special_bonus_unique_snapfire_1 = {
		group = 1,
	},
	special_bonus_unique_snapfire_2 = {
		group = 1,
	},
	special_bonus_unique_snapfire_3 = {
		group = 1,
	},
	special_bonus_unique_snapfire_5 = {
		group = 1,
	},
	special_bonus_unique_snapfire_6 = {
		group = 1,
	},
	special_bonus_unique_snapfire_7 = {
		group = 1,
	},
	special_bonus_unique_snapfire_8 = {
		group = 1,
	},
	special_bonus_unique_phantom_lancer_lance_damage = {
		group = 1,
	},
	special_bonus_unique_phantom_lancer = {
		group = 1,
	},
	special_bonus_unique_phantom_lancer_2 = {
		group = 1,
	},
	special_bonus_unique_phantom_lancer_4 = {
		group = 1,
	},
	special_bonus_unique_phantom_lancer_5 = {
		group = 1,
	},
	special_bonus_unique_phantom_lancer_6 = {
		group = 1,
	},
	special_bonus_unique_riki_1 = {
		group = 1,
	},
	special_bonus_unique_riki_2 = {
		group = 1,
	},
	special_bonus_unique_riki_3 = {
		group = 1,
	},
	special_bonus_unique_riki_5 = {
		group = 1,
	},
	special_bonus_unique_riki_6 = {
		group = 1,
	},
	special_bonus_unique_riki_7 = {
		group = 1,
	},
	special_bonus_unique_riki_8 = {
		group = 1,
	},
	special_bonus_unique_riki_9 = {
		group = 1,
	},
	special_bonus_unique_hoodwink_scurry_evasion = {
		group = 1,
	},
	special_bonus_unique_hoodwink_bushwhack_cooldown = {
		group = 1,
	},
	special_bonus_unique_hoodwink_bushwhack_damage = {
		group = 1,
	},
	special_bonus_unique_hoodwink_acorn_shot_bounces = {
		group = 1,
	},
	special_bonus_unique_hoodwink_sharpshooter_speed = {
		group = 1,
	},
	special_bonus_unique_hoodwink_acorn_shot_charges = {
		group = 1,
	},
	special_bonus_unique_hoodwink_bushwhack_radius = {
		group = 1,
	},
	special_bonus_unique_tusk = {
		group = 1,
	},
	special_bonus_unique_tusk_2 = {
		group = 1,
	},
	special_bonus_unique_tusk_3 = {
		group = 1,
	},
	special_bonus_unique_tusk_4 = {
		group = 1,
	},
	special_bonus_unique_tusk_5 = {
		group = 1,
	},
	special_bonus_unique_tusk_6 = {
		group = 1,
	},
	special_bonus_unique_tusk_7 = {
		group = 1,
	},
	special_bonus_unique_sniper_headshot_damage = {
		group = 1,
	},
	special_bonus_unique_sniper_1 = {
		group = 1,
	},
	special_bonus_unique_sniper_2 = {
		group = 1,
	},
	special_bonus_unique_sniper_3 = {
		group = 1,
	},
	special_bonus_unique_sniper_4 = {
		group = 1,
	},
	special_bonus_unique_sniper_5 = {
		group = 1,
	},
	special_bonus_unique_magnus_reverse_polarity_strength = {
		group = 1,
	},
	special_bonus_unique_magnus = {
		group = 1,
	},
	special_bonus_unique_magnus_2 = {
		group = 1,
	},
	special_bonus_unique_magnus_3 = {
		group = 1,
	},
	special_bonus_unique_magnus_4 = {
		group = 1,
	},
	special_bonus_unique_magnus_5 = {
		group = 1,
	},
	special_bonus_unique_magnus_6 = {
		group = 1,
	},
	special_bonus_unique_magnus_7 = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_gust_selfmovespeed = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_gust_invis = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_1 = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_2 = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_3 = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_6 = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_7 = {
		group = 1,
	},
	special_bonus_unique_drow_ranger_8 = {
		group = 1,
	},
	special_bonus_unique_earth_spirit = {
		group = 1,
	},
	special_bonus_unique_earth_spirit_2 = {
		group = 1,
	},
	special_bonus_unique_earth_spirit_3 = {
		group = 1,
	},
	special_bonus_unique_earth_spirit_4 = {
		group = 1,
	},
	special_bonus_unique_earth_spirit_5 = {
		group = 1,
	},
	special_bonus_unique_earth_spirit_6 = {
		group = 1,
	},
	special_bonus_unique_earth_spirit_8 = {
		group = 1,
	},
	special_bonus_unique_huskar = {
		group = 1,
	},
	special_bonus_unique_huskar_3 = {
		group = 1,
	},
	special_bonus_unique_huskar_4 = {
		group = 1,
	},
	special_bonus_unique_huskar_5 = {
		group = 1,
	},
	special_bonus_unique_huskar_6 = {
		group = 1,
	},
	special_bonus_unique_huskar_7 = {
		group = 1,
	},
	special_bonus_unique_naga_siren_net_cooldown = {
		group = 1,
	},
	special_bonus_unique_naga_siren = {
		group = 1,
	},
	special_bonus_unique_naga_siren_2 = {
		group = 1,
	},
	special_bonus_unique_naga_siren_3 = {
		group = 1,
	},
	special_bonus_unique_naga_siren_4 = {
		group = 1,
	},
	special_bonus_unique_naga_siren_5 = {
		group = 1,
	},
	special_bonus_unique_naga_siren_6 = {
		group = 1,
	},
	special_bonus_unique_oracle_fortunes_end_damage = {
		group = 1,
	},
	special_bonus_unique_oracle = {
		group = 1,
	},
	special_bonus_unique_oracle_2 = {
		group = 1,
	},
	special_bonus_unique_oracle_5 = {
		group = 1,
	},
	special_bonus_unique_oracle_6 = {
		group = 1,
	},
	special_bonus_unique_oracle_7 = {
		group = 1,
	},
	special_bonus_unique_oracle_8 = {
		group = 1,
	},
	special_bonus_unique_oracle_9 = {
		group = 1,
	},
	special_bonus_unique_sand_king_burrowstrike_stun = {
		group = 1,
	},
	special_bonus_unique_sand_king = {
		group = 1,
	},
	special_bonus_unique_sand_king_2 = {
		group = 1,
	},
	special_bonus_unique_sand_king_3 = {
		group = 1,
	},
	special_bonus_unique_sand_king_4 = {
		group = 1,
	},
	special_bonus_unique_sand_king_5 = {
		group = 1,
	},
	special_bonus_unique_sand_king_7 = {
		group = 1,
	},
	special_bonus_unique_sand_king_8 = {
		group = 1,
	},
	special_bonus_unique_shadow_demon_disseminate_damage = {
		group = 1,
	},
	special_bonus_unique_shadow_demon_1 = {
		group = 1,
	},
	special_bonus_unique_shadow_demon_3 = {
		group = 1,
	},
	special_bonus_unique_shadow_demon_4 = {
		group = 1,
	},
	special_bonus_unique_shadow_demon_7 = {
		group = 1,
	},
	special_bonus_unique_shadow_demon_9 = {
		group = 1,
	},
	special_bonus_unique_slardar_slithereen_crush_stun = {
		group = 1,
	},
	special_bonus_unique_slardar = {
		group = 1,
	},
	special_bonus_unique_slardar_2 = {
		group = 1,
	},
	special_bonus_unique_slardar_3 = {
		group = 1,
	},
	special_bonus_unique_slardar_4 = {
		group = 1,
	},
	special_bonus_unique_slardar_5 = {
		group = 1,
	},
	special_bonus_unique_slardar_7 = {
		group = 1,
	},
	special_bonus_unique_lina_1 = {
		group = 1,
	},
	special_bonus_unique_lina_2 = {
		group = 1,
	},
	special_bonus_unique_lina_3 = {
		group = 1,
	},
	special_bonus_unique_lina_6 = {
		group = 1,
	},
	special_bonus_unique_lina_7 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_1 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_2 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_3 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_4 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_5 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_6 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_7 = {
		group = 1,
	},
	special_bonus_unique_ancient_apparition_8 = {
		group = 1,
	},
	special_bonus_unique_disruptor = {
		group = 1,
	},
	special_bonus_unique_disruptor_2 = {
		group = 1,
	},
	special_bonus_unique_disruptor_3 = {
		group = 1,
	},
	special_bonus_unique_disruptor_4 = {
		group = 1,
	},
	special_bonus_unique_disruptor_5 = {
		group = 1,
	},
	special_bonus_unique_disruptor_7 = {
		group = 1,
	},
	special_bonus_unique_disruptor_8 = {
		group = 1,
	},
	special_bonus_unique_disruptor_9 = {
		group = 1,
	},
	special_bonus_unique_outworld_devourer_astral_castrange = {
		group = 1,
	},
	special_bonus_unique_outworld_devourer = {
		group = 1,
	},
	special_bonus_unique_outworld_devourer_4 = {
		group = 1,
	},
	special_bonus_unique_outworld_devourer_5 = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_illuminate_cooldown = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_7 = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_8 = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_10 = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_11 = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_13 = {
		group = 1,
	},
	special_bonus_unique_keeper_of_the_light_14 = {
		group = 1,
	},
	special_bonus_unique_legion_commander = {
		group = 1,
	},
	special_bonus_unique_legion_commander_2 = {
		group = 1,
	},
	special_bonus_unique_legion_commander_3 = {
		group = 1,
	},
	special_bonus_unique_legion_commander_4 = {
		group = 1,
	},
	special_bonus_unique_legion_commander_5 = {
		group = 1,
	},
	special_bonus_unique_legion_commander_6 = {
		group = 1,
	},
	special_bonus_unique_legion_commander_7 = {
		group = 1,
	},
	special_bonus_unique_legion_commander_8 = {
		group = 1,
	},
	special_bonus_unique_puck_orb_damage = {
		group = 1,
	},
	special_bonus_unique_puck_coil_damage = {
		group = 1,
	},
	special_bonus_unique_puck = {
		group = 1,
	},
	special_bonus_unique_puck_2 = {
		group = 1,
	},
	special_bonus_unique_puck_3 = {
		group = 1,
	},
	special_bonus_unique_puck_5 = {
		group = 1,
	},
	special_bonus_unique_puck_6 = {
		group = 1,
	},
	special_bonus_unique_puck_7 = {
		group = 1,
	},
	special_bonus_unique_pugna_1 = {
		group = 9,
	},
	special_bonus_unique_pugna_2 = {
		group = 6,
	},
	special_bonus_unique_pugna_3 = {
		group = 4,
	},
	special_bonus_unique_pugna_4 = {
		group = 7,
	},
	special_bonus_unique_pugna_5 = {
		group = 6,
	},
	special_bonus_unique_pugna_6 = {
		group = 5,
	},
	special_bonus_unique_timbersaw = {
		group = 1,
	},
	special_bonus_unique_timbersaw_2 = {
		group = 1,
	},
	special_bonus_unique_timbersaw_3 = {
		group = 1,
	},
	special_bonus_unique_timbersaw_4 = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_fire_wreath_swipe = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_celestial_hammer_slow = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_luminosity_crit = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_solar_guardian_cooldown = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_solar_guardian_radius = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_luminosity_attack_count = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_fire_wreath_charges = {
		group = 1,
	},
	special_bonus_unique_dawnbreaker_celestial_hammer_cast_range = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_rupture_charges = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_2 = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_3 = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_4 = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_5 = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_6 = {
		group = 1,
	},
	special_bonus_unique_bloodseeker_7 = {
		group = 1,
	},
	special_bonus_unique_broodmother_1 = {
		group = 1,
	},
	special_bonus_unique_broodmother_2 = {
		group = 1,
	},
	special_bonus_unique_broodmother_3 = {
		group = 1,
	},
	special_bonus_unique_broodmother_4 = {
		group = 1,
	},
	special_bonus_unique_broodmother_5 = {
		group = 1,
	},
	special_bonus_unique_broodmother_6 = {
		group = 1,
	},
	special_bonus_unique_broodmother_7 = {
		group = 1,
	},
	special_bonus_unique_marci_lunge_range = {
		group = 1,
	},
	special_bonus_unique_marci_grapple_damage = {
		group = 1,
	},
	special_bonus_unique_marci_guardian_lifesteal = {
		group = 1,
	},
	special_bonus_unique_marci_lunge_cooldown = {
		group = 1,
	},
	special_bonus_unique_marci_grapple_stun_duration = {
		group = 1,
	},
	special_bonus_unique_marci_unleash_speed = {
		group = 1,
	},
	special_bonus_unique_marci_unleash_silence = {
		group = 1,
	},
	special_bonus_unique_marci_guardian_magic_immune = {
		group = 1,
	},
	special_bonus_unique_mars_rebuke_radius = {
		group = 1,
	},
	special_bonus_unique_mars_bulwark_redirect_chance = {
		group = 1,
	},
	special_bonus_unique_mars_rebuke_cooldown = {
		group = 1,
	},
	special_bonus_unique_mars_spear_bonus_damage = {
		group = 1,
	},
	special_bonus_unique_mars_bulwark_damage_reduction = {
		group = 1,
	},
	special_bonus_unique_mars_spear_stun_duration = {
		group = 1,
	},
	special_bonus_unique_mars_gods_rebuke_extra_crit = {
		group = 1,
	},
	special_bonus_unique_mars_arena_of_blood_hp_regen = {
		group = 1,
	},
	special_bonus_unique_chen_2 = {
		group = 1,
	},
	special_bonus_unique_chen_3 = {
		group = 1,
	},
	special_bonus_unique_chen_4 = {
		group = 1,
	},
	special_bonus_unique_chen_5 = {
		group = 1,
	},
	special_bonus_unique_chen_7 = {
		group = 1,
	},
	special_bonus_unique_chen_8 = {
		group = 1,
	},
	special_bonus_unique_chen_11 = {
		group = 1,
	},
	special_bonus_unique_chen_12 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_2 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_4 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_7 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_8 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_9 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_10 = {
		group = 1,
	},
	special_bonus_unique_lone_druid_11 = {
		group = 1,
	},
	special_bonus_unique_techies = {
		group = 1,
	},
	special_bonus_unique_techies_2 = {
		group = 1,
	},
	special_bonus_unique_techies_3 = {
		group = 1,
	},
	special_bonus_unique_techies_4 = {
		group = 1,
	},
	special_bonus_unique_techies_5 = {
		group = 1,
	},
	special_bonus_unique_arc_warden = {
		group = 1,
	},
	special_bonus_unique_arc_warden_2 = {
		group = 1,
	},
	special_bonus_unique_arc_warden_3 = {
		group = 1,
	},
	special_bonus_unique_arc_warden_4 = {
		group = 1,
	},
	special_bonus_unique_arc_warden_5 = {
		group = 1,
	},
	special_bonus_unique_arc_warden_6 = {
		group = 1,
	},
	special_bonus_unique_arc_warden_7 = {
		group = 1,
	},
	special_bonus_unique_meepo_2 = {
		group = 1,
	},
	special_bonus_unique_meepo_3 = {
		group = 1,
	},
	special_bonus_unique_meepo_4 = {
		group = 1,
	},
	special_bonus_unique_meepo_5 = {
		group = 1,
	},
	special_bonus_unique_meepo_6 = {
		group = 1,
	},
	special_bonus_unique_meepo_7 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_2 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_6 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_7 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_8 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_9 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_10 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_11 = {
		group = 1,
	},
	special_bonus_unique_monkey_king_12 = {
		group = 1,
	},
	special_bonus_unique_pangolier_luckyshot_armor = {
		group = 1,
	},
	special_bonus_unique_pangolier = {
		group = 1,
	},
	special_bonus_unique_pangolier_shield_crash_herostacks = {
		group = 1,
	},
	special_bonus_unique_pangolier_2 = {
		group = 1,
	},
	special_bonus_unique_pangolier_3 = {
		group = 1,
	},
	special_bonus_unique_pangolier_4 = {
		group = 1,
	},
	special_bonus_unique_pangolier_5 = {
		group = 1,
	},
	special_bonus_unique_pangolier_6 = {
		group = 1,
	},
	special_bonus_unique_dark_willow_1 = {
		group = 8,
	},
	special_bonus_unique_dark_willow_2 = {
		group = 9,
	},
	special_bonus_unique_dark_willow_3 = {
		group = 9,
	},
	special_bonus_unique_dark_willow_4 = {
		group = 9,
	},
	special_bonus_unique_dark_willow_5 = {
		group = 9,
	},
	special_bonus_unique_dark_willow_6 = {
		group = 9,
	},
	special_bonus_unique_dark_willow_7 = {
		group = 9,
	},
	special_bonus_unique_grimstroke_soul_chain_reflect_damage = {
		group = 1,
	},
	special_bonus_unique_grimstroke_1 = {
		group = 1,
	},
	special_bonus_unique_grimstroke_2 = {
		group = 1,
	},
	special_bonus_unique_grimstroke_3 = {
		group = 1,
	},
	special_bonus_unique_grimstroke_4 = {
		group = 1,
	},
	special_bonus_unique_grimstroke_6 = {
		group = 1,
	},
	special_bonus_unique_grimstroke_7 = {
		group = 1,
	},
	special_bonus_unique_grimstroke_8 = {
		group = 1,
	},
	special_bonus_unique_clockwerk = {
		group = 1,
	},
	special_bonus_unique_clockwerk_2 = {
		group = 1,
	},
	special_bonus_unique_clockwerk_3 = {
		group = 1,
	},
	special_bonus_unique_clockwerk_4 = {
		group = 1,
	},
	special_bonus_unique_clockwerk_5 = {
		group = 1,
	},
	special_bonus_unique_clockwerk_6 = {
		group = 1,
	},
	special_bonus_unique_clockwerk_7 = {
		group = 1,
	},
	special_bonus_unique_clockwerk_9 = {
		group = 1,
	},
	special_bonus_unique_centaur_1 = {
		group = 1,
	},
	special_bonus_unique_centaur_2 = {
		group = 1,
	},
	special_bonus_unique_centaur_3 = {
		group = 1,
	},
	special_bonus_unique_centaur_4 = {
		group = 1,
	},
	special_bonus_unique_centaur_5 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_1 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_2 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_3 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_4 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_5 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_6 = {
		group = 1,
	},
	special_bonus_unique_witch_doctor_7 = {
		group = 1,
	},
	special_bonus_unique_necrophos_heartstopper_regen_duration = {
		group = 1,
	},
	special_bonus_unique_necrophos_sadist_heal_bonus = {
		group = 1,
	},
	special_bonus_unique_necrophos = {
		group = 1,
	},
	special_bonus_unique_necrophos_2 = {
		group = 1,
	},
	special_bonus_unique_necrophos_3 = {
		group = 1,
	},
	special_bonus_unique_necrophos_4 = {
		group = 1,
	},
	special_bonus_unique_necrophos_5 = {
		group = 1,
	},
	special_bonus_unique_necrophos_6 = {
		group = 1,
	},
	special_bonus_unique_mirana_1 = {
		group = 1,
	},
	special_bonus_unique_mirana_2 = {
		group = 1,
	},
	special_bonus_unique_mirana_3 = {
		group = 1,
	},
	special_bonus_unique_mirana_4 = {
		group = 1,
	},
	special_bonus_unique_mirana_5 = {
		group = 1,
	},
	special_bonus_unique_mirana_6 = {
		group = 1,
	},
	special_bonus_unique_mirana_7 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_3 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_4 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_5 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_6 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_7 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_8 = {
		group = 1,
	},
	special_bonus_unique_bounty_hunter_9 = {
		group = 1,
	},
	special_bonus_unique_queen_of_pain_2 = {
		group = 1,
	},
	special_bonus_unique_queen_of_pain_3 = {
		group = 1,
	},
	special_bonus_unique_queen_of_pain_4 = {
		group = 1,
	},
	special_bonus_unique_queen_of_pain_6 = {
		group = 1,
	},
	special_bonus_unique_queen_of_pain_7 = {
		group = 1,
	},
	special_bonus_unique_underlord = {
		group = 1,
	},
	special_bonus_unique_underlord_3 = {
		group = 1,
	},
	special_bonus_unique_underlord_4 = {
		group = 1,
	},
	special_bonus_unique_underlord_5 = {
		group = 1,
	},
	special_bonus_unique_underlord_6 = {
		group = 1,
	},
	special_bonus_unique_underlord_8 = {
		group = 1,
	},
	special_bonus_unique_underlord_9 = {
		group = 1,
	},
	special_bonus_unique_treant_2 = {
		group = 1,
	},
	special_bonus_unique_treant_3 = {
		group = 1,
	},
	special_bonus_unique_treant_7 = {
		group = 1,
	},
	special_bonus_unique_treant_8 = {
		group = 1,
	},
	special_bonus_unique_treant_9 = {
		group = 1,
	},
	special_bonus_unique_treant_11 = {
		group = 1,
	},
	special_bonus_unique_treant_12 = {
		group = 1,
	},
	special_bonus_unique_treant_13 = {
		group = 1,
	},
	special_bonus_unique_razor = {
		group = 9,
	},
	special_bonus_unique_razor_static_link_aspd = {
		group = 1,
	},
	special_bonus_unique_razor_plasmafield_second_ring = {
		group = 1,
	},
	special_bonus_unique_razor_2 = {
		group = 1,
	},
	special_bonus_unique_razor_4 = {
		group = 1,
	},
	special_bonus_unique_razor_5 = {
		group = 1,
	},
	special_bonus_unique_visage_1 = {
		group = 1,
	},
	special_bonus_unique_visage_2 = {
		group = 1,
	},
	special_bonus_unique_visage_3 = {
		group = 1,
	},
	special_bonus_unique_visage_4 = {
		group = 1,
	},
	special_bonus_unique_visage_5 = {
		group = 1,
	},
	special_bonus_unique_visage_6 = {
		group = 1,
	},
	special_bonus_unique_visage_7 = {
		group = 1,
	},
	special_bonus_unique_visage_8 = {
		group = 1,
	},
	special_bonus_unique_void_spirit_dissimilate_outerring = {
		group = 1,
	},
	special_bonus_unique_void_spirit_1 = {
		group = 1,
	},
	special_bonus_unique_void_spirit_2 = {
		group = 1,
	},
	special_bonus_unique_void_spirit_3 = {
		group = 1,
	},
	special_bonus_unique_void_spirit_4 = {
		group = 1,
	},
	special_bonus_unique_void_spirit_7 = {
		group = 1,
	},
	special_bonus_unique_void_spirit_8 = {
		group = 1,
	},
	special_bonus_unique_earthshaker_totem_damage = {
		group = 1,
	},
	special_bonus_unique_earthshaker = {
		group = 1,
	},
	special_bonus_unique_earthshaker_2 = {
		group = 1,
	},
	special_bonus_unique_earthshaker_3 = {
		group = 1,
	},
	special_bonus_unique_earthshaker_4 = {
		group = 1,
	},
	special_bonus_unique_earthshaker_5 = {
		group = 1,
	},
	special_bonus_unique_earthshaker_6 = {
		group = 1,
	},
	special_bonus_unique_lich_1 = {
		group = 1,
	},
	special_bonus_unique_lich_2 = {
		group = 1,
	},
	special_bonus_unique_lich_3 = {
		group = 1,
	},
	special_bonus_unique_lich_4 = {
		group = 1,
	},
	special_bonus_unique_lich_5 = {
		group = 1,
	},
	special_bonus_unique_lich_6 = {
		group = 1,
	},
	special_bonus_unique_lich_7 = {
		group = 1,
	},
	special_bonus_unique_lich_8 = {
		group = 1,
	},
	special_bonus_unique_rubick = {
		group = 1,
	},
	special_bonus_unique_rubick_2 = {
		group = 1,
	},
	special_bonus_unique_rubick_3 = {
		group = 1,
	},
	special_bonus_unique_rubick_4 = {
		group = 1,
	},
	special_bonus_unique_rubick_5 = {
		group = 1,
	},
	special_bonus_unique_rubick_6 = {
		group = 1,
	},
	special_bonus_unique_rubick_7 = {
		group = 1,
	},
	special_bonus_unique_rubick_8 = {
		group = 1,
	},
	special_bonus_unique_primal_beast_onslaught_damage = {
		group = 1,
	},
	special_bonus_unique_primal_beast_trample_magic_resist = {
		group = 1,
	},
	special_bonus_unique_primal_beast_trample_cooldown = {
		group = 1,
	},
	special_bonus_unique_primal_beast_roar_dispells = {
		group = 1,
	},
	special_bonus_unique_primal_beast_trample_attack_damage = {
		group = 1,
	},
	special_bonus_unique_primal_beast_uproar_armor = {
		group = 1,
	},
	special_bonus_unique_primal_beast_pulverize_pierces_magic_immunity = {
		group = 1,
	},
	special_bonus_unique_primal_beast_pulverize_duration = {
		group = 1,
	},
	special_bonus_unique_sven_2 = {
		group = 1,
	},
	special_bonus_unique_sven_3 = {
		group = 1,
	},
	special_bonus_unique_sven_4 = {
		group = 1,
	},
	special_bonus_unique_sven_5 = {
		group = 1,
	},
	special_bonus_unique_sven_6 = {
		group = 1,
	},
	special_bonus_unique_sven_7 = {
		group = 1,
	},
	special_bonus_unique_sven_8 = {
		group = 1,
	},
	special_bonus_unique_dark_seer = {
		group = 1,
	},
	special_bonus_unique_dark_seer_2 = {
		group = 1,
	},
	special_bonus_unique_dark_seer_3 = {
		group = 1,
	},
	special_bonus_unique_dark_seer_5 = {
		group = 1,
	},
	special_bonus_unique_dark_seer_6 = {
		group = 1,
	},
	special_bonus_unique_dark_seer_7 = {
		group = 1,
	},
	special_bonus_unique_dark_seer_13 = {
		group = 1,
	},
	special_bonus_unique_dark_seer_14 = {
		group = 1,
	},
	special_bonus_unique_dazzle_poison_touch_attack_range_bonus = {
		group = 1,
	},
	special_bonus_unique_dazzle_1 = {
		group = 1,
	},
	special_bonus_unique_dazzle_2 = {
		group = 1,
	},
	special_bonus_unique_dazzle_3 = {
		group = 1,
	},
	special_bonus_unique_dazzle_4 = {
		group = 1,
	},
	special_bonus_unique_dazzle_5 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_1 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_2 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_3 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_4 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_5 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_6 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_7 = {
		group = 1,
	},
	special_bonus_unique_shadow_shaman_8 = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_swap_damage = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_missile_castrange = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_1 = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_2 = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_3 = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_4 = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_5 = {
		group = 1,
	},
	special_bonus_unique_vengeful_spirit_9 = {
		group = 1,
	},
	special_bonus_unique_venomancer_poisonsting_regen_reduction = {
		group = 1,
	},
	special_bonus_unique_venomancer_gale_plagueward = {
		group = 1,
	},
	special_bonus_unique_venomancer = {
		group = 1,
	},
	special_bonus_unique_venomancer_2 = {
		group = 1,
	},
	special_bonus_unique_venomancer_3 = {
		group = 1,
	},
	special_bonus_unique_venomancer_4 = {
		group = 1,
	},
	special_bonus_unique_venomancer_5 = {
		group = 1,
	},
	special_bonus_unique_venomancer_8 = {
		group = 1,
	},
	special_bonus_unique_morphling_1 = {
		group = 1,
	},
	special_bonus_unique_morphling_4 = {
		group = 1,
	},
	special_bonus_unique_morphling_6 = {
		group = 1,
	},
	special_bonus_unique_morphling_8 = {
		group = 1,
	},
	special_bonus_unique_morphling_10 = {
		group = 1,
	},
	special_bonus_unique_leshrac_1 = {
		group = 1,
	},
	special_bonus_unique_leshrac_2 = {
		group = 1,
	},
	special_bonus_unique_leshrac_3 = {
		group = 1,
	},
	special_bonus_unique_leshrac_5 = {
		group = 1,
	},
	special_bonus_unique_leshrac_6 = {
		group = 1,
	},
	special_bonus_unique_jakiro_dualbreath_slow = {
		group = 1,
	},
	special_bonus_unique_jakiro = {
		group = 1,
	},
	special_bonus_unique_jakiro_2 = {
		group = 1,
	},
	special_bonus_unique_jakiro_4 = {
		group = 1,
	},
	special_bonus_unique_jakiro_6 = {
		group = 1,
	},
	special_bonus_unique_jakiro_7 = {
		group = 1,
	},
	special_bonus_unique_enigma = {
		group = 1,
	},
	special_bonus_unique_enigma_2 = {
		group = 1,
	},
	special_bonus_unique_enigma_3 = {
		group = 1,
	},
	special_bonus_unique_enigma_4 = {
		group = 1,
	},
	special_bonus_unique_enigma_5 = {
		group = 1,
	},
	special_bonus_unique_enigma_6 = {
		group = 1,
	},
	special_bonus_unique_enigma_9 = {
		group = 1,
	},
	special_bonus_unique_bane_2 = {
		group = 1,
	},
	special_bonus_unique_bane_3 = {
		group = 1,
	},
	special_bonus_unique_bane_5 = {
		group = 1,
	},
	special_bonus_unique_bane_8 = {
		group = 1,
	},
	special_bonus_unique_bane_9 = {
		group = 1,
	},
	special_bonus_unique_bane_10 = {
		group = 1,
	},
	special_bonus_unique_bane_11 = {
		group = 1,
	},
	special_bonus_unique_nevermore_shadowraze_cooldown = {
		group = 1,
	},
	special_bonus_unique_nevermore_raze_procsattacks = {
		group = 1,
	},
	special_bonus_unique_nevermore_1 = {
		group = 1,
	},
	special_bonus_unique_nevermore_2 = {
		group = 1,
	},
	special_bonus_unique_nevermore_3 = {
		group = 1,
	},
	special_bonus_unique_nevermore_6 = {
		group = 1,
	},
	special_bonus_unique_nevermore_7 = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_refraction_damage = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_refraction_disable_cast = {
		group = 1,
	},
	special_bonus_unique_templar_assassin = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_2 = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_3 = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_4 = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_7 = {
		group = 1,
	},
	special_bonus_unique_templar_assassin_8 = {
		group = 1,
	},
	special_bonus_unique_doom_1 = {
		group = 1,
	},
	special_bonus_unique_doom_4 = {
		group = 1,
	},
	special_bonus_unique_doom_6 = {
		group = 1,
	},
	special_bonus_unique_doom_9 = {
		group = 1,
	},
	special_bonus_unique_doom_10 = {
		group = 1,
	},
	special_bonus_unique_doom_11 = {
		group = 1,
	},
	special_bonus_unique_brewmaster = {
		group = 1,
	},
	special_bonus_unique_brewmaster_4 = {
		group = 1,
	},
	special_bonus_unique_brewmaster_5 = {
		group = 1,
	},
	special_bonus_unique_brewmaster_6 = {
		group = 1,
	},
	special_bonus_unique_brewmaster_7 = {
		group = 1,
	},
	special_bonus_unique_brewmaster_8 = {
		group = 1,
	},
	special_bonus_unique_bristleback_2 = {
		group = 1,
	},
	special_bonus_unique_bristleback_3 = {
		group = 1,
	},
	special_bonus_unique_bristleback_5 = {
		group = 1,
	},
	special_bonus_unique_bristleback_6 = {
		group = 1,
	},
	special_bonus_unique_furion = {
		group = 1,
	},
	special_bonus_unique_furion_2 = {
		group = 1,
	},
	special_bonus_unique_furion_3 = {
		group = 1,
	},
	special_bonus_unique_furion_4 = {
		group = 1,
	},
	special_bonus_unique_furion_5 = {
		group = 1,
	},
	special_bonus_unique_furion_6 = {
		group = 1,
	},
	special_bonus_unique_furion_7 = {
		group = 1,
	},
	special_bonus_unique_phoenix_1 = {
		group = 1,
	},
	special_bonus_unique_phoenix_2 = {
		group = 1,
	},
	special_bonus_unique_phoenix_3 = {
		group = 1,
	},
	special_bonus_unique_phoenix_4 = {
		group = 1,
	},
	special_bonus_unique_phoenix_5 = {
		group = 1,
	},
	special_bonus_unique_phoenix_6 = {
		group = 1,
	},
	special_bonus_unique_enchantress_1 = {
		group = 1,
	},
	special_bonus_unique_enchantress_2 = {
		group = 1,
	},
	special_bonus_unique_enchantress_3 = {
		group = 1,
	},
	special_bonus_unique_enchantress_4 = {
		group = 1,
	},
	special_bonus_unique_enchantress_5 = {
		group = 1,
	},
	special_bonus_unique_enchantress_6 = {
		group = 1,
	},
	special_bonus_unique_batrider_1 = {
		group = 1,
	},
	special_bonus_unique_batrider_2 = {
		group = 1,
	},
	special_bonus_unique_batrider_3 = {
		group = 1,
	},
	special_bonus_unique_batrider_4 = {
		group = 1,
	},
	special_bonus_unique_batrider_5 = {
		group = 1,
	},
	special_bonus_unique_batrider_6 = {
		group = 1,
	},
	special_bonus_unique_batrider_7 = {
		group = 1,
	},
	special_bonus_unique_wraith_king_vampiric_skeleton_duration = {
		group = 1,
	},
	special_bonus_unique_wraith_king_2 = {
		group = 1,
	},
	special_bonus_unique_wraith_king_4 = {
		group = 1,
	},
	special_bonus_unique_wraith_king_5 = {
		group = 1,
	},
	special_bonus_unique_wraith_king_6 = {
		group = 1,
	},
	special_bonus_unique_wraith_king_10 = {
		group = 1,
	},
	special_bonus_unique_wraith_king_11 = {
		group = 1,
	},
	special_bonus_unique_kunkka_tidebringer_slow = {
		group = 1,
	},
	special_bonus_unique_kunkka = {
		group = 1,
	},
	special_bonus_unique_kunkka_3 = {
		group = 1,
	},
	special_bonus_unique_kunkka_4 = {
		group = 1,
	},
	special_bonus_unique_kunkka_5 = {
		group = 1,
	},
	special_bonus_unique_kunkka_6 = {
		group = 1,
	},
	special_bonus_unique_kunkka_7 = {
		group = 1,
	},
	special_bonus_unique_invoker_2 = {
		group = 1,
	},
	special_bonus_unique_invoker_3 = {
		group = 1,
	},
	special_bonus_unique_invoker_5 = {
		group = 1,
	},
	special_bonus_unique_invoker_6 = {
		group = 1,
	},
	special_bonus_unique_invoker_9 = {
		group = 1,
	},
	special_bonus_unique_invoker_10 = {
		group = 1,
	},
	special_bonus_unique_invoker_11 = {
		group = 1,
	},
	special_bonus_unique_invoker_13 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_2 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_1 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_3 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_4 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_5 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_6 = {
		group = 1,
	},
	special_bonus_unique_gyrocopter_flak_cannon_bonus_damage = {
		group = 1,
	},
	special_bonus_unique_dragon_knight = {
		group = 1,
	},
	special_bonus_unique_dragon_knight_2 = {
		group = 1,
	},
	special_bonus_unique_dragon_knight_3 = {
		group = 1,
	},
	special_bonus_unique_dragon_knight_7 = {
		group = 1,
	},
	special_bonus_unique_dragon_knight_8 = {
		group = 1,
	},
	special_bonus_unique_dragon_knight_9 = {
		group = 1,
	},
	special_bonus_unique_omniknight_1 = {
		group = 1,
	},
	special_bonus_unique_omniknight_2 = {
		group = 1,
	},
	special_bonus_unique_omniknight_3 = {
		group = 1,
	},
	special_bonus_unique_omniknight_4 = {
    	group = 1,
	},
	special_bonus_unique_omniknight_5 = {
    	group = 1,
	},
	special_bonus_unique_omniknight_6 = {
    	group = 1,
	},
	special_bonus_unique_omniknight_7 = {
    	group = 1,
	},
	special_bonus_unique_wisp = {
		group = 1,
	},
	special_bonus_unique_wisp_3 = {
		group = 1,
	},
	special_bonus_unique_wisp_4 = {
		group = 1,
	},
	special_bonus_unique_wisp_6 = {
		group = 1,
	},
	special_bonus_unique_wisp_8 = {
		group = 1,
	},
	special_bonus_unique_wisp_9 = {
		group = 1,
	},
	special_bonus_unique_wisp_10 = {
		group = 1,
	},
	special_bonus_unique_wisp_11 = {
		group = 1,
	},
	special_bonus_unique_crystal_maiden_frostbite_castrange = {
		group = 1,
	},
	special_bonus_unique_crystal_maiden_1 = {
		group = 1,
	},
	special_bonus_unique_crystal_maiden_2 = {
		group = 1,
	},
	special_bonus_unique_crystal_maiden_3 = {
		group = 1,
	},
	special_bonus_unique_crystal_maiden_5 = {
		group = 1,
	},
	special_bonus_unique_crystal_maiden_6 = {
		group = 1,
	},
	special_bonus_unique_warlock_upheaval_aoe = {
		group = 1,
	},
	special_bonus_unique_warlock_1 = {
		group = 1,
	},
	special_bonus_unique_warlock_2 = {
		group = 1,
	},
	special_bonus_unique_warlock_3 = {
		group = 1,
	},
	special_bonus_unique_warlock_4 = {
		group = 1,
	},
	special_bonus_unique_warlock_5 = {
		group = 1,
	},
	special_bonus_unique_warlock_7 = {
		group = 1,
	},
	special_bonus_unique_warlock_10 = {
		group = 1,
	},
	special_bonus_unique_antimage_manavoid_aoe = {
		group = 7,
	},
	special_bonus_unique_antimage = {
		group = 1,
	},
	special_bonus_unique_antimage_2 = {
		group = 1,
	},
	special_bonus_unique_antimage_3 = {
		group = 1,
	},
	special_bonus_unique_antimage_4 = {
		group = 1,
	},
	special_bonus_unique_antimage_6 = {
		group = 1,
	},
	special_bonus_unique_antimage_7 = {
		group = 1,
	},
	special_bonus_unique_faceless_void = {
		group = 1,
	},
	special_bonus_unique_faceless_void_2 = {
		group = 1,
	},
	special_bonus_unique_faceless_void_3 = {
		group = 1,
	},
	special_bonus_unique_faceless_void_4 = {
		group = 1,
	},
	special_bonus_unique_faceless_void_5 = {
		group = 1,
	},
	special_bonus_unique_faceless_void_6 = {
		group = 1,
	},
	special_bonus_unique_faceless_void_7 = {
		group = 1,
	},
	special_bonus_unique_faceless_void_8 = {
		group = 1,
	},]]
}

table.merge(CUSTOM_TALENTS_DATA, ModuleRequire(..., "native"))

TALENT_GROUP_TO_LEVEL = {
	[1] = 10,
	[2] = 15,
	[3] = 20,
	[4] = 25,
	[5] = 30,
	[6] = 35,
	[7] = 40,
	[8] = 45,
	[9] = 50,
	[10] = 55,
	[11] = 60,
	[12] = 65,
	[13] = 70,
	[14] = 75,
	[15] = 80,
	[18] = 140,
	[19] = 180,
	[20] = 245,
	[21] = 300,
	[22] = 340,
	[23] = 360,
	[24] = 380,
	[25] = 400,
	[26] = 430,
	[27] = 460,
	[28] = 490,
	[29] = 550,
}
	-- [1] = 10, exp;gold_creep;
	-- [2] = 15, mana;regen;gold_min;exp_min;
	-- [3] = 20, armor;mag_resist;
	-- [4] = 25, movespeed;spell_amp;
	-- [5] = 30, cd;evasion;
	-- [6] = 35, ms_limit;
	-- [7] = 40, day;night;
	-- [8] = 45, respawn_time;
	-- [9] = 50, damage;
	-- [10] = 55, truestrike
