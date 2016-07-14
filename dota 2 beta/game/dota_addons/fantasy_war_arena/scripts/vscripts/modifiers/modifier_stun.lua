modifier_stun = class({})
--------------------------------------------------------------------------------
function modifier_stun:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_stun:GetEffectName()
  return "particles/generic_gameplay/generic_stunned.vpcf"
end


function modifier_stun:CheckState()
  local state = {
  [MODIFIER_STATE_STUNNED] = true,
  }
 
  return state
end