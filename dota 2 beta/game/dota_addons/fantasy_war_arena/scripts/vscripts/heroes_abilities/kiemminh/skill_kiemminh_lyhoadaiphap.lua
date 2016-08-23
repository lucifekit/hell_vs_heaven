skill_kiemminh_lyhoadaiphap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemminh_lyhoadaiphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemminh_lyhoadaiphap:GetWeakInflictChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 20+skill_level*8
end

function skill_kiemminh_lyhoadaiphap:GetStunResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 30+skill_level*12
end

function skill_kiemminh_lyhoadaiphap:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())

  -- EXPERT TALENT
--local weak_chance_increase = 20+8*skill_level
--local stun_chance_reduce = 30+12*skill_level
--local attack_speed = math.floor(10+1.6*skill_level)

end