skill_manhan_xikhongmadiem = class({})
SETTING_SKILL_MODIFIER = "modifier_manhan_xikhongmadiem"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_manhan_xikhongmadiem:GetBurnInflictChance()
  return 30+self:GetLevel()*12
end

function skill_manhan_xikhongmadiem:GetMaimResistChance()
  return 30+self:GetLevel()*12
end

function skill_manhan_xikhongmadiem:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- EXPERT TALENT
--local attack_speed = 0.11+0.015*skill_level
--local burn_chance_increase = 30+12*skill_level
--local maim_chance_reduce = 30+12*skill_level
  
end