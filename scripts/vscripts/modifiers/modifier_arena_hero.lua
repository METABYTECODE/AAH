modifier_arena_hero = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return false end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
	GetTexture    = function() return "attribute_abilities/clue" end,
})

function modifier_arena_hero:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_MODIFIER_ADDED,

		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_REFLECT_SPELL,
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_PROPERTY_ABILITY_LAYOUT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION

		--MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		--MODIFIER_PROPERTY_MANA_BONUS,
		--MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_arena_hero:GetModifierMagicalResistanceDirectModification()
	return -self:GetParent():GetIntellect() * 0.1
end

if IsServer() then
	function modifier_arena_hero:GetModifierTotalDamageOutgoing_Percentage(keys)
		local damagetype_const = keys.damage_type
		local damage = keys.original_damage
		local saved_damage = keys.original_damage
		local inflictor
		if keys.inflictor then
			inflictor = keys.inflictor
		end
		local attacker
		if keys.attacker then
			attacker = keys.attacker
		end
		local victim
		if keys.target then
			victim = keys.target
		end

		--print(damage)
		if IsValidEntity(inflictor) and inflictor.GetAbilityName then
			damage = DamageHasInflictor(inflictor, damage, attacker, victim, damagetype_const)
		elseif not IsValidEntity(inflictor) and attacker and attacker.DamageMultiplier and not IsValidEntity(inflictor) then
			local amp = attacker.DamageMultiplier
			damage = damage * (amp)
		end
		--print(damage)

		if IsValidEntity(attacker) then
			if victim.HasModifier then
				for k,v in pairs(ON_DAMAGE_MODIFIER_PROCS) do
					if attacker:HasModifier(k) then
						damage = ProcessDamageModifier(v, attacker, victim, inflictor, damage, damagetype_const)
					end
				end
				for k,v in pairs(OUTGOING_DAMAGE_MODIFIERS) do
					if attacker:HasModifier(k) and (type(v) ~= "table" or not v.condition or (v.condition and v.condition(attacker, victim, inflictor, damage, damagetype_const))) then
						damage = ProcessDamageModifier(v, attacker, victim, inflictor, damage, damagetype_const)
					end
				end
			end
		end
		return (damage / saved_damage * 100) - 100
	end

	function modifier_arena_hero:GetModifierTotal_ConstantBlock(keys)
		local damagetype_const = keys.damage_type
		local damage = keys.damage
		local saved_damage = keys.damage
		--print("1: "..damage)
		local inflictor
		if keys.inflictor then
			inflictor = keys.inflictor
		end
		local attacker
		if keys.attacker then
			attacker = keys.attacker
		end
		local victim
		if keys.target then
			victim = keys.target
		end

		if IsValidEntity(attacker) then

			if victim:IsBoss() and (attacker:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D() > 950 then
				damage = damage / 2
			end
			if victim:IsBoss() and victim._waiting then
				return damage
			end
			local BlockedDamage = 0

			if victim.HasModifier then
				for k,v in pairs(ON_DAMAGE_MODIFIER_PROCS_VICTIM) do
					if victim:HasModifier(k) then
						damage = ProcessDamageModifier(v, attacker, victim, inflictor, damage, damagetype_const)
					end
				end
				for k,v in pairs(INCOMING_DAMAGE_MODIFIERS) do
					if victim:HasModifier(k) and (type(v) ~= "table" or not v.condition or (v.condition and v.condition(attacker, victim, inflictor, damage, damagetype_const))) then
						damage = ProcessDamageModifier(v, attacker, victim, inflictor, damage, damagetype_const)
					end
				end
			end

			if BlockedDamage > 0 then
				SendOverheadEventMessage(victim:GetPlayerOwner(), OVERHEAD_ALERT_BLOCK, victim, BlockedDamage, attacker:GetPlayerOwner())
				SendOverheadEventMessage(attacker:GetPlayerOwner(), OVERHEAD_ALERT_BLOCK, victim, BlockedDamage, victim:GetPlayerOwner())
	
				damage = damage - BlockedDamage
			end
		end
		--print("2: "..damage)
		--print("3: "..saved_damage - damage)
		return saved_damage - damage
	end
end

function modifier_arena_hero:GetModifierAbilityLayout()
	return self.VisibleAbilitiesCount or self:GetSharedKey("VisibleAbilitiesCount") or 4
end

function modifier_arena_hero:GetModifierAttackSpeedBonus_Constant()
	return self:GetParent():GetNetworkableEntityInfo("ReturnedAttackSpeed") or 0
end

if IsServer() then

	modifier_arena_hero.HeroLevel = 1
	function modifier_arena_hero:OnCreated()
		self.tick = 2
		self:StartIntervalThink(self.tick)
	end

	function modifier_arena_hero:OnIntervalThink()
		local parent = self:GetParent()

		local VisibleAbilitiesCount = 0
		for i = 0, parent:GetAbilityCount() - 1 do
			local ability = parent:GetAbilityByIndex(i)
			if ability and not ability:IsHidden() and not ability:GetAbilityName():starts("special_bonus_") then
				VisibleAbilitiesCount = VisibleAbilitiesCount + 1
			end
		end
		if self.VisibleAbilitiesCount ~= VisibleAbilitiesCount then
			self.VisibleAbilitiesCount = VisibleAbilitiesCount
			self:SetSharedKey("VisibleAbilitiesCount", VisibleAbilitiesCount)
		end

		if parent:HasModifier("modifier_alchemist_chemical_rage") and parent:HasModifier("modifier_stamina") and not self.chem_rage then
			local chemical_rage = parent:FindModifierByName("modifier_alchemist_chemical_rage")
			local stamina = parent:FindModifierByName("modifier_stamina")

			self.chem_rage = chemical_rage:GetAbility()
			stamina.outside_change_bat = -self.chem_rage:GetSpecialValueFor("base_attack_time")
		elseif not parent:HasModifier("modifier_alchemist_chemical_rage") and self.chem_rage then
			parent:FindModifierByName("modifier_stamina").outside_change_bat = self.chem_rage:GetSpecialValueFor("base_attack_time")
			self.chem_rage = nil
		end

		self.backpack = CheckBackpack(parent, self.backpack)

		--panorama
		if self._BaseAttackTime ~= parent:GetBaseAttackTime() or
		   self._AttackSpeed ~= parent:GetAttackSpeed()
		   then
			parent:SetNetworkableEntityInfo("BaseAttackTime", parent:GetBaseAttackTime())
			self._BaseAttackTime = parent:GetBaseAttackTime()
			parent:SetNetworkableEntityInfo("CustomAttackSpeed", parent:GetAttackSpeed())
			self._AttackSpeed = parent:GetAttackSpeed()
		end

		if self._Damage ~= parent:GetAverageTrueAttackDamage(parent) then
			self._Damage = parent:GetAverageTrueAttackDamage(parent)
			parent:SetNetworkableEntityInfo("BonusDamage", parent:GetAverageTrueAttackDamage(parent))
		end
	end

	function modifier_arena_hero:OnModifierAdded(keys)
		local parent = keys.unit

		if parent == self:GetParent() then
			Attributes:UpdateAll(parent)
		end
	end

	function modifier_arena_hero:OnDeath(k)
		local parent = self:GetParent()
		if k.unit == parent and not parent:IsIllusion() and parent:IsTrueHero() and not parent:IsTempestDouble() and not Duel:IsDuelOngoing() then
			for _,v in pairs(STONES_TABLE) do
				local stone =  FindItemInInventoryByName(parent, v[1], _, _, _, true)
				if stone then
					parent:DropItemAtPositionImmediate(stone, parent:GetAbsOrigin() + RandomVector(RandomInt(90, 300)))
				end
			end

			local courier = Structures:GetCourier(parent:GetPlayerID())
			if courier:IsAlive() then
				for _,v in pairs(STONES_TABLE) do
					local stone =  FindItemInInventoryByName(courier, v[1], _, _, _, true)
					--print(stone)
					if stone then
						courier:DropItemAtPositionImmediate(stone, parent:GetAbsOrigin() + RandomVector(RandomInt(90, 300)))
					end
				end
			end
		end

		--bounty hunter track fix
		--[[if k.unit == parent and parent:HasModififer("modifier_bounty_hunter_track") and parent.GetPlayerID ~= nil then
			local ability = k.attacker:FindAbilityByName("bounty_hunter_jinada")
			local bonus_allies = ability:GetAbilitySpecial("bonus_gold")
			local bonus_self = ability:GetAbilitySpecial("bonus_gold_self")
			local radius = ability:GetAbilitySpecial("bonus_gold_radius")
			local allies = FindUnitsInRadius(
					k.attacker:GetTeam(),
					target:GetAbsOrigin(),
					nil,
					radius, --radius
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					false
				)
		end]]

		if k.attacker == parent and k.unit:IsCreep() then
			local gold = 0
			local xp = 0
			for _k,v in pairs(CREEP_BONUSES_MODIFIERS) do
				if parent:HasModifier(_k) then
					local gxp = type(v) == "function" and v(parent) or v
					if gxp then
						gold = math.max(gold, (gxp.gold or 0))
						xp = math.max(xp, (gxp.xp or 0))
					end
				end
			end
			if gold > 0 then
				Gold:ModifyGold(parent, gold)
				local particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN, k.unit, parent:GetPlayerOwner())
				ParticleManager:SetParticleControl(particle, 1, Vector(0, gold, 0))
				ParticleManager:SetParticleControl(particle, 2, Vector(2, string.len(gold) + 1, 0))
				ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))
			end
			if xp > 0 and k.unit:GetFullName() ~= "npc_dota_neutral_jungle_variant1" then
				parent:AddExperience(xp, false, false)
			end
		end
		if k.unit == parent then
			parent:RemoveNoDraw()

			if parent:IsIllusion() then
				parent:ClearNetworkableEntityInfo()
			end
		end
	end

	function modifier_arena_hero:OnRespawn(k)
		if k.unit == self:GetParent() and k.unit:GetUnitName() == "npc_dota_hero_crystal_maiden" then
			k.unit:AddNoDraw()
			Timers:CreateTimer(0.1, function() k.unit:RemoveNoDraw() end)
		end
	end

	function modifier_arena_hero:OnAbilityStart(keys)
		--print("start")
		SplashTimer(self:GetParent(), keys.ability)
	end

	function modifier_arena_hero:OnAbilityExecuted(keys)
		if self:GetParent() == keys.unit then
			local ability_cast = keys.ability
			local abilityname = ability_cast ~= nil and ability_cast:GetAbilityName()
			local caster = self:GetParent()
			local target = keys.target or caster:GetCursorPosition()
			if caster.talents_ability_multicast and caster.talents_ability_multicast[abilityname] then
				for i = 1, caster.talents_ability_multicast[abilityname] - 1 do
					Timers:CreateTimer(0.1*i, function()
						if IsValidEntity(caster) and IsValidEntity(ability_cast) then
							CastAdditionalAbility(caster, ability_cast, target, 0, {})
						end
					end)
				end
			end
		end
	end

	function modifier_arena_hero:OnAbilityEndChannel(keys)
		local parent = self:GetParent()
		local endChannelListeners = parent.EndChannelListeners
		if not endChannelListeners then return end
		for _, v in ipairs(endChannelListeners) do
			v(keys.fail_type < 0)
		end
		parent.EndChannelListeners = {}
	end

	function modifier_arena_hero:OnDestroy()
		if IsValidEntity(self.reflect_stolen_ability) then
			self.reflect_stolen_ability:RemoveSelf()
		end
	end
	function modifier_arena_hero:GetReflectSpell(keys)
		local parent = self:GetParent()
		if parent:IsIllusion() then return end
		local originalAbility = keys.ability
		self.absorb_without_check = false
		if originalAbility:GetCaster():GetTeam() == parent:GetTeam() then return end
		if SPELL_REFLECT_IGNORED_ABILITIES[originalAbility:GetAbilityName()] then return end

		local item_lotus_sphere = FindItemInInventoryByName(parent, "item_lotus_sphere", false, false, true)

		if not self.absorb_without_check and item_lotus_sphere and parent:HasModifier("modifier_item_lotus_sphere") and item_lotus_sphere:PerformPrecastActions() then
			ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/arena/items_fx/lotus_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent), 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			parent:EmitSound("Item.LotusOrb.Activate")
			self.absorb_without_check = true
		end

		if self.absorb_without_check then
			if IsValidEntity(self.reflect_stolen_ability) then
				self.reflect_stolen_ability:RemoveSelf()
			end
			local hCaster = self:GetParent()
			local hAbility = hCaster:AddAbility(originalAbility:GetAbilityName())
			if hAbility then
				hAbility:SetStolen(true)
				hAbility:SetHidden(true)
				hAbility:SetLevel(originalAbility:GetLevel())
				hCaster:SetCursorCastTarget(originalAbility:GetCaster())
				hAbility:OnSpellStart()
				hAbility:SetActivated(false)
				self.reflect_stolen_ability = hAbility
			end
		end
	end
	function modifier_arena_hero:GetAbsorbSpell(keys)
		local parent = self:GetParent()
		if self.absorb_without_check then
			self.absorb_without_check = nil
			return 1
		end
		return false
	end
end

--splash
function modifier_arena_hero:OnAttackLanded(keys)
	local attacker = keys.attacker
	local target = keys.target

	if attacker ~= self:GetParent() then return end

	if attacker:FindModifierByName("modifier_splash_timer") then
		return
	end
		if not attacker:IsRangedUnit() then
			local distance = 400
			local start = 100
			local _end = 250
			if FindItemInInventoryByName(attacker, "item_ultimate_splash", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_ultimate_splash", false, false, true)
				distance = item:GetSpecialValueFor("cleave_distance")
				start = item:GetSpecialValueFor("cleave_starting_width")
				_end = item:GetSpecialValueFor("cleave_ending_width")
			elseif FindItemInInventoryByName(attacker, "item_elemental_fury", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_elemental_fury", false, false, true)
				distance = item:GetSpecialValueFor("cleave_distance")
				start = item:GetSpecialValueFor("cleave_starting_width")
				_end = item:GetSpecialValueFor("cleave_ending_width")
			elseif FindItemInInventoryByName(attacker, "item_battlefury_arena", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_battlefury_arena", false, false, true)
				distance = item:GetSpecialValueFor("cleave_distance")
				start = item:GetSpecialValueFor("cleave_starting_width")
				_end = item:GetSpecialValueFor("cleave_ending_width")
			elseif FindItemInInventoryByName(attacker, "item_quelling_fury", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_quelling_fury", false, false, true)
				distance = item:GetSpecialValueFor("cleave_distance")
				start = item:GetSpecialValueFor("cleave_starting_width")
				_end = item:GetSpecialValueFor("cleave_ending_width")
			end
			DoCleaveAttack(
				attacker,
				target,
				nil,
				keys.damage * ((attacker._splash or 0) + 25) * 0.01,-- + 0.15 * attacker:GetLevel()) * 0.01,
				distance,
				start,
				_end,
				"particles/items_fx/battlefury_cleave.vpcf"
			)
		else
			local radius = 200
			if FindItemInInventoryByName(attacker, "item_ultimate_splash", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_ultimate_splash", false, false, true)
				radius = item:GetSpecialValueFor("split_radius")
			elseif FindItemInInventoryByName(attacker, "item_splitshot_ultimate", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_splitshot_ultimate", false, false, true)
				radius = item:GetSpecialValueFor("split_radius")
			elseif FindItemInInventoryByName(attacker, "item_nagascale_bow", false, false, true) then
				local item = FindItemInInventoryByName(attacker, "item_nagascale_bow", false, false, true)
				radius = item:GetSpecialValueFor("split_radius")
			end

			local targets = FindUnitsInRadius(
				attacker:GetTeam(),
				target:GetAbsOrigin(),
				nil,
				radius, --radius
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_ANY_ORDER,
				false
			)
			local timer = 0
			for _,v in pairs(targets) do
				timer = timer + 1
				--Timers:CreateTimer(timer / 50, function()
					ApplyDamage({
						attacker = attacker,
						victim = v,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						damage = keys.damage * ((attacker._splitshot or 0) + 25) * 0.01,-- + 0.15 * attacker:GetLevel()) * 0.01,
						damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
						ability = nil
					})
				--end)
			end
		end
	--end
end