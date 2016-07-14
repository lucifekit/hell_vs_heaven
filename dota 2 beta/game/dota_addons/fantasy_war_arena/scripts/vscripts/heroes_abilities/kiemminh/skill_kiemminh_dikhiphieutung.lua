skill_kiemminh_dikhiphieutung = class({})

function skill_kiemminh_dikhiphieutung:GetElementEvade()
  return self:GetLevel()*5 --250
end

function skill_kiemminh_dikhiphieutung:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())

end