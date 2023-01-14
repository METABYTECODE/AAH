modifier_intelligence_primary_bonus = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

function modifier_intelligence_primary_bonus:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,
    }
end

function modifier_intelligence_primary_bonus:GetModifierStatusResistance()
	return self.Target_StatusResist or 0
end

function modifier_intelligence_primary_bonus:GetModifierStatusResistanceCaster()
	return self.Caster_StatusResist or 0
end

if IsServer() then
    function modifier_intelligence_primary_bonus:OnAbilityExecuted(keys)
		--print('cast')
		local victim = keys.target
		local attacker = keys.ability:GetCaster()

        if not victim then return end
        if not victim.GetPrimaryAttribute or not attacker.GetPrimaryAttribute then return end

        if victim == self:GetParent() then
			local attackerInt = attacker:GetIntellect()
			local victimInt = victim:GetIntellect()
			local diff

            if attackerInt >= victimInt then self.Target_StatusResist = 0 end 
			if attackerInt < victimInt then
				diff = victimInt / attackerInt
				if diff >= INTELLECT_PRIMARY_BONUS_DIFF_FOR_MAX_MULT then
					self.Target_StatusResist = INTELLECT_PRIMARY_BONUS_MAX_BONUS
				else
					diff = 1 - attackerInt / victimInt
					self.Target_StatusResist = INTELLECT_PRIMARY_BONUS_MAX_BONUS * diff
				end
			end
	    end
		if attacker == self:GetParent() then
			local attackerInt = attacker:GetIntellect()
			local victimInt = victim:GetIntellect()
			local diff

			if attackerInt <= victimInt then self.Caster_StatusResist = 0 end
			if attackerInt > victimInt then
				diff = attackerInt / victimInt
				if diff >= INTELLECT_PRIMARY_BONUS_DIFF_FOR_MAX_MULT then
					self.Caster_StatusResist = -INTELLECT_PRIMARY_BONUS_MAX_BONUS
				else
					diff = 1 - victimInt / attackerInt
					self.Caster_StatusResist = -INTELLECT_PRIMARY_BONUS_MAX_BONUS * diff
				end
			end
		end
	--print(self.Target_StatusResist)
	--print(self.Caster_StatusResist)
    end
end