skill_kiemdoan_thienlongthancong = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_thienlongthancong"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemdoan_thienlongthancong:GetSlowInflictChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 20+skill_level*8
end

function skill_kiemdoan_thienlongthancong:GetBurnResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*12
end

function skill_kiemdoan_thienlongthancong:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end