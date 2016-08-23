skill_chiennhan_maviemtaithien = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------

function skill_chiennhan_maviemtaithien:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end

function skill_chiennhan_maviemtaithien:GetBurnInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_chiennhan_maviemtaithien:GetMaimResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end


function skill_chiennhan_maviemtaithien:OnUpgrade()
  local caster = self:GetCaster()
  UpgradeSkill(caster:GetPlayerID())
  -- MASTER TALENT
--local basic_damage = 0+0.02*skill_level
--local burn_time_increase = 0+16*skill_level
--local maim_time_reduce = 0+24*skill_level
  
end

