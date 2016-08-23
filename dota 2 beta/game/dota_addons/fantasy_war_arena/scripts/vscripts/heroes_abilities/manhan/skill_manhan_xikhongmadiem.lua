skill_manhan_xikhongmadiem = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_manhan_xikhongmadiem"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_manhan_xikhongmadiem:GetBurnInflictChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*12
end

function skill_manhan_xikhongmadiem:GetMaimResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*12
end

function skill_manhan_xikhongmadiem:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- EXPERT TALENT
--local attack_speed = 0.11+0.015*skill_level
--local burn_chance_increase = 30+12*skill_level
--local maim_chance_reduce = 30+12*skill_level
  
end