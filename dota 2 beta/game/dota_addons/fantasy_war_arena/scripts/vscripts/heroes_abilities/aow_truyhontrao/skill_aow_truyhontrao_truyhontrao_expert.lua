skill_aow_truyhontrao_truyhontrao_expert = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_truyhontrao_expert"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_aow_truyhontrao_truyhontrao_expert:GetMaimInflictChance()
  --10-80
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end
function skill_aow_truyhontrao_truyhontrao_expert:GetAccuracyChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 0.5+skill_level*0.05
end
function skill_aow_truyhontrao_truyhontrao_expert:GetWeakResistChance()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 10+skill_level*14
end


function skill_aow_truyhontrao_truyhontrao_expert:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- EXPERT TALENT
--local maim_chance_increase = 10+14*skill_level
--local accuracy_chance = 0.5+0.05*skill_level
--local weak_chance_resist = 10+14*skill_level
  
end

