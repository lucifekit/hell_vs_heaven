modifier_knockback = class({})
--------------------------------------------------------------------------------
function modifier_knockback:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_knockback:GetEffectName()
  return "particles/units/heroes/hero_oracle/oracle_fortune_purge_root_pnt.vpcf"
end

function modifier_knockback:CheckState()
  local state = {
  [MODIFIER_STATE_ROOTED] = true,
  }
 
  return state
end