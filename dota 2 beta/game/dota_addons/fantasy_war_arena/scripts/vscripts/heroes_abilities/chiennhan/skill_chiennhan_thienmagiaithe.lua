skill_chiennhan_thienmagiaithe = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chiennhan_thienmagiaithe"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_chiennhan_thienmagiaithe:GetMaimInflictChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*9
end

function skill_chiennhan_thienmagiaithe:GetMaimResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end
function skill_chiennhan_thienmagiaithe:GetStunResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end
function skill_chiennhan_thienmagiaithe:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  --local maim_chance_increase = 10+9*skill_level
--local maim_chance_resist = 10+14*skill_level
--local stun_chance_resist = 10+14*skill_level
end

