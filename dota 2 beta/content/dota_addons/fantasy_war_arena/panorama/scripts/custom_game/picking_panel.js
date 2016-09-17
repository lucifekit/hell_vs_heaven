function OnClickLightButton(){
	$.Msg("You click the light button");
	GameEvents.SendCustomGameEventToServer( "pick_element", {element: "light"} );
	//$.GetContextPanel().SetHasClass("hidden",true);
	//$.GetContextPanel().style.visibility = 'collapse';
	$.GetContextPanel().style.opacity = '0';
	$.Msg("Set class");
	$.Schedule( 5, WhenRoundStart );
}

function WhenRoundStart(){
	$.Msg("Round start");
	$.GetContextPanel().style.visibility = 'visible';
	$.GetContextPanel().style.opacity = '1';
}

(function () {
GameEvents.Subscribe( "show_the_picking_panel_or_whatever_name_you_want", WhenRoundStart );
})();