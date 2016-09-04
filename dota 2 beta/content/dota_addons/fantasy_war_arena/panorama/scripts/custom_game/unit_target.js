"use strict";



/* Action-RPG style input handling.

Left click moves or trigger ability 1.
Right click triggers ability 2.
*/
var LEFT_CLICK_AUTO = "autocast";
var sche = undefined;
var skill_khinhcong_idx = -1;
function GetMouseCastTarget()
{
	var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex !== localHeroIndex; } );
	
	for ( var e of mouseEntities )		
	{
		if ( !e.accurateCollision )
			continue;
		return e.entityIndex;
	}
	for ( var e of mouseEntities )
	{
		return e.entityIndex;
	}

	return -1;
}

function GetMouseCastPosition( abilityIndex )
{
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	var localHeroPosition = Entities.GetAbsOrigin( localHeroIndex );
	var position = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
	if(position){
		var targetDelta = [ position[0] - localHeroPosition[0], position[1] - localHeroPosition[1] ];
		var targetDist = Math.sqrt( targetDelta[0] * targetDelta[0] + targetDelta[1] * targetDelta[1] );
		var abilityRange = Abilities.GetCastRange( abilityIndex );
		//$.Msg("Ability range "+abilityIndex+" is "+abilityRange);
		if ( targetDist > abilityRange && abilityRange > 0 )
		{
			position[0] = localHeroPosition[0] + targetDelta[0] * abilityRange / targetDist;
			position[1] = localHeroPosition[1] + targetDelta[1] * abilityRange / targetDist;
		}
	}else{
		$.Msg("#42 Position null....");
		$.Msg(localHeroPosition);
		$.Msg( GameUI.GetCursorPosition());
	}
	
	//$.Msg("Mouse cast pos : ",position[0],position[1])
	return position;
}
function getAbilityBehavior(order,targetEntityIndex)
{
	var abilityBehavior = Abilities.GetBehavior( order.AbilityIndex );
	//$.Msg("AbilityIndex = "+order.AbilityIndex+" , Last order = "+lastOrder+" behavior : "+abilityBehavior);
	if(lastOrder == LEFT_CLICK_AUTO) {
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TARGET;
		order.TargetIndex = targetEntityIndex;	
		return;	
	}
	
	//$.Msg("Ability behavior : "+abilityBehavior);
	if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
	{
		//$.Msg("56 order point");
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
		order.Position = GetMouseCastPosition( order.AbilityIndex );
	}


	if ( ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) && ( targetEntityIndex !== -1 ) )
	{
		// If shift is held down and we've a valid point target order and our unit target is out of range,
		// just use the point target.
		if ( ! ( GameUI.IsShiftDown() 
				&& order.OrderType !== undefined 
				&& !Entities.IsEntityInRange( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), targetEntityIndex, abilityRange ) ) )
		{
			//$.Msg("70 order cast target");
			order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TARGET;
			order.TargetIndex = targetEntityIndex;
			return;
			//$.Msg("70 cast target on "+targetEntityIndex);
		}
	}

	if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_NO_TARGET )
	{
		$.Msg("79 order no target",order);
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
	}
	
}
// Tracks the left-button held when attacking a target
function BeginAttackState( nMouseButton, abilityIndex, targetEntityIndex )
{
	
	var order = {
		AbilityIndex : abilityIndex,
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};
	getAbilityBehavior(order,targetEntityIndex);//lay thong tin cast vao dau
	
	//$.Msg("Order Type = "+order.OrderType);
	//$.Msg("Order TargetIndex = "+order.TargetIndex);
	//$.Msg("Order Position = "+order.Position);
	if ( order.OrderType === undefined ){
		$.Msg("85 undefined");
		return;
	}
	if(skill_khinhcong_idx==abilityIndex){
		Game.PrepareUnitOrders( order );
	}else{

		(function tic(){
		//$.Msg("==============================Attack state tick ",order.TargetIndex,nMouseButton);
		var localHero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );

		//var movement = Entities.HasMovementCapability(localHero);
		//var ground = Entities.HasGroundMovementCapability(localHero);
		var rooted = Entities.IsRooted(localHero);
		if(rooted){
			sche = $.Schedule( 0.05, tic );
		}else{
			if ( GameUI.IsMouseDown( nMouseButton ) ||lastOrder == LEFT_CLICK_AUTO)
			{
				if ( order.TargetIndex !== undefined )
				{
					//kiem tra lai cho nay ko la ko cast dc
					//$.Msg()
					if(Entities.IsPhantom( order.TargetIndex )){

						return;
					}
					if ( Entities.GetTeamNumber( order.TargetIndex ) === Entities.GetTeamNumber( localHero ) )
					{
						return;
					}
					if ( !Entities.IsAlive( order.TargetIndex) )
					{
						$('#TargetHP').text = "Dead";
						return;
					}
					if(!Entities.IsAlive(localHero)){
						return;
					}
					if(!Entities.IsEntityInRange(localHero,order.TargetIndex,1500)){
						return;
					}
					var cMana = Entities.GetMana(localHero);
					var aMana = Abilities.GetManaCost(order.AbilityIndex);
					if(cMana<aMana){
						return;
					}
					//$.Msg(Entities.NotOnMinimapForEnemies(order.TargetIndex));
					//$.Msg(Entities.CanAcceptTargetToAttack(localHero,order.TargetIndex));
				}
				//$.Msg(abilityIndex);
				if(abilityIndex!=skill_khinhcong_idx&&skill_khinhcong_idx!=-1){
					//$.Msg("reget abilityIndex");
					order.AbilityIndex = getAbilityToBeCast(nMouseButton);	
				}else{
					if(skill_khinhcong_idx==-1){
						order.AbilityIndex = getAbilityToBeCast(nMouseButton);		
					}
					//$.Msg("136",abilityIndex,skill_khinhcong_idx);
				}
				if(lastOrder!=LEFT_CLICK_AUTO){				
					getAbilityBehavior(order,targetEntityIndex);	
				}
				
				//$.Msg("==>"+order.AbilityIndex);
				if ( order.TargetIndex === undefined && (GameUI.IsShiftDown()||nMouseButton==1) )
				{
					//cast vao mat dat
					//$.Msg("Cast vao mat dat")
					order.Position = GetMouseCastPosition( abilityIndex );
				}
				if(order.TargetIndex>0){
					UpdateTarget(order.TargetIndex);
				}
				if ( Abilities.IsCooldownReady( order.AbilityIndex ) && !Abilities.IsInAbilityPhase( order.AbilityIndex ) )
				{
					//$.Msg("115 prepare order ",order);
					Game.PrepareUnitOrders( order );
					sche = $.Schedule( 0.15, tic );
				}else{
					//$.Msg("Skill is Cooldowning");
					sche = $.Schedule( 0.05, tic );
					//$.Msg("Cant cast ",order.AbilityIndex,Abilities.GetAbilityName( order.AbilityIndex ),Abilities.IsCooldownReady( order.AbilityIndex ) ,Abilities.IsInAbilityPhase( order.AbilityIndex ));
				}
				
				//$.Msg("sche = ",sche);
			}	
		}
		//$.Msg("tick",lastOrder);
		
	})();
	}
	
}

// Tracks the left-button helf when picking up an item.
function BeginPickUpState( targetEntIndex )
{
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_PICKUP_ITEM,
		TargetIndex : targetEntIndex,
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};
	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			$.Schedule( 1.0/30.0, tic );
			if ( Entities.IsValidEntity( order.TargetIndex) )
			{
				Game.PrepareUnitOrders( order );
			}
		}	
	})();
}

// Tracks the left-button held state when moving.
function BeginMoveState()
{
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position : [0, 0, 0],
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};
	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			$.Schedule( 1.0/30.0, tic );
			var mouseWorldPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
			if ( mouseWorldPos !== null )
			{
				if ( GameUI.IsMouseDown( 1 ) || GameUI.IsMouseDown( 2 ) )
				{
					return;
				}			
				order.Position = mouseWorldPos;
				Game.PrepareUnitOrders( order );
			}
		}
	})();
}
var clearTargetTimer=0;
var updateTargetHPTimer=0;
var currentTargetIndex;
function ClearTarget(){
	$('#TargetName').text = "";
	$('#TargetHP').text = "";
	$('#TargetDamage').text = "";
	$('#TargetContainer').SetHasClass("HaveTarget",false);
	clearTargetTimer = 0;
	updateTargetHPTimer = 0;
}
function UpdateTargetHP(){
	
	var targetIndex = currentTargetIndex;
	var className = Entities.GetClassname(targetIndex);
	if ( !Entities.IsAlive( targetIndex) )
	{
		$('#TargetHP').text = "Dead";

		return;
    }
	if(className=='npc_dota_creep'){
		$('#TargetHP').text = "HP : "+Entities.GetHealth(targetIndex)+"/"+Entities.GetMaxHealth(targetIndex);
	}else{
		$('#TargetHP').text = "HP : "+Entities.GetHealthPercent(targetIndex)+"%";
	}
}
function UpdateTarget(targetIndex){
	currentTargetIndex = targetIndex;
	if(clearTargetTimer){
		if(clearTargetTimer>0){
			try{
				$.CancelScheduled(clearTargetTimer);		
			}catch(err){

			}
			
		}
		
	}
	if(updateTargetHPTimer){
		if(updateTargetHPTimer>0){
			try{
				$.CancelScheduled(updateTargetHPTimer);			
			}catch(err){

			}
			
		}
	}
	
	clearTargetTimer = $.Schedule( 5, ClearTarget );
	updateTargetHPTimer = $.Schedule(0.5,UpdateTargetHP);

	$('#TargetContainer').SetHasClass("HaveTarget",true);
	var className = Entities.GetClassname(targetIndex);
	var unitName = Entities.GetUnitName(targetIndex);
	//$.Msg(unitName);
	var unitNameFixed = unitName.replace("npc","").replace(/_/g," ").trim();
	//$.Msg(1,unitNameFixed);
	unitNameFixed = unitNameFixed.substr(0,1).toUpperCase()+unitNameFixed.substr(1);
	//$.Msg(2,unitNameFixed);
	$('#TargetImage').SetHasClass("hidden",true);
	$('#TargetHeroImage').SetHasClass("hidden",false);
	if(className=='npc_dota_creep'){
		$('#TargetName').text = unitNameFixed;
		$('#TargetHP').text = "HP : "+Entities.GetHealth(targetIndex)+"/"+Entities.GetMaxHealth(targetIndex);
		$('#TargetDamage').text = "ATK : "+Entities.GetDamageMin(targetIndex)+"-"+Entities.GetDamageMax(targetIndex);
		//$('#TargetHeroImage').heroname = className;
		setCustomTargetImage("creep");
	}else{
		//$.Msg(unitName,"-",$.Localize(unitName),"-",$.Localize('#'+unitName),$.Localize("#npc_dota_hero_nevermore"),$.Localize("npc_dota_hero_nevermore"),$.Localize("game_info_tip01"),$.Localize("#game_info_tip01"));
		$('#TargetName').text = $.Localize(''+unitName)+" - "+targetIndex;
		$('#TargetHP').text = "HP : "+Entities.GetHealthPercent(targetIndex)+"%";
		$('#TargetDamage').text = "ATK : "+Entities.GetDamageMin(targetIndex)+"-"+Entities.GetDamageMax(targetIndex);
		$('#TargetHeroImage').heroname = className;
		//$.Msg(unitNameFixed);
		if(unitNameFixed=="Boss dieptinh"){
			setCustomTargetImage("dieptinh");
			
		}
		if(unitNameFixed=="Boss hokhon"){
			setCustomTargetImage("hokhon");
			
		}
		if(unitNameFixed=="Boss hell"){
			$('#TargetHeroImage').heroname = "npc_dota_hero_night_stalker";
		}
		if(unitNameFixed=="Boss heaven"){
			$('#TargetHeroImage').heroname = "npc_dota_hero_skywrath_mage";
		}
	}
}
function setCustomTargetImage(path){
	//$.Msg("Set custom image = "+path);
	var imagePath = "file://{images}/custom_game/units/"+path+".png";
	//imagePath = "file://{images}/custom_game/units/"+path+"_png.vtex";
	//$.Msg(imagePath);
		$('#TargetImage').SetImage(imagePath);
		//$('#TargetImage').src = imagePath;
		//$.Msg($('#TargetImage').src,$('#TargetImage').GetAttributeString("src",""));
		$('#TargetImage').SetHasClass("hidden",false);
		$('#TargetHeroImage').SetHasClass("hidden",true);
}
// Handle Left Button events
function OnLeftButtonPressed()
{

	//var castAbilityIndex = getAbilityToBeCast();//Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 0 );
	
	var tempPlayerID = Players.GetLocalPlayer();//index
	var lpi = Game.GetLocalPlayerInfo();
	//$.Msg("lpi " ,lpi);
	var pi = Game.GetPlayerInfo( tempPlayerID);
	//$.Msg("pi " ,pi);
	
	var targetIndex = GetMouseCastTarget();
	if ( targetIndex === -1 )
	{
		//cast vao dat
		if ( GameUI.IsShiftDown() )
		{
			var castAbility = getAbilityToBeCast();
			var castAbilityIndex = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), castAbility );
			BeginAttackState( 0, castAbility, -1 );
		}
		else
		{
			if(GameUI.IsControlDown()){
				if(skill_khinhcong_idx==-1){
					//khinh cong
					for(var i = 0;i<16;i++){
						var abilityIndex = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), i);
						var abilityName = Abilities.GetAbilityName(abilityIndex);
						//$.Msg(abilityName);
						if(abilityName=='skill_khinhcong'){
							skill_khinhcong_idx=abilityIndex;

							//$.Msg("Yeah ",skill_khinhcong_idx);
						}
					}
				}
				if(Abilities.IsCooldownReady(skill_khinhcong_idx)){
					BeginAttackState( 0, skill_khinhcong_idx, -1 );
				}
				//$.Msg("Casting khinhcong ",skill_khinhcong_idx);
				
			}else{
				BeginMoveState();	
			}
			
		}
	}
	else if ( Entities.IsItemPhysical( targetIndex ) )
	{
		BeginPickUpState( targetIndex );
	}
	else
	{
		lastOrder = LEFT_CLICK_AUTO;
		//$.Msg("Auto attack");
		var castAbility = getAbilityToBeCast();
		//var castAbilityIndex = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), castAbility );
		//$.Msg("calling",castAbility,castAbilityIndex,targetIndex);
		UpdateTarget(targetIndex);
		
		BeginAttackState( 0, castAbility, targetIndex );
	}
}
function getAbilityToBeCast(nMouseButton)
{
	//$.Msg("269");
	var castAbility = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 0);
	var castPriority = 0;
	var castName = Abilities.GetAbilityName(castAbility);
	var castAuto = false;
	//$.Msg("GETTING ABILITY");
	for(var i = 0;i<=11;i++){
		var tempAbility = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), i );
		var abilityName = Abilities.GetAbilityName(tempAbility);
		//$.Msg("checking ",abilityName);
		var abilityReady = Abilities.AbilityReady(tempAbility);
		var canbeExcuted = 	Abilities.CanBeExecuted(tempAbility);
		var abilityLevel = Abilities.GetLevel(tempAbility);//phai lon hon 0
		var abilityManaCost = Abilities.GetManaCost(tempAbility);
		var isPassive 	= Abilities.IsPassive(tempAbility);//ko cast passive
		var abilityCooldown = 	Abilities.IsCooldownReady(tempAbility);//phai da cooldowned
		var isAutocast  = 	Abilities.GetAutoCastState(tempAbility);//uu tien auto
		var tempPriority = -1;
		var abilityBehavior = Abilities.GetBehavior(tempAbility);
		var canAutocast = abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_AUTOCAST;

		//$.Msg(abilityName,abilityBehavior,"can auto = ",canAutocast,"--",DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_AUTOCAST);
		//$.Msg(abilityName);
		if(abilityReady&&canbeExcuted&&!isPassive&&abilityLevel>0&&canAutocast){
			tempPriority = i;

			if(castAuto){
				//$.Msg("Prev ability is autoed");
				//neu da co skill cast auto roi 
				//$.Msg(" is on cast auto");
				if(isAutocast){
					tempPriority+=10;//neu auto thi + 10
					castAuto = true;	
					if(abilityCooldown) {
						//$.Msg(abilityName+" is ready, +10");
						tempPriority+=10;
					}
					//$.Msg(abilityName+" have priority of "+tempPriority);
					if(tempPriority>castPriority){
						//$.Msg("Set casting ability = "+abilityName);
						castAbility = tempAbility;
						castPriority = tempPriority;
						castName = abilityName;
					}
				}else{
					//ko lam gi ca
				}
			}else{
				//ko phai cast auto
				//$.Msg(" is not on cast auto");
				if(isAutocast){
					//$.Msg(" this spell is auto cast ");
					tempPriority+=10;//neu auto thi + 10
					castAuto = true;	
					if(abilityCooldown) tempPriority+=10;
					//$.Msg(" checking priority  temp= ",tempPriority," vs " ,castPriority);
					if(tempPriority>castPriority){
						//$.Msg("Set casting ability = "+castName);
						castAbility = tempAbility;
						castPriority = tempPriority;
						castName = abilityName;
					}
				}else{
					//$.Msg(" this spell is not auto cast ");
					if(tempPriority>castPriority){
						castAbility = tempAbility;
						castPriority = tempPriority;
						castName = abilityName;
					}
				}
				
			}
		}
		/*
		$.Msg("Slot : "+i+" ["+abilityName+"]["+tempAbility+"] is "+(abilityReady?'ready':' not ready ')+'|'+(canbeExcuted?' can be cast':' not castable')+"| level "+abilityLevel+"| cost"+abilityManaCost+"| auto "+(isAutocast?'yes':'no')+
			"|cooldown "+(abilityCooldown?'yes':'no')); */
			
		
	}
	//$.Msg("Result : "+castName+" "+castAbility);
	return castAbility;
}

// Handle Right Button events
function OnRightButtonPressed( nMouseButton )
{
	//var castAbility = ();
	var castAbilityIndex = getAbilityToBeCast();// Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), castAbility );
	//$.Msg("Right button : "+castAbilityIndex.toString());
	//$.Msg("Local player la gi "+Players.GetLocalPlayer());
	var targetIndex = GetMouseCastTarget();
	var logRightMsg = "target index : "+targetIndex;
	if ( targetIndex === -1 )
	{
		logRightMsg += " 210 "+castAbilityIndex;
		BeginAttackState( 1, castAbilityIndex, -1 );
	}
	else if ( Entities.IsItemPhysical( targetIndex ) )
	{
		BeginPickUpState( targetIndex );
	}
	else
	{
		logRightMsg += " 219 cast on target "+castAbilityIndex;
		BeginAttackState( 1, castAbilityIndex, targetIndex );
	}
	
}


// Camera yaw smoothing.
// var g_yaw = 0;
// var g_targetYaw = 0;
// (function smoothCameraYaw()
// {
// 	$.Schedule( 1.0/30.0, smoothCameraYaw );
// 	while ( g_targetYaw > 360 && g_yaw > 360 )
// 	{
// 		g_targetYaw -= 360;
// 		g_yaw -= 360;
// 	}
// 	while ( g_targetYaw < 0 && g_yaw < 0 )
// 	{
// 		g_targetYaw += 360;
// 		g_yaw += 360;
// 	}

// 	var minStep = 1;
// 	var delta = ( g_targetYaw - g_yaw );
// 	if ( Math.abs( delta ) < minStep )
// 	{
// 		g_yaw = g_targetYaw;
// 	}
// 	else
// 	{
// 		var step = delta * 0.3;
// 		if ( Math.abs( step ) < minStep )
// 		{
// 			if ( delta > 0 )
// 				step = minStep;
// 			else
// 				step = -minStep;
// 		}
// 		g_yaw += step;
// 	}
// 	GameUI.SetCameraYaw( g_yaw );
// 	return;
// })();

var lastOrder = "";

// Main mouse event callback
GameUI.SetMouseCallback( function( eventName, arg ) {
	//return false; de test user
	var nMouseButton = arg;
	var CONSUME_EVENT = true;
	var CONTINUE_PROCESSING_EVENT = false;
	if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
		return CONTINUE_PROCESSING_EVENT;
	//$.Msg("mouse click, reset last order",GameUI.GetClickBehaviors() ,eventName);
	if(debug){
		return CONTINUE_PROCESSING_EVENT;
	}
	if ( eventName === "pressed" )
	{
		lastOrder = "";
		if(sche) {
			try{
				//$.Msg("sche ",sche);
				$.CancelScheduled(sche);
				sche=undefined;	
			}catch(ex){

			}
			
		}
		//$.Msg("Click");
		// Left-click is move to position or attack
		if ( arg === 0 )
		{
			
			var targetIndex = GetMouseCastTarget();
			//var unitName = ;
			if(Entities.IsShop(targetIndex)){
				return CONTINUE_PROCESSING_EVENT;
			}
			OnLeftButtonPressed();
			return CONSUME_EVENT;
		}

		// Right-click is use ability #2
		if ( arg === 1 )
		{
			OnRightButtonPressed();
			return CONSUME_EVENT;
		}

		// Middle-click is reset yaw.
		if ( arg === 2 )
		{
			/*g_targetYaw = 0;
			g_yaw = g_targetYaw;*/
			return CONSUME_EVENT;
		}
	}

	if ( eventName === "wheeled" )
	{
		//g_targetYaw += arg * 10;//ko xoay camera nua
		return CONSUME_EVENT;
	}

	if ( eventName === "doublepressed" )
	{
		return CONSUME_EVENT;
	}
	return CONTINUE_PROCESSING_EVENT;
} );

GameUI.SetCameraPitchMax( 55 );
GameUI.SetCameraDistance( 2000);

// Alternate camera settings
if ( 0 )

{
	$.Msg("509");
	GameUI.SetCameraPitchMax( 45 );
	GameUI.SetCameraDistance( 2000 );
	GameUI.SetCameraLookAtPositionHeightOffset( 50 );
}
/*
function OnExecuteAbility1ButtonPressed( cmdName )
{
	$.Msg( "ExecuteAbility1 as " + cmdName ); 
	var order = {
		AbilityIndex : Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 1 ),
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false,
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
	};
	var abilityBehavior = Abilities.GetBehavior( order.AbilityIndex );
	if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
	{
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
		order.Position = GetMouseCastPosition( order.AbilityIndex );
	}

	Game.PrepareUnitOrders( order );
}
*/
/*
var nParticleIndex = -1;
function OnTestButtonPressed()
{
	$.Msg( "Test button pressed." );
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	nParticleIndex = Particles.CreateParticle( "particles/generic_gameplay/generic_stunned.vpcf", ParticleAttachment_t.PATTACH_OVERHEAD_FOLLOW, localHeroIndex );
}

function OnTestButtonReleased()
{
	$.Msg( "Test button released." ); 
	Particles.DestroyParticleEffect( nParticleIndex, true );
}
*/
/*
Game.AddCommand( "CustomGameExecuteAbility1", OnExecuteAbility1ButtonPressed, "", 0 );
Game.AddCommand( "+CustomGameTestButton", OnTestButtonPressed, "", 0 );
Game.AddCommand( "-CustomGameTestButton", OnTestButtonReleased, "", 0 );
*/
var debug = false
function DebugMode(){
	$.Msg("Enter debug mode");
	debug=true;
}
function QuitDebugMode(){
	$.Msg("Quit debug mode");
	debug=false;
}
(function () {
	//enter_debug_mode
	//print("Register DEBUG EVENT");
	GameEvents.Subscribe( "enter_debug_mode", DebugMode);
	GameEvents.Subscribe( "quit_debug_mode", QuitDebugMode);
})();