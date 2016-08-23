modifier_tutien_doancannhan_cooldown = class({})
require('kem_lib/kem')

function modifier_tutien_doancannhan_cooldown:IsHidden()
   return false
end
function modifier_tutien_doancannhan_cooldown:IsDebuff()
   return true
end
function modifier_tutien_doancannhan_cooldown:RemoveOnDeath()
   return false
end

function modifier_tutien_doancannhan_cooldown:OnCreated( kv )
end

function modifier_tutien_doancannhan_cooldown:OnRefresh( kv )
end
