modifier_kem_moving = class({})
require('kem_lib/kem')
function modifier_kem_moving:IsHidden()
   return false
end
function modifier_kem_moving:IsPurgeable()
   return false
end
function modifier_kem_moving:RemoveOnDeath()
   return true
end
function modifier_kem_moving:GetEffectName()
  return "particles/edited_particle/moving.vpcf"
end
