skill_chiennhan_huyenanhtruyhonthuong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chiennhan_huyenanhtruyhonthuong"
SETTING_EFFECT = "particles/edited_particle/chien_nhan/hatht.vpcf"
--SETTING_EFFECT = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
SETTING_PULL_EFFECT = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
SETTING_FLY_TIME = 0.5
SETTING_FLY_SPEED = 2000
SETTING_CAST_SOUND = "Hero_Abaddon.DeathCoil.Cast"
SETTING_HIT_SOUND = "Hero_Abaddon.DeathCoil.Target"
SETTING_STACK_MODIFIER = "modifier_chiennhan_huyenanhtruyhonthuong_stack"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_SKILL_MODIFIER_3X = "modifier_chiennhan_huyenanhtruyhonthuong_stack"
LinkLuaModifier(SETTING_SKILL_MODIFIER_3X,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER_3X, LUA_MODIFIER_MOTION_NONE )
function skill_chiennhan_huyenanhtruyhonthuong:GetManaCost()
     return 0
end
function skill_chiennhan_huyenanhtruyhonthuong:GetReplenishTime()
  return 10
end
  
function skill_chiennhan_huyenanhtruyhonthuong:OnUpgrade()
  if(self:GetLevel()==1)then
    self:EndCooldown()
  end
  local caster = self:GetCaster()
  local vlth_abi = caster:FindAbilityByName("skill_chiennhan_vanlongtamhien")
  local skill_level = vlth_abi:GetLevel()
  
  local drag_remain = self:GetCooldownTimeRemaining()
  if(skill_level>0)then
    skill_level=skill_level+GetSkillLevel(caster)
    local stack_dragoff_to_hell = math.floor(2+0.2*skill_level)    
    caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER_3X,{max_count = stack_dragoff_to_hell,start_count = 1,replenish_time = self:GetReplenishTime()})
  else
    caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER_3X,{max_count = 1,start_count = 1,replenish_time = self:GetReplenishTime()})
  end
  
   
end


function skill_chiennhan_huyenanhtruyhonthuong:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1,atk_perseconds)
   return true
end

function skill_chiennhan_huyenanhtruyhonthuong:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point-caster_position):Normalized()
   --self:PayManaCost()
   
   -- DRAGGED OFF TO HELL
local pull_chance = 0.25+0.15*skill_level
local speed_reduce = 0.05+0.05*skill_level
local speed_reduce_time = 1.5+0.5*skill_level
   local vector1 = angleBetweenCasterAndTarget*1200
   local vector13 = Vector(1,1,1)
   --print("Set 43")
--   local pfx = ParticleManager:CreateParticle(SETTING_PULL_EFFECT, PATTACH_CUSTOMORIGIN, nil)
--   ParticleManager:SetParticleControl( pfx, 0, caster_position+Vector(0,200,50))
--   ParticleManager:SetParticleControl( pfx,1, caster_position+angleBetweenCasterAndTarget*SETTING_FLY_SPEED/SETTING_FLY_TIME+Vector(0,200,50))
--   ParticleManager:SetParticleControl( pfx,13,Vector(1,1,1))
--   ParticleManager:ReleaseParticleIndex(pfx)

   caster:EmitSound(SETTING_CAST_SOUND)
   Projectiles:CreateProjectile( {
        EffectName      = SETTING_EFFECT,
        ControlPoints   = {[5]=Vector(0.5,0.5,0.5)},
        Ability         = self,
        vSpawnOrigin    = caster_position+Vector(0,0,50),
        fDistance     = 1200,
        fStartRadius    = 96,
        fEndRadius      = 96,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = 2,--GameRules:GetGameTime() +100,--
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        maxTarget = 1,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          --unit:EmitSound(SETTING_HIT_SOUND)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            unit:EmitSound(SETTING_HIT_SOUND)
            local dragDistance = (unit:GetAbsOrigin()-proj.Source:GetAbsOrigin()):Length2D()
            StatusEffectHandler:KnockBack(proj.Source,unit:GetAbsOrigin()+proj.vVelocity,unit,pull_chance*100,0.5,dragDistance)
            unit:AddNewModifier(proj.Source,proj.Ability,SETTING_SKILL_MODIFIER,{duration=speed_reduce_time*10})
            local pfx = ParticleManager:CreateParticle(SETTING_PULL_EFFECT, PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl( pfx, 0, unit:GetOrigin()+Vector(0,0,50))
            local angleBetweenTargetAndCaster = (proj.Source:GetOrigin()-unit:GetOrigin()):Normalized()
            local distanceBetweenTargetAndCaster = (proj.Source:GetOrigin()-unit:GetOrigin()):Length2D()
            ParticleManager:SetParticleControl( pfx,1, unit:GetOrigin()+angleBetweenTargetAndCaster*distanceBetweenTargetAndCaster+Vector(0,0,50))
            ParticleManager:SetParticleControl( pfx,13,Vector(1,1,1))
            ParticleManager:ReleaseParticleIndex(pfx)
            proj:Destroy()
          end})
          
        end
        
      } )
end
