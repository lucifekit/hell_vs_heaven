skill_kiemdoan_thiennambophap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_thiennambophap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_kiemdoan_thiennambophap:OnAbilityPhaseStart()
  self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1)
  return true
end

function skill_kiemdoan_thiennambophap:GetBurnResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 17*skill_level
end


function skill_kiemdoan_thiennambophap:OnSpellStart()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{duration = 120})
  caster:CalculateStatBonus()
  
    UpdatePlayerData(caster:GetPlayerID())
  
  
  
  
 end