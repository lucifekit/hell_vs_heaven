skill_chuongcai_thoithualuclong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_thoithualuclong"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_chuongcai_thoithualuclong:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_chuongcai_thoithualuclong:GetCooldown()
  local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   return 60-6*skill_level
end

function skill_chuongcai_thoithualuclong:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end
function skill_chuongcai_thoithualuclong:OnUpgrade()
  local caster = self:GetCaster()
  print("Add modifier thoi thua luc long")
  caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{})
end
function skill_chuongcai_thoithualuclong:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   local modifier = caster:FindModifierByName(SETTING_SKILL_MODIFIER)
   if(modifier)then
    modifier:Apply()
   end
   
   --self:PayManaCost()
end
