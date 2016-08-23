skill_thuongthien_kinhloiphathien = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_thuongthien_kinhloiphathien"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_thuongthien_kinhloiphathien:GetCriticalChance()

  if(self:GetCaster():HasModifier("modifier_thuongthien_kinhloiphathien_critical"))then
    local caster = self:GetCaster()
    local skill_level = self:GetLevel()+GetSkillLevel(caster)
    print("NEED EDIT KINHLOIPHATHIEN!!!!!!!!!!!!!!!!")
    return 40+skill_level*40
  end
  return 0
end

function skill_thuongthien_kinhloiphathien:GetMaimInflictChance()

  if(self:GetCaster():HasModifier("modifier_thuongthien_kinhloiphathien_critical"))then
    local caster = self:GetCaster()
    local skill_level = self:GetLevel()+GetSkillLevel(caster)
    print("NEED EDIT KINHLOIPHATHIEN!!!!!!!!!!!!!!!!")
    return 40+skill_level*8
  end
  return 0
end

function skill_thuongthien_kinhloiphathien:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
-- DANGER ZONE
--local invulnerable_duration = 0.83+0.334*skill_level
--local critical_chance = 40+40*skill_level
--local maim_chance = 40+8*skill_level
--local buff_duration = 15
--local cooldown = 30
end

