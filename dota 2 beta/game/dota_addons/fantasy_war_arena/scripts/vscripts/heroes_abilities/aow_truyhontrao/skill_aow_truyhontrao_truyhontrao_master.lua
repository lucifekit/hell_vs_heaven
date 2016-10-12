skill_aow_truyhontrao_truyhontrao_master = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_truyhontrao_master"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_aow_truyhontrao_truyhontrao_master:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_aow_truyhontrao_truyhontrao_master:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_aow_truyhontrao_truyhontrao_master:GetMaimInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 5+skill_level*15
end

function skill_aow_truyhontrao_truyhontrao_master:GetWeakResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end

function skill_aow_truyhontrao_truyhontrao_master:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

