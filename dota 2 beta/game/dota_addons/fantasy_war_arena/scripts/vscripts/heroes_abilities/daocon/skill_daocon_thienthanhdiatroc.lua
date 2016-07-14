skill_daocon_thienthanhdiatroc = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_thienthanhdiatroc"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_thienthanhdiatroc:GetStunInflictChance()
  return 20+self:GetLevel()*8
end

function skill_daocon_thienthanhdiatroc:GetSlowResistChance()
  return 30+self:GetLevel()*12
end
function skill_daocon_thienthanhdiatroc:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  
  UpgradeSkill(caster:GetPlayerID())
end

