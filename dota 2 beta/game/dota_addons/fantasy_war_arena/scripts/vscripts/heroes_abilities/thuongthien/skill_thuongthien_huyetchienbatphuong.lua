skill_thuongthien_huyetchienbatphuong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_huyetchienbatphuong"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_thuongthien_huyetchienbatphuong:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_thuongthien_huyetchienbatphuong:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_thuongthien_huyetchienbatphuong:GetMaimInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_thuongthien_huyetchienbatphuong:GetWeakResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end


function skill_thuongthien_huyetchienbatphuong:OnUpgrade()
  local caster = self:GetCaster()
  --caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  --caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

