skill_tutien_baovulehoa = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/tu_tien/bvlh.vpcf"
SETTING_EFFECT_2 = "particles/edited_particle/tu_tien/bvlh_no_moon.vpcf"
SETTING_EFFECT_2 = "particles/edited_particle/tu_tien/bvlh_2.vpcf"
SETTING_CAST_SOUND = "Hero_Spectre.DaggerCast"
SETTING_HIT_SOUND = "Hero_Shredder.TimberChain.Retract"
SETTING_POISON_TIME = 3
SETTING_POISON_PERIOD = 0.5
require('heroes_abilities/tutien/tutien')
--------------------------------------------------------------------------------
function skill_tutien_baovulehoa:GetManaCost()
   return 25
end

function skill_tutien_baovulehoa:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_tutien_baovulehoa:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_tutien_baovulehoa:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   DoanCanNhan(caster,target_point)
   --self:PayManaCost()
-- VOLLEY GLAIVE
local basic_damage = 0.28+0.015*skill_level
local poison_damage = 180+11*skill_level
local chance_to_maim = 0.2+0.01*skill_level
local maim_time = 1
local chance_to_weak = 0.1+0.02*skill_level
local weak_time = 2+0.1*skill_level
local max_target = 5
local volley_poison = 205+12*skill_level



   local damageData = {
      caster = caster,
      main_physic = caster.stat_tp, 
      skill_physical_damage_percent = 0,
      is_physic=true,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = 0,
      element_damage_max = 0
   }
   local damageInfo = DamageHandler:GetDamage(damageData)
   PrintTable(damageInfo)
   local critInfo = DamageHandler:GetCritInfo(caster)
   SoundPoint(SETTING_HIT_SOUND,target_point,1,caster:GetTeam())
   caster:EmitSound(SETTING_CAST_SOUND)
   Projectiles:CreateProjectile( {
       EffectName      = SETTING_EFFECT,
       Ability         = self,
       vSpawnOrigin    = target_point+Vector(0,0,100),
       fDistance     = 50,
       fStartRadius    = 100,
       fEndRadius      = 100,
       Source        = caster,
       bHasFrontalCone   = true,
       bReplaceExisting  = false,
       fExpireTime     = 1,--GameRules:GetGameTime() +100,--
       GroundBehavior = PROJECTILES_NOTHING,
       UnitBehavior  = PROJECTILES_NOTHING,
       vVelocity     = angleBetweenCasterAndTarget*2,--angleBetweenCasterAndTarget,
       bProvidesVision   = true,
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
          
          DamageHandler: ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_WOOD, {})
          PoisonHandler:ApplyPoison(proj.Source,unit,proj.Ability,proj.period,proj.duration,proj.poison,{})
          StatusEffectHandler: ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
          StatusEffectHandler: ApplyEffect(proj.Source, unit, EFFECT_WEAK,chance_to_weak*100, weak_time)
       end})
       end
    } )
    local tick = 2
    Timers:CreateTimer(0.4,function()
      if(tick>0)then
        --print("Create BVLH")
        local hit_group = {}
        for i = 1,8 do
          local tempAngle = RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*45))
          local spawn_point = target_point + 400*tempAngle+Vector(0,0,math.random(100,250))
          local vAngle = ((target_point+Vector(0,0,100))-spawn_point):Normalized()
          Projectiles:CreateProjectile( {
               EffectName      = SETTING_EFFECT_2,
               ControlPoints   = {[1]=target_point},
               Ability         = self,
               vSpawnOrigin    = spawn_point,
               fDistance     = 400,
               fStartRadius    = 100,
               fEndRadius      = 100,
               Source        = caster,
               BVLH_HIT      = tick,
               BVLH_NUMB     = i,
               bHasFrontalCone   = true,
               bReplaceExisting  = false,
               fExpireTime     = 0.5,--GameRules:GetGameTime() +100,--
               GroundBehavior = PROJECTILES_NOTHING,
               UnitBehavior  = PROJECTILES_NOTHING,
               vVelocity     = vAngle*800,--angleBetweenCasterAndTarget,
               bProvidesVision   = true,
               iVisionRadius   = 200,
               bCutTrees = true,
               damage = damageInfo,
               crit = critInfo,
               hit_group = hit_group,
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
                  --PrintTable(proj.hit_group)
                  if(proj.hit_group[unit]==nil)then
                    proj.hit_group[unit]=1
                    ---PrintTable(proj.hit_group)                    
                    --kemPrint("BVLH "..proj.BVLH_NUMB.." Hit "..proj.BVLH_HIT.." Count = "..#proj.hit_group)
                    DamageHandler: ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_WOOD, {})
                    PoisonHandler:ApplyPoison(proj.Source,unit,proj.Ability,proj.period,proj.duration,proj.poison,{})
                    StatusEffectHandler: ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
                    StatusEffectHandler: ApplyEffect(proj.Source, unit, EFFECT_WEAK,chance_to_weak*100, weak_time)
                  end
                  
               end})
               end
            } )
        
        end
      --2
      --1
      --
      
        tick = tick-1
        if(tick>0)then
          return 0.4
        end
      end
    end)
    
end
