skill_manhan_thucphocchu = class({})
SETTING_SKILL_MODIFIER = "modifier_manhan_thucphocchu"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_manhan_thucphocchu:GetReturnResist()
  return 10+self:GetLevel()*5
end
function skill_manhan_thucphocchu:GetIntrinsicModifierName()
    return SETTING_SKILL_MODIFIER
end
