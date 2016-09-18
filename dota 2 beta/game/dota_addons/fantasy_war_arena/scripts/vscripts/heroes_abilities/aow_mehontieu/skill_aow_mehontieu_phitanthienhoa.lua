skill_aow_mehontieu_phitanthienhoa = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/aow_mehontieu/ptth.vpcf"
SETTING_FLY_TIME = 1
SETTING_FLY_SPEED = 1200 
SETTING_CAST_SOUND = "Hero_TemplarAssassin.Trap.Trigger"
SETTING_HIT_SOUND = "Hero_TemplarAssassin.PsiBlade.Resonance"
--------------------------------------------------------------------------------
function skill_aow_mehontieu_phitanthienhoa:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*10
end

function skill_aow_mehontieu_phitanthienhoa:GetCooldown()
   return 5
end

function skill_aow_mehontieu_phitanthienhoa:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4,atk_perseconds)
   return true
end

function skill_aow_mehontieu_phitanthienhoa:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = GetTargetAndLock(self)
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   
   -- FLYING FLOWER
local basic_damage = 0.4+0.0075*skill_level
local physical_damage_amplify = 0.5+0.03*skill_level
local element_damage_min = 65+28*skill_level
local element_damage_max = 75+45*skill_level

local chance_to_maim = 0.15+0.01*skill_level
local maim_time = 1
local max_target = 3
   
   
   
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
   caster:EmitSound(SETTING_CAST_SOUND)
   
   local cp1 = caster_position+SETTING_FLY_TIME*SETTING_FLY_SPEED*angleBetweenCasterAndTarget+Vector(0,0,50)
   if(hTarget)then
    cp1 = hTarget:GetOrigin()+Vector(0,0,50)
   end
   
   
   for i = 0,2 do
    Timers:CreateTimer(i*0.33,function()
      caster_position  = caster:GetOrigin()
      local newAngle   = (target_point - caster_position):Normalized()
      local ptth_missile = Projectiles:CreateProjectile( {
         EffectName      = SETTING_EFFECT,
         Ability         = self,
         vSpawnOrigin    = caster_position+Vector(0,0,50),
         --start tracking
         ControlPoints   = {[1]=cp1,[2]=Vector(SETTING_FLY_SPEED,0,0)},
         iVelocityCP = 9,
         bDestroyImmediate = false,--endcap effect
         bRecreateOnChange = false,
         --end tracking
         fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
         fStartRadius    = 100,
         fEndRadius      = 100,
         Source        = caster,
         bHasFrontalCone   = true,
         bReplaceExisting  = false,
         fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
         GroundBehavior = PROJECTILES_NOTHING,
         UnitBehavior  = PROJECTILES_NOTHING,
         vVelocity     = newAngle*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
         bProvidesVision   = true,
         numHit  = 0,
         iVisionRadius   = 200,
         damage = damageInfo,
         crit = critInfo,
         maim_chance = chance_to_maim*100,
         maim_time = maim_time,
         maxTarget = max_target,
         iVisionTeamNumber = caster:GetTeamNumber(), 
         UnitTest = GeneralUnitTest,
         OnUnitHit = function(proj, unit) 
         
         DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
           unit:EmitSound(SETTING_HIT_SOUND)
           DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_METAL, {})
           --StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
           StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_MAIM, proj.maim_chance, proj.maim_time)
           --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
           proj:Destroy()
         end,miss_function=function(proj)
           proj:Destroy()
         end})
         end
      } )
      Track(ptth_missile,hTarget,0.03,SETTING_FLY_SPEED,0)
    end)
   end
end
