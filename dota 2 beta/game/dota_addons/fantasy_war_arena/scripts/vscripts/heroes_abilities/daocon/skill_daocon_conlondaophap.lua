skill_daocon_conlondaophap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_conlondaophap"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_conlondaophap:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.5+skill_level*0.2
end

function skill_daocon_conlondaophap:GetAmplifyPhysic()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)

  return 0.05+skill_level*0.2
end

function skill_daocon_conlondaophap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)

  return 25+skill_level*5
end
function skill_daocon_conlondaophap:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()

  UpgradeSkill(caster:GetPlayerID())
end

