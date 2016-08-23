modifier_boss_hokhon_regen = class({})


function modifier_boss_hokhon_regen:IsHidden()
  return true
end
function modifier_boss_hokhon_regen:RemoveOnDeath()
  return false
end
function modifier_boss_hokhon_regen:IsPurgable()
  return false
end
function modifier_boss_hokhon_regen:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
  }
 
  return funcs
end

function modifier_boss_hokhon_regen:GetModifierConstantHealthRegen( params)
  --PrintTable(params)
  return 2000
end