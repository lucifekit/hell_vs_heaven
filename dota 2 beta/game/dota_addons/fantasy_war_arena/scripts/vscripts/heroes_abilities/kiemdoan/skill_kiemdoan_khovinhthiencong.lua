skill_kiemdoan_khovinhthiencong = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_khovinhthiencong"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemdoan_khovinhthiencong:GetElementDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*60
end

function skill_kiemdoan_khovinhthiencong:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end