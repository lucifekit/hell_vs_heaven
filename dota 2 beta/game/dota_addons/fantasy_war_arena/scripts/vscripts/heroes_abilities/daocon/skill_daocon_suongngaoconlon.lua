skill_daocon_suongngaoconlon = class({})
SETTING_SKILL_MODIFIER = "modifier_daocon_suongngaoconlon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function skill_daocon_suongngaoconlon:GetBasicDamage()
  return 0.02*self:GetLevel()
end

function skill_daocon_suongngaoconlon:GetStunInflictTime()
  return self:GetLevel()*16
end

function skill_daocon_suongngaoconlon:GetSlowResistTime()
  return self:GetLevel()*24
end
function skill_daocon_suongngaoconlon:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  UpgradeSkill(caster:GetPlayerID())
end

