modifier_chiennhan_bitothanhphong = class({})
require('kem_lib/kem')
function modifier_chiennhan_bitothanhphong:IsHidden()
   return true
end

function modifier_chiennhan_bitothanhphong:RemoveOnDeath()
   return false
end
