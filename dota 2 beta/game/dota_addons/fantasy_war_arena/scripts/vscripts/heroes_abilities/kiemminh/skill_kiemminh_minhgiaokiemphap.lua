skill_kiemminh_minhgiaokiemphap = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER = "modifier_kiemminh_minhgiaokiemphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_kiemminh_minhgiaokiemphap:GetPoisonDamage()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*20
end

function skill_kiemminh_minhgiaokiemphap:GetCriticalChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*10 --50
end
function skill_kiemminh_minhgiaokiemphap:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())

   -- BASIC TALENT
--local poison_damage = 0+20*skill_level
--local critical_chance = 0+10*skill_level
--local attack_speed = 5+2*skill_level
   

end