skill_thuongthien_thienvuongthuongphap = class({})
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_thienvuongthuongphap"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--50-135% 85/10
--vat cong 5-165% 160/9 =18
--chi mang 30-50
function skill_thuongthien_thienvuongthuongphap:GetAccuracyChance()

  return 0.5+self:GetLevel()*0.17
end

function skill_thuongthien_thienvuongthuongphap:GetAmplifyPhysic()

  return 0.04+self:GetLevel()*0.18
end

function skill_thuongthien_thienvuongthuongphap:GetCriticalChance()

  return 26+self:GetLevel()*4
end

function skill_thuongthien_thienvuongthuongphap:OnUpgrade()
  local caster = self:GetCaster()
  --caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  --caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

