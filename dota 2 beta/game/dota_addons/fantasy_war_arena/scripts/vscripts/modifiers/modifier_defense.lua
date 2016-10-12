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
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }
 
  return funcs
end

function modifier_defense:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true,
  }
 
  return state
end
function modifier_defense:GetModifierIncomingDamage_Percentage( params)
  return -75
end

function modifier_defense:GetModifierMoveSpeedBonus_Constant( params)
  return -150
end

function modifier_defense:GetOverrideAnimation( params )
  return ACT_DOTA_LOADOUT
end