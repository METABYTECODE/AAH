GameMode = GameMode or class({})
ARENA_VERSION = LoadKeyValues("addoninfo.txt").version

GAMEMODE_INITIALIZATION_STATUS = {}

local requirements = {
	"libraries/keyvalues",
	"libraries/timers",
	"libraries/projectiles",
	"libraries/notifications",
	"libraries/animations",
	"libraries/attachments",
	"libraries/playertables",
	"libraries/containers",
	-- "libraries/pathgraph",
	"libraries/worldpanels",
	"libraries/statcollection/init",
	--------------------------------------------------
	"data/constants",
	"data/globals",
	"data/kv_data",
	"data/modifiers",
	"data/abilities",
	"data/ability_functions",
	"data/ability_shop",
	--------------------------------------------------
	"internal/gamemode",
	"internal/events",
	--------------------------------------------------
	"modules/index",

	"events",
	"custom_events",
	"filters",
}

local modifiers = {
	modifier_apocalypse_apocalypse = "heroes/hero_apocalypse/modifier_apocalypse_apocalypse",
	modifier_saitama_limiter = "heroes/hero_saitama/modifier_saitama_limiter",
	modifier_set_attack_range = "modifiers/modifier_set_attack_range",
	modifier_charges = "modifiers/modifier_charges",
	modifier_hero_selection_transformation = "modifiers/modifier_hero_selection_transformation",
	modifier_max_attack_range = "modifiers/modifier_max_attack_range",
	modifier_arena_hero = "modifiers/modifier_arena_hero",
	modifier_item_demon_king_bar_curse = "items/modifier_item_demon_king_bar_curse",
	modifier_hero_out_of_game = "modifiers/modifier_hero_out_of_game",
	modifier_arena_util = "modifiers/modifier_arena_util",

	modifier_splash_timer = "modifiers/modifier_splash_timer",

	modifier_stamina = "modifiers/modifier_stamina",
	modifier_strength_crit = "modifiers/modifier_strength_crit",
	modifier_strength_crit_true_strike = "modifiers/modifier_strength_crit",
	modifier_intelligence_primary_bonus = "modifiers/modifier_intelligence_primary_bonus",

	modifier_agility_bonus_attacks = "modifiers/modifier_agility_primary_bonus/modifier_agility_bonus_attacks",
	modifier_agility_primary_bonus = "modifiers/modifier_agility_primary_bonus/modifier_agility_primary_bonus",

	modifier_universal_attribute = "modifiers/modifier_universal_attribute",


	--modifier_item_shard_attackspeed_stack = "modifiers/modifier_item_shard_attackspeed_stack",
}

for k,v in pairs(modifiers) do
	LinkLuaModifier(k, v, LUA_MODIFIER_MOTION_NONE)
end

AllPlayersInterval = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23}

for i = 1, #requirements do
	require(requirements[i])
end

Options:Preload()

function GameMode:InitGameMode()
	GameMode:SetupRules()
	GameMode = self
	GameRules:GetGameModeEntity():SetCustomBackpackSwapCooldown(0)
	GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(1)
	GameRules:SetPreGameTime( 700.0 )
	--print("init game mode")
	if GAMEMODE_INITIALIZATION_STATUS[2] then
		return
	end
	GAMEMODE_INITIALIZATION_STATUS[2] = true

	Containers:SetItemLimit(50)
	Containers:UsePanoramaInventory(false)
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(true)
	--GameRules:GetGameModeEntity():SetUseTurboCouriers(true)
	GameRules:GetGameModeEntity():SetPauseEnabled(IsInToolsMode())
	--print("init game mode")
	
	if not Timers.started then Timers:start() end
	if not Containers.containers then Containers:start() end
	
	Events:Emit("activate")


	PlayerTables:CreateTable("arena", {}, AllPlayersInterval)
	PlayerTables:CreateTable("player_hero_indexes", {}, AllPlayersInterval)
	PlayerTables:CreateTable("players_abandoned", {}, AllPlayersInterval)
	PlayerTables:CreateTable("gold", {}, AllPlayersInterval)
	PlayerTables:CreateTable("weather", {}, AllPlayersInterval)
	PlayerTables:CreateTable("disable_help_data", {[0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {}, [9] = {}, [10] = {}, [11] = {}, [12] = {}, [13] = {}, [14] = {}, [15] = {}, [16] = {}, [17] = {}, [18] = {}, [19] = {}, [20] = {}, [21] = {}, [22] = {}, [23] = {}}, AllPlayersInterval)

	--Timers:start()
	--Containers:start()

	Timers:NextTick(function()
		GLOBAL_DUMMY = GLOBAL_DUMMY or CreateUnitByName("npc_dummy_unit", Vector(0, 0, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
	end)
end

function GameMode:OnFirstPlayerLoaded()
	StatsClient:FetchPreGameData()
	if Options:IsEquals("MainHeroList", "NoAbilities") then
		CustomAbilities:PrepareData()
	end
end

function GameMode:OnAllPlayersLoaded()
	if GAMEMODE_INITIALIZATION_STATUS[4] then
		return
	end
	GAMEMODE_INITIALIZATION_STATUS[4] = true
	Events:Emit("AllPlayersLoaded")
end

function GameMode:OnHeroSelectionStart()
	--StatsClient:CalculateAverageRating()
	Teams:PostInitialize()
	Options:CalculateVotes()
	DynamicMinimap:Init()
	Spawner:PreloadSpawners()
	Bosses:InitAllBosses()
	CustomRunes:Init()
	CustomTalents:Init()
	Timers:CreateTimer(0.1, function()
		for playerId, data in pairs(PLAYER_DATA) do
			if PlayerResource:IsPlayerAbandoned(playerId) then
				PlayerResource:RemoveAllUnits(playerId)
			end
			if PlayerResource:IsBanned(playerId) then
				PlayerResource:KickPlayer(playerId)
			end
		end
	end)
end

function GameMode:OnHeroSelectionEnd()
	--Timers:CreateTimer(CUSTOM_GOLD_TICK_TIME, Dynamic_Wrap(GameMode, "GameModeThink"))
	GameRules:GetGameModeEntity():SetThink( "GameModeThink", GameMode, "GameModeThink", CUSTOM_GOLD_TICK_TIME)
	--Timers:CreateTimer(0.1, Dynamic_Wrap(InfinityStones, "Think"))
	GameRules:GetGameModeEntity():SetThink( "Think", InfinityStones, "InfinityStones", 0.1)
	Timers:CreateTimer(1, Dynamic_Wrap(GameMode, 'KillWeightIncrease'))
	PanoramaShop:StartItemStocks()
	Duel:CreateGlobalTimer()
	Weather:Init()
	GameRules:GetGameModeEntity():SetPauseEnabled(Options:IsEquals("EnablePauses"))

	Timers:CreateTimer(10, function()
		--print("timer")
		for playerId = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(playerId) and not PlayerResource:IsFakeClient(playerId) and GetConnectionState(playerId) == DOTA_CONNECTION_STATE_CONNECTED then
				local heroName = HeroSelection:GetSelectedHeroName(playerId) or ""
				if heroName == "" or heroName == FORCE_PICKED_HERO then
					GameMode:BreakGame("arena_end_screen_error_broken")
					return
				end
			end
		end
	end)
end

function GameMode:OnHeroInGame(hero)
	Timers:NextTick(function()
		if IsValidEntity(hero) and hero:IsTrueHero() then
			Teams:RecalculateKillWeight(hero:GetTeam())
		end
	end)
end

function GameMode:OnGameInProgress()
	if GAMEMODE_INITIALIZATION_STATUS[3] then
		return
	end
	GAMEMODE_INITIALIZATION_STATUS[3] = true
	Spawner:RegisterTimers()
	Timers:CreateTimer(function()
		CustomRunes:SpawnRunes()
		return CUSTOM_RUNE_SPAWN_TIME
	end)
end

function GameMode:PrecacheUnitQueueed(name)
	if not table.includes(RANDOM_OMG_PRECACHED_HEROES, name) then
		if not IS_PRECACHE_PROCESS_RUNNING then
			IS_PRECACHE_PROCESS_RUNNING = true
			table.insert(RANDOM_OMG_PRECACHED_HEROES, name)
			PrecacheUnitByNameAsync(name, function()
				IS_PRECACHE_PROCESS_RUNNING = nil
			end)
		else
			Timers:CreateTimer(0.5, function()
				GameMode:PrecacheUnitQueueed(name)
			end)
		end
	end
end

local mapMin = Vector(-MAP_LENGTH, -MAP_LENGTH)
local mapClampMin = ExpandVector(mapMin, -MAP_BORDER)
local mapMax = Vector(MAP_LENGTH, MAP_LENGTH)
local mapClampMax = ExpandVector(mapMax, -MAP_BORDER)
function GameMode:GameModeThink()
	for i = 0, 23 do
		if PlayerResource:IsValidPlayerID(i) then
			local hero = PlayerResource:GetSelectedHeroEntity(i)
			if hero then
				hero:SetNetworkableEntityInfo("unit_name", hero:GetFullName())
				MeepoFixes:ShareItems(hero)
				for _, v in ipairs(hero:GetFullName() == "npc_dota_hero_meepo" and MeepoFixes:FindMeepos(hero, true) or { hero }) do
					local position = v:GetAbsOrigin()
					if not IsInBox(position, mapMin, mapMax) then
						FindClearSpaceForUnit(v, VectorOnBoxPerimeter(position, mapClampMin, mapClampMax), true)
					end
				end
			end
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
				local goldPerTick = 0

				local courier = Structures:GetCourier(i)
				if courier and courier:IsAlive() then
					goldPerTick = CUSTOM_GOLD_PER_TICK
				end

				if hero then
					if hero.talent_keys and hero.talent_keys.bonus_gold_per_minute then
						goldPerTick = goldPerTick + hero.talent_keys.bonus_gold_per_minute / 60 * CUSTOM_GOLD_TICK_TIME
					end
					if hero.talent_keys and hero.talent_keys.bonus_xp_per_minute then
						hero:AddExperience(hero.talent_keys.bonus_xp_per_minute / 60 * CUSTOM_GOLD_TICK_TIME, 0, false, false)
					end
				end

				Gold:AddGold(i, goldPerTick)
			end
			AntiAFK:Think(i)
		end
	end
	--kill weight increase
	local dota_time = GetDOTATimeInMinutesFull()
	if not Duel.kill_weight_increase and dota_time >= KILL_WEIGHT_START_INCREASE_MINUTE then
		GameMode.kill_weight_per_minute = dota_time - KILL_WEIGHT_START_INCREASE_MINUTE
		Duel.kill_weight_increase = true
	end
	
	--InfinityStones:Think()
	return CUSTOM_GOLD_TICK_TIME
end

function GameMode:SetupRules()
	GameRules:SetCustomGameSetupAutoLaunchDelay(IsInToolsMode() and 3 or 15)
	GameRules:LockCustomGameSetupTeamAssignment(false)
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetTreeRegrowTime(60)
	GameRules:SetUseCustomHeroXPValues(true)

	local gameMode = GameRules:GetGameModeEntity()
	gameMode:SetBuybackEnabled(false)
	gameMode:SetTopBarTeamValuesOverride(true)
	gameMode:SetUseCustomHeroLevels(true)
	gameMode:SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
	gameMode:SetMaximumAttackSpeed(800)
	gameMode:SetMinimumAttackSpeed(50)
	gameMode:SetNeutralStashEnabled(false)
end

function GameMode:BreakGame(message)
	GameMode.Broken = message
	Tutorial:ForceGameStart()
	GameMode:OnOneTeamLeft(-1)
end

function GameMode:BreakSetup(message)
	GameRules:SetPostGameTime(0)
	GameRules:SetSafeToLeave(true)
	PlayerTables:CreateTable("stats_setup_error", message, AllPlayersInterval)
	Timers:CreateTimer(60, function() GameMode:BreakGame(true) end)
end
