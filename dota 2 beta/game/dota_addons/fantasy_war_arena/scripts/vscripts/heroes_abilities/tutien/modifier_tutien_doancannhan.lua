modifier_tutien_doancannhan = class({})
require('kem_lib/kem')

function modifier_tutien_doancannhan:IsHidden()
   return true
end

function modifier_tutien_doancannhan:RemoveOnDeath()
   return false
end

function modifier_tutien_doancannhan:OnCreated( kv )
end

function modifier_tutien_doancannhan:OnRefresh( kv )
end
