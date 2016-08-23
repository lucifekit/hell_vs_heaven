skill_kiemcon_nguynguyconlon = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_kiemcon_nguynguyconlon"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemcon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_kiemcon_nguynguyconlon:OnUpgrade()
  local caster = self:GetCaster()
  
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  self:UpdateSkill()
  --print("Need edit Nguy nguy con lon stack count +level!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
  -- LIGHTNING MASTERY
--local cooldown_reduce = 0+0.2*skill_level
--local stack_duration = 3
--local max_stack = 2+1*skill_level
--local critical_per_stack = 0+12*skill_level
--local damage_reduce_per_stack = 0+0.01*skill_level
  
end

function skill_kiemcon_nguynguyconlon:UpdateSkill()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  local nncl_modifier  =caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  nncl_modifier:SetStackCount(skill_level)
  
end