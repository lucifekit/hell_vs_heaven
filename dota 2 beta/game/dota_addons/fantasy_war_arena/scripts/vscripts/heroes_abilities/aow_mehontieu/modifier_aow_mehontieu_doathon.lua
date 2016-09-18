modifier_aow_mehontieu_doathon = class({})
--
require('kem_lib/kem')
function modifier_aow_mehontieu_doathon:IsHidden()
   return false
end

function modifier_aow_mehontieu_doathon:RemoveOnDeath()
   return true
end

function modifier_aow_mehontieu_doathon:GetTexture()
   return "nevermore_necromastery"
end

function modifier_aow_mehontieu_doathon:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
return funcs
end

function modifier_aow_mehontieu_doathon:GetModifierIncomingDamage_Percentage( params)
  local damage_increase = 1*self:GetStackCount() 
  return -damage_increase
end

