-- Percentage
BOSS_DAMAGE_ABILITY_MODIFIERS = {
	zuus_static_field = 5,
	--item_blade_mail = 40,
	--centaur_return = 15,
	enigma_midnight_pulse = 5,
	enigma_black_hole = 5,
	techies_suicide = 25,
	--lina_laguna_blade = 50,
	--lion_finger_of_death = 50,
	--shredder_chakram_2 = 40,
	--shredder_chakram = 40,
	--sniper_shrapnel = 40,
	abyssal_underlord_firestorm = 5,
	--bristleback_quill_spray = 40,
	--centaur_hoof_stomp = 40,
	--centaur_double_edge = 40,
	--kunkka_ghostship = 60,
	--kunkka_torrent = 400,
	--ember_spirit_flame_guard = 400,
	--sandking_sand_storm = 4000,
	--antimage_mana_void = 60,
	doom_bringer_infernal_blade = 5,
	winter_wyvern_arctic_burn = 5,
	freya_ice_cage = 5,
	tinker_march_of_the_machines = 2000,
	necrolyte_reapers_scythe = 5,
	huskar_life_break = 5,
	huskar_burning_spear_arena = 20,
	phantom_assassin_fan_of_knives = 5,
	item_unstable_quasar = 25,
	bloodseeker_blood_mist = 5,
	bloodseeker_bloodrage = 0,
	bloodseeker_rupture = 5,
	venomancer_poison_nova = 5,
}

local function OctarineLifesteal(attacker, victim, inflictor, damage, _, itemname, cooldownModifierName)
	if inflictor and attacker:GetTeam() ~= victim:GetTeam() and not OCTARINE_NOT_LIFESTALABLE_ABILITIES[inflictor:GetAbilityName()] then
		local heal = math.floor(damage * GetAbilitySpecial(itemname, victim:IsHero() and "hero_lifesteal" or "creep_lifesteal") * 0.01)
		if heal >= 1 then
			if not victim:IsIllusion() then
				SafeHeal(attacker, heal, attacker)
			end
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, heal, nil)
			ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
		end

		local item = FindItemInInventoryByName(attacker, itemname, false)
		if item and RollPercentage(GetAbilitySpecial(itemname, "bash_chance")) and not attacker:HasModifier(cooldownModifierName) then
			victim:AddNewModifier(attacker, item, "modifier_stunned", {duration = GetAbilitySpecial(itemname, "bash_duration")})
			item:ApplyDataDrivenModifier(attacker, attacker, cooldownModifierName, {})
		end
	end
end

local function FixedDamageReflect(attacker, victim, inflictor, damage, damagetype_const, modifiername, reflect_pct)
	local ability
	if victim:FindModifierByName(modifiername) and victim:FindModifierByName(modifiername).GetAbility then
		ability = victim:FindModifierByName(modifiername):GetAbility()
	end
	--print(damage)
	--print(attacker.DamageAmpPerAgility)
	if victim:IsAlive() then
		local multiplier = 0
		if inflictor and FilterDamageSpellAmpCondition(inflictor, inflictor:GetAbilityName(), attacker) then
			multiplier = attacker.DamageMultiplier - 1
			--print("blademail spell mult: "..multiplier)
		elseif not inflictor then
			multiplier = attacker.DamageMultiplier - 1
			--print("blademail attack mult: "..multiplier)
		end
		--if multiplier > 1 then
			local reflect_damage = (damage * multiplier * ability:GetSpecialValueFor(reflect_pct) * 0.01)
			--print("blademail total reflect: "..reflect_damage)

			if reflect_damage > 0 then
				ability.NoDamageAmp = true
				ApplyDamage({
					victim = attacker,
					attacker = victim,
					damage = reflect_damage,
					damage_type = damagetype_const,
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
					ability = ability
				})
			end
		--end
	end
end

ON_DAMAGE_MODIFIER_PROCS = {
	modifier_item_octarine_core_arena = function(attacker, victim, inflictor, damage, damagetype_const)
		OctarineLifesteal(attacker, victim, inflictor, damage, damagetype_const, "item_octarine_core_arena", "modifier_octarine_bash_cooldown")
	end,
	modifier_item_refresher_core = function(attacker, victim, inflictor, damage, damagetype_const)
		OctarineLifesteal(attacker, victim, inflictor, damage, damagetype_const, "item_refresher_core", "modifier_octarine_bash_cooldown")
	end,
	modifier_sara_evolution = function(attacker, victim, _, damage)
		local ability = attacker:FindAbilityByName("sara_evolution")
		if ability and attacker.ModifyEnergy then
			attacker:ModifyEnergy(damage * ability:GetSpecialValueFor("damage_to_energy_pct") * 0.01, true)
		end
	end,
	modifier_item_golden_eagle_relic = function(attacker, _, inflictor, damage)
		if not IsValidEntity(inflictor) then
			local LifestealPercentage = GetAbilitySpecial("item_golden_eagle_relic", "lifesteal_pct")
			local lifesteal = damage * LifestealPercentage * 0.01
			SafeHeal(attacker, lifesteal)
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
		end
	end
}

ON_DAMAGE_MODIFIER_PROCS_VICTIM = {
	modifier_item_holy_knight_shield = function(attacker, victim, inflictor, damage) if inflictor then
		local item = FindItemInInventoryByName(victim, "item_holy_knight_shield", false)
		if item and RollPercentage(GetAbilitySpecial("item_holy_knight_shield", "buff_chance")) and victim:GetTeam() ~= attacker:GetTeam() then
			if item:PerformPrecastActions() then
				item:ApplyDataDrivenModifier(victim, victim, "modifier_item_holy_knight_shield_buff", {})
			end
		end
	end end,

	--[[modifier_stamina = function(attacker, parent, inflictor, damage)
		if not inflictor and (attacker:IsHero() or attacker:IsIllusion()) and not attacker:IsBoss() and parent:GetFullName() ~= "npc_arena_hero_saitama"  then
			damage = damage * STAMINA_TAKING_DAMAGE_DECREASE_PERCENT * 0.01
			if parent:GetFullName() == "npc_arena_hero_shinobu" then damage = damage * 6 end
            parent:ModifyStamina(-damage)
		end
	end,]]

	--[[modifier_freya_pain_reflection = function(attacker, victim, inflictor, damage, damagetype_const)
		FixedDamageReflect(attacker, victim, inflictor, damage, damagetype_const, "modifier_freya_pain_reflection", "damage_return_pct")
	end,
	modifier_item_blade_mail_arena_active = function(attacker, victim, inflictor, damage, damagetype_const)
		FixedDamageReflect(attacker, victim, inflictor, damage, damagetype_const, "modifier_item_blade_mail_arena_active", "reflected_damage_pct")
	end,
	modifier_item_sacred_blade_mail_active = function(attacker, victim, inflictor, damage, damagetype_const)
		FixedDamageReflect(attacker, victim, inflictor, damage, damagetype_const, "modifier_item_sacred_blade_mail_active", "reflected_damage_pct")
	end,
	modifier_nyx_assassin_spiked_carapace = function(attacker, victim, inflictor, damage, damagetype_const)
		local mod = victim:FindModifierByName("modifier_nyx_assassin_spiked_carapace")
		mod.AttackersTakedDamage = {}
		if not mod.AttackersTakedDamage[attacker:GetFullName()] then
			mod.AttackersTakedDamage[attacker:GetFullName()] = true
			FixedDamageReflect(attacker, victim, inflictor, damage, damagetype_const, "modifier_nyx_assassin_spiked_carapace", "damage_reflect_pct")
		end
	end,]]
	--[[modififer_sara_conceptual_reflection = function(attacker, victim, inflictor, damage, damagetype_const)
		FixedDamageReflect(attacker, victim, inflictor, damage, damagetype_const, "modififer_sara_conceptual_reflection", "reflected_damage")
	end,]]
}

OUTGOING_DAMAGE_MODIFIERS = {
	--[[modifier_arena_rune_arcane = {
		condition = function(_, _, inflictor)
			return inflictor
		end,
		multiplier = 1.5
	},]]
	--[[modifier_stamina = function(attacker, _, inflictor)
		local mod = attacker:FindModifierByName("modifier_stamina")
		if mod:GetStackCount() == 0 and not inflictor then
			return 1 - STAMINA_DAMAGE_DECREASE_PCT * 0.01
		end
	end,]]
	--[[modifier_item_octarine_core_arena = function(attacker, victim, inflictor)
		if inflictor and attacker:GetTeam() ~= victim:GetTeam() and not OCTARINE_NOT_LIFESTALABLE_ABILITIES[inflictor:GetAbilityName()] then
			return {
				SpellLifestealPercentage = GetAbilitySpecial("item_octarine_core_arena", victim:IsHero() and "hero_lifesteal" or "creep_lifesteal")
			}
		end
	end,
	modifier_item_refresher_core = function(attacker, victim, inflictor)
		if inflictor and not inflictor.NoSpellLifesteal and attacker:GetTeam() ~= victim:GetTeam() and not OCTARINE_NOT_LIFESTALABLE_ABILITIES[inflictor:GetAbilityName()] then
			return {
				SpellLifestealPercentage = GetAbilitySpecial("item_refresher_core", victim:IsHero() and "hero_lifesteal" or "creep_lifesteal")
			}
		end
	end,]]
	modifier_muerta_pierce_the_veil_buff = function(attacker, victim, inflictor, damage, damagetype_cons)
		if not inflictor and damagetype_cons == DAMAGE_TYPE_PHYSICAL then
			if victim:IsMagicImmune() then
				return 0
			end
			--print(victim:GetPhysicalArmorValue(false))
			return 1 - victim:GetMagicalArmorValue()
		end
	end,
	--[[modifier_death_prophet_spirit_siphon = function(attacker, victim, inflictor)
		if inflictor and inflictor:GetAbilityName() == "death_prophet_spirit_siphon" then
			return {
				SpellLifestealPercentage = 100,
				SpellLifestealStackable = true,
				DontShowParticleAndHealNumber = true,
			}
		end
	end,]]
	modifier_kadash_strike_from_shadows = {
		condition = function(_, _, inflictor)
			return not inflictor
		end,
		multiplier = function(attacker, victim, _, damage)
			local kadash_strike_from_shadows = attacker:FindAbilityByName("kadash_strike_from_shadows")
			attacker:RemoveModifierByName("modifier_kadash_strike_from_shadows")
			attacker:RemoveModifierByName("modifier_invisible")
			if kadash_strike_from_shadows then

				kadash_strike_from_shadows.NoDamageAmp = true
				ApplyDamage({
					victim = victim,
					attacker = attacker,
					damage = damage * kadash_strike_from_shadows:GetAbilitySpecial("magical_damage_pct") * 0.01,
					damage_type = kadash_strike_from_shadows:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					ability = kadash_strike_from_shadows
				})
				kadash_strike_from_shadows:ApplyDataDrivenModifier(attacker, victim, "modifier_kadash_strike_from_shadows_debuff", nil)
				return 0
			end
		end
	},
	--[[modifier_item_piercing_blade = {
		condition = function(attacker, _, inflictor)
			return not inflictor and not attacker:HasModifier("modifier_item_soulcutter")
		end,
		multiplier = function()
			return 1 - GetAbilitySpecial("item_piercing_blade", "attack_damage_to_pure_pct") * 0.01
		end
	},]]
	--[[modifier_item_soulcutter = {
		condition = function(_, _, inflictor)
			return not inflictor
		end,
		multiplier = function()
			return 1 - GetAbilitySpecial("item_soulcutter", "attack_damage_to_pure_pct") * 0.01
		end
	},]]
	modifier_sai_release_of_forge = {
		condition = function(_, _, inflictor)
			return not inflictor
		end,
		multiplier = function(attacker)
			local ability = attacker:FindAbilityByName("sai_release_of_forge")
			local pct = ability:GetSpecialValueFor("pure_damage_pct") * 0.01
			return 1 - pct
		end
	},
	modifier_anakim_wisps = {
		condition = function(_, _, inflictor)
			return not inflictor
		end,
		multiplier = function()
			return 0
		end
	},

	modifier_strength_crit = function(parent, victim, inflictor, damage)
		local modifier = parent:FindModifierByName("modifier_strength_crit")
		if inflictor and
		inflictor.GetAbilityName and
		not SPELL_CRIT_EXEPTIONS[inflictor:GetAbilityName()] and
		FilterDamageSpellAmpCondition(inflictor, inflictor:GetAbilityName(), parent) and
		modifier.ready then
			local mult = (1 + modifier.strengthCriticalDamage * 0.01) / STRENGTH_CRIT_SPELL_CRIT_DECREASRE_MULT
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, damage * mult, nil)
			modifier:cancel(parent)
			return mult
		end
	end,

	modifier_talent_lifesteal = function(attacker, _, inflictor)
		if not IsValidEntity(inflictor) then
			return {
				LifestealPercentage = attacker:GetModifierStackCount("modifier_talent_lifesteal", caster)
			}
		end
	end,

	modifier_intelligence_primary_bonus = {
		multiplier = function(attacker, victim)
			local mod = attacker:FindModifierByName("modifier_intelligence_primary_bonus")
			if not mod then return 1 end
			local max_bonus = INTELLECT_PRIMARY_BONUS_MAX_BONUS
			local difference = INTELLECT_PRIMARY_BONUS_DIFF_FOR_MAX_MULT
			if mod.util_ then
				max_bonus = max_bonus * INTELLECT_PRIMARY_BONUS_UPGRADE_MULT
				difference = difference / INTELLECT_PRIMARY_BONUS_UPGRADE_DIFF_MULT
			end
			if (victim:IsTrueHero() or victim:IsIllusion()) and (attacker:IsTrueHero() or attacker:IsIllusion()) then
				local attackerInt = (attacker:GetUniversalAttribute() or attacker:GetIntellect())
				local victimInt = victim:GetIntellect()
				local diff

				if attackerInt <= victimInt then
					mod:SetStackCount(0)
					return 1
				end

				if attackerInt > victimInt then
					diff = attackerInt / victimInt
					if diff >= difference then
						mod:SetStackCount(math.round(max_bonus))
						return 1 + max_bonus * 0.01
					else
						diff = 1 - victimInt / attackerInt
						mod:SetStackCount(math.round(max_bonus * diff))
						return 1 + max_bonus * 0.01 * diff
					end
				end
			elseif (attacker:IsTrueHero() or attacker:IsIllusion()) then
				mod:SetStackCount(math.round((max_bonus / INTELLECT_PRIMARY_BONUS_ON_CREEPS_DECREASE)))
				return 1 + (max_bonus / INTELLECT_PRIMARY_BONUS_ON_CREEPS_DECREASE) * 0.01
			end
		end
	},

	modifier_arena_hero = {
		multiplier = function(_, victim, inflictor)
			if inflictor then
				if inflictor.GetAbilityName and
				(inflictor:GetAbilityName() == "leshrac_diabolic_edict" --or
				--inflictor:GetAbilityName() == "bloodseeker_blood_mist"
				) then
					if victim:IsMagicImmune() then
						return 0
					end
					--print(victim:GetMagicalArmorValue())
					return 1 - victim:GetMagicalArmorValue()
				end
			end
		end
	},
}

INCOMING_DAMAGE_MODIFIERS = {
	--[[modifier_item_radiance_lua_effect = {
		multiplier = function(_, victim, inflictor)
			if inflictor and inflictor:GetAbilityName() == "item_radiance_frozen" and victim:GetFullName() == "npc_dota_neutral_jungle_variant1" then
				return GetAbilitySpecial("item_radiance_frozen", "jungle_bears_damage_mult")
			end
		end
	},]]
	--[[modifier_nyx_assassin_spiked_carapace = {
		multiplier = function(attacker, victim, _, damage, damagetype_const)
			local mod = victim:FindModifierByName("modifier_nyx_assassin_spiked_carapace")
			mod.AttackersDoingDamage = {}
			if not mod.AttackersDoingDamage[attacker:GetFullName()] then
				mod.AttackersDoingDamage[attacker:GetFullName()] = true
				return 0
			end
		end
	},]]
	modifier_item_pipe_of_enlightenment_team_buff = {
		multiplier = function(_, victim, _, damage, damagetype_const)
			--if not mod then return 1 end
			if damagetype_const ~= DAMAGE_TYPE_MAGICAL then return 1 end

			local mod = victim:FindModifierByName("modifier_item_pipe_of_enlightenment_team_buff")
			local stacks = mod:GetStackCount()

        	if stacks > damage then
            	mod:SetStackCount(math.round(stacks - damage))
            	return 0
       		else
            	Timers:NextTick(function() mod:Destroy() end)
            	return 1 - stacks / damage
       		end
		end
	},
	modifier_mirratie_sixth_sense = {
		multiplier = function(_, victim)
			local mirratie_sixth_sense = victim:FindAbilityByName("mirratie_sixth_sense")
			if mirratie_sixth_sense and victim:IsAlive() and RollPercentage(mirratie_sixth_sense:GetAbilitySpecial("dodge_chance_pct")) and not victim:PassivesDisabled() then
				ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
				return 0
			end
		end
	},
	modifier_item_blade_mail_arena_active = {
		multiplier = function(_, victim)
			local modifier = victim:FindModifierByNameAndCaster("modifier_item_blade_mail_arena_active", victim)
			if modifier and IsValidEntity(modifier:GetAbility()) then
				return 1 - modifier:GetAbility():GetAbilitySpecial("reduced_damage_pct") * 0.01
			end
		end
	},
	modifier_item_sacred_blade_mail_active = {
		multiplier = function()
			return 1 - GetAbilitySpecial("item_sacred_blade_mail", "reduced_damage_pct") * 0.01
		end
	},
	modifier_saber_instinct = {
		multiplier = function(attacker, victim, inflictor, damage)
			local saber_instinct = victim:FindAbilityByName("saber_instinct")
			if not IsValidEntity(inflictor) and saber_instinct and victim:IsAlive() and not victim:PassivesDisabled() then
				if attacker:IsRangedUnit() then
					if RollPercentage(saber_instinct:GetAbilitySpecial("ranged_evasion_pct")) then
						local victimPlayer = victim:GetPlayerOwner()
						local attackerPlayer = attacker:GetPlayerOwner()

						SendOverheadEventMessage(victimPlayer, OVERHEAD_ALERT_EVADE, victim, damage, attackerPlayer)
						SendOverheadEventMessage(attackerPlayer, OVERHEAD_ALERT_MISS, victim, damage, victimPlayer)
						ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
						return false
					end
				else
					if RollPercentage(saber_instinct:GetAbilitySpecial("melee_block_chance")) then
						local blockPct = saber_instinct:GetAbilitySpecial("melee_damage_pct") * 0.01
						return {
							BlockedDamage = blockPct * damage,
						}
					end
				end
			end
		end
	},
	modifier_sara_fragment_of_armor = {
		multiplier = function(attacker, victim, inflictor, damage)
			local sara_fragment_of_armor = victim:FindAbilityByName("sara_fragment_of_armor")
			if sara_fragment_of_armor and not victim:IsIllusion() and victim:IsAlive() and not victim:PassivesDisabled() and victim.GetEnergy and sara_fragment_of_armor:GetToggleState() then
				local blocked_damage_pct = sara_fragment_of_armor:GetAbilitySpecial("blocked_damage_pct") * 0.01
				local mana_needed = (damage * blocked_damage_pct) / sara_fragment_of_armor:GetAbilitySpecial("damage_per_energy")
				if victim:GetEnergy() >= mana_needed then
					victim:EmitSound("Hero_Medusa.ManaShield.Proc")
					victim:ModifyEnergy(-mana_needed)
					local particleName = "particles/arena/units/heroes/hero_sara/fragment_of_armor_impact.vpcf"
					local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, victim)
					ParticleManager:SetParticleControl(particle, 0, victim:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
					return 1 - blocked_damage_pct
				end
			end
		end
	},
	modifier_arena_healer = {
		damage = function (_, _, inflictor)
			if not inflictor or inflictor:GetAbilityName() ~= "item_meteor_hammer" then
				return 1
			end
		end
	},
	modifier_anakim_transfer_pain = {
		multiplier = function(attacker, victim, inflictor, damage)
			local anakim_transfer_pain = victim:FindAbilityByName("anakim_transfer_pain")
			if anakim_transfer_pain and victim:IsAlive() then
				local transfered_damage_pct = anakim_transfer_pain:GetAbilitySpecial("transfered_damage_pct")
				local radius = anakim_transfer_pain:GetAbilitySpecial("radius")
				local dealt_damage = damage * transfered_damage_pct * 0.01
				local summonTable = victim.custom_summoned_unit_ability_anakim_summon_divine_knight

				if summonTable and IsValidEntity(summonTable[1]) and summonTable[1]:IsAlive() and (summonTable[1]:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D() <= radius then
					ApplyDamage({
						attacker = attacker,
						victim = summonTable[1],
						ability = anakim_transfer_pain,
						damage = dealt_damage,
						damage_type = DAMAGE_TYPE_PURE
					})
					return 1 - transfered_damage_pct * 0.01
				end
			end
		end
	},
	modifier_item_timelords_butterfly = {
		multiplier = function(_, victim)
			if victim:IsAlive() and not victim:IsMuted() and RollPercentage(GetAbilitySpecial("item_timelords_butterfly", "dodge_chance_pct")) then
				ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
				return false
			end
		end
	},
	modifier_intelligence_primary_bonus = {
		multiplier = function(attacker, victim)
			local mod = attacker:FindModifierByName("modifier_intelligence_primary_bonus")
			if not mod then return end
			local max_bonus = INTELLECT_PRIMARY_BONUS_MAX_BONUS
			local difference = INTELLECT_PRIMARY_BONUS_DIFF_FOR_MAX_MULT
			if mod.util_ then
				max_bonus = max_bonus * INTELLECT_PRIMARY_BONUS_UPGRADE_MULT
				difference = difference / INTELLECT_PRIMARY_BONUS_UPGRADE_DIFF_MULT
			end
			if victim:IsTrueHero() and (attacker:IsTrueHero() or attacker:IsIllusion()) then
				local attackerInt = attacker:GetIntellect()
				local victimInt = (victim:GetUniversalAttribute() or victim:GetIntellect())
				local diff

				if attackerInt >= victimInt then
					mod:SetStackCount(0)
					 return 1
				end

				if attackerInt < victimInt then
					diff = victimInt / attackerInt
					if diff >= difference then
						mod:SetStackCount(math.round(max_bonus))
						return 1 - max_bonus * 0.01
					else
						diff = 1 - attackerInt / victimInt
						mod:SetStackCount(math.round(max_bonus * diff))
						return 1 - max_bonus * 0.01 * diff
					end
				end
			elseif victim:IsTrueHero() then
				mod:SetStackCount(math.round(max_bonus / INTELLECT_PRIMARY_BONUS_ON_CREEPS_DECREASE))
				return 1 - (max_bonus / INTELLECT_PRIMARY_BONUS_ON_CREEPS_DECREASE) * 0.01
			end
		end
	},

	--[[modifier_strength_crit = {
		multiplier = function(_, victim)
			local parent = victim
			local strength = parent:GetStrength() - parent:GetBaseStrength() + CalculateStatForLevel(parent, 0, STAT_GAIN_LEVEL_LIMIT) + (parent:GetKeyValue("AttributeBaseStrength") or 0)
			local mult = DAMAGE_DECREASE_PER_STRENGTH * strength
			if mult > STRENGTH_MAX_DAMAGE_DECREASE then mult = STRENGTH_MAX_DAMAGE_DECREASE end

			--return 1 - mult * 0.01
		end
	},]]

	modififer_sara_conceptual_reflection = {
		multiplier = function(_, victim, _, damage)
			local modifier = victim:FindModifierByName("modififer_sara_conceptual_reflection")
			if modifier then
				local ability = modifier:GetAbility()
				if not ability:GetAutoCastState() then return 1 end
				if modifier:GetStackCount() == 0 then return 1 end
				if victim:PassivesDisabled() then return 1 end
				local health_to_proc = victim:GetMaxHealth() * ability:GetSpecialValueFor("max_health_damage_proc") * 0.01
				if damage <= health_to_proc then
					return 1 - ability:GetSpecialValueFor("damage_decrease") * 0.01
				elseif damage > health_to_proc then
					return 1 - ability:GetSpecialValueFor("reflection_damage_decrease") * 0.01
				end
			end
		end
	}
}

CREEP_BONUSES_MODIFIERS = {
	modifier_item_golden_eagle_relic = {
		gold = GetAbilitySpecial("item_golden_eagle_relic", "kill_gold"),
		xp = GetAbilitySpecial("item_golden_eagle_relic", "kill_xp")
	},

	modifier_item_skull_of_midas = {
		gold = GetAbilitySpecial("item_skull_of_midas", "kill_gold"),
		xp = GetAbilitySpecial("item_skull_of_midas", "kill_xp")
	},

	modifier_talent_creep_gold = function(self)
		local modifier = self:FindModifierByName("modifier_talent_creep_gold")
		if modifier then
			return {gold = modifier:GetStackCount()}
		end
	end
}
