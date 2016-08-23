skill_kiemminh_thanhhoalenhphap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemminh_thanhhoalenhphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_kiemminh_thanhhoalenhphap:OnAbilityPhaseStart()
  self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1)
  return true
end

function skill_kiemminh_thanhhoalenhphap:GetCooldown()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30-3*skill_level
end


function skill_kiemminh_thanhhoalenhphap:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{duration = 3+skill_level})

  for i = 1,4 do
    caster:GetAbilityByIndex(i):EndCooldown()
  end

  caster:EmitSound("Hero_DeathProphet.Exorcism.Cast")
 end