skill_daocon_conlondaophap = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_conlondaophap"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_conlondaophap:GetAccuracyChance()
  return 0.5+self:GetLevel()*0.2
end

function skill_daocon_conlondaophap:GetAmplifyPhysic()

  return 0.05+self:GetLevel()*0.2
end

function skill_daocon_conlondaophap:GetCriticalChance()

  return 25+self:GetLevel()*5
end
function skill_daocon_conlondaophap:OnUpgrade()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
  caster:CalculateStatBonus()

  UpgradeSkill(caster:GetPlayerID())
end

