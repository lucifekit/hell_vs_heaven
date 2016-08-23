skill_thuongthien_thienvuongthuongphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_thienvuongthuongphap"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--50-135% 85/10
--vat cong 5-165% 160/9 =18
--chi mang 30-50
function skill_thuongthien_thienvuongthuongphap:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.5+skill_level*0.17
end

function skill_thuongthien_thienvuongthuongphap:GetAmplifyPhysic()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.04+skill_level*0.18
end

function skill_thuongthien_thienvuongthuongphap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 26+skill_level*4
end

function skill_thuongthien_thienvuongthuongphap:OnUpgrade()
  local caster = self:GetCaster()
  --caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  --caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

