var m_Ability,m_QueryUnit,m_PlayerID,m_Name;

function updateAbility(){
	if(!m_Ability) return;
	var level = Abilities.GetLevel(m_Ability);
 	var texture = Abilities.GetAbilityTextureName(m_Ability);
 	var name = Abilities.GetAbilityName(m_Ability);
 	m_Name = name;
 	//$.Msg(name," ",m_Ability);
 	var canUpgradeRet = Abilities.CanAbilityBeUpgraded( m_Ability );
 	
	var canUpgrade = ( canUpgradeRet == AbilityLearnResult_t.ABILITY_CAN_BE_UPGRADED );
	var logStr = "";
	
	if(!canUpgrade){
		logStr+= " Cannot upgrade";
		if(canUpgradeRet==AbilityLearnResult_t.ABILITY_CANNOT_BE_UPGRADED_REQUIRES_LEVEL){
			logStr+= " Require level ";
			if(level==0){
				logStr+= " Level 0 ";
				$.GetContextPanel().SetHasClass('no_upgrade',true);	
			}else{
				logStr+= " Other ";
				$.GetContextPanel().SetHasClass('other',true);	
			}			
		}else{
			logStr+= " Not Require level ";
			if(canUpgradeRet==AbilityLearnResult_t.ABILITY_CANNOT_BE_UPGRADED_AT_MAX){
				logStr+= " Max level ";
				$.GetContextPanel().SetHasClass('max_level',true);	
			}else{
				logStr+= " Other ";
				$.GetContextPanel().SetHasClass('other',true);	
			}
		}
	}else{
		//can upgrade
		logStr+= " Can upgrade,set classs = false";
		$.GetContextPanel().SetHasClass('no_upgrade',false);	
		$.GetContextPanel().SetHasClass('other',false);	
	}
	//$.Msg(name," canupgradeData ",canUpgradeRet," ==> ",canUpgrade," ==>",logStr);
 	$( "#AbilityImage" ).abilityname = name;
 	$( "#AbilityText" ).text = $.Localize('#DOTA_Tooltip_Ability_'+name)+(level>0?"\nLevel : "+level:"");
 	var hotkey = Abilities.GetHotkeyOverride(m_Ability);
 	if(hotkey!=''){
 		$('#HotkeyText').text = 'Hot key : <b style="color:red">'+hotkey+'</b>';	
 	}
}
function setAbility(tempAbility,Owner,playerID)
{
	//$.Msg("called function in ability.js",whatAbility);
	m_Ability = tempAbility;
	m_QueryUnit = Owner;
	m_PlayerID= playerID;
	updateAbility();
 	//$.Msg("Set ability done");
}
function UpgradeAbility()
{
	if(!m_Ability) return false;
	GameEvents.SendCustomGameEventToServer( "level_up_ability", {ability: m_Ability, playerID: m_PlayerID, unit: m_QueryUnit} );
}

function AbilityShowTooltip()
{
	if(!m_Ability) return false;
	var abilityButton = $( "#AbilityButton" );
	var abilityName = Abilities.GetAbilityName( m_Ability );
	// If you don't have an entity, you can still show a tooltip that doesn't account for the entity
	//$.DispatchEvent( "DOTAShowAbilityTooltip", abilityButton, abilityName );
	//$.Msg(abilityName,m_QueryUnit);
	// If you have an entity index, this will let the tooltip show the correct level / upgrade information
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, m_QueryUnit );
}
function AbilityHideTooltip()
{
	var abilityButton = $( "#AbilityButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function LearnedSkill(data){
	if(data.ability==m_Ability){
		$.Msg("Upgrade "+m_Name);
		updateAbility();
	}
	/*
	if(data.hero.skill_point==0){
		$.GetContextPanel().SetHasClass('no_upgrade',true);	
		$.GetContextPanel().SetHasClass('other',true);	
	}
	*/
}


(function () {
$.GetContextPanel().setAbility = setAbility;
$.GetContextPanel().updateAbility = updateAbility;


GameEvents.Subscribe( "learned_skill", LearnedSkill );
})();