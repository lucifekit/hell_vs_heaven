skill_chiennhan_thiennhanthuongphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chiennhan_thiennhanthuongphap"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_chiennhan_thiennhanthuongphap:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.5+skill_level*0.2
end

function skill_chiennhan_thiennhanthuongphap:GetAmplifyPhysic()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.05+skill_level*0.25
end

function skill_chiennhan_thiennhanthuongphap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*4
end
function skill_chiennhan_thiennhanthuongphap:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- BASIC TALENT
--local attack_speed = 10+5*skill_level
--local accuracy_chance = 0.5+0.2*skill_level
--local physical_amplify = 0.05+0.25*skill_level
--local critical_chance = 30+4*skill_level
  
end

