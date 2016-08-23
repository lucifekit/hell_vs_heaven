modifier_tutien_baovulehoa = class({})
require('kem_lib/kem')
function modifier_tutien_baovulehoa:IsHidden()
   return true
end

function modifier_tutien_baovulehoa:RemoveOnDeath()
   return false
end

function modifier_tutien_baovulehoa:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_baovulehoa:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_baovulehoa:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_baovulehoa:OnCreated( kv )
end

function modifier_tutien_baovulehoa:OnRefresh( kv )
end
