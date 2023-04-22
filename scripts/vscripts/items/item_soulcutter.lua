item_soulcutter = {
	GetIntrinsicModifierName = function() return "modifier_item_soulcutter" end
}


LinkLuaModifier("modifier_item_soulcutter", "items/item_soulcutter.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_soulcutter = {
	IsHidden      = function() return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
	IsPurgable    = function() return false end,

	IsAura             = function() return true end,
	GetModifierAura    = function() return "modifier_item_soulcutter_aura_effect" end,
	GetAuraRadius      = function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetAuraSearchTeam  = function() return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType  = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
}

function modifier_item_soulcutter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_soulcutter:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_soulcutter:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_soulcutter:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("all_damage_increase")
end

if IsServer() then
	function modifier_item_soulcutter:OnAttackLanded(keys)
		if self:GetParent().bonus_attack then return end
		local attacker = keys.attacker
		if attacker ~= self:GetParent() then return end
		local ability = self:GetAbility()
		local target = keys.target

		--[[if attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end

		if IsModifierStrongest(attacker, self:GetName(), MODIFIER_PROC_PRIORITY.pure_damage) then
			ApplyDamage({
				victim = target,
				attacker = attacker,
				damage = 0,--keys.original_damage * ability:GetSpecialValueFor("attack_damage_to_pure_pct") * 0.01,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			})
		end]]

		if attacker:IsIllusion() then return end

		ParticleManager:CreateParticle("particles/arena/items_fx/dark_flow_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

		if target:IsAlive() then
			local modifier = target:AddNewModifier(
			target,
			ability,
			"modifier_item_soulcutter_stack",
			{ duration = ability:GetSpecialValueFor("duration") }
			)
			if modifier:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
				modifier:IncrementStackCount()
			end
		end
	end
end


LinkLuaModifier("modifier_item_soulcutter_aura_effect", "items/item_soulcutter.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_soulcutter_aura_effect = {
	DeclareFunctions = function() return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS } end,
	GetModifierPhysicalArmorBonus = function(self) return self:GetAbility():GetSpecialValueFor("aura_armor_reduction") end,
}


LinkLuaModifier("modifier_item_soulcutter_stack", "items/item_soulcutter.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_soulcutter_stack = {
	IsPurgable = function() return false end,
	IsDebuff = function() return true end,
	DeclareFunctions = function()
		return {
			MODIFIER_PROPERTY_TOOLTIP,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		}
	end,
}

function modifier_item_soulcutter_stack:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_item_soulcutter_stack:OnIntervalThink()
	--[[if self:GetStackCount() > self:GetAbility():GetSpecialValueFor("max_stacks") then
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_stacks"))
		return
	end]]
	self.armorReduction = (
		self:GetStackCount() *
		self:GetAbility():GetSpecialValueFor("armor_per_hit_pct") *
		(self:GetParent()._custom_attributes.armor or self:GetParent():GetPhysicalArmorValue(false) - (self.armorReduction or 0)) *
		0.01
	)
end

function modifier_item_soulcutter_stack:OnTooltip()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("armor_per_hit_pct")
end

function modifier_item_soulcutter_stack:GetModifierPhysicalArmorBonus()
	return self.armorReduction
end
