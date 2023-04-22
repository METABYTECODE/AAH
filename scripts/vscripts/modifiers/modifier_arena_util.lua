modifier_arena_util = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

if IsServer() then
    function modifier_arena_util:OnCreated()
		self.tick = 1 / 10
        --self:StartIntervalThink(self.tick)
    end

    function modifier_arena_util:OnIntervalThink()
        local parent = self:GetParent()
        --[[if not self.evolution then
			if parent:GetMana() ~= self._Mana or parent:GetMaxMana() ~= self._MaxMana then
				self._Mana = parent:GetMana()
				self._MaxMana = parent:GetMaxMana()
				parent:SetNetworkableEntityInfo("CurrentMana", parent:GetMana())
				parent:SetNetworkableEntityInfo("MaxMana", parent:GetMaxMana())
			end
		end

        if self._Health ~= parent:GetHealth() or self._MaxHealth ~= parent:GetMaxHealth() then
			self._Health = parent:GetHealth()
			self._MaxHealth = parent:GetMaxHealth()
			parent:SetNetworkableEntityInfo("CurrentHealth", parent:GetHealth())
			parent:SetNetworkableEntityInfo("MaxHealth", parent:GetMaxHealth())
		end]]

		--[[if self._health_regen ~= parent:GetHealthRegen() or
		self.custom_regen ~= parent.custom_regen then
			self._health_regen = parent:GetHealthRegen()
			self.custom_regen = parent.custom_regen
			parent:SetNetworkableEntityInfo("HealthRegen", (__toFixed(math.max(0, (parent.custom_regen or 0)) + parent:GetHealthRegen(), 1)))
		end]]

		--[[if parent:GetHealth() < parent:GetMaxHealth() then
			parent:Heal(math.max(0, parent.custom_regen * self.tick), nil)
		end]]
    end
end