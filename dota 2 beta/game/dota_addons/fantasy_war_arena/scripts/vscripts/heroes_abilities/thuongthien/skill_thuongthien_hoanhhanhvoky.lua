skill_thuongthien_hoanhhanhvoky = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_thuongthien_hoanhhanhvoky"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_thuongthien_hoanhhanhvoky:GetManaCost()
   return 25
end

function skill_thuongthien_hoanhhanhvoky:GetCooldown()
   return 37.5
end

function skill_thuongthien_hoanhhanhvoky:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1,atk_perseconds)   
   return true
end

function skill_thuongthien_hoanhhanhvoky:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   -- RAGE
local duration = 5+2*skill_level
   
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=duration})
   caster:RemoveModifierByName(EFFECT_SLOW)
   caster:RemoveModifierByName(EFFECT_STUN)
   caster:RemoveModifierByName(EFFECT_WEAK)
   caster:RemoveModifierByName(EFFECT_MAIM)
   
end
