skill_daocon_suongngaoconlon = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_daocon_suongngaoconlon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function skill_daocon_suongngaoconlon:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end

function skill_daocon_suongngaoconlon:GetStunInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_daocon_suongngaoconlon:GetSlowResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end
function skill_daocon_suongngaoconlon:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  UpgradeSkill(caster:GetPlayerID())
end

