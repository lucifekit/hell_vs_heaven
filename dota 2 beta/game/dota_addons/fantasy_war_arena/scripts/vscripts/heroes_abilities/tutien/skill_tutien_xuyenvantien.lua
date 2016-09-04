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
  return 200
end

function skill_tutien_xuyenvantien:GetCooldown()
   return 10
end

function skill_tutien_xuyenvantien:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
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
local basic_damage = 1
local physical_damage_amplify = 0.03+0.04*skill_level
local poison_damage = 45+14*skill_level
local chance_to_maim = 0.15+0.025*skill_level
local maim_time = 1
local chance_to_weak = 0.15+0.035*skill_level
local weak_time = 2+0.1*skill_level
local max_target = 3
   
   local damageData = {
      caster = caster,
      main_physic = caster.stat_tp, 
      skill_physical_damage_percent = physical_damage_amplify,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = 0,
      element_damage_max = 0
   }
 
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   caster:EmitSound(SETTING_CAST_SOUND)
   Projectiles:CreateProjectile( {
   EffectName      = SETTING_EFFECT,
   Ability         = self,
   vSpawnOrigin    = caster_position+Vector(0,0,100),
   fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
   fStartRadius    = 140,
   fEndRadius      = 140,
   Source        = caster,
   bHasFrontalCone   = true,
   bReplaceExisting  = false,
   fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
   GroundBehavior = PROJECTILES_NOTHING,
   UnitBehavior  = PROJECTILES_NOTHING,
   vVelocity     = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
   bProvidesVision   = true,
   numHit  = 0,
   iVisionRadius   = 200,
   
   damage = damageInfo,
   crit = critInfo,
   
   effect = EFFECT_MAIM,
   effect_chance = chance_to_maim*100,
   effect_time = maim_time,
   
   poison          = poison_damage,
   period          = SETTING_POISON_PERIOD,
   duration        = SETTING_POISON_TIME,
   maxTarget = max_target,
   
   iVisionTeamNumber = caster : GetTeamNumber(), 
   UnitTest = GeneralUnitTest,
   OnUnitHit = function(proj, unit) 
   --unit:EmitSound(SETTING_HIT_SOUND)
   DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
      DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_WOOD, {})
      PoisonHandler:ApplyPoison(proj.Source,unit,proj.Ability,proj.period,proj.duration,proj.poison,{})
      StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
      StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_WEAK,chance_to_weak*100, weak_time)
   end})
   end
} )
end
