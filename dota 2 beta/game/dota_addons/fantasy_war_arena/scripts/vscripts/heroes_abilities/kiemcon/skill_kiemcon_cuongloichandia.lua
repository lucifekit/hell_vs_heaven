skill_kiemcon_cuongloichandia = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
SETTING_FLY_TIME = 0.5 
SETTING_FLY_SPEED = 400 
SETTING_CAST_SOUND = "Hero_Zuus.ArcLightning.Cast"
SETTING_HIT_SOUND = ""
SETTING_RADIUS = 200
--------------------------------------------------------------------------------
function skill_kiemcon_cuongloichandia:GetManaCost()
   return 25
end

function skill_kiemcon_cuongloichandia:GetCooldown(nLevel)
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_kiemcon_cuongloichandia:OnAbilityPhaseStart()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)
   return true
end

function skill_kiemcon_cuongloichandia:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()

-- LIGHTNING BEAM
local basic_damage = 1
local element_damage_min = 44+40*skill_level
local element_damage_max = 72+48*skill_level
local chance_to_stun = 0.15+0.02*skill_level
local stun_time = 1
local max_target = 5

   
   
   
   local damageData = {
      caster = caster,
      main_magic = caster:GetIntellect(), 
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = element_damage_min,
      element_damage_max = element_damage_max
   }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   caster:EmitSound(SETTING_CAST_SOUND)
   local damageAreaData = {
      whoDealDamage = caster,
      byWhichAbility = self,
      where = target_point,
      radius = SETTING_RADIUS,
      damage = damageInfo,        
      damage_element = ELEMENT_EARTH,
      crit  = critInfo,
      maxTarget=max_target,
      custom = {
        action="status_effect",
        effect_type=EFFECT_STUN,
        effect_chance=chance_to_stun*100,
        effect_time=stun_time
      }

    }
   local pfx = ParticleManager:CreateParticle(SETTING_EFFECT,PATTACH_WORLDORIGIN,caster)
   ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin()+Vector(0,0,50))     
   ParticleManager:SetParticleControl( pfx, 1, cast_point+Vector(0,0,50))
   ParticleManager:ReleaseParticleIndex(pfx)
   --PrintTable(damageAreaData)
   DamageHandler:DamageArea(damageAreaData) 
end
