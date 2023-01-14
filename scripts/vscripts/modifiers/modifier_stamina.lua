modifier_stamina = class({
	IsPurgable    = function() return false end,
    IsHidden      = function() return false end,
	RemoveOnDeath = function() return false end,
	GetTexture    = function() return "attribute_abilities/agility_attribute_symbol" end,
})

function modifier_stamina:DeclareFunctions()
    return { 
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

if IsServer() then
    function modifier_stamina:OnAttackStart(keys)
        local parent = keys.attacker
		if parent == self:GetParent() and parent:GetFullName() ~= "npc_arena_hero_saitama" then
            if self.stamina and self.current_stamina then
                local st_per_hit = STAMINA_DAMAGE_PERCENT_IN_STAMINA_CONSUMPTION * 0.01
				local cost = parent:GetAverageTrueAttackDamage(parent) * st_per_hit
				if parent:GetFullName() == "npc_arena_hero_shinobu" then cost = cost / 4 end
				parent:ModifyStamina(-cost)
            end
        end
	end
	function modifier_stamina:OnAttackLanded(keys)
		local parent = keys.target
		local attacker = keys.attacker
		--print("landed")
        if parent == self:GetParent() and parent:GetFullName() ~= "npc_arena_hero_saitama" and (attacker:IsHero() or attacker:IsIllusion()) then
            if self.stamina and self.current_stamina then
				local damage = keys.damage * STAMINA_TAKING_DAMAGE_DECREASE_PERCENT * 0.01
				if parent:GetFullName() == "npc_arena_hero_shinobu" then damage = damage * 4 end
               	parent:ModifyStamina(-damage)
            end
        end
	end
    function modifier_stamina:GetModifierBaseAttackTimeConstant()
		return (self.bat or 0) + self.attack_time_change
	end
	function modifier_stamina:GetModifierMoveSpeedBonus_Percentage()
		return -self.ret_ms
	end
    function modifier_stamina:OnCreated()
		local parent = self:GetParent()
		self.stamina = 100 + STAMINA_PER_AGILITY * parent:GetAgility()
		self._stamina = self.stamina
		self.current_stamina = self.stamina
		self.stamina_regen = self.stamina * STAMINA_REGEN * 0.01
		self.ret_ms = 0
		self.attack_time_change = 0
		self.bat = parent:GetBaseAttackTime() or parent:GetKeyValue("AttackRate")
		--self.disable_regen = false

		parent.GetMaxStamina = function()
			return self.stamina
		end
		parent.GetStamina = function()
			return self.current_stamina
		end
		parent.GetStaminaRegen = function()
			return self.stamina_regen
		end
		parent.ModifyStamina = function(_, value, bShowMessage)
			if type(value) ~= "number" then return 0 end
			self.current_stamina = math.min(math.max(self.current_stamina + value, 0), self.stamina)
			parent:SetNetworkableEntityInfo("Stamina", self.current_stamina)
			return self.current_stamina
		end

        self.tick = 1/20
        self:StartIntervalThink(self.tick)
    end
    function modifier_stamina:OnIntervalThink()
        local parent = self:GetParent()

		local bonus_for_health = (parent:GetMaxHealth() - 100 - parent:GetStrength() * 20) * 3
		local bonus_for_mana = (parent:GetMaxMana() - 100 - parent:GetIntellect() * 12) * 3
		--sara fix
		if parent.GetEnergy then bonus_for_mana = 0 end

		--set stamina
		self.stamina = math.round(100 + STAMINA_PER_AGILITY * parent:GetAgility() + bonus_for_mana + bonus_for_health)
		if self._stamina < self.stamina then
			local difference = self.stamina - self._stamina
			parent:ModifyStamina(difference)
			self.stamina_regen = self.stamina * STAMINA_REGEN * 0.01
			self._stamina = self.stamina
		elseif self._stamina > self.stamina then
			local difference = self._stamina - self.stamina
			parent:ModifyStamina(-difference)
			self.stamina_regen = self.stamina * STAMINA_REGEN * 0.01
			self._stamina = self.stamina
		end

		--stamina fountain regen
		if parent:HasModifier("modifier_fountain_aura_arena") then
			self.stamina_regen_fountain_bonus	= self.stamina_regen * 3
		else
			self.stamina_regen_fountain_bonus = 0
		end
		parent:ModifyStamina((self.stamina_regen + self.stamina_regen_fountain_bonus) * self.tick)

		--change attack and movement speed
		local current_stamina = 1 - parent:GetStamina() / parent:GetMaxStamina()
		local changeBat = STAMINA_MAX_BAT_DECREASE_MULTIPLIER * self.bat - self.bat
		self.attack_time_change = current_stamina * changeBat
		self.ret_ms = current_stamina * STAMINA_MAX_MS_REDUSE

		self:SetStackCount(math.round(parent:GetStamina() / parent:GetMaxStamina() * 100))
		--panorama
		parent:SetNetworkableEntityInfo("AttackTimeChange", self.attack_time_change)
		parent:SetNetworkableEntityInfo("Stamina", self.stamina)
		parent:SetNetworkableEntityInfo("CurrentStamina", math.round(self.current_stamina))
		parent:SetNetworkableEntityInfo("MaxStamina", math.round(self.stamina))
		parent:SetNetworkableEntityInfo("StaminaRegen", tostring(__toFixed(self.stamina_regen, 1)))
    end
end