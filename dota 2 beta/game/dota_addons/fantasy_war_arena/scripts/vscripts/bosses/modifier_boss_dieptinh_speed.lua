modifier_boss_dieptinh_speed = class({})


function modifier_boss_dieptinh_speed:IsHidden()
  return true
end
function modifier_boss_dieptinh_speed:RemoveOnDeath()
  return false
end
function modifier_boss_dieptinh_speed:IsPurgable()
  return false
end
function modifier_boss_dieptinh_speed:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end

function modifier_boss_dieptinh_speed:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return 100
end