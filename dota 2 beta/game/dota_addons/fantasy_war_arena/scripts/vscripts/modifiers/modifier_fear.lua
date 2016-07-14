modifier_fear = class({})
--------------------------------------------------------------------------------
function modifier_fear:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_fear:GetEffectName()
  return "particles/units/heroes/hero_oracle/oracle_fortune_purge_root_pnt.vpcf"
end

function modifier_immobile:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true,
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true
  }
 
  return state
end