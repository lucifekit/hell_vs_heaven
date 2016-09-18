skill_aow_mehontieu_mehontieu_basic = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_mehontieu_basic"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_aow_mehontieu_mehontieu_basic:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.25+skill_level*0.3
end

function skill_aow_mehontieu_mehontieu_basic:GetAmplifyPhysic()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.15
end

function skill_aow_mehontieu_mehontieu_basic:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 20+skill_level*6
end


function skill_aow_mehontieu_mehontieu_basic:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- BASIC TALENT
--local accuracy_chance = 25+30*skill_level
--local attack_speed = 5+2*skill_level
--local physical_amplify = 0+15*skill_level
--local critical_chance = 20+6*skill_level
  
end

