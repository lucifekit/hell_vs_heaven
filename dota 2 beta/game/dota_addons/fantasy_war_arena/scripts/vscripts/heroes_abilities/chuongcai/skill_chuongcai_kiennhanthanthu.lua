skill_chuongcai_kiennhanthanthu = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/chuong_cai/kntt.vpcf"
SETTING_FLY_TIME = 1 
SETTING_FLY_SPEED = 800 
SETTING_CAST_SOUND = "Ability.PreLightStrikeArray"
SETTING_HIT_SOUND = ""
--------------------------------------------------------------------------------
function skill_chuongcai_kiennhanthanthu:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return skill_level*5
end

function skill_chuongcai_kiennhanthanthu:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_chuongcai_kiennhanthanthu:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_chuongcai_kiennhanthanthu:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   -- DRAGON SLAVE
local basic_damage = 1
local element_damage_min = 15+50*skill_level
local element_damage_max = 30+60*skill_level
local chance_to_burn = 0.15+0.025*skill_level
local burn_time = 2+0.1*skill_level
local max_target = math.floor(3+0.2*skill_level)
   
   local damageData = {
      caster = caster,
      main_attribute_value = caster:GetIntellect(), 
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = element_damage_min,
      element_damage_max = element_damage_max
   }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   caster:EmitSound(SETTING_CAST_SOUND)
   Projectiles:CreateProjectile( {
   EffectName      = SETTING_EFFECT,
   Ability         = self,
   vSpawnOrigin    = caster_position,
   fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
   fStartRadius    = 100,
   fEndRadius      = 100,
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
   effect = EFFECT_BURN,
   effect_chance = chance_to_burn*100,
   effect_time = burn_time,
   maxTarget = max_target,
   iVisionTeamNumber = caster:GetTeamNumber(), 
   UnitTest = GeneralUnitTest,
   OnUnitHit = function(proj, unit) 
   --unit:EmitSound(SETTING_HIT_SOUND)
   DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
   DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_FIRE, {})
   StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
   --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
   if(not HasBook(proj.Source))then
    if(proj.numHit<2)then
      proj.numHit=proj.numHit+1
      else
      proj:Destroy()
    end
   end
   --proj:Destroy()
   end})
   end
} )
end
