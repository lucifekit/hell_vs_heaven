skill_tutien_xuyenvantien = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/tu_tien/xvt.vpcf"
SETTING_FLY_TIME = 2
SETTING_FLY_SPEED =700 
SETTING_CAST_SOUND = "Hero_Luna.MoonGlaive.Impact"
SETTING_CAST_SOUND = "Hero_Luna.Taunt.Land"
SETTING_HIT_SOUND = ""
SETTING_POISON_TIME = 3
SETTING_POISON_PERIOD = 0.5
require('heroes_abilities/tutien/tutien')
--------------------------------------------------------------------------------
function skill_tutien_xuyenvantien:GetManaCost()  
  return 100
end

function skill_tutien_xuyenvantien:GetCooldown()
  if(IsInToolsMode())then
    return 0
  end
   return 10
end

function skill_tutien_xuyenvantien:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_tutien_xuyenvantien:OnProjectileHit_ExtraData(hTarget, vLocation, proj_data)
  local caster = self:GetCaster()
  local target = hTarget

  local mat_ability = caster:FindAbilityByName("skill_tutien_meanhtung")
  --local current_cooldown = mat_ability:GetCooldownTimeRemaining()
  mat_ability:EndCooldown()  
  
  
  -- HEART SEEKING
local basic_damage = 1.5
local poison_damage = 1000
local chance_to_immobile = 0.85
local immobile_time = 3
local immobile_time_max = 9
local max_target = 3

   local damageData = {
      caster = caster,
      main_physic = caster.stat_tp, 
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = 0,
      element_damage_max = 0
   }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   proj_data.Source = caster
   proj_data.Ability = self
   proj_data.damage = damageInfo
   proj_data.crit = critInfo
   proj_data.effect = EFFECT_IMMOBILE
   proj_data.effect_chance = chance_to_immobile*100
   proj_data.effect_time = immobile_time
   proj_data.poison          = poison_damage
   proj_data.period          = SETTING_POISON_PERIOD
   proj_data.duration        = SETTING_POISON_TIME
   DamageHandler:MissileHandler({attacker=caster,target=target,projectile=proj_data,hit_function=function(proj,unit)
      
      DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_WOOD, {})      
      PoisonHandler:ApplyPoison(proj.Source,unit,proj.Ability,proj.period,proj.duration,proj.poison,{})      
      local effect_time_addition = (proj.Source:GetOrigin()-unit:GetOrigin()):Length2D()/1200
      local effect_time_addition_multiplier =1+math.min(2.1,effect_time_addition)
      local effect_time = proj.effect_time*effect_time_addition_multiplier      
      StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance,effect_time )      
   end,miss_function=function()
      
   
   end})

 
end
function skill_tutien_xuyenvantien:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   DoanCanNhan(caster,target_point)
   --self:PayManaCost()
   -- SWIFT GLAIVE

   caster:EmitSound(SETTING_CAST_SOUND)
   --giam thoi gian cho me anh tung
   
   ProjectileManager:CreateTrackingProjectile({
      EffectName = "particles/edited_particle/tu_tien/xvt_tracking.vpcf",
      Ability = self,
      iMoveSpeed = SETTING_FLY_SPEED,
      Source = caster,
      Target = self:GetCursorTarget(),
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
   })
   
end
