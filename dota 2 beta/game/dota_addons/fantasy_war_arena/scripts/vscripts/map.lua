


function Activate(trigger)
  if(IsServer())then
    --kemPrint("============================MAP==============================")
  end
  

end 
LinkLuaModifier("modifier_kemtele","modifiers/modifier_teleporting", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_immobile","modifiers/modifier_immobile", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_battle_hunger","modifiers/modifier_battle_hunger", LUA_MODIFIER_MOTION_NONE )
function StartTeleportHell(trigger)
  
  local hero = trigger.activator
  local targetEntities = Entities:FindAllByName("hell_teleport") 
  local target_point = targetEntities[1]:GetAbsOrigin()
  target_point = Vector(target_point.x+math.random(-500,500),target_point.y+math.random(-500,500),128)

  --kemPrint("Teleporting "..hero:GetUnitName().." to "..target_point.x.."x"..target_point.y)
  hero:Stop()
  hero:AddNewModifier(hero,nil,"modifier_immobile",{duration=1})
  hero:AddNewModifier(hero,nil,"modifier_kemtele",{duration=3,x=target_point.x,y=target_point.y})
  --kemPrint("Added modifier")

end 
function StartTeleportHeaven(trigger)
  
  local hero = trigger.activator
  local targetEntities = Entities:FindAllByName("heaven_teleport") 
  local target_point = targetEntities[1]:GetAbsOrigin()
  target_point = Vector(target_point.x+math.random(-500,500),target_point.y+math.random(-500,500),128)

  --kemPrint("Teleporting "..hero:GetUnitName().." to "..target_point.x.."x"..target_point.y)
  
  hero:Stop()
  hero:AddNewModifier(hero,nil,"modifier_immobile",{duration=1})
  hero:AddNewModifier(hero,nil,"modifier_kemtele",{duration=3,x=target_point.x,y=target_point.y})
  
  --kemPrint("Added modifier")

end 
function StartTeleportHeavenHome(trigger)
  
  local hero = trigger.activator

  local canActivate =hero:GetTeam()==DOTA_TEAM_GOODGUYS
  if(IsInToolsMode())then
    canActivate = true
  end 
  if(canActivate)then
    local targetEntities = Entities:FindAllByName("heaven_home_teleport") 
    local target_point = targetEntities[1]:GetAbsOrigin()
    target_point = Vector(target_point.x+math.random(-100,100),target_point.y+math.random(-100,100),128)
    --kemPrint("Teleporting "..hero:GetUnitName().." to "..target_point.x.."x"..target_point.y)
    local targetEntities_2 = Entities:FindAllByName("heaven_teleport") 
    local target_point_2 = targetEntities_2[1]:GetAbsOrigin()
    target_point_2 = Vector(target_point_2.x+math.random(-500,500),target_point_2.y+math.random(-500,500),128)
    hero:Stop()
    hero:AddNewModifier(hero,nil,"modifier_immobile",{duration=1})
    hero:AddNewModifier(hero,nil,"modifier_kemtele",{duration=5,x=target_point.x,y=target_point.y,home=1,home_x=target_point_2.x,home_y=target_point_2.y})
    print("Add battle hunger")
  end
  
  --kemPrint("Added modifier")

end 

function StartTeleportHellHome(trigger)
  
  local hero = trigger.activator

    local canActivate =hero:GetTeam()==DOTA_TEAM_BADGUYS
  if(IsInToolsMode())then
    canActivate = true
  end 
  if(canActivate)then
    local targetEntities = Entities:FindAllByName("hell_home_teleport") 
    local target_point = targetEntities[1]:GetAbsOrigin()
    target_point = Vector(target_point.x+math.random(-100,100),target_point.y+math.random(-100,100),128)
    --kemPrint("Teleporting "..hero:GetUnitName().." to "..target_point.x.."x"..target_point.y)
    local targetEntities_2 = Entities:FindAllByName("hell_teleport") 
    local target_point_2 = targetEntities_2[1]:GetAbsOrigin()
    target_point_2 = Vector(target_point_2.x+math.random(-500,500),target_point_2.y+math.random(-500,500),128)
      
    hero:Stop()
    hero:AddNewModifier(hero,nil,"modifier_immobile",{duration=1})
    hero:AddNewModifier(hero,nil,"modifier_kemtele",{duration=5,x=target_point.x,y=target_point.y,home=1,home_x=target_point_2.x,home_y=target_point_2.y})
    --hero:AddNewModifier(hero,nil,"modifier_battle_hunger",{duration=60,x=target_point_2.x,y=target_point_2.y})
    
  end
  
  --kemPrint("Added modifier")
end 
function EndTeleportHell(trigger)
  kemPrint("============================END==============================")
end 