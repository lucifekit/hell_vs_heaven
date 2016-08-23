skill_tutien_doancannhan = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
require('heroes_abilities/tutien/tutien')
SETTING_SKILL_MODIFIER = "modifier_tutien_doancannhan"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/tutien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_tutien_doancannhan:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end
function skill_tutien_doancannhan:GetCooldown()
  return 20
end
function skill_tutien_doancannhan:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_tutien_doancannhan:OnSpellStart()
   CastDoanCanNhan(self:GetCaster(),self:GetCursorPosition())
end