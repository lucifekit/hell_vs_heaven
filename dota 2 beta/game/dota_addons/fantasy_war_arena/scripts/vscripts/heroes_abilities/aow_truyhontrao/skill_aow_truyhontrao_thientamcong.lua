skill_aow_truyhontrao_thientamcong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_thientamcong"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_aow_truyhontrao_thientamcong:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

