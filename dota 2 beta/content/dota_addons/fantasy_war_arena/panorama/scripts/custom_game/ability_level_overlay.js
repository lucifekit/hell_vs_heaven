"use strict";
function UpdateSkillLevel(event)
{
	var hero = event.hero;
	//$.Msg(hero);
	//$.Msg("JS update skill",data.skill_1,data.skill_2);
	var showIdx  = 1;
	//$.Msg("update skill",hero);
	for(var i=0;i<12;i++){
		//$.Msg("Checking ability ",i,"-",hero.idx);
	 	var tempAbility = Entities.GetAbility( hero.idx, i );
	 	if(!Abilities.IsHidden(tempAbility)){
	 		var name = Abilities.GetAbilityName(tempAbility);
	 		var level = Abilities.GetLevel(tempAbility);
		 	var query = '#ability_level_overlay_text'+(showIdx).toString();
	 		//$.Msg("13",query,name);
		 	var el = $(query);
		 	if(el){
		 		//$.Msg("17");
		 		showIdx+=1;
		 		if(level>0){
			 		el.text = "Level " + level ;
			 	}else{
			 		el.text = "N/A" ;
			 	}
		 	}else{
		 		$.Msg(query+ ' is invalid');
		 	}
	 	}else{
	 		//$.Msg(Abilities.GetAbilityName(tempAbility)+" is hidden");
	 	}
	 	
	}
}


(function () {

GameEvents.Subscribe( "update_skill", UpdateSkillLevel );
GameEvents.Subscribe( "learned_skill", UpdateSkillLevel );

})();