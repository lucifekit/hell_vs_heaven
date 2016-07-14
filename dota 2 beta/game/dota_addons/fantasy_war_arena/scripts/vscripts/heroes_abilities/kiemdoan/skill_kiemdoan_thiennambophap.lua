skill_kiemdoan_thiennambophap = class({})
SETTING_SKILL_MODIFIER = "modifier_kiemdoan_thiennambophap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_kiemdoan_thiennambophap:OnAbilityPhaseStart()
  self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1)
  return true
end

function skill_kiemdoan_thiennambophap:GetBurnResistTime()
  return 17*self:GetLevel()
end


function skill_kiemdoan_thiennambophap:OnSpellStart()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{duration = 120})
  caster:CalculateStatBonus()
  
  Timers:CreateTimer(0.2,function()
    UpdatePlayerData(caster:GetPlayerID())
  end)
  
  
  
 end