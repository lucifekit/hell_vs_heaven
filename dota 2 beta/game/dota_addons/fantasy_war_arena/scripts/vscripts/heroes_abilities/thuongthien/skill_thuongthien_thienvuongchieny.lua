skill_thuongthien_thienvuongchieny = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_thuongthien_thienvuongchieny"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_thuongthien_thienvuongchieny:GetMaimInflictChance()

  return 10+self:GetLevel()*7
end

function skill_thuongthien_thienvuongchieny:GetAmplifyPhysic()

  return 0.1+self:GetLevel()*0.2
end

function skill_thuongthien_thienvuongchieny:GetCriticalChance()

  return 10+self:GetLevel()*4
end



function skill_thuongthien_thienvuongchieny:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster: CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  -- WAR AURA
--local physical_amplify = 0.1+0.2*skill_level
--local critical_chance = 10+4*skill_level
--local maim_chance = 10+7*skill_level
--local allies_physical_amplify = 0.1+0.05*skill_level
--local allies_critical_chance = 10+2*skill_level
--local allies_maim_chance = 10+3.5*skill_level
  
end

