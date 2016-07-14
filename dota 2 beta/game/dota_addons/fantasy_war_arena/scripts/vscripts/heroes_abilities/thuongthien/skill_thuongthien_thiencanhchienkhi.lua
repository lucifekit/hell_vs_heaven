skill_thuongthien_thiencanhchienkhi = class({})
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_thiencanhchienkhi"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

--danh trung 100-50
--hoi phuc 20-5
--khang 150-10

function skill_thuongthien_thiencanhchienkhi:GetHpRegenPercentage()
  --10-80

  --kemPrint("get hp regen percentage")
  return 0.05+self:GetLevel()*0.015
end
function skill_thuongthien_thiencanhchienkhi:GetAccuracyChance()
  --kemPrint("Get accuracy chance",self)
  --kemPrint("get accuracy chance")
  return 0.5+self:GetLevel()*0.05
end
function skill_thuongthien_thiencanhchienkhi:GetWeakResistChance()
  --kemPrint("Get accuracy chance",self)
  --kemPrint("get weak resist chance")

  return 10+self:GetLevel()*14
end
function skill_thuongthien_thiencanhchienkhi:OnUpgrade()
  local caster = self:GetCaster()
  --caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  --caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

