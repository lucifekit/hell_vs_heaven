modifier_tutien_meanhtung = class({})
require('kem_lib/kem')
function modifier_tutien_meanhtung:IsHidden()
   return true
end

function modifier_tutien_meanhtung:RemoveOnDeath()
   return false
end

function modifier_tutien_meanhtung:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_meanhtung:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_meanhtung:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_meanhtung:OnCreated( kv )
end

function modifier_tutien_meanhtung:OnRefresh( kv )
end
