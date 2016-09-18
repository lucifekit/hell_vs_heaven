skill_aow_mehontieu_thienlytruyhon = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_thienlytruyhon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_aow_mehontieu_thienlytruyhon:GetCriticalDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.1+skill_level*0.1
end


function skill_aow_mehontieu_thienlytruyhon:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  -- [IT] SIX DIRECTIONS
--local critical_damage = 0.1+0.1*skill_level
--local dexterity_multiple = 0+0.03*skill_level
  UpgradeSkill(caster:GetPlayerID())
end

