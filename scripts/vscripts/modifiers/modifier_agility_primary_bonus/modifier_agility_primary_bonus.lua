modifier_agility_primary_bonus = class({
	IsPurgable    = function() return false end,
    IsHidden      = function() return true end,
    RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

if IsServer() then
	function modifier_agility_primary_bonus:DeclareFunctions()
		return {
			MODIFIER_EVENT_ON_ATTACK_START,
		}
	end

    function modifier_agility_primary_bonus:OnCreated()
		self.primary = DOTA_ATTRIBUTE_AGILITY
        self.tick = 0.2

		self.calculateChance = function()
			return AGILITY_BONUS_BASE_PROCK_CHANCE + AGILITY_BONUS_PROCK_CHANCE_PER_LEVEL * self:GetParent():GetLevel()
		end
		self:StartIntervalThink(self.tick)
    end

    function modifier_agility_primary_bonus:OnAttackStart(keys)
		--print("bonus attacks")
        local parent = keys.attacker

        if RollPercentage(self:calculateChance()) and parent == self:GetParent() and (parent:IsTrueHero() or parent:IsIllusion()) and self.bonusAttacksCount >= 1 then
			--if self._fix == true then
			--	self._fix = false
			--	return
			--end
			--print("start")
			local minDelay = 0
			if self.minDelay then minDelay = self.minDelay end
			local delay = parent:GetKeyValue("AttackRate") or 1.7
			local target = keys.target
			local coeff = math.abs(parent:GetAgility() - self.bonusAttacksCount * AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK)
			local lastDelay =  minDelay + delay * (AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK - coeff) * 0.01
			--duration = minDelay * self.bonusAttacksCount + lastDelay,

			local modifier = parent:AddNewModifier(parent, nil, "modifier_agility_bonus_attacks", {duration = minDelay * self.bonusAttacksCount + lastDelay + 1, minDelay = minDelay, lastDelay = lastDelay, bonusAttacksCount = self.bonusAttacksCount, coeff = AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK - coeff / 1.5})
			modifier.target = target
			--[[if parent:IsRangedAttacker() then
				self.bonusAttacksCooldow = true
				Timers:CreateTimer(2, function()
					self.bonusAttacksCooldow = false
				end)
			else
				self.bonusAttacksCooldow = true
				Timers:CreateTimer(1, function()
					self.bonusAttacksCooldow = false
				end)
			end]]
		end
    end

    function modifier_agility_primary_bonus:OnIntervalThink()
        local parent = self:GetParent()

		--if self.primary ~= parent:GetPrimaryAttribute() then parent:RemoveModifierByName("modifier_agility_primary_bonus") end
		self.minDelay = AGILITY_BONUS_MIN_DELAY
		self.bonusAttacksCount = 2
		for i = 1, math.round(parent:GetAgility()) do
			if i % AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK == 0 then self.bonusAttacksCount = self.bonusAttacksCount + 1 end
	    end
		if parent:GetAgility() == 0 then
			self.bonusAttacksCount = 0
		end

        parent:SetNetworkableEntityInfo("AgilityBonusAttacks", self.bonusAttacksCount)
		parent:SetNetworkableEntityInfo("AgilityBonusAttacksDamage", parent:GetAgility() * AGILITY_BONUS_BONUS_DAMAGE)
		parent:SetNetworkableEntityInfo("AgilityBonusChance", self:calculateChance())
    end
end