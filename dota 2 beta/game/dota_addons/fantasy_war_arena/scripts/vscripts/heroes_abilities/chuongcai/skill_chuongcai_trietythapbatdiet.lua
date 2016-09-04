skill_chuongcai_trietythapbatdiet = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_trietythapbatdiet"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_chuongcai_trietythapbatdiet:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

