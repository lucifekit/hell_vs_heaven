skill_aow_mehontieu_mehontieu_master = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_mehontieu_master"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_aow_mehontieu_mehontieu_master:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_aow_mehontieu_mehontieu_master:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_aow_mehontieu_mehontieu_master:GetWeakInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_aow_mehontieu_mehontieu_master:GetStunResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end



function skill_aow_mehontieu_mehontieu_master:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

