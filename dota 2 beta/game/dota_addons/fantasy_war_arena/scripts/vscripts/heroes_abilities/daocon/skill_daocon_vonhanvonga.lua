skill_daocon_vonhanvonga = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_vonhanvonga"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_vonhanvonga:GetByPassEvade()
  return 50+self:GetLevel()*10
end

function skill_daocon_vonhanvonga:GetStunResistTime()
  return 60+self:GetLevel()*5
end

function skill_daocon_vonhanvonga:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

