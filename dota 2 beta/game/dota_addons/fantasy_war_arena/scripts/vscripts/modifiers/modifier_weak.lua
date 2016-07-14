modifier_weak = class({})
--------------------------------------------------------------------------------

function modifier_weak:GetStatusEffectName()
  return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_weak:GetTexture()
  return "necrolyte_heartstopper_aura"

end
function modifier_weak:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  }
 
  return funcs
end
function modifier_weak:GetModifierTotalDamageOutgoing_Percentage()
  return 60

end