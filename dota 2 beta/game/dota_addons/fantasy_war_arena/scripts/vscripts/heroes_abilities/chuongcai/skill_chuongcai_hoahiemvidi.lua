skill_chuongcai_hoahiemvidi = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_hoahiemvidi"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_chuongcai_hoahiemvidi:GetEvade()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 50+skill_level*60
end

function skill_chuongcai_hoahiemvidi:GetReturnResist()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*5
end
function skill_chuongcai_hoahiemvidi:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
--      "01"
--    {
--      "var_type"  "FIELD_INTEGER"
--      "return_short_range_damage"  "10 15 20 25 30"
--    }
--    "02"
--    {
--      "var_type"  "FIELD_INTEGER"
--      "resist_return_damage"  "14 18 22 26 30"
--    }
--    "03"
--    {
--      "var_type"  "FIELD_INTEGER"
--      "evade"  "110 170 230 290 350"
end

