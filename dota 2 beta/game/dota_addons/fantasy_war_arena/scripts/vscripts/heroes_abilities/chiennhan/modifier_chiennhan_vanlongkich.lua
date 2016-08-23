modifier_chiennhan_vanlongkich = class({})
require('kem_lib/kem')
function modifier_chiennhan_vanlongkich:IsHidden()
   return true
end

function modifier_chiennhan_vanlongkich:RemoveOnDeath()
   return false
end

function modifier_chiennhan_vanlongkich:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_chiennhan_vanlongkich:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_chiennhan_vanlongkich:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_vanlongkich:OnCreated( kv )
end

function modifier_chiennhan_vanlongkich:OnRefresh( kv )
end
