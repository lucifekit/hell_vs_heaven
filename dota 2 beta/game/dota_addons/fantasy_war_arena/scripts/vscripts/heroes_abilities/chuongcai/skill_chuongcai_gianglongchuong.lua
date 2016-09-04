skill_chuongcai_gianglongchuong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_gianglongchuong"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_chuongcai_gianglongchuong:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_chuongcai_gianglongchuong:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_chuongcai_gianglongchuong:GetBurnInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_chuongcai_gianglongchuong:GetMaimResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end


function skill_chuongcai_gianglongchuong:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- MASTER TALENT
--local basic_damage = 0+0.02*skill_level
--local burn_time_increase = 0+16*skill_level
--local maim_time_reduce = 0+24*skill_level
  
end

