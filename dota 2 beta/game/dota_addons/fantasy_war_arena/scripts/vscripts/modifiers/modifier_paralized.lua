modifier_paralized = class({})
--------------------------------------------------------------------------------
function modifier_paralized:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_paralized:GetEffectName()
  return "particles/units/heroes/hero_oracle/oracle_fortune_purge_root_pnt.vpcf"
end

function modifier_paralized:CheckState()
  local state = {
  [MODIFIER_STATE_ROOTED] = true,

  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true

  }
 
  return state
end