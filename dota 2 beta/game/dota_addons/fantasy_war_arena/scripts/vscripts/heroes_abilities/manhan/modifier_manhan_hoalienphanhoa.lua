modifier_manhan_hoalienphanhoa = class({})
--------------------------------------------------------------------------------

function modifier_manhan_hoalienphanhoa:IsPurgable()
  return false
end
function modifier_manhan_hoalienphanhoa:IsDebuff()
  return true
end

function modifier_manhan_hoalienphanhoa:GetEffectName()
  return ""
end

function modifier_manhan_hoalienphanhoa:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }
 
  return funcs
end

function modifier_manhan_hoalienphanhoa:CheckState()
  local state = {
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
  }
 
  return state
end

function modifier_manhan_hoalienphanhoa:GetOverrideAnimation( params )
  return ACT_DOTA_FLAIL
end