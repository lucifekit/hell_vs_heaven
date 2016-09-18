modifier_defense = class({})
--------------------------------------------------------------------------------

function modifier_defense:GetTexture()
  return "rubick_null_field"
end

function modifier_defense:GetEffectName()
  return "particles/items3_fx/lotus_orb_shield.vpcf"
end

function modifier_defense:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  }
 
  return funcs
end
function modifier_defense:GetModifierIncomingDamage_Percentage( params)
  return -75
end