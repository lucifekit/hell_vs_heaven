skill_chuongcai_traolongcong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chuongcai_traolongcong"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chuongcai/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_chuongcai_traolongcong:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- DRAGON BLOOD
--local paralyze_chance = 0.05+0.03*skill_level
--local paralyze_time = 1.5+0.2*skill_level
--local splash_damage = 0+0.1*skill_level
--local splash_damage_max = 0+0.2*skill_level
--local active_chance = 0.3+0.1*skill_level
--local active_resist = 0.2+0.08*skill_level
--local active_damage = 0+0.02*skill_level
--local active_drain = 0+0.02*skill_level
--local active_duration = math.floor(2.5+1.5*skill_level)
--local active_sixth_dragon_level = 0+1*skill_level
  
end

