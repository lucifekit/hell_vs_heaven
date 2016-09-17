skill_aow_mehontieu_truyhondoatmenh = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_truyhondoatmenh"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_aow_mehontieu_truyhondoatmenh:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_aow_mehontieu_truyhondoatmenh:GetCooldown()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 60-3*skill_level
end

function skill_aow_mehontieu_truyhondoatmenh:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_REFRACTION,atk_perseconds)
   return true
end

function skill_aow_mehontieu_truyhondoatmenh:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   caster:EmitSound("Hero_TemplarAssassin.Refraction")
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=20} ):SetStackCount(10)
   --self:PayManaCost()
end
