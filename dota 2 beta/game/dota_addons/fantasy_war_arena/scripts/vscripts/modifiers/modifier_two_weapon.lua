modifier_two_weapon = class({})
--------------------------------------------------------------------------------
function modifier_two_weapon:GetEffectName()
  return "particles/units/heroes/hero_oracle/oracle_fatesedict_disarm.vpcf"
end
function modifier_two_weapon:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_two_weapon:IsDebuff()
  return true
end
function modifier_two_weapon:GetTexture()
  return "disarm"
end
function modifier_two_weapon:IsHidden()
  return false
end

function modifier_two_weapon:IsPurgable()
  return false
end
function modifier_two_weapon:RemoveOnDeath()
  return false
end
function modifier_two_weapon:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true
  }
 
  return state
end