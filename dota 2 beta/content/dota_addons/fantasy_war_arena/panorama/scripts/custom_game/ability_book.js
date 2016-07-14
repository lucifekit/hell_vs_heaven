"use strict";

var m_hero,m_Player;
var abilityPanel = new Array();
function OnTogglePanel(){

	if($('#AbilityBooks').BHasClass('hidden')){
		//GameEvents.SendCustomGameEventToServer( "open_panel", {playerID: m_Player, panel: m_Panel} );
		$('#AbilityBooks').SetHasClass('hidden',false);
	}else{
		$('#AbilityBooks').SetHasClass('hidden',true);
		$.GetContextPanel().kem_isOpen = false;
	}
}
function doInitAbilityBook(hero,playerID){
	var abilityCount = Entities.GetAbilityCount(hero.idx);
	//$.Msg("Initing abilities book hero level = ",hero.hero_level," ability count = ",abilityCount);
	$("#skill_point").text = hero.skill_point;
	$("#AbilityPointLabel").text = hero.skill_point;
	if(hero.skill_point==0){
		$('#AbilityBooks').SetHasClass("no_skill_point",true);
		$('#AbilityPointLabel').SetHasClass("hidden",true);
	}else{
		$('#AbilityBooks').SetHasClass("no_skill_point",false);
		$('#AbilityPointLabel').SetHasClass("hidden",false);
	}
	for(var i=0;i<abilityCount;i++){
		var tempAbility = Entities.GetAbility( hero.idx, i );	 	
 		var name = Abilities.GetAbilityName(tempAbility);
 		
	 	if(name!=""&&name!="skill_khinhcong"&&name.substr(0,5)=="skill"){
	
	 		if(abilityPanel[i]){
	 			abilityPanel[i].updateAbility();
	 		}else{
	 			var parentPanel =$('#active_ability_list'); // the root panel of the current XML context
			 	if(Abilities.IsPassive(tempAbility)) parentPanel = $('#passive_ability_list');
				abilityPanel[i] = $.CreatePanel( "Panel", parentPanel, "ability-"+i.toString() );
				abilityPanel[i].BLoadLayout( "file://{resources}/layout/custom_game/ability.xml", false, false );
				abilityPanel[i].setAbility(tempAbility,hero.idx,playerID);	
	 		}
		 	
	 	}
	}
	//$.Msg("Done Init ability ");
}
function InitAbilityBook(hero,playerID){
	m_hero = hero;
	m_Player = playerID;
	doInitAbilityBook(hero,playerID);
	
}
function ReinitAbilityBook(hero,playerID){
	//$('#active_ability_list').RemoveAndDeleteChildren();
	//$('#passive_ability_list').RemoveAndDeleteChildren();

	doInitAbilityBook(hero,playerID);
}
function CloseUI(){
	OnTogglePanel();
}
function CloseUIReleased(){

}
function LearnedSkill(data){
	$("#skill_point").text = data.hero.skill_point;
	$("#AbilityPointLabel").text = data.hero.skill_point;
	if(data.hero.skill_point==0){
		$('#AbilityBooks').SetHasClass("no_skill_point",true);	
		$('#AbilityPointLabel').SetHasClass("hidden",true);
	}
	
}
(function () {
$.GetContextPanel().InitAbilityBook = InitAbilityBook;
$.GetContextPanel().ReinitAbilityBook = ReinitAbilityBook;
Game.AddCommand( "+CloseBook", CloseUI, "", 0 );
Game.AddCommand( "-CloseBook", CloseUIReleased, "", 0 );
GameEvents.Subscribe( "learned_skill", LearnedSkill );
GameEvents.SendCustomGameEventToServer( "inited_ability_book", {playerID: 	Players.GetLocalPlayer()} );
})();