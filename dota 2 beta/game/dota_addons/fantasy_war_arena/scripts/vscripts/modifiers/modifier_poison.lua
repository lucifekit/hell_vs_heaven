modifier_poison = class({})
--------------------------------------------------------------------------------


--
--function modifier_poison:GetEffectAttachType()
--  return PATTACH_ABSORIGIN_FOLLOW
--end

function modifier_poison:GetStatusEffectName()
  return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
--function modifier_poison:GetEffectName()
--  return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
--end
function modifier_poison:GetTexture()
  return "alchemist_acid_spray"
end
