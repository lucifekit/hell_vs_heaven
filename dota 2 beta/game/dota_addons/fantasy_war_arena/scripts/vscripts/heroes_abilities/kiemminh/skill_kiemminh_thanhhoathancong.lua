skill_kiemminh_thanhhoathancong = class({})
require('kem_lib/kem')

function skill_kiemminh_thanhhoathancong:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_kiemminh_thanhhoathancong:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_kiemminh_thanhhoathancong:GetWeakInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_kiemminh_thanhhoathancong:GetStunResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end


function skill_kiemminh_thanhhoathancong:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())

   -- MASTER TALENT
--local weak_time_increase = 0+16*skill_level
--local stun_time_reduce = 0+24*skill_level
--local basic_damage = 0+0.02*skill_level
   

end