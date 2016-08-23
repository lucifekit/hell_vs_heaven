modifier_tutien_tamnhan = class({})
require('kem_lib/kem')
function modifier_tutien_tamnhan:IsHidden()
   return true
end

function modifier_tutien_tamnhan:RemoveOnDeath()
   return false
end

function modifier_tutien_tamnhan:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_tamnhan:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_tamnhan:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_tamnhan:OnCreated( kv )
end

function modifier_tutien_tamnhan:OnRefresh( kv )
end
