"use strict";
var m_Hero,m_Player,m_Panel="Ability";

function doInitAbility(){

	//$.Msg("Do init ability");
	var hero = m_Hero;
	var playerID = m_Player;
	if(hero==undefined) {
		$.Msg("Hero = undefined, quitting");
		return false;

	}
	
	//$.Msg("JS Do Initing ability ",Entities.GetUnitName(hero.idx)," of player ",playerID);
	var parentPanel = $('#AbilityBookList');
	if(!parentPanel) return;
	var tempPanel = $('#ability-books-'+playerID);
	if(tempPanel){
		//$.Msg("JS Reinitng "+"ability-books-"+playerID);
		tempPanel.ReinitAbilityBook(hero,playerID);
	}else{
		//$.Msg("JS Creating "+"ability-books-"+playerID);
		var tempPanel = $.CreatePanel("Panel",parentPanel,"ability-books-"+playerID);
		tempPanel.BLoadLayout("file://{resources}/layout/custom_game/ability_book.xml",false,false);
		tempPanel.InitAbilityBook(hero,playerID);
		GameEvents.SendCustomGameEventToServer( "mark_inited_js", {playerID: playerID} );
	}
	
	
	
}
function InitAbility(event)
{
	
	//$.Msg(event);

	m_Hero  = event.hero;
	m_Player = event.playerID;
	//$.Msg("Event Init ability ne ",m_Hero,m_Player);
	//$.Msg("JS Event init ability  "+event.msg);
	doInitAbility();
	
}


(function () {
//$.Msg("JS Subscribe Event File");
GameEvents.Subscribe( "update_skill", InitAbility );
//$.Msg("JS Subscribe Event Done");
//GameEvents.Subscribe( "open_panel", OpenPanel );
})();