skill_doanchi_langbavibo = class({})
SETTING_SKILL_MODIFIER = "modifier_doanchi_langbavibo"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/doanchi/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_doanchi_langbavibo:OnSpellStart()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{duration = 20})
  caster:CalculateStatBonus()
 end