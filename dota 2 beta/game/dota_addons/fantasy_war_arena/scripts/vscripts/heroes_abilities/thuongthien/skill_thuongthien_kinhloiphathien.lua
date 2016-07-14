skill_thuongthien_kinhloiphathien = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_thuongthien_kinhloiphathien"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_thuongthien_kinhloiphathien:GetCriticalChance()

  if(self:GetCaster():HasModifier("modifier_thuongthien_kinhloiphathien_critical"))then
    return 40+40*self:GetLevel()
  end
  return 0
end

function skill_thuongthien_kinhloiphathien:GetMaimInflictChance()

  if(self:GetCaster():HasModifier("modifier_thuongthien_kinhloiphathien_critical"))then
    return 40+8*self:GetLevel()
  end
  return 0
end

function skill_thuongthien_kinhloiphathien:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
-- DANGER ZONE
--local invulnerable_duration = 0.83+0.334*skill_level
--local critical_chance = 40+40*skill_level
--local maim_chance = 40+8*skill_level
--local buff_duration = 15
--local cooldown = 30
end

