skill_chuongcai_philongtaithien = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/chuong_cai/pltt.vpcf"
SETTING_FLY_TIME = 2
SETTING_FLY_SPEED = 600 
SETTING_DISTANCE_DRAGON=80
SETTING_CAST_SOUND = "Hero_DragonKnight.DragonTail.Cast.Kindred"
SETTING_HIT_SOUND = "Hero_Clinkz.Death"
--SETTING_EXPLODE_EFFECT = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_beam_immortal1.vpcf"
SETTING_EXPLODE_EFFECT_NO_TARGET = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_flame_immortal1.vpcf"
SETTING_EXPLODE_EFFECT = "particles/edited_particle/chuong_cai/lcvd.vpcf"
--------------------------------------------------------------------------------
function skill_chuongcai_philongtaithien:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_chuongcai_philongtaithien:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_chuongcai_philongtaithien:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_chuongcai_philongtaithien:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local target = self:GetCursorTarget()
   
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   -- DRAGON RISE
local basic_damage = 0.1+0.006*skill_level
local element_damage_min = 213+13*skill_level
local element_damage_max = 260+16*skill_level
local chance_to_burn = 0.05+0.01*skill_level
local burn_time = 2+0.1*skill_level
local explode_damage_min = 407+25*skill_level
local explode_damage_max = 611+38*skill_level
local explode_basic_damage_min = 0.27+0.016*skill_level
local explode_basic_damage_max = 0.4+0.025*skill_level
local max_target = math.floor(2+0.2*skill_level)
   
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
   local damageDataExplode = {
      caster = caster,
      main_magic = caster:GetIntellect(), 
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = math.random(explode_basic_damage_min,explode_basic_damage_max),
      element_damage_min = explode_damage_min,
      element_damage_max = explode_damage_max
   }
   local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        
        radius = 200,
        damage = DamageHandler:GetDamage(damageDataExplode),
        damage_element = ELEMENT_FIRE,
        crit = critInfo,
        custom = {}
      }
   caster:EmitSound(SETTING_CAST_SOUND)
   local projectile_group = {}
   for i = 1,4 do
      local spawn_point = caster_position+RotateVector2D(angleBetweenCasterAndTarget,math.rad(90))*(i-2)*SETTING_DISTANCE_DRAGON+Vector(0,0,50)
      
      local cp1 = spawn_point+angleBetweenCasterAndTarget*SETTING_FLY_SPEED
      if(target)then
      else
        cp1 = spawn_point+angleBetweenCasterAndTarget*SETTING_FLY_SPEED*SETTING_FLY_TIME
      end
      --FxPoint("particles/edited_particle/kiem_minh/thanhhoaphantam.vpcf",cp1,5)
      projectile_group[i] = Projectiles:CreateProjectile( {
         EffectName      = SETTING_EFFECT,
         ControlPoints   = {[1]=cp1,[2]=Vector(SETTING_FLY_SPEED,0,0)},
         iVelocityCP = 9,
         bRecreateOnChange=false,
         Ability         = self,
         vSpawnOrigin    = spawn_point,
         fDistance     = SETTING_FLY_SPEED*SETTING_FLY_TIME,
         fStartRadius    = 120,
         fEndRadius      = 120,
         
         
         Source        = caster,
         bHasFrontalCone   = false,
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
         followTarget    = target,
         damageAreaData = damageAreaData,
         effect = EFFECT_BURN,
         effect_chance = chance_to_burn*100,
         effect_time = burn_time,
         maxTarget = max_target,
         iVisionTeamNumber = caster:GetTeamNumber(), 
         UnitTest = GeneralUnitTest,
         OnUnitHit = function(proj, unit) 
         --unit:EmitSound(SETTING_HIT_SOUND)
           DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
             
             --print(proj.id.." Deal damage to "..unit:GetUnitName())
             DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_FIRE, {})
             StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
             --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
             --FxPoint()
             proj.damageAreaData.where = unit:GetOrigin()
             local pfx = ParticleManager:CreateParticle( SETTING_EXPLODE_EFFECT, PATTACH_ABSORIGIN, unit )
             ParticleManager:SetParticleControl( pfx, 1, Vector(200,200,0))
             ParticleManager:SetParticleControlEnt( pfx, 0, unit, PATTACH_POINT_FOLLOW, "follow_origin", unit:GetAbsOrigin(), true )
             ParticleManager:SetParticleControlEnt( pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
             ParticleManager:ReleaseParticleIndex(pfx)
            
             SoundPoint(SETTING_HIT_SOUND,proj.damageAreaData.where,0.5,proj.Source:GetTeam())
             DamageHandler:DamageArea(proj.damageAreaData)
             --print("destroying")
             proj:Destroy()
             
             
             end})
           end,
          OnFinish= function(proj,pos)
            --print(proj.id.." is Finishing")
            proj.damageAreaData.where = pos
            FxPoint(SETTING_EXPLODE_EFFECT_NO_TARGET,pos,0.5)
            
            
            
            SoundPoint(SETTING_HIT_SOUND,pos,0.5,proj.Source:GetTeam())
            DamageHandler:DamageArea(proj.damageAreaData)
            --print(proj.id.." is Finished")
          end})
      Track(projectile_group[i],target,0.25,SETTING_FLY_SPEED,0)
      --proj,target,delay,speed,difDistance
   end
   
end
