require("items/item_infinity_stones")

STONES_TIME_DROP = 6
DROP_CHANCE_DECREASE = 2

PLAYERS_DROP_CHANCE = {}

CHAMPIONS_DROP_CHANCE = {
    [5] = 20,
    [4] = 15,
    [3] = 10,
    [2] = 5
}

STONES_TABLE = {
    {"item_power_stone", true},
    {"item_time_stone", true},
    {"item_soul_stone", true},
    {"item_mind_stone", true},
    {"item_space_stone", true},
    {"item_reality_stone", true},
}

STONES_LIST = {
    ["item_power_stone"] = true,
    ["item_time_stone"] = true,
    ["item_soul_stone"] = true,
    ["item_mind_stone"] = true,
    ["item_space_stone"] = true,
    ["item_reality_stone"] = true
}

STONES_IN_WORLD = {}

DROPPED_STONES = 0