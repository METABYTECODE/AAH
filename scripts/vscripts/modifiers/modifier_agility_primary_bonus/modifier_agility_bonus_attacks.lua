modifier_agility_bonus_attacks = class({
	IsPurgable    = function() return false end,
    IsHidden      = function() return true end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_agility_bonus_attacks:DeclareFunctions()
    return { 
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED,
    }
end

if IsServer() then
    function modifier_agility_bonus_attacks:OnCreated(keys)
        --{minDelay = minDelay, lastDelay = minDelay + delay * (100 - coeff) * 0.01), bonusAttacksCount = self.bonusAttacksCount, coeff = 100 - coeff / 1.5}
        local parent = self:GetParent()
        self.i = 1
        self.lastDelay = keys.lastDelay
        self.bonusAttacksCount = keys.bonusAttacksCount
        self.Pos = parent:GetAbsOrigin()

        local damage = parent:GetAverageTrueAttackDamage(parent)
        self._tick = 0
        self.tick = keys.minDelay

        --print(keys.minDelay)
        self:StartIntervalThink(self.tick)
    end

    function modifier_agility_bonus_attacks:OnIntervalThink()
        --for k in pairs(keys) do print(k) end
        self._tick = self._tick + 1
        if not self.target then return end
        local parent = self:GetParent()
        local target = self.target
        local enemyPos = target:GetAbsOrigin()
        local pos = parent:GetAbsOrigin()

        if (pos - self.Pos):Length2D() >= DISTANCE_DIFFERENCE_FOR_CANCEL_ATACKS then
            self:Destroy()
        elseif self._tick % (2 / self.tick) == 0 then
            self.Pos = pos
        end

        if not target:IsAlive() then self:Destroy() end

        if parent:Script_GetAttackRange() + 100 >= (pos - enemyPos):Length2D() and parent:IsAlive() and target:IsAlive() and not parent:IsStunned() and not parent:IsHexed() and not parent:IsDisarmed() then
        else
            self:Destroy()
        end

        if self.lastAttack then
            self:Destroy()
        end

        if self.i % self.bonusAttacksCount == 0 then
            self.lastAttack = true
            self:StartIntervalThink(self.tick)
            return
        end
        
        self.i = self.i + 1
        if parent:Script_GetAttackRange() + 100 >= (pos - enemyPos):Length2D() and parent:IsAlive() and target:IsAlive() and not parent:IsStunned() and not parent:IsHexed() and not parent:IsDisarmed() then
            --parent:FindModifierByName("modifier_agility_primary_bonus")._fix = true
            self.Damage = parent:GetAgility() * AGILITY_BONUS_BONUS_DAMAGE
            parent:PerformAttack(target, true, true, true, false, true, false, false)
            --print(parent:GetAverageTrueAttackDamage(parent))
            self.Damage = 0
        end
    end

    function modifier_agility_bonus_attacks:OnAttackCancelled(keys)
        if keys.attacker == self:GetParent() then
            self:Destroy()
        end
    end
end

function modifier_agility_bonus_attacks:GetModifierBaseDamageOutgoing_Percentage()
    return self.Damage or 0
end