skill_aow_mehontieu_dutithoihon = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_dutithoihon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_defense","modifiers/modifier_defense", LUA_MODIFIER_MOTION_NONE )
function skill_aow_mehontieu_dutithoihon:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_aow_mehontieu_dutithoihon:GetCooldown()
   return 0.3
end

function skill_aow_mehontieu_dutithoihon:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_REFRACTION,atk_perseconds)
   --ACT_DOTA_CAST_REFRACTION = ne
   --ACT_DOTA_CAST_ABILITY_2 = cui xuong
   --ACT_DOTA_CAST_ABILITY_4 -- rut trap
   --ACT_DOTA_CAST_ABILITY_5 = dat trap
   return true
end

function skill_aow_mehontieu_dutithoihon:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=300} )
   caster:AddNewModifier(caster,self,"modifier_defense",{duration=0.5} )
   --self:PayManaCost()
end
