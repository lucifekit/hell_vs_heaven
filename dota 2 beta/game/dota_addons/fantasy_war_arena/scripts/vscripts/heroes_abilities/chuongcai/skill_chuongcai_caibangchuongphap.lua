skill_chuongcai_caibangchuongphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_caibangchuongphap"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_chuongcai_caibangchuongphap:GetElementDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*115-40
end

function skill_chuongcai_caibangchuongphap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*4
end
function skill_chuongcai_caibangchuongphap:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  print("chuong cai upgrade skill")
  UpgradeSkill(caster:GetPlayerID())
  -- BASIC TALENT
--local attack_speed = 10+1*skill_level
--local element_damage = -40+115*skill_level
--local critical_chance = 30+4*skill_level
  
end

