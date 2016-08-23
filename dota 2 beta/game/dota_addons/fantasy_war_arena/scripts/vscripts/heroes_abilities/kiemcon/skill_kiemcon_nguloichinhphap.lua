skill_kiemcon_nguloichinhphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_kiemcon_nguloichinhphap"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemcon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_kiemcon_nguloichinhphap:GetStunInflictChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*9
end

function skill_kiemcon_nguloichinhphap:GetSlowResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end


function skill_kiemcon_nguloichinhphap:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

