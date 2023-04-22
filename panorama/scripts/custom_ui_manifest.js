'use strict';
GameUI.CustomUIConfig().team_colors = {};
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = '#008000';
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_BADGUYS] = '#FF0000';
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = '#c54da8';
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = '#FF6C00';

GameUI.CustomUIConfig().team_names = {};
GameUI.CustomUIConfig().team_names[DOTATeam_t.DOTA_TEAM_GOODGUYS] = $.Localize('#DOTA_GoodGuys');
GameUI.CustomUIConfig().team_names[DOTATeam_t.DOTA_TEAM_BADGUYS] = $.Localize('#DOTA_BadGuys');
GameUI.CustomUIConfig().team_names[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = $.Localize('#DOTA_Custom1');
GameUI.CustomUIConfig().team_names[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = $.Localize('#DOTA_Custom2');

Game.MouseEvents = {
	OnLeftPressed: []
};
Game.DisableWheelPanels = [];
GameUI.SetMouseCallback(function(eventName, arg) {
	var result = false;
	var ClickBehaviors = GameUI.GetClickBehaviors();
	if (eventName === 'pressed') {
		if (arg === 0) {
			if (Game.MouseEvents.OnLeftPressed.length > 0) {
				for (var k in Game.MouseEvents.OnLeftPressed) {
					var r = Game.MouseEvents.OnLeftPressed[k](ClickBehaviors, eventName, arg);
					if (r === true)
						result = r;
				}
			}
		} else if (ClickBehaviors === CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE && (arg === 5 || arg === 6)) {
			for (var index in Game.DisableWheelPanels) {
				if (IsCursorOnPanel(Game.DisableWheelPanels[index])) {
					return true;
				}
			}
		};
	};
	return result;
});

GameUI.CustomUIConfig().custom_entity_values = GameUI.CustomUIConfig().custom_entity_values || {};
DynamicSubscribeNTListener('custom_entity_values', function(tableName, key, value) {
	GameUI.CustomUIConfig().custom_entity_values[key] = value;
});
GameUI.CustomUIConfig().ability_damage_subtypes = GameUI.CustomUIConfig().ability_damage_subtypes || {};
DynamicSubscribeNTListener('ability_damage_subtypes', function(tableName, key, value) {
	GameUI.CustomUIConfig().ability_damage_subtypes[key] = value;
});
GameUI.CustomUIConfig().units_subtypes_resistance = GameUI.CustomUIConfig().units_subtypes_resistance || {};
DynamicSubscribeNTListener('units_subtypes_resistance', function(tableName, key, value) {
	GameUI.CustomUIConfig().units_subtypes_resistance[key] = value;
});

function Hook() {
	this.handlers = [];
}

Hook.prototype.tap = function(handler) {
	this.handlers.push(handler)
}

Hook.prototype.call = function() {
	var args = arguments;
	_.each(this.handlers, function(handler) {
		handler.apply(null, args)
	})
}

GameUI.CustomUIConfig().CustomHooks = {
	custom_talents_toggle_tree: new Hook(),
	panorama_shop_open_close: new Hook(),
	panorama_shop_show_item: new Hook(),
	panorama_shop_show_item_if_open: new Hook(),
	player_profiles_show_info: new Hook(),
}
