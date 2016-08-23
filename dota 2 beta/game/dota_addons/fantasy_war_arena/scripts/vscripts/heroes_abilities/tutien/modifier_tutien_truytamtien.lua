modifier_tutien_truytamtien = class({})
require('kem_lib/kem')
function modifier_tutien_truytamtien:IsHidden()
   return true
end

function modifier_tutien_truytamtien:RemoveOnDeath()
   return false
end

function modifier_tutien_truytamtien:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_truytamtien:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_truytamtien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_truytamtien:OnCreated( kv )
end

function modifier_tutien_truytamtien:OnRefresh( kv )
end
