modifier_arena_hero = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

function modifier_arena_hero:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_ABILITY_LAYOUT,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		--MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
		--MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		--MODIFIER_EVENT_ON_ATTACK_START,
		--MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_arena_hero:GetModifierAbilityLayout()
	return self.VisibleAbilitiesCount or self:GetSharedKey("VisibleAbilitiesCount") or 4
end

function modifier_arena_hero:GetModifierBaseAttack_BonusDamage()
	if not self.primary then return 0 end
	return -self.primary + self.custom_base_damage
end

function modifier_arena_hero:GetModifierSpellAmplify_Percentage()
	local value = CustomNetTables:GetTableValue("attributes_helper", self:GetName()).IntellectSpellDamage
	if not value then return 0 end
	return self:GetParent():GetIntellect() * value
end

function modifier_arena_hero:GetModifierAttackSpeedBonus_Constant()
	return self.ret_as or 0
end

--health regen remove
function modifier_arena_hero:GetModifierConstantHealthRegen()
	local parent = self:GetParent()
	return 1.2 - parent:GetStrength() * .1
end

function modifier_arena_hero:GetModifierConstantManaRegen()
	return 0.8
end

function modifier_arena_hero:GetModifierMoveSpeedBonus_Percentage()
	local _AGILITY_BONUS_MS = CustomNetTables:GetTableValue("attributes_helper", self:GetName())["AgilityBonusMovementSpeed"]
	local _AGILITY_LEVEL_LIMIT = CustomNetTables:GetTableValue("attributes_helper", self:GetName())["AgilityLevelLimit"]
	if not _AGILITY_LEVEL_LIMIT or not _AGILITY_BONUS_MS then return 0 end
	local parent = self:GetParent()
	local agility_per_level = 0
		if parent.CustomGain_Agility then
			if parent:GetLevel() <= _AGILITY_LEVEL_LIMIT then
				agility_per_level = parent:GetLevel() * parent:GetNetworkableEntityInfo("AttributeAgilityGain")
			else
				agility_per_level = _AGILITY_LEVEL_LIMIT * parent:GetNetworkableEntityInfo("AttributeAgilityGain")
			end
		else
			if parent:GetLevel() <= _AGILITY_LEVEL_LIMIT then
				agility_per_level = parent:GetLevel() * parent:GetNetworkableEntityInfo("AttributeAgilityGain")
			else
				agility_per_level = _AGILITY_LEVEL_LIMIT * parent:GetNetworkableEntityInfo("AttributeAgilityGain")
			end
		end
	local bonus_ms = ((parent:GetAgility() - (parent:GetNetworkableEntityInfo("AttributeBaseAgility") or 0) + (agility_per_level or 0)) * (_AGILITY_BONUS_MS or 0))
	return bonus_ms
end

--[[function modifier_arena_hero:GetModifierMagicalResistanceDirectModification()
	return self.resistanceDifference or self:GetSharedKey("resistanceDifference") or 0
end]]

if IsServer() then
	modifier_arena_hero.HeroLevel = 1
	function modifier_arena_hero:OnCreated()
		local parent = self:GetParent()
		self._tick = 0

		CustomNetTables:SetTableValue("attributes_helper", self:GetName(), {
			AgilityLevelLimit = AGILITY_LEVEL_LIMIT,
			AgilityBonusMovementSpeed = AGILITY_BONUS_MS,
			IntellectSpellDamage = INTELLECT_SPELL_DAMAGE_AMPLIFY
		})

		self.RegenExeptions = function()
			if parent:HasItemInInventory("item_heart") then
				--print(parent:FindItemInInventoryByName("item_heart"):GetSpecialValueFor("health_regen_pct"))
				self.regen = self.regen - (FindItemInInventoryByName(parent, "item_heart", false, false, true):GetSpecialValueFor("health_regen_pct") or 0) * parent:GetMaxHealth() * 0.01
			end
			for _,v in pairs(REGEN_EXEPTIONS) do
				--if self._tick % 150 == 0 then print(#REGEN_EXEPTIONS) end
				--if self._tick % 150 == 0 then print(v[1]..", "..v[2]) end
				local modifier = parent:FindModifierByName(v[1])
				if modifier then
					local hp_reg_pct
					local ability = modifier:GetAbility()
					if v[1] == "modifier_huskar_berserkers_blood" then
						hp_reg_pct = ability:GetSpecialValueFor(v[2]) * parent:GetStrength() * 0.01
						self.regen = self.regen - hp_reg_pct
					else
						hp_reg_pct = ability:GetSpecialValueFor(v[2]) * parent:GetMaxHealth() * 0.01
						self.regen = self.regen - hp_reg_pct
					end
				end
			end
		end

		self.tick = 1/20
		self:StartIntervalThink(self.tick)

		parent:SetNetworkableEntityInfo("IntellectPrimaryBonusMultiplier", INTELLECT_PRIMARY_BONUS_MAX_BONUS)
		parent:SetNetworkableEntityInfo("IntellectPrimaryBonusDifference", INTELLECT_PRIMARY_BONUS_DIFF_FOR_MAX_MULT)

		parent:SetNetworkableEntityInfo("AttributeAgilityGain", parent:GetAgilityGain())
		parent:SetNetworkableEntityInfo("AttributeStrengthGain", parent:GetStrengthGain())
		parent:SetNetworkableEntityInfo("AttributeIntelligenceGain", parent:GetIntellectGain())

		if parent.ArenaHero then 
			parent:SetNetworkableEntityInfo("PrimaryAttribute", _G[NPC_HEROES_CUSTOM[parent:GetFullName()]["AttributePrimary"]])
			return
		end
		parent:SetNetworkableEntityInfo("PrimaryAttribute", parent:GetPrimaryAttribute())
	end

	function modifier_arena_hero:OnIntervalThink()
		self._tick = self._tick + 1
		local parent = self:GetParent()
		local evolution = parent:FindModifierByName("modifier_sara_evolution") and parent:FindModifierByName("modifier_sara_evolution"):GetAbility() or nil

		local hl = parent:GetLevel()
		if hl > self.HeroLevel  then
			if not parent:IsIllusion() and not parent:IsTempestDouble() then
				for level = self.HeroLevel + 1, hl do
					if LEVELS_WITHOUT_ABILITY_POINTS[level] or level > 25 then
						parent:SetAbilityPoints(parent:GetAbilityPoints() + 1)
					end
				end
			end


			local diff = hl - self.HeroLevel
			self.HeroLevel = hl
			--print("Adding str, agi, int, times: ", parent.CustomGain_Strength, parent.CustomGain_Agility, parent.CustomGain_Intelligence, diff)
			if parent.CustomGain_Strength then
				parent:ModifyStrength((parent.CustomGain_Strength - parent:GetKeyValue("AttributeStrengthGain", nil, true)) * diff)
			end
			if parent.CustomGain_Intelligence then
				parent:ModifyIntellect((parent.CustomGain_Intelligence - parent:GetKeyValue("AttributeIntelligenceGain", nil, true)) * diff)
			end
			if parent.CustomGain_Agility then
				parent:ModifyAgility((parent.CustomGain_Agility - parent:GetKeyValue("AttributeAgilityGain", nil, true)) * diff)
			end
		end

		--удаление неуязвимости от фонтана
		if parent:HasModifier("modifier_fountain_invulnerability") then
			--print("destroy")
			parent:FindModifierByName("modifier_fountain_invulnerability"):Destroy()
		end

		local VisibleAbilitiesCount = 0
		for i = 0, parent:GetAbilityCount() - 1 do
			local ability = parent:GetAbilityByIndex(i)
			if ability and not ability:IsHidden() and not ability:GetAbilityName():starts("special_bonus_") then
				VisibleAbilitiesCount = VisibleAbilitiesCount + 1
			end
		end
		if self.VisibleAbilitiesCount ~= VisibleAbilitiesCount then
			self.VisibleAbilitiesCount = VisibleAbilitiesCount
			self:SetSharedKey("VisibleAbilitiesCount", VisibleAbilitiesCount)
		end

		--mana regen
		--self.ManaRegenAmplify = MANA_REGEN_AMPLIFY * parent:GetIntellect()
		local ManaRegenAmp = parent:GetBonusManaRegen() * (parent:GetIntellect() * MANA_REGEN_AMPLIFY) * 0.01
		if not evolution then
			parent:SetBaseManaRegen(0.9 - parent:GetIntellect() * 0.05 + ManaRegenAmp)
			parent:SetNetworkableEntityInfo("ManaRegen", tostring(__toFixed(parent:GetManaRegen(), 1)))
		end
		parent:SetNetworkableEntityInfo("ManaRegenAmplify", ManaRegenAmp)

		--health regen remove
		local HPRegenAmplify = STRENGTH_REGEN_AMPLIGY * parent:GetStrength()
		self.regen = parent:GetHealthRegen()

		--fix percent regen
		self:RegenExeptions()
		local allModifiers = parent:FindAllModifiers()
		for _,v in pairs(allModifiers) do
			local tick = self._tick / 30
			--if self._tick % 150 == 0 then print("["..tostring(tick / 5 - 2).."] "..v:GetName()) end
			--if self._tick % 150 == 0 then print("["..tostring(tick).."] "..tostring(v)) end
			if (v:GetName() == "modifier_sai_release_of_forge_final_regeneration") then
				self.regen = self.regen - v:GetModifierConstantHealthRegen()
			end
			local declare
			if v.DeclareFunctions then
				declare = v:DeclareFunctions()
				local _hp_reg_pct = 0
				for _,i in ipairs(declare) do if i == 87 then _hp_reg_pct = v:GetModifierHealthRegenPercentage() end end
				self.regen = self.regen - _hp_reg_pct * parent:GetMaxHealth() * 0.01
			end
		end
		--fix health regen amplify
		for k,v in pairs(HP_REGEN_AMP) do
			if parent:HasItemInInventory(v[1]) then
				local item = FindItemInInventoryByName(parent, v[1], false, false, true)
				if item then
					local amp = item:GetSpecialValueFor(v[2]) * parent:GetHealthRegen() * 0.01
					self.regen = self.regen - amp
				end
			end
		end
		--fix sara regen amplify
		if parent:FindModifierByName("modifier_sara_regeneration_active") then
			local modifier = parent:FindModifierByName("modifier_sara_regeneration_active")
			self.regen = self.regen - modifier.Regen
		end
		self.regen = self.regen * HPRegenAmplify * 0.01
		parent:Heal(self.regen * self.tick, nil)
		parent:SetNetworkableEntityInfo("HealtRegenAmplify", HPRegenAmplify)
		parent:SetNetworkableEntityInfo("HealthRegen", tostring(__toFixed(self.regen + parent:GetHealthRegen(), 1)))

		--custom base armor
		local agility_per_level = 0
		if parent.CustomGain_Agility then
			if parent:GetLevel() <= AGILITY_LEVEL_LIMIT then
				agility_per_level = parent:GetLevel() * parent.CustomGain_Agility
			else
				agility_per_level = AGILITY_LEVEL_LIMIT * parent.CustomGain_Agility
			end
		else
			if parent:GetLevel() <= AGILITY_LEVEL_LIMIT then
				agility_per_level = parent:GetLevel() * parent:GetAgilityGain()
			else
				agility_per_level = AGILITY_LEVEL_LIMIT * parent:GetAgilityGain()
			end
		end

		local agilityArmor = parent:GetAgility() * (AGILITY_ARMOR_BASE_COEFF)
		local current_stamina = (1 - parent:GetStamina() / parent:GetMaxStamina()) * STAMINA_ARMOR_DECREASE_MULT * 0.01

		local agilityForArmor
		if parent.ArenaHero and parent.Custom_AttributeBaseAgility then
			agilityForArmor = parent:GetAgility() - parent:GetBaseAgility() + agility_per_level + (parent.Custom_AttributeBaseAgility / (AGILITY_ARMOR_COEFF / AGILITY_ARMOR_BASE_COEFF))
		else
			agilityForArmor = parent:GetAgility() - parent:GetBaseAgility() + agility_per_level + (parent:GetKeyValue("AttributeBaseAgility") / (AGILITY_ARMOR_COEFF / AGILITY_ARMOR_BASE_COEFF))
		end

			--drow ranger fix
		if parent:HasModifier("modifier_drow_ranger_marksmanship_aura_bonus") then 
			local marksmanship = parent:FindModifierByName("modifier_drow_ranger_marksmanship_aura_bonus"):GetAbility()
			local marksmanshipAgilityBonus = parent:GetBaseAgility() * marksmanship:GetSpecialValueFor("agility_multiplier") * 0.01
			if marksmanshipAgilityBonus > 120 then
				agilityForArmor = agilityForArmor - marksmanshipAgilityBonus + 120
			end
		end
			--slark fix
		if parent:HasModifier("modifier_slark_essence_shift") then 
			local essenceshiftModifier = parent:FindModifierByName("modifier_slark_essence_shift")
			local essenceshift = essenceshiftModifier:GetAbility()
			local essenceshiftAgilityBonus = essenceshiftModifier:GetStackCount() * essenceshift:GetSpecialValueFor("agi_gain")
			if essenceshiftAgilityBonus > 250 then
				agilityForArmor = agilityForArmor - essenceshiftAgilityBonus + 250
			end
		end

		if agilityForArmor < 0 then agilityForArmor = 0 end
		local newArmor = agilityForArmor * (AGILITY_ARMOR_COEFF)

		if evolution then
			local SARA_ARMOR_COEFF = 1 / evolution:GetAbilitySpecial("armor_per_agility")
			newArmor = agilityForArmor * (SARA_ARMOR_COEFF)
		end

		if newArmor < 0 then newArmor = 0 end
		local decreaseArmor = newArmor * current_stamina
		parent:SetPhysicalArmorBaseValue((newArmor - agilityArmor - decreaseArmor) + parent:GetKeyValue("ArmorPhysical") + (evolution and evolution:GetAbilitySpecial("bonus_base_armor") or 0))
		parent:SetNetworkableEntityInfo("IdealArmor", newArmor)
		parent:SetNetworkableEntityInfo("AttributeBaseAgility", parent:GetBaseAgility())
		--print(newArmor)

		--custom attack speed
		local custom_as = parent:GetAgility() - parent:GetBaseAgility() + agility_per_level + parent:GetKeyValue("AttributeBaseAgility")
			--butterfly fix
		if parent:HasModifier("modifier_item_timelords_butterfly_evasion") then
			local butterflyModififer = parent:FindModifierByName("modifier_item_timelords_butterfly_evasion")
			local butterfly = butterflyModififer:GetAbility()
			local butterflyAgilityBonus = butterfly:GetSpecialValueFor("bonus_agility_active") * parent:GetBaseAgility() * 0.01
			custom_as = custom_as + butterflyAgilityBonus
		end

		--panorama 
		parent:SetNetworkableEntityInfo("BaseAttackTime", parent:GetBaseAttackTime())
		self.ret_as = -parent:GetAgility() + custom_as
		parent:SetNetworkableEntityInfo("CustomAttackSpeed", parent:GetAttackSpeed())
		parent:SetNetworkableEntityInfo("AgilityAttackSpeed", custom_as)

		--custom base damage
		self.primary = parent:GetPrimaryStatValue()
		self.custom_base_damage = math.round(parent:GetStrength())
		parent:SetNetworkableEntityInfo("CustomBaseDamage", self.custom_base_damage)

		--int spell damage
		parent:SetNetworkableEntityInfo("IntellectSpellAmplify", parent:GetIntellect() * INTELLECT_SPELL_DAMAGE_AMPLIFY)

		--agility bonus ms
		parent:SetNetworkableEntityInfo("AgilityBonusMovementSpeed", (parent:GetAgility() - parent:GetBaseAgility() + agility_per_level) * AGILITY_BONUS_MS)

		if not evolution then
			parent:SetNetworkableEntityInfo("CurrentMana", tostring(math.round(parent:GetMana())))
			parent:SetNetworkableEntityInfo("MaxMana", tostring(math.round(parent:GetMaxMana())))
		end
	end

	function modifier_arena_hero:OnAttack(keys)
		local attacker = keys.attacker
		local target = keys.target
		--[[if not attacker:IsRangedUnit() then return end
		local lockName = "_lock_modifier_arena_hero"
		if attacker[lockName] then return end
		attacker[lockName] = true
		Timers:NextTick(function() attacker[lockName] = false end)]]

		local targets = FindUnitsInRadius(
			attacker:GetTeam(),
			target:GetAbsOrigin(),
			nil,
			250, --radius
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
		)

		local projInfo = GenerateAttackProjectile(attacker, nil)
		for _,v in ipairs(targets) do
			if v ~= target and not v:IsAttackImmune() then
				projInfo.Target = v
				if projectileSpeedSpecialName then
					projInfo.iMoveSpeed = ability:GetSpecialValueFor(projectileSpeedSpecialName)
				end

				ProjectileManager:CreateTrackingProjectile(projInfo)
			end
		end
	end

	function modifier_arena_hero:OnAttackLanded(keys)
		local attacker = keys.attacker
		local target = keys.target

		--bounty hunter jinada fix
		if attacker == self:GetParent() and not attacker:IsIllusion() and attacker:FindModifierByName("modififer_bounty_hunter_jinada") then
			local ability = attacker:FindAbilityByName("bounty_hunter_jinada")
			if attacker.GetTeam() ~= target:GetTeam() and target:IsRealHero() then
				local steal = ability:GetAbilitySpecial("gold_steal")
				local target_gold = Gold:GetGold(target.GetPlayerID())
				Gold:ModifyGold(target, -math.min(steal, target_gold))
				Gold:ModifyGold(attacker, math.min(steal, target_gold))
			end
		end

		--splash
		if attacker == self:GetParent() and not (
		attacker:GetFullName() == "npc_dota_hero_tidehunter" or
		attacker:GetFullName() == "npc_dota_hero_mars" or
		attacker:GetFullName() == "npc_dota_hero_monkey_king" or
		attacker:GetFullName() == "npc_dota_hero_sven" or
		attacker:GetFullName() == "npc_dota_hero_magnataur" or
		attacker:GetFullName() == "npc_dota_hero_kunkka" or
		attacker:GetFullName() == "npc_dota_hero_medusa" or
		attacker:GetFullName() == "npc_dota_hero_luna" or
		attacker:GetFullName() == "npc_dota_hero_templar_assassin" or
		attacker:GetFullName() == "npc_dota_hero_tiny" or
		attacker:GetFullName() == "npc_dota_hero_pangolier" or
		attacker:GetFullName() == "npc_dota_hero_ember_spirit") and not
		(attacker:HasItemInInventory("item_nagascale_bow") or
		attacker:HasItemInInventory("item_splitshot_ultimate") or
		attacker:HasItemInInventory("item_quelling_fury") or
		attacker:HasItemInInventory("item_battlefury_arena") or
		attacker:HasItemInInventory("item_elemental_fury") or
		attacker:HasItemInInventory("item_ultimate_splash"))
		then
			if not attacker:IsRangedUnit() then
				DoCleaveAttack(
					attacker,
					target,
					ability,
					keys.damage * 0.15,
					440, --distance
					100, --start
					250, --end
					"particles/items_fx/battlefury_cleave.vpcf"
				)
			else
				local targets = FindUnitsInRadius(
					attacker:GetTeam(),
					target:GetAbsOrigin(),
					nil,
					250, --radius
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					false
				)
				for _,v in pairs(targets) do
					ApplyDamage({
						attacker = attacker,
						victim = v,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						damage = attacker:GetAverageTrueAttackDamage(v) * 0.1,
						damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
						ability = nil
					})
				end
			end
		end
	end

	function modifier_arena_hero:OnDeath(k)
		local parent = self:GetParent()

		--bounty hunter track fix
		--[[if k.unit == parent and parent:HasModififer("modifier_bounty_hunter_track") and parent.GetPlayerID ~= nil then
			local ability = k.attacker:FindAbilityByName("bounty_hunter_jinada")
			local bonus_allies = ability:GetAbilitySpecial("bonus_gold")
			local bonus_self = ability:GetAbilitySpecial("bonus_gold_self")
			local radius = ability:GetAbilitySpecial("bonus_gold_radius")
			local allies = FindUnitsInRadius(
					k.attacker:GetTeam(),
					target:GetAbsOrigin(),
					nil,
					radius, --radius
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					false
				)
		end]]

		if k.attacker == parent and k.unit:IsCreep() then
			local gold = 0
			local xp = 0
			for k,v in pairs(CREEP_BONUSES_MODIFIERS) do
				if parent:HasModifier(k) then
					local gxp = type(v) == "function" and v(parent) or v
					if gxp then
						gold = math.max(gold, gxp.gold or 0)
						xp = math.max(xp, gxp.xp or 0)
					end
				end
			end
			if gold > 0 then
				Gold:ModifyGold(parent, gold)
				local particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN, k.unit, parent:GetPlayerOwner())
				ParticleManager:SetParticleControl(particle, 1, Vector(0, gold, 0))
				ParticleManager:SetParticleControl(particle, 2, Vector(2, string.len(gold) + 1, 0))
				ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))
			end
			if xp > 0 then
				parent:AddExperience(xp, false, false)
			end
		end
		if k.unit == parent then
			parent:RemoveNoDraw()

			if parent:IsIllusion() then
				parent:ClearNetworkableEntityInfo()
			end
		end
	end

	function modifier_arena_hero:OnRespawn(k)
		if k.unit == self:GetParent() and k.unit:GetUnitName() == "npc_dota_hero_crystal_maiden" then
			k.unit:AddNoDraw()
			Timers:CreateTimer(0.1, function() k.unit:RemoveNoDraw() end)
		end
	end

	function modifier_arena_hero:OnAbilityExecuted(keys)
		if self:GetParent() == keys.unit then
			local ability_cast = keys.ability
			local abilityname = ability_cast ~= nil and ability_cast:GetAbilityName()
			local caster = self:GetParent()
			local target = keys.target or caster:GetCursorPosition()
			if caster.talents_ability_multicast and caster.talents_ability_multicast[abilityname] then
				for i = 1, caster.talents_ability_multicast[abilityname] - 1 do
					Timers:CreateTimer(0.1*i, function()
						if IsValidEntity(caster) and IsValidEntity(ability_cast) then
							CastAdditionalAbility(caster, ability_cast, target, 0, {})
						end
					end)
				end
			end
		end
	end

	function modifier_arena_hero:OnAbilityEndChannel(keys)
		local parent = self:GetParent()
		local endChannelListeners = parent.EndChannelListeners
		if not endChannelListeners then return end
		for _, v in ipairs(endChannelListeners) do
			v(keys.fail_type < 0)
		end
		parent.EndChannelListeners = {}
	end

	function modifier_arena_hero:OnDestroy()
		if IsValidEntity(self.reflect_stolen_ability) then
			self.reflect_stolen_ability:RemoveSelf()
		end
	end
	function modifier_arena_hero:GetReflectSpell(keys)
		local parent = self:GetParent()
		if parent:IsIllusion() then return end
		local originalAbility = keys.ability
		self.absorb_without_check = false
		if originalAbility:GetCaster():GetTeam() == parent:GetTeam() then return end
		if SPELL_REFLECT_IGNORED_ABILITIES[originalAbility:GetAbilityName()] then return end

		local item_lotus_sphere = FindItemInInventoryByName(parent, "item_lotus_sphere", false, false, true)

		if not self.absorb_without_check and item_lotus_sphere and parent:HasModifier("modifier_item_lotus_sphere") and item_lotus_sphere:PerformPrecastActions() then
			ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/arena/items_fx/lotus_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent), 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			parent:EmitSound("Item.LotusOrb.Activate")
			self.absorb_without_check = true
		end

		if self.absorb_without_check then
			if IsValidEntity(self.reflect_stolen_ability) then
				self.reflect_stolen_ability:RemoveSelf()
			end
			local hCaster = self:GetParent()
			local hAbility = hCaster:AddAbility(originalAbility:GetAbilityName())
			if hAbility then
				hAbility:SetStolen(true)
				hAbility:SetHidden(true)
				hAbility:SetLevel(originalAbility:GetLevel())
				hCaster:SetCursorCastTarget(originalAbility:GetCaster())
				hAbility:OnSpellStart()
				hAbility:SetActivated(false)
				self.reflect_stolen_ability = hAbility
			end
		end
	end
	function modifier_arena_hero:GetAbsorbSpell(keys)
		local parent = self:GetParent()
		if self.absorb_without_check then
			self.absorb_without_check = nil
			return 1
		end
		return false
	end
end
