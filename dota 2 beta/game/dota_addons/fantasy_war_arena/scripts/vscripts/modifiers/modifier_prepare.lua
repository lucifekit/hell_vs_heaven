modifier_prepare = class({})
--------------------------------------------------------------------------------
function modifier_prepare:GetEffectName()
  return "particles/invulernable.vpcf"
end
function modifier_prepare:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_prepare:GetTexture()
  return "omniknight_repel"
end
function modifier_prepare:IsHidden()
  return false
end

function modifier_prepare:IsPurgable()
  return false
end
function modifier_prepare:RemoveOnDeath()
  return false
end
function modifier_prepare:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_PASSIVES_DISABLED] = true
  }
 
  return state
end