modifier_tutien_doancannhan_active = class({})
require('kem_lib/kem')
function modifier_tutien_doancannhan_active:IsHidden()
   return false
end
function modifier_tutien_doancannhan_active:GetEffectName()
   return "particles/units/heroes/hero_luna/luna_eclipse.vpcf"
end

function modifier_tutien_doancannhan_active:RemoveOnDeath()
   return true
end

function modifier_tutien_doancannhan_active:OnCreated( kv )
end

function modifier_tutien_doancannhan_active:OnRefresh( kv )
end
