local nativeTalents = {}
local skippedTalents = {}

local npc_heroes = LoadKeyValues("scripts/npc/npc_heroes.txt")
local npc_abilities = LoadKeyValues("scripts/npc/npc_abilities.txt")

local function addTalent(talentName, heroName, group, value)
	local newValues
	if not value then
		newValues = GetAbilitySpecial(talentName)
		--PrintTable(newValues)
	else
		newValues = {}
		newValues[value.key] = value.value
	end

	--[[NATIVE_TALENTS[talentName] = {
		cost = 6 - group,
		group = group,
		icon = heroName,
		requirement = heroName,
		special_values = newValues,
		effect = { abilities = talentName }
	}]]

	--PrintTable(newValues)
	--print(type(npc_abilities))
	--[[if not newValues then
		for _,v in pairs(npc_heroes) do
			local ability = GetAbilitySpecial(v)
			if ability then
				for k,v1 in pairs(GetAbilitySpecial(v)) do
					print(k)
					PrintTable(v1)
					if k == talentName then
						newValues = {value = tostring(v1)}
					end
				end
			end
		end]]


		--[[for i,_ in pairs(npc_abilities) do
			print(i)
			--GetKeyValue(heroName, "Changed")
			for k,v in pairs(GetAbilitySpecial(i)) do
				print(k)
				PrintTable(v)
				if k == talentName then
					newValues = {value = tostring(v)}
				end
			end
		end]]
	--end
	local cost
	if group <= 3 then
		cost = 4
	elseif group <= 6 then
		cost = 3
	elseif group <= 9 then
		cost = 2
	end
	nativeTalents[talentName] = {
		cost = cost,
		group = group,
		icon = heroName,
		requirement = heroName,
		special_values = newValues or 0,
		effect = { abilities = talentName }
	}

	--if NATIVE_TALENTS[talentName] == nil then
		--[[if NATIVE_TALENTS[talentName] == false then
			skippedTalents[talentName] = true
		else
			nativeTalents[talentName] = table.merge({
				cost = 6 - group,
				group = group,
				icon = heroName,
				requirement = heroName,
				special_values = newValues,
				effect = { abilities = talentName }
			}, NATIVE_TALENTS[talentName])
		end
	--else]]
		--print(talentName .. ": native talent is not defined in NATIVE_TALENTS")
	--end
end

for heroName, heroData in pairs(npc_heroes) do
	local partiallyChanged = PARTIALLY_CHANGED_HEROES[heroName]
	local isChanged = GetKeyValue(heroName, "Changed") == 1 and not partiallyChanged
	if type(heroData) == "table" and not isChanged then
		for _,talentName in pairs(heroData) do
			if type(talentName) == "string" and (string.starts(talentName, "special_bonus_unique_")) then
				if not partiallyChanged or partiallyChanged[talentName] ~= true then
					if not GetAbilitySpecial(talentName) then
						for _,abilityName in pairs(heroData) do
							--PrintTable(abilityName)
							local abilityValues
							if type(abilityName) == "string" and not string.starts(abilityName, "special_bonus_unique_") then abilityValues = GetKeyValue(abilityName, "AbilityValues") end
							if type(abilityValues) == "table" then
								for k,v in pairs(abilityValues) do
									if type(k) == "string" and
									not string.endswith(k, "tooltip") and
									type(v) == "table" then
										for k1,v1 in pairs(v) do
											if type(k1) == "string" and string.starts(k1, "special_bonus_unique_") then
												addTalent(k1, heroName, math.random(9), {key = "value", value = v1})
												--print("k: "..k)
												--print("v1: "..v1)
												--continue = true
											end
										end
										
									end
								end
							end
						end
					else
						addTalent(talentName, heroName, math.random(5))
					end
				end
			end
		end
	end
end

for name, override in pairs(NATIVE_TALENTS) do
	if not nativeTalents[name] and not skippedTalents[name] then
		--print(name .. ": presents in NATIVE_TALENTS but isn't a valid talent")
	end
end

for name in pairs(LoadKeyValues("scripts/npc/override/talents.txt")) do
	if not nativeTalents[name] then
		--print(name .. ": presents in ability override but isn't a valid talent")
	end
end

return nativeTalents
