skill_thuongthien_tinhtamquyet = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_thuongthien_tinhtamquyet"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_thuongthien_tinhtamquyet:GetReducePoisonTime()
  --5-30
  return 0.02*self:GetLevel()+0.1
end




function skill_thuongthien_tinhtamquyet:OnUpgrade()
  local caster = self:GetCaster()
  if(caster:HasModifier(SETTING_SKILL_MODIFIER)) then
    caster:RemoveModifierByName(SETTING_SKILL_MODIFIER)
  end
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
end

