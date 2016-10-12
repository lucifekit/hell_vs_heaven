skill_aow_truyhontrao_truyhontrao_basic = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_truyhontrao_basic"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_aow_truyhontrao_truyhontrao_basic:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.5+skill_level*0.2
end

function skill_aow_truyhontrao_truyhontrao_basic:GetAmplifyPhysic()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.05+skill_level*0.15
end

function skill_aow_truyhontrao_truyhontrao_basic:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 20+skill_level*6
end


function skill_aow_truyhontrao_truyhontrao_basic:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

