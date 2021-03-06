skill_kiemminh_phieuducthanphap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemminh_phieuducthanphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )




function skill_kiemminh_phieuducthanphap:GetStunResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return math.ceil(skill_level*13.5)
end

function skill_kiemminh_phieuducthanphap:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())

  -- GHOST FORM
--local movement_speed = 20+6*skill_level
--local stun_time_reduce = math.floor(0+13.5*skill_level)

end