skill_daocon_nhatkhitamthanh = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_nhatkhitamthanh"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_nhatkhitamthanh:GetAccuracyChance()
  return 0.2+self:GetLevel()*0.08
end

function skill_daocon_nhatkhitamthanh:GetAmplifyPhysic()
  return 0.4+self:GetLevel()*0.16
end

function skill_daocon_nhatkhitamthanh:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

