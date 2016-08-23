skill_manhan_kimthienthoatxac = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_manhan_kimthienthoatxac"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_manhan_kimthienthoatxac:GetPhysicEvade()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*2 --250
end

function skill_manhan_kimthienthoatxac:GetMaimResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*17 --50
end
function skill_manhan_kimthienthoatxac:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
end