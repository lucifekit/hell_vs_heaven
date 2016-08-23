modifier_boss_hokhon_regenX_target = class({})
function modifier_boss_hokhon_regenX_target:IsHidden()
   return false
end
function modifier_boss_hokhon_regenX_target:RemoveOnDeath()
   return true
end

function modifier_boss_hokhon_regenX_target:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf"
end
--function modifier_poison:GetEffectName()
--  return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
--end
function modifier_boss_hokhon_regenX_target:GetTexture()
  return "item_blademail"
end

function modifier_boss_hokhon_regenX_target:IsDebuff()
  return false
end

function modifier_boss_hokhon_regenX_target:DeclareFunctions(  )
 local funcs = {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
  }
 
  return funcs
end
function modifier_boss_hokhon_regenX_target:GetModifierConstantHealthRegen( params )
  return 2000
end
function modifier_boss_hokhon_regenX_target:OnCreated( kv )

end



function modifier_boss_hokhon_regenX_target:OnDestroy( kv )
 
end
