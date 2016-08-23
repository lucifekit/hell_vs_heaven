skill_manhan_thiennhandaophap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_manhan_thiennhandaophap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_manhan_thiennhandaophap:GetElementDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*50
end

function skill_manhan_thiennhandaophap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*10
end
function skill_manhan_thiennhandaophap:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
   -- BASIC TALENT
--local attack_speed = 5+2*skill_level
--local element_damage = 0+50*skill_level
--local critical_chance = 0+10*skill_level
   
end