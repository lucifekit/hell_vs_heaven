skill_aow_truyhontrao_daimaccohon = class({})
require('kem_lib/kem')
SETTING_CAST_SOUND = ""
SETTING_MAX_TICK = 7
SETTING_TICK_TIME = 0.25
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_daimaccohon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER,LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function skill_aow_truyhontrao_daimaccohon:GetManaCost()
   return 0
end

function skill_aow_truyhontrao_daimaccohon:GetCooldown()
   return 999   
end
function skill_aow_truyhontrao_daimaccohon:IsAngryAbility()
   return true
end

function skill_aow_truyhontrao_daimaccohon:OnUpgrade()
  self:StartCooldown(999)
end
function skill_aow_truyhontrao_daimaccohon:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()

   
   caster:EmitSound(SETTING_CAST_SOUND)
   local modifier_duration = SETTING_TICK_TIME*SETTING_MAX_TICK
   print("add modifier blade dance "..modifier_duration)
   
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{
    duration=modifier_duration,
    tick_time=SETTING_TICK_TIME,
    max_tick=SETTING_MAX_TICK,
    angleX=angleBetweenCasterAndTarget.x,
    angleY=angleBetweenCasterAndTarget.y,
    angleZ=angleBetweenCasterAndTarget.z})
end