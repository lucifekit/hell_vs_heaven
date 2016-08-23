skill_tutien_thattuyetsatquang = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_tutien_thattuyetsatquang"
SETTING_INTERVAL = 30
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/tutien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_tutien_thattuyetsatquang:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

