modifier_strength_crit = class({
	IsPurgable      = function() return false end,
	IsHidden        = function() return false end,
	RemoveOnDeath   = function() return false end,
	IsDebuff 	    = function() return false end,
	DestroyOnExpire = function() return false end,
	GetTexture      = function() return "attribute_abilities/strength_attribute_symbol" end,
})

modifier_strength_crit_true_strike = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	IsDebuff 	  = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})
if IsServer() then
	function modifier_strength_crit_true_strike:CheckState()
		return { [MODIFIER_STATE_CANNOT_MISS] = true }
	end
end


function modifier_strength_crit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED,
		--MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end

function modifier_strength_crit:OnTooltip()
	return 100 + self:GetParent():GetNetworkableEntityInfo("StrengthMagicCrit")
end

function modifier_strength_crit:OnTooltip2()
	return self:GetParent():GetNetworkableEntityInfo("StrengthCritCooldown")
end

--[[function modifier_strength_crit:GetModifierStatusResistanceStacking()
	return self:GetParent():GetNetworkableEntityInfo("StrengthDamageDecrease") or 0
end]]

function modifier_strength_crit:crit_procced()
	return self.strengthCriticalDamage
end

 function modifier_strength_crit:crit_procced_num()
	return 100.0001 --if it is 100 the crit indicator won't show
end

if IsServer() then
	function modifier_strength_crit:OnCreated()
		local parent = self:GetParent()
		--parent:AddNewModifier(parent, nil, "modifier_strength_crit_true_strike", nil)
		parent:SetNetworkableEntityInfo("STRENGTH_CRIT_SPELL_CRIT_DECREASRE_MULT", STRENGTH_CRIT_SPELL_CRIT_DECREASRE_MULT)
		self.calculateCooldown = function()
			if parent then
				return ((STRENGTH_CRIT_COOLDOWN - STRENGTH_CRIT_COLDOOWN_DECREASE_PER_LEVEL * parent:GetLevel())) * parent:GetCooldownReduction()
			end
		end

		self.decrease_coeff = STRENGTH_CRIT_DECREASE_COEFF
		self.crit_mult = STRENGTH_CRIT_MULTIPLIER

		self:SetDuration(self:calculateCooldown(), true)
        self.ready = false

		self.OnAttackStart = self.start
		self:StartIntervalThink(1)
	end

	function modifier_strength_crit:OnAttackCancelled(keys)
		if keys.attacker ~= self:GetParent() then return end
		self.GetModifierDamageOutgoing_Percentage = nil
		self.GetModifierPreAttack_CriticalStrike = nil
		self:GetParent().strength_crit = false
	end

	function modifier_strength_crit:cancel(parent)
		self.GetModifierDamageOutgoing_Percentage = nil
		self.GetModifierPreAttack_CriticalStrike = nil
		self:SetDuration(self:calculateCooldown(), true)
		self.ready = false
		parent:RemoveModifierByName("modifier_strength_crit_true_strike")
		self.OnAttackFinished = nil
	end

	function modifier_strength_crit:crit_cancel(keys)
		local parent = self:GetParent()
		if keys.attacker == self:GetParent() then
			self:cancel(parent)
		end
	end

	function modifier_strength_crit:start(keys)
		if keys.attacker ~= self:GetParent() then return end
		if not self.ready then return end
		--print(self:GetParent():GetAverageTrueAttackDamage(keys.target))
		self.GetModifierDamageOutgoing_Percentage = self.crit_procced
		self.GetModifierPreAttack_CriticalStrike = self.crit_procced_num
		self.OnAttackFinished = self.crit_cancel
		local damage = self:GetParent():GetAverageTrueAttackDamage(keys.target) * STAMINA_DAMAGE_PERCENT_IN_STAMINA_CONSUMPTION * 0.01
		damage = (damage - (damage / (self.strengthCriticalDamage * 0.01)))
		--[[if damage < self:GetParent():GetStamina() then
			self:GetParent():ModifyStamina((damage - (damage / (self.strengthCriticalDamage * 0.01))), nil, 0.1)
		end]]
	end

	function modifier_strength_crit:OnIntervalThink()
		local parent = self:GetParent()
		if not self.ready and self:GetRemainingTime() <= 0 then
			--self:SetDuration(-1, true)
			self.ready = true
			parent:AddNewModifier(parent, nil, "modifier_strength_crit_true_strike", nil)
		end

		--[[local mod = self
		if tostring(parent:GetPrimaryAttribute()) == parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and not mod._util then
			mod._util = true
			mod.decrease_coeff = STRENGTH_CRIT_DECREASE_COEFF / 1.2
			mod.crit_mult = STRENGTH_CRIT_MULTIPLIER * 1.5
			mod._strength = parent:GetStrength() - 1
		elseif tostring(parent:GetPrimaryAttribute()) ~= parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and mod._util then
			mod._util = false
			mod.crit_mult = STRENGTH_CRIT_MULTIPLIER
			mod.decrease_coeff = STRENGTH_CRIT_DECREASE_COEFF
			mod._strength = parent:GetStrength() - 1
		end]]
	end

	--[[function modifier_strength_crit:OnDestroy()
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_strength_crit", nil)
		self:Destroy()
	end]]
end