modifier_aow_mehontieu_truyhon = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_truyhon:IsHidden()
   return false
end

function modifier_aow_mehontieu_truyhon:RemoveOnDeath()
   return true
end

function modifier_aow_mehontieu_truyhon:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
return funcs
end

function modifier_aow_mehontieu_truyhon:GetModifierIncomingDamage_Percentage( params)
  local damage_increase = 1*self:GetStackCount() 
  return damage_increase
end

