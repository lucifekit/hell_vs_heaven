skill_kiemdoan_doangiakhikiem = class({})

function skill_kiemdoan_doangiakhikiem:GetBasicDamage()
  return 0.02*self:GetLevel()
end

function skill_kiemdoan_doangiakhikiem:GetSlowInflictTime()
  return self:GetLevel()*16
end

function skill_kiemdoan_doangiakhikiem:GetBurnResistTime()
  return self:GetLevel()*24
end


function skill_kiemdoan_doangiakhikiem:OnUpgrade()
   local caster = self:GetCaster()
   UpgradeSkill(caster:GetPlayerID())
   -- MASTER TALENT
--local basic_damage = 0+0.02*skill_level
--local slow_time_increase = 0+16*skill_level
--local burn_time_reduce = 0+24*skill_level
end