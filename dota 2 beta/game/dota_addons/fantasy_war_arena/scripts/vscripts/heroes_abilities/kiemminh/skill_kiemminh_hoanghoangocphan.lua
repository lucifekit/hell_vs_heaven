skill_kiemminh_hoanghoangocphan = class({})
require('kem_lib/kem')

function skill_kiemminh_hoanghoangocphan:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end

function skill_kiemminh_hoanghoangocphan:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end




function skill_kiemminh_hoanghoangocphan:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())
end