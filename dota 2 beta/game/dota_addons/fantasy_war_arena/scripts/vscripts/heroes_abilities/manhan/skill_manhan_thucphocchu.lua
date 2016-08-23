skill_manhan_thucphocchu = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_manhan_thucphocchu"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_manhan_thucphocchu:GetReturnResist()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*5
end
function skill_manhan_thucphocchu:GetIntrinsicModifierName()
    return SETTING_SKILL_MODIFIER
end
