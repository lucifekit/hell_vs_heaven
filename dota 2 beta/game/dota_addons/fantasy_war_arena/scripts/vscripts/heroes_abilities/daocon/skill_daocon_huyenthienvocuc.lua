skill_daocon_huyenthienvocuc = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_huyenthienvocuc"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_huyenthienvocuc:GetReturnResist()
  return 10+7*self:GetLevel()
end
function skill_daocon_huyenthienvocuc:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- TEMPEST AURA
--local damage_negate = 0.4
--local damage_negate_max = 0.015+0.005*skill_level
--local reflect_damage_resist = 0.1+0.07*skill_level
  
end

