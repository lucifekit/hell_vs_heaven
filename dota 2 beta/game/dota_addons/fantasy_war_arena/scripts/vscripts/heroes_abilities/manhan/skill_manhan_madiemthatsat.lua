skill_manhan_madiemthatsat = class({})

function skill_manhan_madiemthatsat:GetBasicDamage()
  return 0.02*self:GetLevel()
end

function skill_manhan_madiemthatsat:GetBurnInflictTime()
  return self:GetLevel()*16
end

function skill_manhan_madiemthatsat:GetMaimResistTime()
  return self:GetLevel()*24
end


function skill_manhan_madiemthatsat:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())
   -- MASTER TALENT
--local basic_damage = 0+0.02*skill_level
--local burn_time_increase = 0+16*skill_level
--local maim_time_reduce = 0+24*skill_level
   
end