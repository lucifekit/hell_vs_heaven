skill_daocon_thanhphongphu = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_thanhphongphu"
SETTING_RADIUS = 200
SETTING_DURATION = 300
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_thanhphongphu:GetManaCost()
   return 25
end

function skill_daocon_thanhphongphu:GetCooldown()
   return 15
end
function skill_daocon_thanhphongphu:GetSlowResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*2.5
end
function skill_daocon_thanhphongphu:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_daocon_thanhphongphu:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
  caster:EmitSound("DOTA_Item.Mjollnir.Activate")
  caster:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DURATION } )
  BuffAllies(caster,self,SETTING_SKILL_MODIFIER,SETTING_DURATION,target_point,SETTING_RADIUS)
end
