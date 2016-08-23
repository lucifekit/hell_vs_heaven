skill_kiemdoan_bacminhthancong = class({})
require('kem_lib/kem')

SETTING_SKILL_MODIFIER = "modifier_kiemdoan_bacminhthancong"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemdoan_bacminhthancong:GetParalizeResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*200
end

function skill_kiemdoan_bacminhthancong:GetFearResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*200
end

function skill_kiemdoan_bacminhthancong:GetKnockbackResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*200
end


function skill_kiemdoan_bacminhthancong:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
   -- RELIEF AURA
--local paralize_resist_chance = 0+200*skill_level
--local fear_resist_chance = 0+200*skill_level
--local knockback_resist_chance = 0+200*skill_level
--local damage_negate = 0.3
--local damage_negate_max_based_on_hp = 0.005+0.005*skill_level
   
end