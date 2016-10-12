modifier_defense_break = class({})
--------------------------------------------------------------------------------

function modifier_defense_break:GetTexture()
  return "slardar_amplify_damage"
end


function modifier_defense_break:GetEffectName()
  return "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf"
end
function modifier_defense_break:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end