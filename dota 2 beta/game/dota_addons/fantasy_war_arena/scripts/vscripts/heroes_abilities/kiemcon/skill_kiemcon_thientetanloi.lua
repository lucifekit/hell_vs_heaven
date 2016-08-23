skill_kiemcon_thientetanloi = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/kiem_con/thientetanloi.vpcf"
SETTING_EFFECT = "particles/edited_particle/kiem_con/thientetanloi_2.vpcf"
SETTING_FLY_TIME = 0.5 
SETTING_FLY_SPEED = 400 
SETTING_RADIUS = 400
SETTING_CAST_SOUND = "Hero_Sven.StormBolt"
SETTING_HIT_SOUND = "Hero_Leshrac.Lightning_Storm"
--------------------------------------------------------------------------------
function skill_kiemcon_thientetanloi:GetManaCost()
   return 25
end

function skill_kiemcon_thientetanloi:GetCooldown(nLevel)

   return 2
end

function skill_kiemcon_thientetanloi:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,atk_perseconds)
   return true
end

function skill_kiemcon_thientetanloi:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   
-- LIGHTNING RAIN
   local ldq_level = caster:FindAbilityByName("skill_kiemcon_loidinhquyet"):GetLevel()
local basic_damage = 0.45
    if(ldq_level>=1)then
      ldq_level=ldq_level+GetSkillLevel(caster)
      basic_damage = basic_damage+0.1+0.02*ldq_level
    end
local element_damage_min = 604+71*skill_level
local element_damage_max = 925+75*skill_level
local chance_to_stun = 0.15+0.025*skill_level
local stun_time = 1
local max_target = 3

   
   
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
   FxPointRelease(SETTING_EFFECT,target_point+Vector(0,0,800),{[1]=target_point})
   DamageHandler:DamageArea(damageAreaData)
   local tick = 3
   local damageUnitTable = {}
   Timers:CreateTimer(0.5,function()
      local startRad = math.random(0,72)
      caster:EmitSound(SETTING_HIT_SOUND)
      
      for i=1,5 do
        Timers:CreateTimer(i*0.05,function()
        
          local tempPoint = cast_point+math.random(100,300)*RotateVector2D(angleBetweenCasterAndTarget,math.rad(startRad+i*72))
          FxPointRelease(SETTING_EFFECT,tempPoint+Vector(0,0,1000),{[1]=tempPoint})
          damageAreaData.maxTarget = 2
          damageAreaData.radius = 128
          damageAreaData.where = tempPoint
          damageAreaData.damageUnitTable = damageUnitTable
          DamageHandler:DamageArea(damageAreaData)
        end)
      end
      if(tick>0)then
        tick=tick-1
        if(tick==1)then
          damageUnitTable={}
        end
        return 0.5
      end
   end)
   
   
end
