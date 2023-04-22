ModuleRequire(..., "data")

InfinityStones = InfinityStones or class({})
InfinityStones.particle_cash = {}

if IsServer() then
	function InfinityStones:OnEntityKilled(keys)
	   	local killedUnit = EntIndexToHScript( keys.entindex_killed )
		local killerEntity
		if keys.entindex_attacker then
			killerEntity = EntIndexToHScript( keys.entindex_attacker )
		end

	    if killedUnit and killerEntity then
	        --print(CHAMPIONS_DROP_CHANCE)
			--infinity stones drop
			if
			killerEntity:IsTrueHero() and
			killedUnit:IsChampion() and
			GetDOTATimeInMinutesFull() >= STONES_TIME_DROP and
			DROPPED_STONES < #STONES_TABLE and

			RollPercentage(CHAMPIONS_DROP_CHANCE[killedUnit:FindModifierByName("modifier_neutral_champion"):GetStackCount()] * (PLAYERS_DROP_CHANCE[killerEntity:GetPlayerID()] or 1)) then
				local stone
				while true do
					local i = RandomInt(1, #STONES_TABLE)
					local st = STONES_TABLE[i]
					if st[2] then
						stone = CreateItem(STONES_TABLE[i][1], nil, nil)
						stone.first = true
						--stone:SetEntityName("infinity_stone")
						STONES_IN_WORLD[STONES_TABLE[i][1]] = stone
						--print(st[1])
						DROPPED_STONES = DROPPED_STONES + 1
						st[2] = false
						break
					end
				end
				--print(stone:GetAbilityName())
				CreateItemOnPositionSync(killedUnit:GetAbsOrigin(), stone)
				local drop_chance_mult = PLAYERS_DROP_CHANCE[killerEntity:GetPlayerID()]
				PLAYERS_DROP_CHANCE[killerEntity:GetPlayerID()] = (drop_chance_mult or 1) / DROP_CHANCE_DECREASE

				local hero_name = killerEntity:GetFullName()
				--print(hero_name)
				Notifications:TopToAll({text="#"..stone:GetAbilityName(), duration = 6})
				Notifications:TopToAll({text="#infinity_stones_get", continue = true})
				Notifications:TopToAll({text="#"..hero_name, continue = true})
			end
		end
	end

	function InfinityStones:Think()
		for k,_ in pairs(STONES_LIST) do
			local stone = k
			local entities = Entities:FindAllByName(stone)
			if entities ~= {} then
				for _,v in pairs(entities) do
					if not v.first then
					if v:GetItemSlot() == -1 and not v.vision then
						for team = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
							local f = FindFountain(team)
							if f then
								local dummy = CreateUnitByName("npc_dummy_flying", v:GetAbsOrigin(), false, nil, nil, team)
								dummy:SetEntityName("infinity_stone")
								dummy:SetDayTimeVisionRange(100)
								dummy:SetNightTimeVisionRange(100)
								v.dummy_cash = dummy
							end
						end
						v.vision = true
					elseif v:GetItemSlot() > -1 and v.vision then
						UTIL_Remove(v.dummy_cash)
						v.vision = false
					end
					end
				end
			end
		end
		return 1
	end

	function InfinityStones:OnItemPickedUp(item)
		if IsValidEntity(item) and STONES_LIST[item:GetName()] and item.first then
			item.first = false
		end
	end
end

--GetContainer()
--Entities