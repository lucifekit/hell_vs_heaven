CurrentQuest = nil
LinkLuaModifier("modifier_prepare","modifiers/modifier_prepare",LUA_MODIFIER_MOTION_NONE)
function Battle_End()
  for i = 0 , 9 do
      if(HERO_OF_PLAYER[i])then
        local tempHero = HERO_OF_PLAYER[i]
        tempHero:RemoveModifierByName("modifier_prepare")
        tempHero:SetOrigin(tempHero.spawn_point)
        FindClearSpaceForUnit(tempHero,tempHero.spawn_point,true)
      end
      
      
    end
  Battle_Step_0_Wait()
end
function Battle_Step_2_Battle()
    Battle_Time = true  
    local maps_selection = math.random(1,3)
    
    local team_1_position = math.random(1,2)
    local team_2_position = 3-team_1_position
    local team_1_tele_pos = Maps[maps_selection][team_1_position]
    local team_2_tele_pos = Maps[maps_selection][team_2_position]
    for i = 0 , 9 do
      if(HERO_OF_PLAYER[i])then
        local tempHero = HERO_OF_PLAYER[i]
        tempHero:RemoveModifierByName("modifier_prepare")
        tempHero:AddNewModifier(tempHero,nil,"modifier_prepare",{duration=5})
        if(tempHero:GetTeam()==DOTA_TEAM_GOODGUYS)then
          tempHero:SetOrigin(team_1_tele_pos)
          tempHero.battle_position = team_1_tele_pos
        else
          tempHero:SetOrigin(team_2_tele_pos)
          tempHero.battle_position = team_2_tele_pos
        end
        FindClearSpaceForUnit(tempHero,tempHero:GetOrigin(),true)
        
       end
    end
    kemPrint("Battle 40")
    CurrentQuest = SpawnEntityFromTableSynchronous( "quest", { name = "Battle", title = "#battle_time" } )
    CurrentQuest.EndTime = 120
    local subQuest = SpawnEntityFromTableSynchronous( "subquest_base", { 
             show_progress_bar = true, 
             progress_bar_hue_shift = -119 
           } )
           
    CurrentQuest:AddSubquest( subQuest )
    -- text on the quest timer at start
    CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 120 )
    CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 120 )
    
    -- value on the bar
    subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 120 )
    subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 120 )
    Timers:CreateTimer(1, function()
        CurrentQuest.EndTime = CurrentQuest.EndTime - 1
        CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CurrentQuest.EndTime )
        subQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CurrentQuest.EndTime )
    
        -- Finish the quest when the time is up  
        if CurrentQuest.EndTime == 0 then 
            EmitGlobalSound("Tutorial.Quest.complete_01") -- Part of game_sounds_music_tutorial
            CurrentQuest:CompleteQuest()
            Battle_End()
            return
        else
            return 1 -- Call again every second
        end
    end)
end
function Battle_Step_1_Prepare()
  kemPrint("Preparing")
  Battle_Time = true
  local team_1_count = 0
  local team_2_count = 0
  for i = 0, 9 do
    if(HERO_OF_PLAYER[i])then
      --kemPrint("Hero "..i.." team = "..)
      if(HERO_OF_PLAYER[i]:GetTeam()==DOTA_TEAM_GOODGUYS)then
        team_1_count=team_1_count+1
      else
        team_2_count = team_2_count+1
      end
      
    end
  end
  if(team_1_count>0 and team_2_count>0)then
    local teleport_center = Entities:FindAllByName("battle_prepare")[1]:GetAbsOrigin()
    for i = 0 , 9 do
      if(HERO_OF_PLAYER[i])then
        local tempHero = HERO_OF_PLAYER[i]
        tempHero:AddNewModifier(nil,nil,"modifier_prepare",{duration=75})
        tempHero:SetOrigin(teleport_center)
        FindClearSpaceForUnit(tempHero,teleport_center,true)
      end
      
      
    end
    kemPrint("Battle 99")
    CurrentQuest = SpawnEntityFromTableSynchronous( "quest", { name = "PrepareBattle", title = "#prepare_battle" } )
    CurrentQuest.EndTime = 60
    local subQuest = SpawnEntityFromTableSynchronous( "subquest_base", { 
             show_progress_bar = true, 
             progress_bar_hue_shift = -29 
           } )
           
    CurrentQuest:AddSubquest( subQuest )
    -- text on the quest timer at start
    CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 60 )
    CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 60 )
    
    -- value on the bar
    subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 60 )
    subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 60 )
    Timers:CreateTimer(1, function()
        CurrentQuest.EndTime = CurrentQuest.EndTime - 1
        CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CurrentQuest.EndTime )
        subQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CurrentQuest.EndTime )
    
        -- Finish the quest when the time is up  
        if CurrentQuest.EndTime == 0 then 
            EmitGlobalSound("Tutorial.Quest.complete_01") -- Part of game_sounds_music_tutorial
            CurrentQuest:CompleteQuest()
            Battle_Step_2_Battle()
            return
        else
            return 1 -- Call again every second
        end
    end)
  else
    GameRules:SendCustomMessage("Not enough players, battle cancel", 0, 0)
    GameRules:SendCustomMessage("Not enough players, battle cancel", 1, 0)
    Battle_Step_0_Wait()
  end
end

function Battle_Step_0_Wait()
  Battle_Time = false
  --kemPrint("Battle 140")
  CurrentQuest = SpawnEntityFromTableSynchronous( "quest", { name = "WaitBattle", title = "#battle_in" } )
    CurrentQuest.EndTime = 300
    local subQuest = SpawnEntityFromTableSynchronous( "subquest_base", { 
             show_progress_bar = true, 
             progress_bar_hue_shift = -119 
           } )
           
    CurrentQuest:AddSubquest( subQuest )
    -- text on the quest timer at start
  CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 300 )
  CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 300 )
  
  -- value on the bar
  subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 300 )
  subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, 300 )
  Timers:CreateTimer(1, function()
      CurrentQuest.EndTime = CurrentQuest.EndTime - 1
      CurrentQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CurrentQuest.EndTime )
      subQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CurrentQuest.EndTime )
  
      -- Finish the quest when the time is up  
      if CurrentQuest.EndTime == 0 then 
          EmitGlobalSound("Tutorial.Quest.complete_01") -- Part of game_sounds_music_tutorial
          CurrentQuest:CompleteQuest()
          Battle_Step_1_Prepare()
          return
      else
          return 1 -- Call again every second
      end
  end)
end

