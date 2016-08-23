modifier_kiemcon_honnguyencankhon = class({})
require('kem_lib/kem')
function modifier_kiemcon_honnguyencankhon:IsHidden()
   return true
end

function modifier_kiemcon_honnguyencankhon:RemoveOnDeath()
   return false
end

function modifier_kiemcon_honnguyencankhon:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_honnguyencankhon:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_honnguyencankhon:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_honnguyencankhon:OnCreated( kv )
end

function modifier_kiemcon_honnguyencankhon:OnRefresh( kv )
end
