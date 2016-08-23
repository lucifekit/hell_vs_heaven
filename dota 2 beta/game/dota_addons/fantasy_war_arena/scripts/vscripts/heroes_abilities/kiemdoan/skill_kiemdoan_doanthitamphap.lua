skill_kiemdoan_doanthitamphap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_doanthitamphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_kiemdoan_doanthitamphap:GetElementDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*80
end

function skill_kiemdoan_doanthitamphap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*10
end
function skill_kiemdoan_doanthitamphap:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
end