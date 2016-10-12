modifier_aow_truyhontrao_soul = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_soul:IsHidden()
   return false
end

function modifier_aow_truyhontrao_soul:RemoveOnDeath()
   return true
end

function modifier_aow_truyhontrao_soul:GetEffectName()
   return "particles/units/heroes/hero_pudge/pudge_dismember.vpcf"
end

function modifier_aow_truyhontrao_soul:GetBasicDamage()
  return 0.03*self:GetStackCount()
end