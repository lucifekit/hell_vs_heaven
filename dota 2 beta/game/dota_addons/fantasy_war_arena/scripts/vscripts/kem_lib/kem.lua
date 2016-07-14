-- theta is in radians.
function RotateVector2D(v,theta)
    local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
    local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
    return Vector(xp,yp,v.z):Normalized()
end

function distanceBetweenPoint(v1,v2)
	return math.sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y))
end
function kemPrint(msg)

  if(IsInToolsMode())then
    print(GameRules:GetGameTime().." : "..msg)
  end
  
end
function FxPoint(effect,point,time)
  local hit_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl( hit_effect, 0, point)     
  --ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
  Timers:CreateTimer(time,function() 
      ParticleManager:DestroyParticle(hit_effect,true)
  end)

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

