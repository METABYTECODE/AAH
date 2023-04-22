modifier_universal_attribute = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

if IsServer() then

function modifier_universal_attribute:ChangePrimaryBonus(index)
    local parent = self:GetParent()
    if self.PrimaryBonuses[index] then
        parent:SetPrimaryAttribute(index - 1)
        parent:AddNewModifier(parent, nil, self.PrimaryBonuses[index], nil)
        self.CurrentPrimaryBonus = index
    else
        self.CurrentPrimaryBonus = 1
        self:ChangePrimaryBonus(1)
    end
end

function modifier_universal_attribute:OnCreated()
    self.PrimaryBonuses = {
       "modifier_strength_crit",
       "modifier_agility_primary_bonus",
       "modifier_intelligence_primary_bonus"
    }

    self.CurrentPrimaryBonus = 1

    self:ChangePrimaryBonus(self.CurrentPrimaryBonus)
end

end

