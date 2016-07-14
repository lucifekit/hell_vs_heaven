modifier_immobile = class({})
--------------------------------------------------------------------------------
function modifier_immobile:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_immobile:GetEffectName()
  return "particles/units/heroes/hero_oracle/oracle_fortune_purge_root_pnt.vpcf"
end

function modifier_immobile:CheckState()
  local state = {
  [MODIFIER_STATE_ROOTED] = true,
  }
 
  return state
end