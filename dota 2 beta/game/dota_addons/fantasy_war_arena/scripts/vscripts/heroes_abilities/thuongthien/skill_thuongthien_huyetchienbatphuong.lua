skill_thuongthien_huyetchienbatphuong = class({})
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_huyetchienbatphuong"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_thuongthien_huyetchienbatphuong:GetBasicDamage()
  return 0.02*self:GetLevel()
end

function skill_thuongthien_huyetchienbatphuong:GetMaimInflictTime()
  return self:GetLevel()*16
end

function skill_thuongthien_huyetchienbatphuong:GetWeakResistTime()
  return self:GetLevel()*24
end


function skill_thuongthien_huyetchienbatphuong:OnUpgrade()
  local caster = self:GetCaster()
  --caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  --caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

