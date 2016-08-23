skill_daocon_cuongphongsaudien = class({})
require('kem_lib/kem')
SETTING_CPSD_EFFECT = "particles/edited_particle/dao_con/cuongphongsaudien.vpcf"
SETTING_CPSD_FLY_TIME = 1.2
SETTING_CPSD_FLY_SPEED = 800
SETTING_CPSD_HIT_EFFECT = "particles/units/heroes/hero_visage/visage_base_attack_hit.vpcf"
--------------------------------------------------------------------------------
function skill_daocon_cuongphongsaudien:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*5
end

function skill_daocon_cuongphongsaudien:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_daocon_cuongphongsaudien:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_daocon_cuongphongsaudien:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   
   -- LIGHTNING CYCLONE
local physical_damage_amplify = 0.5+0.07*skill_level
local element_damage_min = 448+12*skill_level
local element_damage_max = 560+6*skill_level
local basic_damage = 0.85
local chance_to_stun = 0.15+0.025*skill_level
local stun_time = 1
   
   
   local damageData = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   caster:EmitSound("Hero_Juggernaut.BladeFuryStop")
   Projectiles:CreateProjectile( {
        EffectName      = SETTING_CPSD_EFFECT,
        Ability         = self,
        vSpawnOrigin    = caster_position,
        fDistance     = SETTING_CPSD_FLY_TIME*SETTING_CPSD_FLY_SPEED,
        fStartRadius    = 100,
        fEndRadius      = 100,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_CPSD_FLY_TIME,--GameRules:GetGameTime() +100,--
      
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*SETTING_CPSD_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        effect = EFFECT_STUN,
        effect_chance = chance_to_stun*100,
        effect_time = stun_time,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_EARTH,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            
            CreateEffectOnUnit(SETTING_HPP_HIT_EFFECT,unit,0.5)
            CreateEffectOnPoint(SETTING_HPP_HIT_EFFECT,unit:GetAbsOrigin(),0.5)
          end})
          
          
        end
        
      } )
end
