skill_kiemdoan_kinhthiennhatkiem= class({})

SETTING_KTNK_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_ktnk_sword.vpcf"
--SETTING_KTNK_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_KTNK_HIT_EFFECT = "particles/edited_particle/kiem_doan/fx_phongvanbienhuyen_hit.vpcf"
SETTING_KTNK_FLY_TIME = 1
SETTING_KTNK_FLY_SPEED = 1000
SETTING_KTNK_DURATION= 8
function skill_kiemdoan_kinhthiennhatkiem:GetCooldown()
  --self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  return 1
  --return 45-self:GetLevel()*3
end

function skill_kiemdoan_kinhthiennhatkiem:OnAbilityPhaseStart()
  --self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_ATTACK,atk_perseconds)
  return true
end


function skill_kiemdoan_kinhthiennhatkiem:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()
  local target_point = self:GetCursorPosition()
  local caster_point = caster:GetAbsOrigin()
  local angleBetweenCasterAndTarget = (target_point - caster_point):Normalized()
  local castTime = GameRules:GetGameTime()
  


        
  -- TIDAL WAVE
local chance_to_slow = 1
local slow_time = 2+0.4*skill_level
local chance_to_knockback = 1
local knockback_distance = 96
        
        
  Timers:CreateTimer(0.01,function()
    
    for i = 1,3 do
      Timers:CreateTimer((i-1)*0.1,function()
        local tempPoint = Vector(target_point.x+math.random(-45,45),target_point.y+math.random(-45,45),caster_point.z)
        local tempPoint_2 = Vector(caster_point.x+math.random(-30,30),caster_point.y+math.random(-30,30),caster_point.z)
        local knockback_angle = (tempPoint-tempPoint_2):Normalized()
        Projectiles:CreateProjectile({
        EffectName      = SETTING_KTNK_EFFECT,
        Ability         = self,
        vSpawnOrigin    = tempPoint_2,        
        fDistance     = SETTING_KTNK_FLY_SPEED,
        fStartRadius    = 80,
        fEndRadius      = 80,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = 1,--GameRules:GetGameTime() +100,--
      
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = knockback_angle*SETTING_KTNK_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        iVisionRadius   = 200,
        iVisionTeamNumber = caster:GetTeamNumber(),
        effect = EFFECT_SLOW,
        effect_chance = chance_to_slow*100,
        effect_time = slow_time,
        knockback_angle = knockback_angle,
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
            DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)

              unit:EmitSound("Hero_Kunkka.TidebringerDamage")
              
              local hit_effect = ParticleManager:CreateParticle(SETTING_PVBH_HIT_EFFECT, PATTACH_ABSORIGIN_FOLLOW, unit)
              ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
              ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))

              Timers:CreateTimer(0.5,function() 
                  ParticleManager:DestroyParticle(hit_effect,true)
              end)
              StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)

              StatusEffectHandler:KnockBack(proj.Source,proj.Source:GetAbsOrigin(),unit,chance_to_knockback*100,0.12,knockback_distance)

              
            end})
        end
        })
        

      end)
    end
    local now = GameRules:GetGameTime()
    if((now-castTime)<SETTING_KTNK_DURATION)then
      return 0.5
    end
  end)
  

    
end