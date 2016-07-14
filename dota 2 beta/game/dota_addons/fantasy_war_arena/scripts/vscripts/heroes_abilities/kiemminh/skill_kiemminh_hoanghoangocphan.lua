skill_kiemminh_hoanghoangocphan = class({})

function skill_kiemminh_hoanghoangocphan:GetBasicDamage()
  return 0.02*self:GetLevel()
end

function skill_kiemminh_hoanghoangocphan:GetSkillAmplify()
  return 0.02*self:GetLevel()
end




function skill_kiemminh_hoanghoangocphan:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())

end