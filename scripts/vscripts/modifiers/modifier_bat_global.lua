modifier_bat_global = class({
	IsPurgable    = function() return false end,
    IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
})

function modifier_bat_global:DeclareFunctions()
    return { 
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
    }
end

if IsServer() then
    function modifier_bat_global:OnCreated()
        self.bat = self:GetParent():GetBaseAttackTime()
        self.changed_bat = 0

        --self:StartIntervalThink(1 / 20)
    end
    --[[function modifier_bat_global:OnIntervalThink()
        local parent = self:GetParent()
        if self.bat ~= parent:GetBaseAttackTime() then
            
        end
    end]]
    function modifier_bat_global:GetModifierBaseAttackTimeConstant()
        if self.changed_bat and self.changed_bat ~= 0 then
            self.bat = self:GetParent():GetBaseAttackTime() - self.changed_bat
		    return self.bat + self.changed_bat
        end
	end
    function modifier_bat_global:ChangeBAT(value)
        print(self.changed_bat)
        self.changed_bat = self.changed_bat + value
        print(self.changed_bat)
        print("-------------------------")
    end
end