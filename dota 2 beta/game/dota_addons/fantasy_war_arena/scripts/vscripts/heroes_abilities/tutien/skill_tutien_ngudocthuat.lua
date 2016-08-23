skill_tutien_ngudocthuat = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_tutien_ngudocthuat"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/tutien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_tutien_ngudocthuat:GetPoisonDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*20
end
function skill_tutien_ngudocthuat:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*4
end
function skill_tutien_ngudocthuat:GetStunResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 35+skill_level*10
end

function skill_tutien_ngudocthuat:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- MASTER POISON
--local poison_damage = 0+20*skill_level
--local critical_chance = 30+4*skill_level
--local stun_time_reduce = 35+10*skill_level
  
end

