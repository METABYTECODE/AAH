if not Attributes then
	Attributes = {
        Heroes = {}
    }
end

function Attributes:RegenExeptions(parent, custom_regen, parent_info)
    --fix percent regen
    --print("debug2")
    local amp = 0
    local allModifiers = parent:FindAllModifiers()
    for _,v in pairs(allModifiers) do
        if (v:GetName() == "modifier_sai_release_of_forge_final_regeneration") then
            custom_regen = custom_regen - v:GetModifierConstantHealthRegen()
        end
        if (v:GetName() == "modifier_sara_regeneration_active") then
            custom_regen = custom_regen - (v:GetModifierConstantHealthRegen() or v.Regen)
        end
        local declare
        if v.DeclareFunctions then
            declare = v:DeclareFunctions()
            local _hp_reg_pct = 0
            for _,i in ipairs(declare) do if i == 87 then _hp_reg_pct = v:GetModifierHealthRegenPercentage() end end
            custom_regen = custom_regen - _hp_reg_pct * parent:GetMaxHealth() * 0.01

            for _,i in ipairs(declare) do if i == MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE then amp = amp + v:GetModifierHPRegenAmplify_Percentage() end end

            
        end
    end
    if FindItemInInventoryByName(parent, "item_heart", false, false, true) then
        custom_regen = custom_regen - (FindItemInInventoryByName(parent, "item_heart", false, false, true):GetSpecialValueFor("health_regen_pct") or 0) * parent:GetMaxHealth() * 0.01
    end
    for _,v in pairs(REGEN_EXEPTIONS) do
        local modifier = parent:FindModifierByName(v[1])
        if modifier then
            local hp_reg_pct
            local ability = modifier:GetAbility()
            if v[1] == "modifier_huskar_berserkers_blood" then
                hp_reg_pct = ability:GetSpecialValueFor(v[2]) * parent:GetStrength() * 0.01
                custom_regen = custom_regen - hp_reg_pct
            elseif ability then
                hp_reg_pct = ability:GetSpecialValueFor(v[2]) * parent:GetMaxHealth() * 0.01
                custom_regen = custom_regen - hp_reg_pct
            end
        end
    end
    --fix health regen amplify
    for _,v in pairs(HP_REGEN_AMP) do
        if FindItemInInventoryByName(parent, v[1], false, false, true) then
            local item = FindItemInInventoryByName(parent, v[1], false, false, true)
            amp = amp + item:GetSpecialValueFor(v[2])
        end
    end
    local regen = parent:GetHealthRegen()
    amp = 1 + amp * 0.01
    regen = regen - regen / amp
    local HPRegenAmplify = (parent_info.HpRegenAmp or STRENGTH_REGEN_AMPLIFY) * parent:GetStrength()
    custom_regen = (custom_regen - regen) * (HPRegenAmplify)
    return custom_regen
end

function Attributes:CalculateRegen(parent, parent_info)
   --health regen
   --print("debug3")
    Timers:NextTick(function()
        local HPRegenAmplify = (parent_info.HpRegenAmp or STRENGTH_REGEN_AMPLIFY) * parent:GetStrength()
        local custom_regen = parent:GetHealthRegen() - parent:GetBaseHealthRegen()
        custom_regen = Attributes:RegenExeptions(parent, custom_regen, parent_info)
        parent:SetBaseHealthRegen((parent_info.BaseHealthRegen or 1.2) + custom_regen)
        parent:SetNetworkableEntityInfo("HealtRegenAmplify", 1 + HPRegenAmplify)
    end)
end

function Attributes:FountainFix(parent)
    --print("debug4")
    if not parent:IsAlive() then return end
    if parent:FindModifierByName("modifier_fountain_aura_arena") then
        parent:FindModifierByName("modifier_fountain_aura_arena"):Destroy()
        parent:AddNewModifier(parent, nil, "modifier_fountain_aura_arena", nil)
    else
        parent:AddNewModifier(parent, nil, "modifier_fountain_aura_arena", {not_on_fountain = true})
        parent:FindModifierByName("modifier_fountain_aura_arena"):Destroy()
    end
end

function Attributes:UpdateStrength(parent)
    --print("debug5")
    if not parent then return end
    local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
    if not parent_info then return end

    --strength crit
    if parent.FindModifierByName and parent:FindModifierByName("modifier_strength_crit") then

    local mod = parent:FindModifierByName("modifier_strength_crit")
        local multiplier
        local coeff = (parent:GetUniversalAttribute() or parent:GetStrength()) / STRENGTH_CRIT_THRESHOLD

		if tostring(parent:GetPrimaryAttribute()) == parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and not mod._util then
			mod._util = true
			mod.decrease_coeff = STRENGTH_CRIT_DECREASE_COEFF / 1.2
			mod.crit_mult = STRENGTH_CRIT_MULTIPLIER * 1.5
			mod._strength = (parent:GetUniversalAttribute() or parent:GetStrength()) - 1
		elseif tostring(parent:GetPrimaryAttribute()) ~= parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and mod._util then
			mod._util = false
			mod.crit_mult = STRENGTH_CRIT_MULTIPLIER
			mod.decrease_coeff = STRENGTH_CRIT_DECREASE_COEFF
			mod._strength = (parent:GetUniversalAttribute() or parent:GetStrength()) - 1
		end

        if coeff >= 1 then
            local strength_diff = (parent:GetUniversalAttribute() or parent:GetStrength()) - STRENGTH_CRIT_THRESHOLD
            multiplier = (STRENGTH_CRIT_THRESHOLD * mod.crit_mult) + (strength_diff * math.min(mod.crit_mult, mod.crit_mult / (coeff * mod.decrease_coeff)))
        else
            multiplier = (parent:GetUniversalAttribute() or parent:GetStrength()) * mod.crit_mult
        end

        mod.strengthCriticalDamage = STRENGTH_BASE_CRIT + multiplier
        mod:SetStackCount(100 + math.round(mod.strengthCriticalDamage))
        parent:SetNetworkableEntityInfo("StrengthMagicCrit", mod.strengthCriticalDamage / STRENGTH_CRIT_SPELL_CRIT_DECREASRE_MULT)
        parent:SetNetworkableEntityInfo("StrengthCrit", 100 + mod.strengthCriticalDamage)
        parent:SetNetworkableEntityInfo("StrengthCritCooldown", mod:calculateCooldown())

        --[[local strength = parent:GetStrength() - parent:GetBaseStrength() + CalculateStatForLevel(parent, 0, 60) + (parent:GetKeyValue("AttributeBaseStrength") or 0)
        local mult = DAMAGE_DECREASE_PER_STRENGTH * strength
        if mult > STRENGTH_MAX_DAMAGE_DECREASE then mult = STRENGTH_MAX_DAMAGE_DECREASE end
        parent:SetNetworkableEntityInfo("StrengthDamageDecrease", mult)]]
    end

    --health

		parent:SetNetworkableEntityInfo("StrHealth", parent:GetStrength() * (parent_info.HealthPerStrength or 20))
		--self:FountainFix(parent)

    --regen
		self:CalculateRegen(parent, parent_info)

	--base damage

		if parent_info.primary_base_damage == 0 then
            local str = NPC_HEROES_CUSTOM[parent:GetFullName()].AttributeBaseStrength or parent:GetKeyValue("AttributeBaseStrength") or 16
            local ag = NPC_HEROES_CUSTOM[parent:GetFullName()].AttributeBaseAgility or parent:GetKeyValue("AttributeBaseAgility") or 16
            local int = NPC_HEROES_CUSTOM[parent:GetFullName()].AttributeBaseIntelligence or parent:GetKeyValue("AttributeBaseIntelligence") or 16

			if parent:GetFullName() ~= "npc_dota_hero_target_dummy" then

			if parent:GetPrimaryAttribute() == 1 then
				parent_info.primary_base_damage = ag - str
			end
			if parent:GetPrimaryAttribute() == 2 then
				parent_info.primary_base_damage = int - str
			end
            if parent:GetPrimaryAttribute() == 3 then
                parent_info.primary_base_damage = (str + ag + int) * DAMAGE_PER_ATTRIBUTE_FOR_UNIVERSALES - str
            end
			end
		end

		parent:SetNetworkableEntityInfo("CustomBaseDamage", parent:GetStrength() * (parent_info.BaseDamagePerStrength or 1))

        local custom_base_damage = -parent:GetPrimaryStatValue() + parent:GetStrength() * (parent_info.BaseDamagePerStrength or 1) + (parent_info.primary_base_damage or 1)
        --print("custom_base_damage: "..custom_base_damage)
        --print("primary_base_damage: "..parent_info.primary_base_damage)
        --print('total: '..parent_info._BaseDamageMin + custom_base_damage)
        parent:SetBaseDamageMin(parent_info._BaseDamageMin + custom_base_damage)
        parent:SetBaseDamageMax(parent_info._BaseDamageMax + custom_base_damage)

        parent:SetNetworkableEntityInfo("BaseDamageMin", parent:GetBaseDamageMin())
        parent:SetNetworkableEntityInfo("BaseDamageMax", parent:GetBaseDamageMax())
end

function Attributes:UpdateAgility(parent)
    --print("debug6")
    if not parent then return end
    local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
    if not parent_info then return end

    if parent.FindModifierByName and parent:FindModifierByName("modifier_agility_primary_bonus") then

        local mod = parent:FindModifierByName("modifier_agility_primary_bonus")
        mod.bonusAttacksCount = AGILITY_BONUS_ATTACKS_BASE_COUNT

        local base_requirement = mod.requirement
        local current_requirement = base_requirement
        local max_bonus_attacks = AGILITY_BONUS_ATTACKS_THRESHOULD

        if tostring(parent:GetPrimaryAttribute()) == parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and not mod._util then
            mod._util = true
            mod.requirement = math.round(AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK / 4)
            mod.agility = (parent:GetUniversalAttribute() or parent:GetAgility()) - 1
        elseif tostring(parent:GetPrimaryAttribute()) ~= parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and mod._util then
            mod._util = false
            mod.requirement = AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK
            mod.agility = (parent:GetUniversalAttribute() or parent:GetAgility()) - 1
        end

        for i = 1, math.round(parent:GetUniversalAttribute() or parent:GetAgility()) do
            if i % current_requirement == 0 then
                mod.bonusAttacksCount = mod.bonusAttacksCount + 1
                if mod.bonusAttacksCount >= max_bonus_attacks then
                    base_requirement = math.round(base_requirement * AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK_GROWTH_MULTIPLIER)
                    max_bonus_attacks = max_bonus_attacks + 1
                end
                current_requirement = current_requirement + base_requirement
            end
        end
        parent:SetNetworkableEntityInfo("bonus_attacks_requirement", base_requirement)
        parent:SetNetworkableEntityInfo("agility_for_next_bonus_attack", current_requirement)
        mod:SetStackCount(mod.bonusAttacksCount)
        if (parent:GetUniversalAttribute() or parent:GetAgility()) <= 0 then
            mod.bonusAttacksCount = 1
        end
        if mod._bonusAttacksCount ~= mod.bonusAttacksCount then
            parent:SetNetworkableEntityInfo("AgilityBonusAttacks", mod.bonusAttacksCount)
            mod._bonusAttacksCount = mod.bonusAttacksCount
        end

        if mod._level ~= parent:GetLevel() then
            mod._level = parent:GetLevel()
            parent:SetNetworkableEntityInfo("AgilityBonusChance", mod:calculateChance())
        end
    end

		local agility_per_level = CalculateStatForLevel(parent, DOTA_ATTRIBUTE_AGILITY, STAT_GAIN_LEVEL_LIMIT)
		local bonus_agility = parent:GetAgility() - parent:GetBaseAgility()

		local talent = parent:FindModifierByName("modifier_talent_bonus_all_stats")
		if talent then bonus_agility = bonus_agility - talent:GetStackCount() end
        

		--damage multiplier
		local damage_mult = 1 + parent:GetAgility() * (parent_info.DamageAmpPerAgility or AGILITY_DAMAGE_AMPLIFY)
		parent.DamageMultiplier = damage_mult
		parent:SetNetworkableEntityInfo("IntellectSpellAmplify", damage_mult)

		--custom base armor
		local agilityArmor = parent:GetAgility() * (AGILITY_ARMOR_BASE_COEFF)
		local agilityForArmor
		local agilityArmorCoeff = 1 / parent_info.AgilityArmorMultiplier
        
		agilityForArmor = bonus_agility + agility_per_level + ((parent.Custom_AttributeBaseAgility or parent:GetKeyValue("AttributeBaseAgility")) / (agilityArmorCoeff / AGILITY_ARMOR_BASE_COEFF))

		if agilityForArmor < 0 then agilityForArmor = 0 end
		local newArmor = agilityForArmor * (agilityArmorCoeff)

		if newArmor < 0 then newArmor = 0 end
		if newArmor > AGILITY_MAX_BASE_ARMOR_COUNT then newArmor = AGILITY_MAX_BASE_ARMOR_COUNT end
        local evolution = parent:FindModifierByName("modifier_sara_evolution") and parent:FindModifierByName("modifier_sara_evolution"):GetAbility() or nil
		local armor = (newArmor - agilityArmor) + parent:GetKeyValue("ArmorPhysical") + (evolution and evolution:GetAbilitySpecial("bonus_base_armor") or 0)
			parent:SetPhysicalArmorBaseValue(armor)
			parent:SetNetworkableEntityInfo("IdealArmor", newArmor)
			parent:SetNetworkableEntityInfo("AttributeBaseAgility", parent:GetBaseAgility())
			--print(newArmor)

		--custom attack speed
		local custom_as = math.max(0, bonus_agility + agility_per_level + (parent.Custom_AttributeBaseAgility or parent:GetKeyValue("AttributeBaseAgility"))) * ATTACK_SPEED_PER_AGILITY
		if custom_as > AGILITY_MAX_ATTACK_SPEED_COUNT then custom_as = AGILITY_MAX_ATTACK_SPEED_COUNT end
        parent:SetNetworkableEntityInfo("ReturnedAttackSpeed", -parent:GetAgility() + custom_as)
		parent:SetNetworkableEntityInfo("AgilityAttackSpeed", custom_as)

        --stamina

        local stamina = parent:FindModifierByName("modifier_stamina")

        if stamina then
            stamina:UpdateMaxStamina(parent, STAMINA_PER_AGILITY * parent:GetAgility())
        end
end

function Attributes:UpdateIntelligence(parent)
    --print("debug7")
    if not parent then return end
    local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
    if not parent_info then return end

    --mana 
	parent:SetNetworkableEntityInfo("IntMana", math.max(0, parent:GetIntellect() * (parent_info.ManaPerInt or BASE_MANA_PER_INT)))

    Attributes:UpdateManaRegen(parent)
end

function Attributes:UpdateManaRegen(parent)
    --print("debug8")
    --mana regen
    local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
    if not parent_info then return end
		local intellect = parent:GetIntellect() - parent:GetBaseIntellect()

		--local talent = parent:FindModifierByName("modifier_talent_bonus_all_stats")
		--if talent then intellect = intellect - talent:GetStackCount() end

		local intellect_regen = (intellect + CalculateStatForLevel(parent, DOTA_ATTRIBUTE_INTELLECT, STAT_GAIN_LEVEL_LIMIT) + (parent:GetKeyValue("AttributeBaseIntelligence") or 0)) * 0.025
		if intellect_regen > 25 then intellect_regen = 25 end
		parent:SetNetworkableEntityInfo("IntellectManaRegen", intellect_regen)

		local ManaRegenAmp = (parent:GetIntellect() * parent_info.ManaRegAmpPerInt)

		--[[if parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
			ManaRegenAmp = ManaRegenAmp / NON_INTELLECT_BONUSES_DECREASE_MULT
		end]]

        local evolution = parent:FindModifierByName("modifier_arena_hero").evolution
		if not evolution then
			local BaseManaRegen = (parent:GetBonusManaRegen() + intellect_regen) * ManaRegenAmp
			parent:SetBaseManaRegen(0.9 - parent:GetIntellect() * 0.05 + BaseManaRegen)
			parent:SetNetworkableEntityInfo("ManaRegen", (__toFixed(parent:GetManaRegen(), 1)))
			parent:SetNetworkableEntityInfo("ManaRegenAmplify", 1 + (ManaRegenAmp or 0))
		elseif evolution then
			parent:SetNetworkableEntityInfo("ManaRegenAmplify", 1 + (ManaRegenAmp or 0))
		end
end

function Attributes:UpdateAll(parent)
    --print("debug9")
    local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
    --[[print(parent_info)
    print(type(parent_info))
    if type(parent_info) == "table" then for k,v in ipairs(parent_info) do
        print("key: "..k)
        print("value: "..v)
    end end]]
    if not parent_info then return end

    Timers:NextTick(function()
        self:UpdateStrength(parent)
        self:UpdateAgility(parent)
        self:UpdateIntelligence(parent)
    end)
end