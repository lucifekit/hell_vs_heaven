modifier_fall = class({})
--------------------------------------------------------------------------------
function modifier_fall:GetEffectName()
  return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf"
end



function modifier_fall:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_fall:CheckState()
  local state = {
  [MODIFIER_STATE_STUNNED] = true,
  }
 
  return state
end

function modifier_fall:DeclareFunctions()
  return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_fall:GetOverrideAnimation( params )
  return ACT_DOTA_DISABLED
end