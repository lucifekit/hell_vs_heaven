skill_kiemminh_thanhhoathancong = class({})

function skill_kiemminh_thanhhoathancong:GetBasicDamage()
  return 0.02*self:GetLevel()
end

function skill_kiemminh_thanhhoathancong:GetWeakInflictTime()
  return self:GetLevel()*16
end

function skill_kiemminh_thanhhoathancong:GetStunResistTime()
  return self:GetLevel()*24
end


function skill_kiemminh_thanhhoathancong:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())

   -- MASTER TALENT
--local weak_time_increase = 0+16*skill_level
--local stun_time_reduce = 0+24*skill_level
--local basic_damage = 0+0.02*skill_level
   

end