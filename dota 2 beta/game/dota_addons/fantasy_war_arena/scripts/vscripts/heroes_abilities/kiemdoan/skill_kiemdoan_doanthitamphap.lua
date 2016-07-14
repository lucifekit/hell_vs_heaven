skill_kiemdoan_doanthitamphap = class({})
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_doanthitamphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_kiemdoan_doanthitamphap:GetElementDamage()
  return self:GetLevel()*80
end

function skill_kiemdoan_doanthitamphap:GetCriticalChance()
  return self:GetLevel()*10
end
function skill_kiemdoan_doanthitamphap:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
end