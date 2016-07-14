modifier_slow = class({})
--------------------------------------------------------------------------------

function modifier_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_frost_lich.vpcf"
end
function modifier_slow:GetTexture()
  return "lich_frost_armor"
end
function modifier_slow:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
  }
 
  return funcs
end
function modifier_slow:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return -50
end
function modifier_slow:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return -50
end
function modifier_slow:GetModifierPercentageCasttime(params)
  return 10
end
function modifier_slow:GetModifierTurnRate_Percentage(params)
  return 20
end