skill_aow_mehontieu_cauhonnhiepphach = class({})
require('kem_lib/kem')
--SETTING_EFFECT = "particles/edited_particle/aow_mehontieu/chnp.vpcf"
--_2 la mau vang
SETTING_EFFECT = "particles/edited_particle/aow_mehontieu/chnp_3.vpcf"
SETTING_EXPLODE_EFFECT = "particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf"
SETTING_FLY_TIME = 1 
SETTING_FLY_SPEED = 1000 
SETTING_CAST_SOUND = "Hero_TemplarAssassin.Meld.Move"
SETTING_HIT_SOUND = "Hero_TemplarAssassin.Meld.Attack"
--modifier_aow_mehontieu_truyhon
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_truyhon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )




--------------------------------------------------------------------------------
function skill_aow_mehontieu_cauhonnhiepphach:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return skill_level*5
end

function skill_aow_mehontieu_cauhonnhiepphach:GetCooldown()
   if(IsInToolsMode())then
    return 1
   end
   return 3
end

function skill_aow_mehontieu_cauhonnhiepphach:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_aow_mehontieu_cauhonnhiepphach:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = GetTargetAndLock(self)
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   
   -- STARSHATTER
local basic_damage = 0.4+0.01*skill_level
local physical_damage_amplify = 0+0.08*skill_level
local element_damage_min = 25+18*skill_level
local element_damage_max = 33+35*skill_level
local chance_to_maim = 0.15+0.025*skill_level
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
   
   local speed = SETTING_FLY_SPEED
   local cp1 = caster_position+SETTING_FLY_TIME*speed*angleBetweenCasterAndTarget+Vector(0,0,50)
   if(hTarget)then
    cp1 = hTarget:GetOrigin()+Vector(0,0,50)
   end
   
   for i = 0,1 do
    Timers:CreateTimer(i*0.5,function()
      caster_position  = caster:GetOrigin()
      local newAngle   = (target_point - caster_position):Normalized()
      local chnp_projectile = Projectiles:CreateProjectile( {
       EffectName      = SETTING_EFFECT,
       Ability         = self,
       --start tracking
       ControlPoints   = {[1]=cp1,[2]=Vector(speed,0,0)},
       iVelocityCP = 9,
       bDestroyImmediate = false,--endcap effect
       bRecreateOnChange = false,
       --end tracking
       vSpawnOrigin    = caster_position+Vector(0,0,50),
       fDistance     = SETTING_FLY_TIME*speed,
       fStartRadius    = 80,
       fEndRadius      = 80,       
       Source        = caster,
       bHasFrontalCone   = true,
       bReplaceExisting  = false,
       fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
       GroundBehavior = PROJECTILES_NOTHING,
       UnitBehavior  = PROJECTILES_NOTHING,
       vVelocity     = newAngle*speed,--angleBetweenCasterAndTarget,
       bProvidesVision   = true,
       numHit  = 0,
       iVisionRadius   = 200,
       damage = damageInfo,
       crit = critInfo,
       effect = EFFECT_MAIM,
       effect_chance = chance_to_maim*100,
       effect_time = maim_time,
       maxTarget = max_target,
       iVisionTeamNumber = caster:GetTeamNumber(), 
       UnitTest = GeneralUnitTest,
       OnUnitHit = function(proj, unit) 
       
       DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
          local dh_modifier = unit:AddNewModifier(proj.Source,proj.Ability,SETTING_SKILL_MODIFIER,{duration=10})
          if(dh_modifier:GetStackCount()<20)then
            dh_modifier:IncrementStackCount()
          end
          unit:EmitSound(SETTING_HIT_SOUND)
          DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_METAL, {})
          StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
          proj:Destroy()
       end,miss_function=function(proj)
        proj:Destroy()
       end})
       end
    } )
    
          Track(chnp_projectile,hTarget,0.03,speed,0)
    end)
   end
   
end
