modifier_tutien_thienladiavong = class({})
require('kem_lib/kem')
function modifier_tutien_thienladiavong:IsHidden()
   return true
end

function modifier_tutien_thienladiavong:RemoveOnDeath()
   return false
end

function modifier_tutien_thienladiavong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_thienladiavong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_thienladiavong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_thienladiavong:OnCreated( kv )
end

function modifier_tutien_thienladiavong:OnRefresh( kv )
end
