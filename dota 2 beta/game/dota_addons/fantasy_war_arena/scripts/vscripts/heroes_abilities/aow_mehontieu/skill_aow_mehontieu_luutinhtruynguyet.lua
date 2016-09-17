skill_aow_mehontieu_luutinhtruynguyet = class({})
require('kem_lib/kem')
--SETTING_EFFECT = "particles/edited_particle/aow_mehontieu/chnp.vpcf"
SETTING_EFFECT = "particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf"
SETTING_HIT_EFFECT = "particles/edited_particle/aow_mehontieu/lttn_explode.vpcf"
SETTING_FLY_TIME = 1
SETTING_FLY_SPEED = 1000 
SETTING_CAST_SOUND = "Hero_TemplarAssassin.PsiBlade.Resonance"
SETTING_HIT_SOUND = "Hero_TemplarAssassin.Refraction.Damage"
--------------------------------------------------------------------------------
function skill_aow_mehontieu_luutinhtruynguyet:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_aow_mehontieu_luutinhtruynguyet:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_aow_mehontieu_luutinhtruynguyet:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_aow_mehontieu_luutinhtruynguyet:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   
   local hTarget = GetTargetAndLock(self)
   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   
   -- STAR SHOOTING
local basic_damage = 0.85
local physical_damage_amplify = 0+0.08*skill_level
local element_damage_min = 40+32*skill_level
local element_damage_max = 55+39*skill_level
local chance_to_slow = 0.15+0.025*skill_level
local slow_time = 2+0.1*skill_level
local max_target = 4
   
   
   --self:PayManaCost()
   local damageData = {
      caster = caster,
      main_physic = caster.stat_tp, 
      skill_physical_damage_percent = physical_damage_amplify,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = element_damage_min,
      element_damage_max = element_damage_max
   }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   
   local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        radius = 200,
        damage = damageInfo,
        damage_element = ELEMENT_WATER,
        crit = critInfo,
        custom = {
          action="status_effect",
          effect_type=EFFECT_SLOW,
          effect_chance=chance_to_slow*100,
          effect_time=slow_time
        }
      }
   
   
   caster:EmitSound(SETTING_CAST_SOUND)
   local cp1 = caster_position+SETTING_FLY_TIME*SETTING_FLY_SPEED*angleBetweenCasterAndTarget+Vector(0,0,50)
   
   if(hTarget)then
    --PrintTable(hTarget)
    cp1 = hTarget:GetOrigin()+Vector(0,0,50)
   end
   
   
   local lttn_proj = Projectiles:CreateProjectile({
       EffectName      = SETTING_EFFECT,
       Ability         = self,
       ControlPoints   = {[1]=cp1,[2]=Vector(SETTING_FLY_SPEED,0,0)},
       iVelocityCP = 99,
       vSpawnOrigin    = caster_position+Vector(0,0,50),
       fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
       fStartRadius    = 51,
       fEndRadius      = 51,
       Source        = caster,
       bDestroyImmediate = false,--endcap
       bRecreateOnChange = false,
       
       --draw=true,
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
       effect = EFFECT_SLOW,
       effect_chance = chance_to_slow*100,
       effect_time = 1,
       maxTarget = 2,
       iVisionTeamNumber = caster:GetTeamNumber(), 
       UnitTest = GeneralUnitTest,
       OnUnitHit = function(proj, unit) 
       --unit:EmitSound(SETTING_HIT_SOUND)
         damageAreaData.where = unit:GetOrigin()
         DamageHandler:DamageArea(damageAreaData)
         SoundPoint(SETTING_HIT_SOUND,damageAreaData.where,0.5,caster:GetTeam())
         FxPointControl(SETTING_HIT_EFFECT,damageAreaData.where,0.5,{[3]=damageAreaData.where})
         proj:Destroy()
--          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
--          DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_WOOD, {})
--          StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
--         --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
--          proj:Destroy()
--         end,miss_function=function()
--          proj:Destroy()
--         end})
         
       end
   })
   
   if(hTarget)then
    --cast vao unit
      Track(lttn_proj,hTarget,0.03,SETTING_FLY_SPEED,0)
   else
    --cast vao mat dat
   end
   
   
end
