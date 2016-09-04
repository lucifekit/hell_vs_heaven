skill_chuongcai_tiemlongtaiuyen = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_tiemlongtaiuyen"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_chuongcai_tiemlongtaiuyen:GetBurnInflictChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*9
end

function skill_chuongcai_tiemlongtaiuyen:GetMaimResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end

function skill_chuongcai_tiemlongtaiuyen:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- EXPERT TALENT
--local attack_speed = math.floor(10+1.6*skill_level)
--local burn_chance_increase = 10+9*skill_level
--local maim_chance_reduce = 10+14*skill_level
  
end

