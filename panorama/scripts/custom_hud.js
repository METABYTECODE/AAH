var ONCLICK_PURGABLE_MODIFIERS = [
	'modifier_doppelganger_mimic',
	'modifier_tether_ally_aghanims',
	"modifier_universal_attribute"
];
var CustomChatLinesPanel,
	BossDropVoteTimers = [],
	HookedAbilityPanelsCount = 0;

function UpdateHealthBar(){
	var unit = Players.GetLocalPlayerPortraitUnit();
	//$.Msg(Entities.IsHero(unit))
	if (!unit) return
	var custom_entity_value = GameUI.CustomUIConfig().custom_entity_values[unit];
	var HealthContainer = FindDotaHudElement('HealthContainer');
	var HealthLabel = HealthContainer.FindChildTraverse('HealthLabel');

	var HealthRegenLabel = FindDotaHudElement('HealthRegenLabel');
	if (HealthLabel && HealthRegenLabel && unit) {
		var curhealth = (Entities.GetHealth(unit))
		var maxhealth = (Entities.GetMaxHealth(unit))
		//HealthRegenLabel.text = "+" + (Entities.GetHealthThinkRegen(unit) / Entities.GetMaxHealth(unit) * 100).toFixed(1)+"%"
		curhealth = NumberReduction(Entities.GetHealth(unit))
		maxhealth = NumberReduction(Entities.GetMaxHealth(unit))
		HealthLabel.text = curhealth + " /" + maxhealth
	}
}

function UpdateManaBar() {
	//$.Msg('Mana')
	var unit = Players.GetLocalPlayerPortraitUnit();
	if (!unit) return
	var custom_entity_value = GameUI.CustomUIConfig().custom_entity_values[unit];

	var ManaContainer = FindDotaHudElement('ManaContainer');
	var ManaProgress = FindDotaHudElement('ManaProgress');
	var ManaRegenLabel = FindDotaHudElement('ManaRegenLabel');
	var ManaLabel = ManaContainer.FindChildTraverse('ManaLabel');

	if (ManaContainer && unit && ManaProgress) {
		if (!custom_entity_value || !custom_entity_value.Energy) {
			//$.Msg('mana')
			var curmana = (Entities.GetMana(unit))
			var maxmana = (Entities.GetMaxMana(unit))
			var manareg = Entities.GetManaThinkRegen(unit)
			var manacount = curmana / maxmana
			//ManaRegenLabel.text = "+"+(manareg / maxmana * 100).toFixed(1) + "%"
			ManaProgress.value = manacount
			curmana = NumberReduction(Entities.GetMana(unit))
			maxmana = NumberReduction(Entities.GetMaxMana(unit))
			ManaLabel.text = curmana + " /" + maxmana
		}else{
			var maxmana = NumberReduction(Entities.GetMaxMana(unit))
			ManaLabel.text = maxmana
			ManaProgress.value = 1
			ManaRegenLabel.text = "+"+NumberReduction(Entities.GetManaThinkRegen(unit))
		}
	}
}

function UpdateStaminaBar() {
	//$.Msg('Stamina')
	var unit = Players.GetLocalPlayerPortraitUnit();
	if (!unit || !Entities.IsHero(unit)) return
	var custom_entity_value = GameUI.CustomUIConfig().custom_entity_values[unit];

	var ManaContainer = FindDotaHudElement('ManaContainer');
	var ManaProgress = FindDotaHudElement('ManaProgress');
	var ManaRegenLabel = FindDotaHudElement('ManaRegenLabel');
	var ManaLabel = ManaContainer.FindChildTraverse('ManaLabel');

	if (ManaContainer && unit && custom_entity_value && ManaProgress && ManaLabel){
		var curstam = NumberReduction(custom_entity_value.CurrentStamina)
		var maxstam = NumberReduction(custom_entity_value.MaxStamina)
		var stamreg = custom_entity_value.StaminaRegen
		var stamcount = curstam / maxstam
		ManaLabel.text = curstam + " /" + maxstam
		ManaRegenLabel.text = ""//"+"+stamreg
		ManaProgress.value = stamcount
	}
}

function UpdatePanoramaHUD() {
	var unit = Players.GetLocalPlayerPortraitUnit();
	if (!unit) return
	var CustomModifiersList = $('#CustomModifiersList');
	var VisibleModifiers = [];
	for (var i = 0; i < Entities.GetNumBuffs(unit); ++i) {
		var buffSerial = Entities.GetBuff(unit, i);
		if (buffSerial !== -1) {
			var buffName = Buffs.GetName(unit, buffSerial);
			VisibleModifiers.push(buffName);
			if (ONCLICK_PURGABLE_MODIFIERS.indexOf(buffName) !== -1) {
				if (CustomModifiersList.FindChildTraverse(buffName) == null) {
					if (buffName == "modifier_universal_attribute") {
						var panel = $.CreatePanel('DOTAAbilityImage', CustomModifiersList, buffName);
						panel.SetImage("s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_all_psd.vtex");

						panel.SetPanelEvent('onactivate', (function(_buffName) {
							return function() {
								GameEvents.SendCustomGameEventToServer('modifier_universal_attribute_clicked', {
									unit: unit,
									modifier: _buffName
								});
							};
						})(buffName));
						panel.SetPanelEvent('onmouseover', (function(_panel, _buffName) {
							return function() {
								$.DispatchEvent('DOTAShowTitleTextTooltip', _panel, $.Localize('#DOTA_Tooltip_modifier_universal_attribute'), $.Localize('#hud_modifier_click_to_change_primary_bonus'));
							};
						})(panel, buffName));
						panel.SetPanelEvent('onmouseout', (function(_panel) {
							return function() {
								$.DispatchEvent('DOTAHideTitleTextTooltip', _panel);
							};
						})(panel));
						
						continue;
					}
					var panel = $.CreatePanel('DOTAAbilityImage', CustomModifiersList, buffName);
					panel.abilityname = Buffs.GetTexture(unit, buffSerial);
					panel.SetPanelEvent('onactivate', (function(_buffName) {
						return function() {
							GameEvents.SendCustomGameEventToServer('modifier_clicked_purge', {
								unit: unit,
								modifier: _buffName
							});
						};
					})(buffName));
					panel.SetPanelEvent('onmouseover', (function(_panel, _buffName) {
						return function() {
							$.DispatchEvent('DOTAShowTitleTextTooltip', _panel, $.Localize('#DOTA_Tooltip_' + _buffName), $.Localize('#hud_modifier_click_to_remove'));
						};
					})(panel, buffName));
					panel.SetPanelEvent('onmouseout', (function(_panel) {
						return function() {
							$.DispatchEvent('DOTAHideTitleTextTooltip', _panel);
						};
					})(panel));
				}
			}
		}
	}

	var StrengthDamageLabel = FindDotaHudElement('StrengthDamageLabel');
	var AgilityDamageLabel = FindDotaHudElement('AgilityDamageLabel');
	var IntelligenceDamageLabel = FindDotaHudElement('IntelligenceDamageLabel');

	var StrengthContainer = FindDotaHudElement('StrengthContainer');
	var AgilityContainer = FindDotaHudElement('AgilityContainer');
	var IntelligenceContainer = FindDotaHudElement('IntelligenceContainer');

	var custom_entity_value = GameUI.CustomUIConfig().custom_entity_values[unit];

	var primat
	var b_primat
	if (custom_entity_value && custom_entity_value.PrimaryAttribute) primat = custom_entity_value.PrimaryAttribute
	if (custom_entity_value && custom_entity_value.BonusPrimaryAttribute) b_primat = custom_entity_value.BonusPrimaryAttribute
	//b_primat = 0
	//$.Msg(b_primat)
	//$.Msg(primat)
	if (typeof(primat) == "string" && StrengthDamageLabel && AgilityDamageLabel && IntelligenceDamageLabel &&
		StrengthContainer && AgilityContainer && IntelligenceContainer) {
		//$.Msg(typeof(primat))
		if (primat == "0") {
			//$.Msg(b_primat)
			StrengthDamageLabel.visible = true
			AgilityDamageLabel.visible = false
			IntelligenceDamageLabel.visible = false
			AddStyle(StrengthContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #380f01 ) )",
				"margin-left": "6px"
			})
			AddStyle(AgilityContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
			AddStyle(IntelligenceContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
		}
		else if (primat == "1") {
			//$.Msg(primat)
			StrengthDamageLabel.visible = false
			AgilityDamageLabel.visible = true
			IntelligenceDamageLabel.visible = false
			AddStyle(StrengthContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
			AddStyle(AgilityContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #09360b ) )",
				"margin-left": "6px"
			})
			AddStyle(IntelligenceContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
		}
		//||
		else if (primat == "2") {
			//$.Msg(primat)
			StrengthDamageLabel.visible = false
			AgilityDamageLabel.visible = false
			IntelligenceDamageLabel.visible = true
			AddStyle(StrengthContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
			AddStyle(AgilityContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
			AddStyle(IntelligenceContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #003237 ) )",
				"margin-left": "6px"
			})
		}
	}

	if (typeof(b_primat) == "string" && StrengthDamageLabel && AgilityDamageLabel && IntelligenceDamageLabel &&
		StrengthContainer && AgilityContainer && IntelligenceContainer) {
		if (b_primat == "0" && b_primat != primat) {
			StrengthDamageLabel.visible = true
			AddStyle(StrengthContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #380f01 ) )",
				"margin-left": "6px"
			})
		}
		else if (typeof(b_primat) != "string") {
			StrengthDamageLabel.visible = false
			AddStyle(StrengthContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
		}
		if (b_primat == "1" && b_primat != primat) {
			AgilityDamageLabel.visible = true
			AddStyle(AgilityContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #09360b ) )",
				"margin-left": "6px"
			})
		}
		else if (typeof(b_primat) != "string") {
			AgilityDamageLabel.visible = false
			AddStyle(AgilityContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
		}
		if (b_primat == "2" && b_primat != primat) {
			IntelligenceDamageLabel.visible = true
			AddStyle(IntelligenceContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #003237 ) )",
				"margin-left": "6px"
			})
		}
		else if (typeof(b_primat) != "string") {
			IntelligenceDamageLabel.visible = false
			AddStyle(IntelligenceContainer, {
				"background-color": "gradient( linear, 100% 0%, 0% 0%, from( #000 ), to( #000 ) )",
				"margin-left": "6px"
			})
		}
	}

	_.each(CustomModifiersList.Children(), function(child) {
		if (VisibleModifiers.indexOf(child.id) === -1) child.DeleteAsync(0);
	});

	var GoldLabel = FindDotaHudElement('ShopButton').FindChildTraverse('GoldLabel');
	var playerTeam = Players.GetTeam(Game.GetLocalPlayerID());
	UpdateGoldLabel(playerTeam, unit, GoldLabel);
	var sw = Game.GetScreenWidth();
	var sh = Game.GetScreenHeight();
	var minimap = FindDotaHudElement('minimap_block');
	$('#DynamicMinimapRoot').style.height = ((minimap.actuallayoutheight + minimap.contentheight - minimap.actuallayoutheight) / sh * 100) + '%';
	$('#DynamicMinimapRoot').style.width = ((minimap.actuallayoutwidth + minimap.contentwidth - minimap.actuallayoutwidth) / sw * 100) + '%';
	var pcs = FindDotaHudElement('PortraitContainer').GetPositionWithinWindow();
	if (pcs != null && !isNaN(pcs.x) && !isNaN(pcs.y))
		CustomModifiersList.style.position = (pcs.x / sw * 100) + '% ' + (pcs.y / sh * 100) + '% 0';
	var abilities = FindDotaHudElement('abilities');
	if (HookedAbilityPanelsCount !== abilities.GetChildCount()) {
		HookedAbilityPanelsCount = abilities.GetChildCount();
		_.each(abilities.Children(), function(child, index) {
			var btn = child.FindChildTraverse('AbilityButton');
			btn.SetPanelEvent('onactivate', function() {
				if (GameUI.IsAltDown()) {
					var unit = Players.GetLocalPlayerPortraitUnit();
					GameEvents.SendCustomGameEventToServer('custom_chat_send_message', {
						ability: GetVisibleAbilityInSlot(unit, index)
					});
				}
			});
		});
	}

	// Chat redirect
	var ChatLinesPanel = FindDotaHudElement('ChatLinesPanel');
	var redirectedPhrases = [
		$.Localize('#DOTA_Chat_CantPause'),
		$.Localize('#DOTA_Chat_NoPausesLeft'),
		$.Localize('#DOTA_Chat_CantPauseYet'),
		$.Localize('#DOTA_Chat_PauseCountdown'),
		$.Localize('#DOTA_Chat_Paused'),
		$.Localize('#DOTA_Chat_UnpauseCountdown'),
		$.Localize('#DOTA_Chat_Unpaused'),
		$.Localize('#DOTA_Chat_AutoUnpaused'),
		$.Localize('#DOTA_Chat_YouPaused'),
		$.Localize('#DOTA_Chat_CantUnpauseTeam')
	];
	var escaped = _.escapeRegExp(redirectedPhrases.map(function(x) {return $.Localize(x).replace(/%s\d/g, '.*');}).join('|'));
	var regexp = new RegExp('^(' + escaped + ')$');
	for (var i = 0; i < ChatLinesPanel.GetChildCount(); i++) {
		var child = ChatLinesPanel.GetChild(i);
		if (child.text && child.text.match(regexp)) {
			RedirectMessage(child);
		}
	}
}

function UpdateGoldLabel(playerTeam, unit, label) {
	if (playerTeam === Entities.GetTeamNumber(unit)) {
		var ownerId = Entities.GetPlayerOwnerID(unit);
		label.text = FormatGold(GetPlayerGold(ownerId === -1 ? Game.GetLocalPlayerID() : ownerId));
	} else {
		label.text = '';
	}
}

function AutoUpdatePanoramaHUD() {
	$.Schedule(0.2, AutoUpdatePanoramaHUD);
	UpdatePanoramaHUD();
	//for (var keys in GameUI.CustomUIConfig().units_subtypes_resistance) $.Msg(keys)
	//$.Msg(GameUI.GetCursorPosition())
}
function HookPanoramaPanels() {
	FindDotaHudElement('QuickBuyRows').visible = false;
	FindDotaHudElement('shop').visible = false;
	FindDotaHudElement('HUDSkinMinimap').visible = false;
	FindDotaHudElement('combat_events').visible = false;
	FindDotaHudElement('ChatEmoticonButton').visible = false;
	FindDotaHudElement('topbar').visible = false;
	FindDotaHudElement('DeliverItemsButton').style.horizontalAlign = 'right';
	FindDotaHudElement('LevelLabel').style.width = '100%';
	FindDotaHudElement('stash').style.marginBottom = '47px';

	var ability_damage_subtypes_tooltip = $.CreatePanel('Panel', $.GetContextPanel(), '');
	ability_damage_subtypes_tooltip.style.position = "564px 950px 0"
	ability_damage_subtypes_tooltip.style.tooltipPosition = 'top';

	//$.Msg("1")
	var portrait_hud = FindDotaHudElement('portraitHUD');
	portrait_hud.SetPanelEvent('onmouseover', function() {
		var unit_ = Players.GetLocalPlayerPortraitUnit()
		var custom_entity_value = GameUI.CustomUIConfig().custom_entity_values[unit_];
		ability_damage_subtypes_tooltip.visible = true;

		for (var keys in DAMAGE_SUBTYPES) {
			ability_damage_subtypes_tooltip.SetDialogVariable(DAMAGE_SUBTYPES[keys], "0%");
		}
		if (custom_entity_value && custom_entity_value.DamageSubtypesResistance) {
			for (var keys in custom_entity_value.DamageSubtypesResistance) {
				var damsubres = custom_entity_value.DamageSubtypesResistance[keys]
				//$.Msg(keys + ", " + damsubres)
				ability_damage_subtypes_tooltip.SetDialogVariable(DAMAGE_SUBTYPES[keys], damsubres + "%");
			}
		}
		if (Entities.IsHero(unit_)) $.DispatchEvent("DOTAShowTitleTextTooltip", ability_damage_subtypes_tooltip, "#damage_subtype_resistance", "#damage_subtype_resistance_list")
		//$.Msg("1")
	});
	portrait_hud.SetPanelEvent('onmouseout', function() {
		if (ability_damage_subtypes_tooltip) {
			$.DispatchEvent("DOTAHideTitleTextTooltip");
			ability_damage_subtypes_tooltip.visible = false;
		}
	});

	var shopbtn = FindDotaHudElement('ShopButton');
	var StatBranch = FindDotaHudElement('StatBranch');
	var level_stats_frame = FindDotaHudElement('level_stats_frame');
	var chat = FindDotaHudElement('ChatLinesWrapper');
	var StatsLevelUpTab = level_stats_frame.FindChildTraverse('LevelUpTab');

	shopbtn.FindChildTraverse('BuybackHeader').visible = false;
	shopbtn.ClearPanelEvent('onactivate');
	shopbtn.ClearPanelEvent('onmouseover');
	shopbtn.ClearPanelEvent('onmouseout');
	shopbtn.SetPanelEvent('onactivate', function() {
		if (GameUI.IsAltDown()) {
			GameEvents.SendCustomGameEventToServer('custom_chat_send_message', {
				GoldUnit: Players.GetLocalPlayerPortraitUnit()
			});
		} else {
			CustomHooks.panorama_shop_open_close.call();
		}
	});

	StatBranch.ClearPanelEvent('onactivate');
	StatBranch.ClearPanelEvent('onmouseover');
	StatBranch.ClearPanelEvent('onmouseout');
	StatBranch.hittestchildren = false;

	level_stats_frame.ClearPanelEvent('onmouseover');
	StatsLevelUpTab.ClearPanelEvent('onmouseover');
	StatsLevelUpTab.ClearPanelEvent('onmouseout');
	StatsLevelUpTab.ClearPanelEvent('onactivate');
	StatsLevelUpTab.SetPanelEvent('onactivate', function() {
		CustomHooks.custom_talents_toggle_tree.call();
	});
	var DebugChat = false;

	chat.FindChildTraverse('ChatLinesPanel').visible = DebugChat;
	if (chat.FindChildTraverse('SelectionChatMessages'))
		chat.FindChildTraverse('SelectionChatMessages').DeleteAsync(0);
	CustomChatLinesPanel = $.CreatePanel('Panel', chat, 'SelectionChatMessages');
	CustomChatLinesPanel.visible = !DebugChat;
	CustomChatLinesPanel.hittest = false;
	CustomChatLinesPanel.hittestchildren = false;
	AddStyle(CustomChatLinesPanel, {
		'width': '100%',
		'flow-children': 'down',
		'vertical-align': 'top',
		'overflow': 'squish noclip',
		'padding-right': '14px',
		'background-color': 'gradient( linear, 0% 0%, 100% 0%, from( #0000 ), color-stop( 0.01, #0000 ), color-stop( 0.1, #0000 ), to( #0000 ) )',
		'transition-property': 'background-color',
		'transition-duration': '0.23s',
		'transition-timing-function': 'ease-in-out'
	});

	var stats_region = FindDotaHudElement('stats_tooltip_region');
	stats_region.SetPanelEvent('onmouseover', function() {
		var _unit = Players.GetLocalPlayerPortraitUnit();
		$.DispatchEvent('DOTAHUDShowDamageArmorTooltip', stats_region);
		var custom_entity_value = GameUI.CustomUIConfig().custom_entity_values[_unit];
		var DOTAHUDDamageArmorTooltip = FindDotaHudElement('DOTAHUDDamageArmorTooltip');

		if (DOTAHUDDamageArmorTooltip != null && custom_entity_value != null && Entities.IsHero(_unit)) {

			if (custom_entity_value.BaseAttackTime && custom_entity_value.CustomAttackSpeed){
				var AttackSpeed = custom_entity_value.CustomAttackSpeed
				var BaseAttackTime = custom_entity_value.BaseAttackTime
				//$.Msg(AttackSpeed)
				//$.Msg(BaseAttackTime)
				var AttackRate = 1 / ((1 + custom_entity_value.CustomAttackSpeed) / BaseAttackTime)
				AttackSpeed = AttackSpeed * 100
				//$.Msg(FindDotaHudElement("AttackSpeedRow").FindChildTraverse("AttackSpeed"))
				DOTAHUDDamageArmorTooltip.FindChildTraverse("AttacksPerSecond").text = "("+ AttackRate.toFixed(2)+")"
				FindDotaHudElement("AttackSpeedRow").FindChildTraverse("AttackSpeed").text = AttackSpeed.toFixed(0)
			}



			if (custom_entity_value.BaseDamageMin && custom_entity_value.BaseDamageMax && typeof(custom_entity_value.BonusDamage) == "number") {

				//var BaseDamageMin = NumberReduction(custom_entity_value.BaseDamageMin)
				//var BaseDamageMax = NumberReduction(custom_entity_value.BaseDamageMax)
				var BonusDamage = NumberReduction(custom_entity_value.BonusDamage - Math.round((custom_entity_value.BaseDamageMin + custom_entity_value.BaseDamageMax) / 2))

				DOTAHUDDamageArmorTooltip.FindChildTraverse("Damage").text = NumberReduction(custom_entity_value.BonusDamage)
				DOTAHUDDamageArmorTooltip.FindChildTraverse("DamageBonus").text = " + " + BonusDamage
			}

			//реген
			//if (custom_entity_value.HealthRegen) {
				//DOTAHUDDamageArmorTooltip.FindChildTraverse("HealthRegen").text = NumberReduction(Entities.GetHealthThinkRegen(_unit), 2)
				//DOTAHUDDamageArmorTooltip.FindChildTraverse("HealthRegenBonus").text = ""
			//}

			if (custom_entity_value.IdealArmor != null)
				DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_armor', custom_entity_value.IdealArmor.toFixed(1));

			//мана
			if (custom_entity_value.IntMana != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('intelligence_mana', NumberReduction(custom_entity_value.IntMana))

			//здоровье
			if (custom_entity_value.StrHealth != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('strength_hp', NumberReduction(custom_entity_value.StrHealth))

			//выносливость
			if (custom_entity_value.MaxStamina != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_st', NumberReduction(custom_entity_value.MaxStamina));
			//if (custom_entity_value.StaminaRegen != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_st_regen', custom_entity_value.StaminaRegen);
			if (custom_entity_value.StaminaPerHit != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('st_per_hit', custom_entity_value.StaminaPerHit.toFixed(1));

			//множители восстановления маны и силы
			if (custom_entity_value.HealtRegenAmplify != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('strength_hp_regen', custom_entity_value.HealtRegenAmplify.toFixed(2));
			if (custom_entity_value.ManaRegenAmplify != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('intelligence_mana_regen', custom_entity_value.ManaRegenAmplify.toFixed(2));

			//базовый урон
			if (custom_entity_value.CustomBaseDamage != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('custom_base_damage', custom_entity_value.CustomBaseDamage.toFixed(0));

			//скорость атаки
			if (custom_entity_value.AgilityAttackSpeed != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_attack_speed', custom_entity_value.AgilityAttackSpeed.toFixed(0));

			//бонусы от основных атрибутов
			if (custom_entity_value.StrengthCrit != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('strength_crit', custom_entity_value.StrengthCrit.toFixed(1));
			if (custom_entity_value.StrengthCritCooldown != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('strength_crit_cooldown', custom_entity_value.StrengthCritCooldown.toFixed(1));
			if (custom_entity_value.AgilityBonusAttacks != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_bonus_attacks', custom_entity_value.AgilityBonusAttacks.toFixed(0));
			if (custom_entity_value.AgilityBonusChance != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_bonus_chance', custom_entity_value.AgilityBonusChance.toFixed(1));
			if (custom_entity_value.AgilityBonusAttacksDamage != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_bonus_attacks_damage', custom_entity_value.AgilityBonusAttacksDamage.toFixed(1));
			if (custom_entity_value.IntellectPrimaryBonusMultiplier != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('intellect_multiplier', custom_entity_value.IntellectPrimaryBonusMultiplier.toFixed(0));
			if (custom_entity_value.IntellectPrimaryBonusDifference != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('intellect_difference', custom_entity_value.IntellectPrimaryBonusDifference.toFixed(0));

			//урон заклинаний
			if (custom_entity_value.IntellectSpellAmplify != null) DOTAHUDDamageArmorTooltip.SetDialogVariable('intelligence_spell_amp', custom_entity_value.IntellectSpellAmplify.toFixed(2));

			//$.Msg(custom_entity_value.StrengthCritCooldown)

			if (custom_entity_value.AttributeStrengthGain != null)
				DOTAHUDDamageArmorTooltip.SetDialogVariable('strength_per_level', custom_entity_value.AttributeStrengthGain.toFixed(1));
			if (custom_entity_value.AttributeAgilityGain != null)
				DOTAHUDDamageArmorTooltip.SetDialogVariable('agility_per_level', custom_entity_value.AttributeAgilityGain.toFixed(1));
			if (custom_entity_value.AttributeIntelligenceGain != null)
				DOTAHUDDamageArmorTooltip.SetDialogVariable('intelligence_per_level', custom_entity_value.AttributeIntelligenceGain.toFixed(1));

				DOTAHUDDamageArmorTooltip.FindChildTraverse('StrengthDetails').text = $.Localize('#arena_hud_tooltip_details_strength', DOTAHUDDamageArmorTooltip);
				DOTAHUDDamageArmorTooltip.FindChildTraverse('StrengthDetails').style.textOverflow = 'shrink';textOverflow = 'shrink';

				DOTAHUDDamageArmorTooltip.FindChildTraverse('AgilityDetails').text = $.Localize('#arena_hud_tooltip_details_agility', DOTAHUDDamageArmorTooltip);
				DOTAHUDDamageArmorTooltip.FindChildTraverse('AgilityDetails').style.textOverflow = 'shrink';
			DOTAHUDDamageArmorTooltip.FindChildTraverse('IntelligenceDetails').text = $.Localize('#arena_hud_tooltip_details_intelligence', DOTAHUDDamageArmorTooltip);
			DOTAHUDDamageArmorTooltip.FindChildTraverse('IntelligenceDetails').style.textOverflow = 'shrink';
			//$.Msg(DOTAHUDDamageArmorTooltip.FindChildTraverse('IntelligenceDetails'))


			DOTAHUDDamageArmorTooltip.FindChildTraverse('StrengthDamageLabel').text = $.Localize('#arena_hud_tooltip_details_primary_attribute_strength', DOTAHUDDamageArmorTooltip);
			DOTAHUDDamageArmorTooltip.FindChildTraverse('StrengthDamageLabel').style.textOverflow = 'shrink';
			DOTAHUDDamageArmorTooltip.FindChildTraverse('AgilityDamageLabel').text = $.Localize('#arena_hud_tooltip_details_primary_attribute_agility', DOTAHUDDamageArmorTooltip);
			DOTAHUDDamageArmorTooltip.FindChildTraverse('AgilityDamageLabel').style.textOverflow = 'shrink';
			DOTAHUDDamageArmorTooltip.FindChildTraverse('IntelligenceDamageLabel').text = $.Localize('#arena_hud_tooltip_details_primary_attribute_intelligence', DOTAHUDDamageArmorTooltip);
			DOTAHUDDamageArmorTooltip.FindChildTraverse('IntelligenceDamageLabel').style.textOverflow = 'shrink';
		}
	});
	Game.MouseEvents.OnLeftPressed.push(function(ClickBehaviors, eventName, arg) {
		if (ClickBehaviors === CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE) {
			//$.DispatchEvent('DOTAHUDHideDamageArmorTooltip');
		}
	});
	stats_region.SetPanelEvent('onmouseout', function() {
		$.DispatchEvent('DOTAHUDHideDamageArmorTooltip');
	});
	var InventoryContainer = FindDotaHudElement('InventoryContainer');
	_.each(InventoryContainer.FindChildrenWithClassTraverse('InventoryItem'), function(child, index) {
		child.FindChildTraverse('AbilityButton').SetPanelEvent('onactivate', function() {
			var item = Entities.GetItemInSlot(Players.GetLocalPlayerPortraitUnit(), index);
			if (item > -1) {
				if (GameUI.IsAltDown()) {
					GameEvents.SendCustomGameEventToServer('custom_chat_send_message', {
						ability: item
					});
				} else {
					CustomHooks.panorama_shop_show_item_if_open.call(Abilities.GetAbilityName(item));
					var _unit = Players.GetLocalPlayerPortraitUnit();
					if (Entities.IsControllableByPlayer(_unit, Game.GetLocalPlayerID())) {
						Abilities.ExecuteAbility(item, _unit, false);
					}
				}
			}
		});
	});
	var xpRoot = FindDotaHudElement('xp');
	//_.each([xpRoot.FindChildTraverse('LevelBackground'), xpRoot.FindChildTraverse('CircularXPProgress'), xpRoot.FindChildTraverse('XPProgress')], function(p) {
	//	p.SetPanelEvent('onactivate', function() {
	//		if (GameUI.IsAltDown()) {
	//			GameEvents.SendCustomGameEventToServer('custom_chat_send_message', {
	//				xpunit: Players.GetLocalPlayerPortraitUnit()
	//			});
	//		}
	//	});
	//});
}


function OnUpdateSelectedUnit() {
	var unitName = GetHeroName(Players.GetLocalPlayerPortraitUnit());
	FindDotaHudElement('UnitNameLabel').text = $.Localize("#" + unitName).toUpperCase();
	OnSkillPoint();
}

function OnSkillPoint() {
	const unit = Players.GetLocalPlayerPortraitUnit();
	const canLevelStats = Entities.GetAbilityPoints(unit) > 0 && Entities.IsControllableByPlayer(unit, Game.GetLocalPlayerID());
	const level_stats_frame = FindDotaHudElement('level_stats_frame');

	// `level_stats_frame` resets `CanLevelStats` class every frame
	level_stats_frame.GetParent().SetHasClass('CanLevelStats', canLevelStats);
	level_stats_frame.visible = canLevelStats;

	//var abilities = FindDotaHudElement('SelectedHeroAbilitiesPanelInner').Children()
		//$.Msg(abilities.length)
		/*if (abilities) {
			for (var i = 0; i < abilities.length; i++){
			var ability_image = abilities[i]
			//ability_image.SetPanelEvent('onmouseover', function() {
				var ability_tooltip =  FindDotaHudElement('DOTAAbilityTooltip')
				var description = ability_tooltip.FindChildTraverse('AbilityDescriptionContainer').Children()[0]
				//$.Msg(description)
				description.visible = false
				var ability_name = ability_tooltip.FindChildTraverse("AbilityName").text
				var ability_damage_subtypes = GameUI.CustomUIConfig().ability_damage_subtypes
				var subtype
				for (var keys in ability_damage_subtypes){
					//$.Msg($.Localize("#DOTA_Tooltip_ability_"+keys).toLowerCase())
					if ($.Localize("#DOTA_Tooltip_ability_"+keys).toLowerCase() == ability_name.toLowerCase()) {
						subtype = $.Localize('#'+ability_damage_subtypes[keys]._)
						//$.Msg('#'+subtype)
						$.Msg(ability_name)
						break;
					}
				}
				if (subtype) {
					//$.DispatchEvent('DOTAHideAbilityTooltip', "");
					if (description) {
						var text = description.text
						var _subtype_localization = $.Localize('#damage_subtype')
						description.text = text + '\n'+_subtype_localization + subtype
						//$.Msg(ability_tooltip.FindChildTraverse('AbilityDescriptionContainer').FindChildrenWithClassTraverse('Active')[0].text)
					}
				}
				//description.visible = true
			//});
		}}*/

	//for (var i = 0; i < 6; i++){
		//var ability = FindDotaHudElement('Ability'+i)
		//$.Msg(ability)
		//if (ability) ability.SetPanelEvent('onmouseover', function() {
			
			//ability_tooltip.hittest = false
		//});
	//}
	/*var ability = FindDotaHudElement('DOTAAbilityImage')
	$.Msg(ability)*/
}

// On Death
function OnDeath(data) {
	if (data.entindex_killed === SafeGetPlayerHeroEntityIndex(Game.GetLocalPlayerID())) {
		var killerOwner = Entities.GetPlayerOwnerID(data.entindex_attacker);
		var attacker = Players.IsValidPlayerID(killerOwner) ? SafeGetPlayerHeroEntityIndex(killerOwner) : data.entindex_attacker;
		FindDotaHudElement('KilledByHeroName').text = $.Localize(GetHeroName(attacker)).toUpperCase();
	}
}

// Toasts
function CreateCustomToast(data) {
	var row = $.CreatePanel('Panel', $('#CustomToastManager'), '');
	row.BLoadLayoutSnippet('ToastPanel');
	row.AddClass('ToastPanel');
	var rowText = '';

	if (data.type === 'kill') {
		var byNeutrals = data.killerPlayer == null;
		var isSelfKill = data.victimPlayer === data.killerPlayer;
		var isAllyKill = !byNeutrals && data.victimPlayer != null && Players.GetTeam(data.victimPlayer) === Players.GetTeam(data.killerPlayer);
		var isVictim = data.victimPlayer === Game.GetLocalPlayerID();
		var isKiller = data.killerPlayer === Game.GetLocalPlayerID();
		var teamVictim = byNeutrals || Players.GetTeam(data.victimPlayer) === Players.GetTeam(Game.GetLocalPlayerID());
		var teamKiller = !byNeutrals && Players.GetTeam(data.killerPlayer) === Players.GetTeam(Game.GetLocalPlayerID());
		row.SetHasClass('AllyEvent', teamKiller);
		row.SetHasClass('EnemyEvent', byNeutrals || !teamKiller);
		row.SetHasClass('LocalPlayerInvolved', isVictim || isKiller);
		row.SetHasClass('LocalPlayerKiller', isKiller);
		row.SetHasClass('LocalPlayerVictim', isVictim);
		if (isKiller)
			Game.EmitSound('notification.self.kill');
		else if (isVictim)
			Game.EmitSound('notification.self.death');
		else if (teamKiller)
			Game.EmitSound('notification.teammate.kill');
		else if (teamVictim)
			Game.EmitSound('notification.teammate.death');
		if (isSelfKill) {
			Game.EmitSound('notification.self.kill');
			rowText = $.Localize('#custom_toast_PlayerDeniedSelf');
		} else if (isAllyKill) {
			rowText = $.Localize('#custom_toast_PlayerDenied');
		} else {
			if (byNeutrals) {
				rowText = $.Localize('#npc_dota_neutral_creep');
			} else {
				rowText = '{killer_name}';
			}
			rowText = rowText + ' {killed_icon} {victim_name} {gold}';
		}
	} else if (data.type === 'generic') {
		if (data.teamPlayer != null || data.teamColor != null) {
			var team = data.teamPlayer == null ? data.teamColor : Players.GetTeam(data.teamPlayer);
			var teamVictim = team === Players.GetTeam(Game.GetLocalPlayerID());
			if (data.teamInverted === 1)
				teamVictim = !teamVictim;
			row.SetHasClass('AllyEvent', teamVictim);
			row.SetHasClass('EnemyEvent', !teamVictim);
		} else
			row.AddClass('AllyEvent');
		rowText = $.Localize(data.text);
	}

	rowText = rowText.replace('{denied_icon}', "<img class='DeniedIcon'/>").replace('{killed_icon}', "<img class='CombatEventKillIcon'/>").replace('{time_dota}', "<font color='lime'>" + secondsToMS(Game.GetDOTATime(false, false), true) + '</font>');
	if (data.player != null)
		rowText = rowText.replace('{player_name}', CreateHeroElements(data.player));
	if (data.victimPlayer != null)
		rowText = rowText.replace('{victim_name}', CreateHeroElements(data.victimPlayer));
	if (data.killerPlayer != null) {
		rowText = rowText.replace('{killer_name}', CreateHeroElements(data.killerPlayer));
	}
	if (data.victimUnitName)
		rowText = rowText.replace('{victim_name}', "<font color='red'>" + $.Localize(data.victimUnitName) + '</font>');
	if (data.team != null)
		rowText = rowText.replace('{team_name}', "<font color='" + GameUI.CustomUIConfig().team_colors[data.team] + "'>" + GameUI.CustomUIConfig().team_names[data.team] + '</font>');
	if (data.gold != null)
		rowText = rowText.replace('{gold}', "<font color='gold'>" + FormatGold(data.gold) + "</font> <img class='CombatEventGoldIcon' />");
	if (data.runeType != null)
		rowText = rowText.replace('{rune_name}', "<font color='#" + RUNES_COLOR_MAP[data.runeType] + "'>" + $.Localize('#custom_runes_rune_' + data.runeType + '_title') + '</font>');
	if (data.variables)
		for (var k in data.variables) {
			rowText = rowText.replace(k, $.Localize(data.variables[k]));
		}
	if (rowText.indexOf('<img') === -1)
		row.AddClass('SimpleText');
	row.FindChildTraverse('ToastLabel').text = rowText;
	$.Schedule(10, function() {
		row.AddClass('Collapsed');
	});
	row.DeleteAsync(10.3);
};

function CreateHeroElements(id) {
	var playerColor = GetHEXPlayerColor(id);
	return "<img src='" + TransformTextureToPath(GetPlayerHeroName(id), 'icon') + "' class='CombatEventHeroIcon'/> <font color='" + playerColor + "'>" + _.escape(Players.GetPlayerName(id)) + '</font>';
}

function ToggleOnStaminaBar(){
	var ButtonSwap = $.GetContextPanel("ButtonSwapMana")
    var agbut = ButtonSwap.FindChildTraverse("Stamina")
    var intbut = ButtonSwap.FindChildTraverse("Mana")
	var ManaProgress_Left = FindDotaHudElement("ManaProgress_Left")
	var ManaProgress_Right = FindDotaHudElement("ManaProgress_Right")


    agbut.visible = false
    intbut.visible = true
	ButtonSwap.Mana = false
	ButtonSwap.Stamina = true
	AutoUpdateStaminaBar() 
}

function ToggleOnManaBar(){
	var ButtonSwap = $.GetContextPanel("ButtonSwapMana")
    var agbut = ButtonSwap.FindChildTraverse("Stamina")
    var intbut = ButtonSwap.FindChildTraverse("Mana")
    agbut.visible = true
    intbut.visible = false
	ButtonSwap.Mana = true
	ButtonSwap.Stamina = false
	AutoUpdateManaBar() 
}

function AutoUpdateManaBar() {
	var ButtonSwap = $.GetContextPanel("ButtonSwapMana")
	//if (!ButtonSwap.Mana) return
	$.Schedule(1 / 40, AutoUpdateManaBar);
	UpdateManaBar();
}

function AutoUpdateStaminaBar() {
	var ButtonSwap = $.GetContextPanel("ButtonSwapMana")
	if (!ButtonSwap.Stamina) return
	$.Schedule(1 / 40, AutoUpdateStaminaBar);
	UpdateStaminaBar();
}

function AutoUpdateHealthBar() {
	$.Schedule(1 / 40, AutoUpdateHealthBar);
	UpdateHealthBar();
}

function AutoUpdateAbilitiesSubtypes() {
	$.Schedule(0.1, AutoUpdateAbilitiesSubtypes);
	UpdateAbilitiesSubtypes();
}

function UpdateAbilitiesSubtypes() {
	var ability_tooltip =  FindDotaHudElement('DOTAAbilityTooltip')
	if (!ability_tooltip) return
		//if (ability_tooltip.util) return
		var description = ability_tooltip.FindChildTraverse('AbilityDescriptionContainer').Children()
		if (description[1]) {description = description[1]
		}else description = description[0]
		var ability_name = ability_tooltip.FindChildTraverse("AbilityName").text
		var ability_damage_subtypes = GameUI.CustomUIConfig().ability_damage_subtypes
		var subtype
		//$.Msg(ability_name)
		for (var keys in ability_damage_subtypes){
			//$.Msg($.Localize("#DOTA_Tooltip_ability_"+keys).toLowerCase())
			if ($.Localize("#DOTA_Tooltip_ability_"+keys).toLowerCase() == ability_name.toLowerCase()) {
				subtype = $.Localize('#'+ability_damage_subtypes[keys]._)
				//$.Msg(subtype)
				break;
			}
		}
		if (subtype) {
			//$.DispatchEvent('DOTAHideAbilityTooltip', "");
			if (description) {
				var text = description.text
				var _subtype_localization = $.Localize('#damage_subtype')
				if (!description._text)  description.text = text + '\n'+_subtype_localization + subtype
				if (!description._text) description._text = text
				//$.Msg(ability_tooltip.FindChildTraverse('AbilityDescriptionContainer').FindChildrenWithClassTraverse('Active')[0].text)
			}
		}
}

(function() {
	//$.Msg("11")
	HookPanoramaPanels();
	_DynamicMinimapSubscribe($('#DynamicMinimapRoot'));
	var mapInfo = Options.GetMapInfo();
	hud.AddClass('map_landscape_' + mapInfo.landscape);
	hud.AddClass('map_gamemode_' + mapInfo.gamemode);
	$.GetContextPanel().SetHasClass('ShowMMR', Options.IsEquals('EnableRatingAffection'));
	DynamicSubscribePTListener('players_abandoned', function(tableName, changesObject, deletionsObject) {
		if (changesObject[Game.GetLocalPlayerID()]) $.GetContextPanel().AddClass('LocalPlayerAbandoned');
	});

	var HealthBar = FindDotaHudElement("HealthBar");
	var HealthBarProgress_Left = HealthBar.FindChildTraverse("HealthBarProgress_Left");
	var HealthBarProgress_Right = HealthBar.FindChildTraverse("HealthBarProgress_Right");

	//var ButtonSwap = $.GetContextPanel("ButtonSwapMana");
	//ButtonSwap.FindChildTraverse("Mana").visible = false;
	//ButtonSwap.Mana = true;
	AutoUpdateManaBar();
	AutoUpdateHealthBar();
	AutoUpdatePanoramaHUD();
	AutoUpdateAbilitiesSubtypes();

	GameEvents.Subscribe('entity_killed', OnDeath);
	DynamicSubscribeNTListener('custom_entity_values', OnUpdateSelectedUnit);
	GameEvents.Subscribe('dota_player_update_selected_unit', OnUpdateSelectedUnit);
	GameEvents.Subscribe('dota_player_update_query_unit', OnUpdateSelectedUnit);
	GameEvents.Subscribe('dota_player_gained_level', OnSkillPoint);
	GameEvents.Subscribe('dota_player_learned_ability', OnSkillPoint);

	GameEvents.Subscribe('create_custom_toast', CreateCustomToast);
})
(function() { 
})