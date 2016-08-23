SETTING_EFFECT = "particles/edited_particle/tu_tien/dcn.vpcf"
SETTING_FLY_TIME = 1
SETTING_FLY_SPEED = 1200 
SETTING_CAST_SOUND = "Hero_Luna.Taunt.Land"
SETTING_HIT_SOUND = ""
SETTING_POISON_TIME = 3
SETTING_POISON_PERIOD = 0.5
MODIFIER_DOANCANNHAN = "modifier_tutien_doancannhan"
SKILL_DOANCANNHAN = "skill_tutien_doancannhan"
SETTING_DOANCANNHAN_COOLDOWN = 20
function DoanCanNhan(caster,target_point)
   if(caster:HasModifier(MODIFIER_DOANCANNHAN))then
    local dcn_ability = caster:FindAbilityByName(SKILL_DOANCANNHAN)
    if(dcn_ability:IsCooldownReady())then
      dcn_ability:StartCooldown(SETTING_DOANCANNHAN_COOLDOWN)
      CastDoanCanNhan(caster,target_point)
    end
   end 
   
  
end

function CastDoanCanNhan(caster,target_point)
local skill_level = caster:FindAbilityByName("skill_tutien_doancannhan"):GetLevel()
   local caster_position = caster:GetAbsOrigin()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()

-- MOON CURSE
local immobile_chance = 0.25+0.07*skill_level
local immobile_time = 3
local critical_immobile_chance = 0.5+0.07*skill_level
local critical_immobile_time = 3
local critical_immobile_cooldown = 20
local critical_max_target = 2

  
   caster:EmitSound(SETTING_CAST_SOUND)
   for i = -4,4 do
      local tempAngle = RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*10))
      
      Projectiles:CreateProjectile({
      EffectName      = SETTING_EFFECT,
      Ability         = self,
      vSpawnOrigin    = caster_position+Vector(0,0,50),        
      fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
      fStartRadius    = 80,
      fEndRadius      = 80,
      Source        = caster,
      bHasFrontalCone   = true,
      bReplaceExisting  = false,
      fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
      bCutTrees       = true,
      GroundBehavior = PROJECTILES_NOTHING,
      UnitBehavior  = PROJECTILES_NOTHING,
      vVelocity     = tempAngle*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
      bProvidesVision   = true,
      iVisionRadius   = 200,
      iVisionTeamNumber = caster:GetTeamNumber(),
      effect = EFFECT_IMMOBILE,
      effect_chance = immobile_chance*100,
      effect_time = immobile_time,
      UnitTest = GeneralUnitTest,
      OnUnitHit = function(proj,unit)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
    
            --unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            
            --local hit_effect = ParticleManager:CreateParticle(SETTING_PVBH_HIT_EFFECT, PATTACH_ABSORIGIN_FOLLOW, unit)
            --ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
            --ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
    
            --Timers:CreateTimer(0.5,function() 
                --ParticleManager:DestroyParticle(hit_effect,true)
            --end)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
    
            --StatusEffectHandler:KnockBack(proj.Source,proj.Source:GetAbsOrigin(),unit,chance_to_knockback*100,0.12,knockback_distance)
    
            
          end})
      end
      })
   end
end