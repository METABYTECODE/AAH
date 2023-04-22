modifier_agility_primary_bonus = class({
	IsPurgable    = function() return false end,
    IsHidden      = function() return false end,
    RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
	GetTexture    = function() return "attribute_abilities/agility_attribute_symbol" end,

})

function modifier_agility_primary_bonus:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end

function modifier_agility_primary_bonus:OnTooltip()
	return self:GetParent():GetNetworkableEntityInfo("bonus_attacks_requirement")
end

function modifier_agility_primary_bonus:OnTooltip2()
	return self:GetParent():GetNetworkableEntityInfo("agility_for_next_bonus_attack")
end

if IsServer() then
    function modifier_agility_primary_bonus:OnCreated()
		self.primary = DOTA_ATTRIBUTE_AGILITY
        self.tick = 1
		self.bonusAttacksCount = AGILITY_BONUS_ATTACKS_BASE_COUNT
		self.requirement = AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK

		self.calculateChance = function()
			return AGILITY_BONUS_BASE_PROCK_CHANCE + AGILITY_BONUS_PROCK_CHANCE_PER_LEVEL * self:GetParent():GetLevel()
		end
		--self:StartIntervalThink(self.tick)
    end

	function modifier_agility_primary_bonus:OnIntervalThink()
		local mod = self
		local parent = self:GetParent()
    	--[[if tostring(parent:GetPrimaryAttribute()) == parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and not mod._util then
   	    	mod._util = true
        	mod.requirement = math.round(AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK / 4)
        	mod.agility = parent:GetAgility() - 1
    	elseif tostring(parent:GetPrimaryAttribute()) ~= parent:GetNetworkableEntityInfo("BonusPrimaryAttribute") and mod._util then
        	mod._util = false
        	mod.requirement = AGILITY_BONUS_AGILITY_FOR_BONUS_ATTACK
        	mod.agility = parent:GetAgility() - 1
    	end]]
	end

    function modifier_agility_primary_bonus:OnAttackStart(keys)
		--print("bonus attacks")
        local parent = keys.attacker

        if RollPercentage(self:calculateChance()) and parent == self:GetParent() and (parent:IsTrueHero() or parent:IsIllusion()) and self.bonusAttacksCount >= 1 then
			local attack_rate = 1 / ((1 + parent:GetAttackSpeed()) / parent:GetBaseAttackTime())
			local target = keys.target

			local modifier = parent:AddNewModifier(parent, nil, "modifier_agility_bonus_attacks", {duration = attack_rate * self.bonusAttacksCount, target = target, attack_rate = attack_rate, parent_modifier = self})
			modifier.target = target
		end
    end
end