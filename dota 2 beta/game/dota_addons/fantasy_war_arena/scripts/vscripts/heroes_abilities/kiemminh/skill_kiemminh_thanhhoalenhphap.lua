skill_kiemminh_thanhhoalenhphap = class({})
SETTING_SKILL_MODIFIER = "modifier_kiemminh_thanhhoalenhphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_kiemminh_thanhhoalenhphap:OnAbilityPhaseStart()
  self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1)
  return true
end

function skill_kiemminh_thanhhoalenhphap:GetCooldown()
  return 30-3*self:GetLevel()
end


function skill_kiemminh_thanhhoalenhphap:OnSpellStart()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{duration = 3+1*self:GetLevel()})

  for i = 1,4 do
    caster:GetAbilityByIndex(i):EndCooldown()
  end

  caster:EmitSound("Hero_DeathProphet.Exorcism.Cast")
 end