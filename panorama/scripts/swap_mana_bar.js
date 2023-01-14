function ToggleOnStaminaBar(){
    var agbut = $.GetContextPanel("Agility")
    var intbut = $.GetContextPanel("Intelligence")
    agbut.enabled, agbut.visible = false
    intbut.enabled, intbut.visible = true
}

function ToggleOnManaBar(){
    var agbut = $.GetContextPanel("Agility")
    var intbut = $.GetContextPanel("Intelligence")
    agbut.enabled, agbut.visible = true
    intbut.enabled, intbut.visible = false
}

(function(){
    $.GetContextPanel("ButtonSwapMana").FindChildTraverse("Intelligence").enabled, $.GetContextPanel("ButtonSwapMana").FindChildTraverse("Intelligence").visible = false
})