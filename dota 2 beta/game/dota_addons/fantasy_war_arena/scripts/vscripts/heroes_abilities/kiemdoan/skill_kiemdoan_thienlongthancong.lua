skill_kiemdoan_thienlongthancong = class({})
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_thienlongthancong"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemdoan_thienlongthancong:GetSlowInflictChance()
  return 20+self:GetLevel()*8
end

function skill_kiemdoan_thienlongthancong:GetBurnResistChance()
  return 30+self:GetLevel()*12
end

function skill_kiemdoan_thienlongthancong:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end