skill_kiemcon_honnguyencankhon = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_kiemcon_honnguyencankhon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemcon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemcon_honnguyencankhon:GetBasicDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_kiemcon_honnguyencankhon:GetSkillAmplify()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*0.02
end
function skill_kiemcon_honnguyencankhon:GetStunInflictTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*16
end

function skill_kiemcon_honnguyencankhon:GetSlowResistTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*24
end

function skill_kiemcon_honnguyencankhon:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

