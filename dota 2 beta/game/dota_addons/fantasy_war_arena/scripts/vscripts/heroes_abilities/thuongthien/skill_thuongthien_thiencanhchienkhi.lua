skill_thuongthien_thiencanhchienkhi = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_thiencanhchienkhi"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

--danh trung 100-50
--hoi phuc 20-5
--khang 150-10

function skill_thuongthien_thiencanhchienkhi:GetHpRegenPercentage()
  --10-80

  --kemPrint("get hp regen percentage")
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.05+skill_level*0.015
end
function skill_thuongthien_thiencanhchienkhi:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.5+skill_level*0.05
end
function skill_thuongthien_thiencanhchienkhi:GetWeakResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end
function skill_thuongthien_thiencanhchienkhi:OnUpgrade()
  local caster = self:GetCaster()
  --caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  --caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

