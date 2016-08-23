modifier_chiennhan_vanlongtamhien = class({})
require('kem_lib/kem')
function modifier_chiennhan_vanlongtamhien:IsHidden()
   return true
end

function modifier_chiennhan_vanlongtamhien:RemoveOnDeath()
   return false
end

function modifier_chiennhan_vanlongtamhien:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_chiennhan_vanlongtamhien:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_chiennhan_vanlongtamhien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_vanlongtamhien:OnCreated( kv )
end

function modifier_chiennhan_vanlongtamhien:OnRefresh( kv )
end
