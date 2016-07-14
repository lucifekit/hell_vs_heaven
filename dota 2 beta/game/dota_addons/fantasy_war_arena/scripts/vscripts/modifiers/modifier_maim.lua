modifier_maim = class({})
--------------------------------------------------------------------------------

function modifier_maim:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_maim:GetEffectName()
  return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end
function modifier_maim:GetStatusEffectName()
  return "particles/status_fx/status_effect_phantom_lancer_illusion.vpcf"
end

function modifier_maim:GetTexture()
  return "bloodseeker_rupture"
end
function modifier_maim:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_ROOTED] = true,
  [MODIFIER_STATE_SILENCED] = true
  --[MODIFIER_STATE_BLIND] = true,
  }
 
  return state
end
function modifier_maim:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
    
  }
 
  return funcs
end
function modifier_maim:GetModifierTurnRate_Percentage(params)
  return 100
end