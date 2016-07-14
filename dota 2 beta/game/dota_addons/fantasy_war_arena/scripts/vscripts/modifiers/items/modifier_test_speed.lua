modifier_test_speed = class({})
--------------------------------------------------------------------------------

function modifier_test_speed:GetTexture()
  return "item_boot_normal"
end
function modifier_test_speed:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_test_speed:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return 400
end