skill_aow_mehontieu_thienlytruyhon = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_thienlytruyhon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_aow_mehontieu_thienlytruyhon:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

