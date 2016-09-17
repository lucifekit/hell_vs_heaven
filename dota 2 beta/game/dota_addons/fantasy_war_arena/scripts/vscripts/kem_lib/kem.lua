-- theta is in radians.
function RotateVector2D(v,theta)
    local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
    local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
    return Vector(xp,yp,v.z):Normalized()
end

function GetSkillLevel(hero)
    
    local ms = hero:GetModifierStackCount("modifier_skill_level",hero)
    --print("Skill level "..ms) 
    return ms
    --return 0
end

function GetTargetAndLock(abilityData)
  local caster = abilityData:GetCaster()
  local hTarget = abilityData:GetCursorTarget()
  local result = hTarget
  if(hTarget)then
      caster.lockTarget = hTarget
      --setLock
      CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "set_lock", {playerID=caster:GetPlayerID(),target_idx=result:entindex()})
   else
      --an nut skill vao mat dat
      if(caster.lockTarget)then
        if(caster.lockTarget:IsNull())then
          caster.lockTarget=nil
        else
          if(caster.lockTarget:IsAlive())then
            if(caster:CanEntityBeSeenByMyTeam(caster.lockTarget))then
              local castRange = abilityData:GetCastRange(caster:GetOrigin(),caster)+500
              --print("Cast range : "..castRange)            
              if((caster.lockTarget:GetOrigin()-caster:GetOrigin()):Length2D()<=castRange)then
                result = caster.lockTarget
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "set_lock", {playerID=caster:GetPlayerID(),target_idx=result:entindex()})
                --setLock
              else
                caster.lockTarget = nil
              end   
            else
              caster.lockTarget = nil 
            end
          else
            --target die
            caster.lockTarget = nil
          end
        end
        
      else
        --ko co lock target, thi cast vao mat dat thoi
      end
   end
   return result
end
function IsShortRangeAttack(attacker,target)
  if(not attacker:IsAlive())then
    return false
  end
  if(not target:IsAlive())then
    return false
  end
  return (attacker:GetOrigin()-target:GetOrigin()):Length2D()<240
end
function ReturnDamage(target,ability,attacker,damage,return_amount)
  print("Damage = "..damage)
  local damage_return = damage*return_amount
  print("Damage return = "..damage_return)
  if(attacker.inited)then
     damage_return=damage_return*5
  end
  print("After check inited, Damage return = "..damage_return)
  if(target.inited)then
    if(attacker.return_damage_resist)then
      local resist = attacker.return_damage_resist*0.01
      print("Resist = "..resist)
      damage_return = damage_return-damage_return*resist
    end
  end
  print("After check resist, Damage return = "..damage_return)
  DamageHandler:ApplyDamage(target,ability,attacker,damage_return,
    DamageHandler:InitCrit(0,0),ELEMENT_METAL,
    {flag="reflect"})
end
function Track(proj,target,tick,missile_speed,missile_back_distance)
  if target then
    --proj.bLive = true
    proj.changes = proj.fExpireTime/tick
    
    Timers:CreateTimer(tick,function() 
      --print("19")
      if(proj.id and Projectiles.timers[proj.ProjectileTimerName])then
        --print("21")
        if(target)then
          if(target:IsAlive())then
            --print("23 alive")
            local targetNewPos = target:GetAbsOrigin()+Vector(0,0,50)
            local myNewPos = proj.pos--tempProjectile:GetOrigin()
            local newAngle = (targetNewPos-myNewPos):Normalized()
            local spawn_point = myNewPos-newAngle*missile_back_distance
            --PrintTable(tempProjectile)
            --proj.ControlPoints[1] = targetNewPos
            if(proj.bRecreateOnChange)then
              --print("31 velo")
              proj:SetVelocity(newAngle*missile_speed,spawn_point)
            else
              proj:SetVelocity(newAngle*missile_speed,myNewPos)            
              ParticleManager:SetParticleControl(proj.id, 1, targetNewPos)
            end
            return tick
          else
            proj:Destroy()
          end
        else
        
        end
        
      end    
      
      
    end)
  end
end
function HasBook(hero)
  return GetSkillLevel(hero)>0
end
function ReflectDamage(attacker,victim,damage)

end
function kemPrint(msg)

  if(IsInToolsMode())then
    if(IsServer())then
      print(GameRules:GetGameTime().." : "..msg)
    end
  end
  
end
function BuffAllies(caster,ability,buff,duration,center,aoe)
  local group = FindUnitsInRadius(caster:GetTeam(), center, nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  if #group > 0 then
    for _,unit in pairs(group) do
      if(not unit==caster)then
        unit:AddNewModifier(caster, ability,buff, { duration = duration } )
      end
    end
  end
end
function FxPointRelease(effect,point,control)
  local hit_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl( hit_effect, 0, point)     
  if(control)then
    for i,v in ipairs(control) do
      ParticleManager:SetParticleControl( hit_effect, i,v)
    end
    
  end
  ParticleManager:ReleaseParticleIndex(hit_effect)
end
function FxPointControl(effect,point,time,control)
  local hit_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl( hit_effect, 0, point)
  --PrintTable(control)     
  if(control)then
    for i,v in pairs(control) do
      --print("Set control point "..i.." = ")
      ParticleManager:SetParticleControl( hit_effect, i,v)
    end
    
  end
  --ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
  Timers:CreateTimer(time,function() 
      ParticleManager:DestroyParticle(hit_effect,true)
  end)
  return hit_effect
end
function FxPoint(effect,point,time)
  FxPointControl(effect,point,time,nil)
end
function CreateEffectOnUnit(effect,unit,time)
  local hit_effect = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
  ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
  --ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))

  Timers:CreateTimer(time,function() 

      ParticleManager:DestroyParticle(hit_effect,true)
  end)
end
function GeneralUnitTest(proj,unit)
    --valve remove cai DOTA_UNIT_TARGET_MECHANICAL roi thi phai
    local filter_result = UnitFilter(unit,DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP , DOTA_UNIT_TARGET_FLAG_NONE, proj.Source:GetTeamNumber())
    return filter_result==UF_SUCCESS
end

function SoundPoint(sound,point,time,team)
  local dcld_dummy_unit = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, team)
  dcld_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
  dcld_dummy_unit:EmitSound(sound)
  Timers:CreateTimer({
              endTime = time,
              callback = function()
                 dcld_dummy_unit:RemoveSelf()
              end
            })
end

function CreateEffectOnPoint(effect,point,time)
  local hit_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl( hit_effect, 0, point)     
  --ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
  Timers:CreateTimer(0.5,function() 
      ParticleManager:DestroyParticle(hit_effect,true)
  end)
end
function testingEffect(caster,effect)
  local caster_point = caster:GetOrigin()
  local top_point = caster_point + Vector(0,200,0)
  local right_point = caster_point + Vector(200,0,0)
  local left_point = caster_point + Vector(-200,0,0)
  local bottom_point = caster_point + Vector(0,-200,0)
  local top_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, caster)
  ParticleManager:SetParticleControl( top_effect, 0,top_point)
  ParticleManager:SetParticleControl( top_effect, 1,top_point)
  ParticleManager:SetParticleControl( top_effect, 2,top_point)
  ParticleManager:SetParticleControl( top_effect, 3,top_point)     
  
  local left_dummy_unit = CreateUnitByName("npc_dummy_unit", left_point, false, nil, nil, caster:GetTeam())
  left_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
  local left_effect = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, left_dummy_unit)
  ParticleManager:SetParticleControl( left_effect, 0,left_point)
  ParticleManager:SetParticleControl( left_effect, 1,left_point)
  ParticleManager:SetParticleControl( left_effect, 2,left_point)
  ParticleManager:SetParticleControl( left_effect, 3,left_point)
  
  
  local right_dummy_unit = CreateUnitByName("npc_dummy_unit", right_point, false, nil, nil, caster:GetTeam())
  right_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
  local right_effect = ParticleManager:CreateParticle(effect, PATTACH_POINT, right_dummy_unit)
  ParticleManager:SetParticleControl( right_effect, 0,right_point)
  ParticleManager:SetParticleControl( right_effect, 1,right_point)
  ParticleManager:SetParticleControl( right_effect, 2,right_point)
  ParticleManager:SetParticleControl( right_effect, 3,right_point)
  
  
  local bottom_dummy_unit = CreateUnitByName("npc_dummy_unit", bottom_point, false, nil, nil, caster:GetTeam())
  bottom_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
   
  local bottom_effect = ParticleManager:CreateParticle(effect, PATTACH_CUSTOMORIGIN, bottom_dummy_unit)
  ParticleManager:SetParticleControl( bottom_effect, 0,bottom_point)
  ParticleManager:SetParticleControl( bottom_effect, 1, Vector(1,1,1))
  ParticleManager:SetParticleControl( bottom_effect, 2, Vector(0,0,0))
  --ParticleManager:SetParticleControlEnt(bottom_effect, 0, bottom_dummy_unit, PATTACH_POINT_FOLLOW, "attach_origin", bottom_dummy_unit:GetAbsOrigin(), true)
  
--  ParticleManager:ReleaseParticleIndex(top_effect)
--  ParticleManager:ReleaseParticleIndex(left_effect)
--  ParticleManager:ReleaseParticleIndex(right_effect)
--  ParticleManager:ReleaseParticleIndex(bottom_effect)
  Timers:CreateTimer(2,function() 
    
    left_dummy_unit:RemoveSelf()
    right_dummy_unit:RemoveSelf()
    bottom_dummy_unit:RemoveSelf()
    ParticleManager:DestroyParticle(top_effect,true)
    ParticleManager:DestroyParticle(left_effect,true)
    ParticleManager:DestroyParticle(right_effect,true)
    ParticleManager:DestroyParticle(bottom_effect,true)
    
  end)
  
end

