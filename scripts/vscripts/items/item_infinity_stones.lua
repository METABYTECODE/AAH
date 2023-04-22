LinkLuaModifier("modifier_power_stone", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mind_stone", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_time_stone", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_stone", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reality_stone", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_space_stone", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_soul_stone_vision", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_soul_stone_active", "items/item_infinity_stones.lua", LUA_MODIFIER_MOTION_NONE)
--[[modifier_soul_stone_active = class({
	IsPurgable            = function() return false end,
	IsHidden              = function() return true end,
	IsAura                = function() return true end,
	GetAuraRadius         = function() return 99999 end,
})
function modifier_soul_stone_active:GetModifierAura()
	return "modifier_soul_stone_vision"
end]]

item_power_stone = class({
    GetIntrinsicModifierName = function() return "modifier_power_stone" end,
})
item_time_stone = class({
    GetIntrinsicModifierName = function() return "modifier_time_stone" end,
})

item_soul_stone = class({
    GetIntrinsicModifierName = function() return "modifier_soul_stone" end,
})
if IsServer() then
    function item_soul_stone:OnSpellStart()
        local caster = self:GetCaster()
        caster:AddNewModifier(caster, self, "modifier_soul_stone_active", {duration = self:GetSpecialValueFor("duration")})
    end
end

item_mind_stone = class({
    GetIntrinsicModifierName = function() return "modifier_mind_stone" end,
})
item_reality_stone = class({
    GetIntrinsicModifierName = function() return "modifier_reality_stone" end,
})
item_space_stone = class({
    GetIntrinsicModifierName = function() return "modifier_space_stone" end,
})

infinity_stone_base = {
    RemoveOnDeath = function() return false end,
	IsHidden      = function() return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMAMENT end,
	IsPurgable    = function() return false end,
}

function infinity_stone_base:DeclareFunctions()
    local table = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return table
end

modifier_power_stone = class(infinity_stone_base)
function modifier_power_stone:GetModifierHealthBonus()
    return self:GetParent():GetStrength() * (self.bonus_health or 0)
end
function modifier_power_stone:GetModifierBaseAttack_BonusDamage()
    local strength = self:GetParent():GetStrength() -- self:GetAbility():GetSpecialValueFor("bonus_strength")
	--return strength * self:GetAbility():GetSpecialValueFor("bonus_base_damage_per_strength")
end
function modifier_power_stone:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end
if IsServer() then
    function modifier_power_stone:OnCreated()
        local parent = self:GetParent()
        if parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_STRENGTH then
            local m = parent:AddNewModifier(parent, nil, "modifier_strength_crit", nil)
            Attributes:UpdateStrength(parent)
        end
        Timers:NextTick(function()
            local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
            if not parent_info then return end
            self.bonus_health = parent_info.HealthPerStrength * self:GetAbility():GetSpecialValueFor("bonus_hp_per_strength") * 0.01
            parent_info.HealthPerStrength = parent_info.HealthPerStrength + self.bonus_health

            self.bonus_damage = parent_info.BaseDamagePerStrength * self:GetAbility():GetSpecialValueFor("bonus_base_damage_per_strength") * 0.01
            parent_info.BaseDamagePerStrength = parent_info.BaseDamagePerStrength + self.bonus_damage
            Attributes:UpdateStrength(parent)
            parent:CalculateStatBonus(true)
        end)

        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", "0")
    end

    function modifier_power_stone:OnDestroy()
        local parent = self:GetParent()
        local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
if not parent_info then return end
        if parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_STRENGTH then
            if parent:FindModifierByName("modifier_strength_crit") then
                parent:RemoveModifierByName("modifier_strength_crit")
            end
            if parent:FindModifierByName("modifier_strength_crit_true_strike") then
                parent:RemoveModifierByName("modifier_strength_crit_true_strike")
            end
        end
        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", nil)

        parent_info.HealthPerStrength = parent_info.HealthPerStrength - self.bonus_health
        parent_info.BaseDamagePerStrength =  parent_info.BaseDamagePerStrength - self.bonus_damage

        Attributes:UpdateStrength(parent)
        parent:CalculateStatBonus(true)
    end
end

modifier_time_stone = class(infinity_stone_base)
function modifier_time_stone:GetModifierStatusResistanceCaster()
	return -self:GetAbility():GetSpecialValueFor("bonus_status_resist_pct")
end
function modifier_time_stone:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end
if IsServer() then
    function modifier_time_stone:OnCreated()
        local parent = self:GetParent()
        parent:AddNewModifier(parent, nil, "modifier_agility_primary_bonus", nil)
        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", "1")
        Attributes:UpdateAgility(parent)
        self.value = 0
        self:StartIntervalThink(1 / 30)
    end

    function modifier_time_stone:OnIntervalThink()
        local parent = self:GetParent()
        local agility = parent:GetAgility() - parent:GetBaseAgility() + CalculateStatForLevel(parent, DOTA_ATTRIBUTE_AGILITY, STAT_GAIN_LEVEL_LIMIT) + parent:GetKeyValue("AttributeBaseAgility") - self:GetAbility():GetSpecialValueFor("bonus_agility")
        local max_agility = self:GetAbility():GetSpecialValueFor("max_agility")
        if agility > max_agility then agility = max_agility end
        if self.agility ~= agility then
            local value = agility * (self:GetAbility():GetSpecialValueFor("bat_decrease_per_100_agility") / 100)
            local stamina = parent:FindModifierByName("modifier_stamina")
            self.agility = agility
            --print(value)
            if stamina then
                stamina.outside_change_bat = stamina.outside_change_bat + self.value
                stamina.outside_change_bat = stamina.outside_change_bat - value
            end
            self.value = value
        end
    end
    function modifier_time_stone:OnDestroy()
        local parent = self:GetParent()
        if parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_AGILITY then
            if parent:FindModifierByName("modifier_agility_primary_bonus") then
                parent:RemoveModifierByName("modifier_agility_primary_bonus")
                Attributes:UpdateAgility(parent)
            end
        end
        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", nil)
        Attributes:UpdateAgility(parent)
        local stamina = parent:FindModifierByName("modifier_stamina")
        if stamina then
            stamina.outside_change_bat = stamina.outside_change_bat + self.value
        end
    end
end

modifier_mind_stone = class(infinity_stone_base)
function modifier_mind_stone:GetModifierSpellAmplify_Percentage()
	--return self:GetParent():GetIntellect() * self:GetAbility():GetSpecialValueFor("bonus_spell_damage_per_int")
end
function modifier_mind_stone:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end
function modifier_mind_stone:GetModifierBaseAttack_BonusDamage()
    local intellect = self:GetParent():GetIntellect()
	return intellect * self:GetAbility():GetSpecialValueFor("bonus_base_damage_per_int")
end
if IsServer() then
    function modifier_mind_stone:OnCreated()
        local parent = self:GetParent()
        if parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
            Timers:NextTick(function()
                parent:AddNewModifier(parent, nil, "modifier_intelligence_primary_bonus", nil)
            end)
        end
        --self.mult_bonus = parent.DamageAmpPerAgility * self:GetAbility():GetSpecialValueFor("bonus_spell_damage_mult_per_int_pct") * 0.01
        --parent.DamageAmpPerAgility = parent.DamageAmpPerAgility + self.mult_bonus
        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", "2")
        Attributes:UpdateIntelligence(parent)
    end
    function modifier_mind_stone:OnDestroy()
        local parent = self:GetParent()
        if parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
            if parent:FindModifierByName("modifier_intelligence_primary_bonus") then
                parent:RemoveModifierByName("modifier_intelligence_primary_bonus")
            end
        end

        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", nil)
        Attributes:UpdateIntelligence(parent)
    end
end

modifier_soul_stone = class(infinity_stone_base)
function modifier_soul_stone:GetModifierStatusResistanceStacking()
    local stat = self:GetParent():GetNetworkableEntityInfo("BonusStat") or 0
	return self:GetAbility():GetSpecialValueFor("status_resist_per_primary") * stat
end
function modifier_soul_stone:GetModifierBonusStats_Strength()
    if self:GetParent():GetNetworkableEntityInfo("PrimaryAttribute") ~= "0" then return end
    return self:GetAbility():GetSpecialValueFor("bonus_primary_stat")
end
function modifier_soul_stone:GetModifierBonusStats_Agility()
    if self:GetParent():GetNetworkableEntityInfo("PrimaryAttribute") ~= "1" then return end
    return self:GetAbility():GetSpecialValueFor("bonus_primary_stat")
end
function modifier_soul_stone:GetModifierBonusStats_Intellect()
    if self:GetParent():GetNetworkableEntityInfo("PrimaryAttribute") ~= "2" then return end
    return self:GetAbility():GetSpecialValueFor("bonus_primary_stat")
end
function modifier_soul_stone:GetModifierAura()
	return "modifier_soul_stone_vision"
end
function modifier_soul_stone:IsAura()
    return true
end
function modifier_soul_stone:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_soul_stone:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_soul_stone:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_soul_stone:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

modifier_soul_stone_vision = class({
	IsPurgable = function() return false end,
    IsHidden   = function() return true end,
})

function modifier_soul_stone_vision:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }
end

if IsServer() then
    function modifier_soul_stone_vision:GetModifierProvidesFOWVision()
        return 1
    end

    function modifier_soul_stone:OnCreated()
        self:StartIntervalThink(1 / 20)
    end
    function modifier_soul_stone:OnIntervalThink()
        local parent = self:GetParent()
        local primary = parent:GetPrimaryAttribute()

        local stat
        local stat_max = self:GetAbility():GetSpecialValueFor("stat_max")
        if primary == 0 then
            stat = parent:GetStrength() - parent:GetBaseStrength() + CalculateStatForLevel(parent, 0, STAT_GAIN_LEVEL_LIMIT) + (parent:GetKeyValue("AttributeBaseStrength") or 0) - self:GetAbility():GetSpecialValueFor("status_resist_per_primary")
            if stat > stat_max then stat = stat_max end
            if self.stat ~= stat then
                self.stat = stat
                parent:SetNetworkableEntityInfo("BonusStat", stat)
            end
        end

        if primary == 1 then
            stat = parent:GetAgility() - parent:GetBaseAgility() + CalculateStatForLevel(parent, 1, STAT_GAIN_LEVEL_LIMIT) + (parent:GetKeyValue("AttributeBaseAgility") or 0) - self:GetAbility():GetSpecialValueFor("status_resist_per_primary")
            if stat > stat_max then stat = stat_max end
            if self.stat ~= stat then
                self.stat = stat
                parent:SetNetworkableEntityInfo("BonusStat", stat)
            end
        end

        if primary == 2 then
            stat = parent:GetIntellect() - parent:GetBaseIntellect() + CalculateStatForLevel(parent, 2, STAT_GAIN_LEVEL_LIMIT) + (parent:GetKeyValue("AttributeBaseIntelligence") or 0) - self:GetAbility():GetSpecialValueFor("status_resist_per_primary")
            if stat > stat_max then stat = stat_max end
            if self.stat ~= stat then
                self.stat = stat
                parent:SetNetworkableEntityInfo("BonusStat", stat)
            end
        end
    end
end

modifier_reality_stone = class(infinity_stone_base)
function modifier_reality_stone:GetModifierBaseAttack_BonusDamage()
    local strength = self:GetParent():GetStrength()
	--return strength * self:GetAbility():GetSpecialValueFor("bonus_base_damage_per_strength")
end
function modifier_reality_stone:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stat")
end
function modifier_reality_stone:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stat")
end
function modifier_reality_stone:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stat")
end
function modifier_reality_stone:GetModifierHealthBonus()
    return self:GetParent():GetStrength() * (self.bonus_health or 0)
end
function modifier_reality_stone:GetModifierManaBonus()
    return self:GetParent():GetStrength() * (self.bonus_mana or 0)
end
if IsServer() then
    function modifier_reality_stone:OnCreated()
        local parent = self:GetParent()
        Timers:NextTick(function()
            local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
if not parent_info then return end
            self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana_per_int") * parent_info.ManaPerInt * 0.01
            parent_info.ManaPerInt = parent_info.ManaPerInt + self.bonus_mana

            parent_info.AgilityArmorMultiplier = parent_info.AgilityArmorMultiplier - self:GetAbility():GetSpecialValueFor("agility_requirement_decrease")

            self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_hp_per_strength") * parent_info.HealthPerStrength * 0.01
            parent_info.HealthPerStrength = parent_info.HealthPerStrength + self.bonus_health
            parent:CalculateStatBonus(true)
        end)
        if not parent.random_primary_bonus then
            parent.random_primary_bonus = RandomInt(0, 2)
        end
        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", tostring(parent.random_primary_bonus))
        if parent.random_primary_bonus == 1 then
            parent:AddNewModifier(parent, nil, "modifier_agility_primary_bonus", nil)
            parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", "1")
            Attributes:UpdateAgility(parent)
        end
        if parent.random_primary_bonus == 0 and parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_STRENGTH then
            local m = parent:AddNewModifier(parent, nil, "modifier_strength_crit", nil)
            m:SetDuration(m:calculateCooldown(), true)
            m.ready = false
            Attributes:UpdateStrength(parent)
        end
        if parent.random_primary_bonus == 2 and parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
            parent:AddNewModifier(parent, nil, "modifier_intelligence_primary_bonus", nil)
            Attributes:UpdateIntelligence(parent)
        end
    end

    function modifier_reality_stone:OnDestroy()
        local parent = self:GetParent()

        if parent.random_primary_bonus == 0 and parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_STRENGTH then
            if parent:FindModifierByName("modifier_strength_crit") then
                parent:RemoveModifierByName("modifier_strength_crit")
                Attributes:UpdateStrength(parent)
            end
            if parent:FindModifierByName("modifier_strength_crit_true_strike") then
                parent:RemoveModifierByName("modifier_strength_crit_true_strike")
            end
        end
        if parent.random_primary_bonus == 1 and parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_AGILITY then
            if parent:FindModifierByName("modifier_agility_primary_bonus") then
                parent:RemoveModifierByName("modifier_agility_primary_bonus")
                Attributes:UpdateAgility(parent)
            end
        end
        if parent.random_primary_bonus == 2 and parent:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
            if parent:FindModifierByName("modifier_intelligence_primary_bonus") then
                parent:RemoveModifierByName("modifier_intelligence_primary_bonus")
            end
        end
        parent:SetNetworkableEntityInfo("BonusPrimaryAttribute", nil)

        local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
if not parent_info then return end

        parent_info.ManaPerInt = parent_info.ManaPerInt - self.bonus_mana
        parent_info.AgilityArmorMultiplier = parent_info.AgilityArmorMultiplier + self:GetAbility():GetSpecialValueFor("agility_requirement_decrease")
        parent_info.HealthPerStrength = parent_info.HealthPerStrength - self.bonus_health
        parent:CalculateStatBonus(true)
    end
end

modifier_space_stone = class(infinity_stone_base)
function modifier_space_stone:GetModifierHealthBonus()
    return self:GetParent():GetStrength() * (self.health_bonus or 0)
end
function modifier_space_stone:GetModifierManaBonus()
    return self:GetParent():GetStrength() * (self.mana_bonus or 0)
end
if IsServer() then
    function modifier_space_stone:OnCreated()
        local parent = self:GetParent()
        local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
if not parent_info then return end
        Timers:NextTick(function()
            self.mpreg_bonus = (parent_info.ManaRegAmpPerInt * self:GetAbility():GetSpecialValueFor("all_energies_regen_bonus_pct") * 0.01)
            parent_info.ManaRegAmpPerInt = parent_info.ManaRegAmpPerInt + self.mpreg_bonus

            self.hpreg_bonus = (parent_info.HpRegenAmp * self:GetAbility():GetSpecialValueFor("all_energies_regen_bonus_pct") * 0.01)
            parent_info.HpRegenAmp = parent_info.HpRegenAmp + self.hpreg_bonus

            self.mana_bonus = (parent_info.ManaPerInt * self:GetAbility():GetSpecialValueFor("all_energies_bonus_pct") * 0.01)
            parent_info.ManaPerInt = parent_info.ManaPerInt + self.mana_bonus
            self.health_bonus = (parent_info.HealthPerStrength * self:GetAbility():GetSpecialValueFor("all_energies_bonus_pct") * 0.01)
            parent_info.HealthPerStrength = parent_info.HealthPerStrength + self.health_bonus

            --local stamina = parent:FindModifierByName("modifier_stamina")
            --if stamina then
                parent.bonus_stamina_pct = parent.bonus_stamina_pct + self:GetAbility():GetSpecialValueFor("all_energies_bonus_pct") * 0.01
                parent.bonus_stamina_regen_pct = parent.bonus_stamina_regen_pct + self:GetAbility():GetSpecialValueFor("all_energies_regen_bonus_pct") * 0.01
            --end

            if parent.GetEnergy then
                local Energy = parent:FindModifierByName("modifier_sara_evolution")

                if Energy then
                    Energy.energy_limit_boost_pct = Energy.energy_limit_boost_pct + self:GetAbility():GetSpecialValueFor("all_energies_bonus_pct") * 0.01
                    Energy.energy_growth_boost_pct = Energy.energy_growth_boost_pct + self:GetAbility():GetSpecialValueFor("all_energies_regen_bonus_pct") * 0.01
                end
            end
            parent:CalculateStatBonus(true)
        end)
    end

    function modifier_space_stone:OnDestroy()
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local parent_info = Attributes.Heroes[parent:GetEntityIndex()]
if not parent_info then return end
    Timers:NextTick(function()
        --local stamina = parent:FindModifierByName("modifier_stamina")
        --if stamina then
            parent.bonus_stamina_pct = parent.bonus_stamina_pct - ability:GetSpecialValueFor("all_energies_bonus_pct") * 0.01
            parent.bonus_stamina_regen_pct = parent.bonus_stamina_regen_pct - ability:GetSpecialValueFor("all_energies_regen_bonus_pct") * 0.01
        --end

        if parent.GetEnergy then
            local Energy = parent:FindModifierByName("modifier_sara_evolution")

            if Energy then
                Energy.energy_limit_boost_pct = Energy.energy_limit_boost_pct - ability:GetSpecialValueFor("all_energies_bonus_pct") * 0.01
                Energy.energy_growth_boost_pct = Energy.energy_growth_boost_pct - ability:GetSpecialValueFor("all_energies_regen_bonus_pct") * 0.01
            end
        end
    end)

        parent_info.ManaRegAmpPerInt = parent_info.ManaRegAmpPerInt - self.mpreg_bonus
        parent_info.HpRegenAmp = parent_info.HpRegenAmp - self.hpreg_bonus

        parent_info.ManaPerInt = parent_info.ManaPerInt - self.mana_bonus
        parent_info.HealthPerStrength = parent_info.HealthPerStrength - self.health_bonus

        parent:CalculateStatBonus(true)
    end
end