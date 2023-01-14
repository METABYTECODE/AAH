modifier_strength_crit = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return false end,
	RemoveOnDeath = function() return false end,
	IsDebuff 	  = function() return false end,
	GetTexture    = function() return "attribute_abilities/strength_attribute_symbol" end,
})

modifier_strength_crit_true_strike = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	IsDebuff 	  = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})
LinkLuaModifier("modifier_strength_crit_true_strike", "modifiers/modifier_strength_crit.lua", LUA_MODIFIER_MOTION_NONE)
function modifier_strength_crit_true_strike:CheckState()
	return { [MODIFIER_STATE_CANNOT_MISS] = true }
end


function modifier_strength_crit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED,
	}
end

function modifier_strength_crit:crit_procced()
	return self.strengthCriticalDamage
end

 function modifier_strength_crit:crit_procced_num()
	return 100.0001 --if it is 100 the crit indicator won't show
end

if IsServer() then
	function modifier_strength_crit:OnCreated()
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_strength_crit_true_strike", nil)
		self.calculateCooldown = function()
			return STRENGTH_CRIT_COOLDOWN - STRENGTH_CRIT_COLDOOWN_DECREASE_PER_LEVEL * self:GetParent():GetLevel()
		end

		self.OnAttackStart = self.start
		self:StartIntervalThink(1/30)
	end

	function modifier_strength_crit:OnAttackCancelled(keys)
		if keys.attacker ~= self:GetParent() then return end
		self.GetModifierDamageOutgoing_Percentage = nil
		self.GetModifierPreAttack_CriticalStrike = nil
	end

	function modifier_strength_crit:crit_cancel(keys)
		if keys.attacker == self:GetParent() then
			self.GetModifierDamageOutgoing_Percentage = nil
			self.GetModifierPreAttack_CriticalStrike = nil
			self.OnAttackStart = nil
			self:SetDuration(self.calculateCooldown(), true)
			self:GetParent():RemoveModifierByName("modifier_strength_crit_true_strike")
			self.OnAttackFinished = nil
		end
	end

	function modifier_strength_crit:start(keys)
		if keys.attacker ~= self:GetParent() then return end

		self.GetModifierDamageOutgoing_Percentage = self.crit_procced
		self.GetModifierPreAttack_CriticalStrike = self.crit_procced_num
		self.OnAttackFinished = self.crit_cancel
	end

	function modifier_strength_crit:OnIntervalThink()
		local parent = self:GetParent()
		local multiplier
		local coeff = parent:GetStrength() / STRENGTH_CRIT_THRESHOLD
		if coeff > 1 then
			local strength_diff = parent:GetStrength() - STRENGTH_CRIT_THRESHOLD
			multiplier = (STRENGTH_CRIT_THRESHOLD * STRENGTH_CRIT_MULTIPLIER) + (strength_diff * (STRENGTH_CRIT_MULTIPLIER / (coeff * STRENGTH_CRIT_DECREASE_COEFF)))
		else
			multiplier = parent:GetStrength() * STRENGTH_CRIT_MULTIPLIER
		end

		self.strengthCriticalDamage = 25 + multiplier

		--panorama
		parent:SetNetworkableEntityInfo("StrengthCrit", 100 + self.strengthCriticalDamage)
		parent:SetNetworkableEntityInfo("StrengthCritCooldown", self.calculateCooldown())
	end

	function modifier_strength_crit:OnDestroy()
		local cooldown = self:calculateCooldown()
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_strength_crit", nil)
		self:Destroy()
	end
end