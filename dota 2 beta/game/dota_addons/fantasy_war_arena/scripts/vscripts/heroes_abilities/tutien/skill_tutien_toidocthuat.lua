skill_tutien_toidocthuat = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_tutien_toidocthuat"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/tutien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_tutien_toidocthuat:GetPoisonDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 15+skill_level*6
end

function skill_tutien_toidocthuat:GetAmplifyPhysic()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.2+skill_level*0.07
end

function skill_tutien_toidocthuat:GetCriticalDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.25+skill_level*0.1
end

function skill_tutien_toidocthuat:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- ENVENOM
--local physical_amplify = 0.2+0.07*skill_level
--local poison = 15+6*skill_level
--local critical_damage = 0.25+0.1*skill_level
--local allies_critical_damage = 0.1+0.1*skill_level
  
end

