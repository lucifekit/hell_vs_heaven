"use strict";


var m_PlayerID,m_HeroIdx,m_Panel="Stat";
function OnTogglePanel(){
	if($('#StatPanel').BHasClass('hidden')){
		$('#StatPanel').SetHasClass('hidden',false);
		//GameEvents.SendCustomGameEventToServer( "open_panel", {playerID: m_Player, panel: m_Panel} );
	}else{
		$('#StatPanel').SetHasClass('hidden',true);		
	}
}

function OnUpStat(stat){
	var amount = 10;
	if(GameUI.IsControlDown()) amount=1;
	if(GameUI.IsShiftDown()) amount=100;

	GameEvents.SendCustomGameEventToServer( "up_stat", {stat: stat, playerID: m_PlayerID, heroIdx: m_HeroIdx,amount:amount} );
}
function AutoStat(){
	GameEvents.SendCustomGameEventToServer( "up_stat_auto", {playerID: m_PlayerID, heroIdx: m_HeroIdx} );

}

function RegisterHero( event )
{
	//if (LocalSelection != null) return;

	//LocalSelection = event.entity;
	$.Msg("JS : Registered Hero "+event.msg);
	//$.Msg("JS : Registered Hero "+event.msg);

}
function UpdateStat(data)
{
	//$.Msg(data);
	//$.Msg("updating stat");
	//$.Msg(data);
	$.Msg("JS : Update stat ne ahihi "+data.msg );
	var hero = data.hero;
	//$.Msg(hero);
	var playerID = data.playerID;
	m_PlayerID = playerID;
	var heroIdx = hero.idx;
	m_HeroIdx = heroIdx;

	$('#HeroImage').heroname = hero.hero_image;
	$('#HeroName').text = $.Localize('#'+hero.hero_name)+" Level "+hero.hero_level +" ID : "+heroIdx;
	$('#StatSM').text = hero.stat_sm;
	$('#StatTP').text = hero.stat_tp;
	$('#StatSK').text = hero.stat_sk;
	$('#StatNC').text = hero.stat_nc;
	//$('#StatSkillPoint').text = hero.skill_point;
	$('#StatStatPoint').text =  hero.stat_point;
	$('#StatPointLabel').text = hero.stat_point;
	
	if(hero.stat_point==0){
		$('#StatUpSM').SetHasClass('hidden',true);
		$('#StatUpSK').SetHasClass('hidden',true);
		$('#StatUpTP').SetHasClass('hidden',true);
		$('#StatUpNC').SetHasClass('hidden',true);

		$('#AutoStat').SetHasClass('hidden',true);
		$('#StatPointLabel').SetHasClass('hidden',true);
	}else{
		$('#StatUpSM').SetHasClass('hidden',false);
		$('#StatUpSK').SetHasClass('hidden',false);
		$('#StatUpTP').SetHasClass('hidden',false);
		$('#StatUpNC').SetHasClass('hidden',false);
		$('#AutoStat').SetHasClass('hidden',false);
		$('#StatPointLabel').SetHasClass('hidden',false);
	}

	$('#StatHP').text = Entities.GetHealth(heroIdx)+"/"+Entities.GetMaxHealth(heroIdx);
	$('#StatMP').text = Entities.GetMana(heroIdx)+"/"+Entities.GetMaxMana(heroIdx);
	$('#StatAS').text = hero.as;
	var ms = Entities.GetBaseMoveSpeed(heroIdx);
	$('#StatMS').text = Math.ceil(Entities.GetMoveSpeedModifier(heroIdx, ms));

	$('#StatResistMetal').text = hero.resist_metal;
	$('#StatResistWood').text = hero.resist_wood;
	$('#StatResistFire').text = hero.resist_fire;
	$('#StatResistWater').text = hero.resist_water;
	$('#StatResistEarth').text = hero.resist_earth;

	$('#StatMaim').text = hero.effect_maim_add_percent+" / " +hero.effect_maim_add_time+ " | " +hero.effect_maim_resist_percent  +" / "+hero.effect_maim_reduce_time;
	$('#StatWeak').text = hero.effect_weak_add_percent+" / " +hero.effect_weak_add_time+ " | " +hero.effect_weak_resist_percent  +" / "+hero.effect_weak_reduce_time;
	$('#StatBurn').text = hero.effect_burn_add_percent+" / " +hero.effect_burn_add_time+ " | " +hero.effect_burn_resist_percent  +" / "+hero.effect_burn_reduce_time;
	$('#StatSlow').text = hero.effect_slow_add_percent+" / " +hero.effect_slow_add_time+ " | " +hero.effect_slow_resist_percent  +" / "+hero.effect_slow_reduce_time;
	$('#StatStun').text = hero.effect_stun_add_percent+" / " +hero.effect_stun_add_time+ " | " +hero.effect_stun_resist_percent  +" / "+hero.effect_stun_reduce_time;

	$('#StatElementDamage').text = hero.skill_element_damage+hero.weapon_element_damage;
	//$.Msg(hero.weapon_physical_damage,hero.skill_poison_damage,hero.weapon_poison_damage);
	$('#StatPhysicalDamage').text = hero.weapon_physical_damage;
	$('#StatPoisonDamage').text = hero.skill_poison_damage+hero.weapon_poison_damage;


	$('#StatBasicDamage').text = Math.ceil(hero.basic_damage_percent*100)+"%";
	$('#StatPhysicalAmplify').text = Math.ceil(hero.physic_amplify*100)+"%";


	$('#StatCriticalChance').text = hero.critical_chance;
	$('#StatCriticalDamage').text = Math.ceil(hero.critical_damage*100)/100;
	$('#StatEvade').text = Math.ceil(hero.evade_point);
	$('#StatAccuracy').text = Math.ceil(hero.accuracy_point*hero.accuracy_chance);
	//$.Msg("JS Skill_point = ",data.skill_point );
	//$.Msg("JS Stat_point = ",data.stat_point );
}

function CloseUI(){
	OnTogglePanel();
}
function CloseUIReleased(){

}
function OnDragStart( panelId, dragCallbacks ){
	//$.Msg("start drag",panelId);
	//$.Msg(dragCallbacks);
	var panel = $('#' + panelId);

	  dragCallbacks.displayPanel = panel;//panel;

	  var cursor = GameUI.GetCursorPosition();
	  panel.kem_startX = cursor[0];
	  panel.kem_startY = cursor[1];
	  
	  var sh = Game.GetScreenHeight();
      
      var scale = 1;
      if(sh>0){
      	scale = 1080 / sh;
      }
      $.Msg("scale = ",scale);
      var oX = 620*scale;
      if(panel.current_marginLeft){
      	oX=panel.current_marginLeft*scale;
      }
      oX = panel.actualxoffset;
	  dragCallbacks.offsetX = cursor[0] - oX;//250;
	  var oY = 80*scale+panel.actualyoffset;
	  
	  dragCallbacks.offsetY = cursor[1] - oY;//20;
		$.Msg("sh = ",sh,"       scale=",scale," yoff-",panel.actualyoffset,"    -xoff-",panel.actualxoffset,"           -ox-",oX,"         -oY-",oY);
	  dragCallbacks.removePositionBeforeDrop = false;
	  return false;
}

function OnDragEnd(panelId,draggedPanel )
{
  //$.Msg('OnDragEnd -- ', panelId, ' -- ', draggedPanel);
  //$.Msg("Drag end");
  draggedPanel.SetParent(draggedPanel.dragParent);
  var cursor = GameUI.GetCursorPosition();
  var tempPanel = $('#'+panelId);
  $.Msg(cursor,tempPanel.kem_startX,"x",tempPanel.kem_startY);
  //$.Msg("Current style  ",tempPanel.style);
  var sh = Game.GetScreenHeight();
      
      var scale = 1;
      if(sh>0){
      	scale = 1080 / sh;
      }
      $.Msg("end scale = ",scale);


  var oldMarginTop = tempPanel.current_marginTop?tempPanel.current_marginTop:0;
  var topDif = cursor[1]-tempPanel.kem_startY;
  var newMarginTop = oldMarginTop+topDif;
  //newMarginTop = newMarginTop*scale;
  tempPanel.style.marginTop = newMarginTop+"px";
  tempPanel.current_marginTop = newMarginTop;
  var oldMarginLeft = tempPanel.current_marginLeft?tempPanel.current_marginLeft:500;
  var leftDif = cursor[0]-tempPanel.kem_startX;
  var newMarginLeft = (oldMarginLeft+leftDif);
  tempPanel.style.marginLeft = newMarginLeft+"px";
  tempPanel.current_marginLeft = newMarginLeft;
  //$.Msg("Dif = "+topDif+"-"+leftDif+" new margin top left "+newMarginTop+"-"+newMarginLeft);
  //$.Msg("Current margin left = "+tempPanel.style.marginLeft);
  //tempPanel.forEach(myFunction);
  //tempPanel.SetStyle('marginTop',cursor.y-draggedPanel.y);
  //tempPanel.SetStyle('marginLeft',cursor.y-draggedPanel.y);
  return false; 
} 
(function () {
	//$.Msg("Init Subscribe Update Stat");
GameEvents.Subscribe( "register_hero", RegisterHero );
GameEvents.Subscribe( "update_stat", UpdateStat );
	
//GameEvents.Subscribe( "open_panel", OpenPanel );

Game.AddCommand( "+CloseStat", CloseUI, "", 0 );
Game.AddCommand( "-CloseStat", CloseUIReleased, "", 0 );
$('#StatPanelToggleButtonContainer').SetDraggable(true);
var panel = $('#StatPanel');
panel.SetDraggable(true);
panel.dragParent = panel.GetParent();
//$.RegisterEventHandler( 'DragStart', panel, OnDragStart );
//$.RegisterEventHandler( 'DragEnd', panel, OnDragEnd );

})();
