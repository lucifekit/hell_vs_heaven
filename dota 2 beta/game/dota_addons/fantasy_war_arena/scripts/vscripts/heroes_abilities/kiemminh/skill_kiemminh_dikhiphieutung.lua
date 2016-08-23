skill_kiemminh_dikhiphieutung = class({})
require('kem_lib/kem')

function skill_kiemminh_dikhiphieutung:GetElementEvade()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*5 --250
end

function skill_kiemminh_dikhiphieutung:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())

end