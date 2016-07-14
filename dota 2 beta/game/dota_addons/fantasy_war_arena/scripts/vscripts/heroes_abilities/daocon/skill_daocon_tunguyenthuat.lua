skill_daocon_tunguyenthuat = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_tunguyenthuat"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_tunguyenthuat:GetManaCost()
   return 25
end

function skill_daocon_tunguyenthuat:GetCooldown()
  return 30
end

function skill_daocon_tunguyenthuat:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_daocon_tunguyenthuat:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   --self:PayManaCost()
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=300})
end
