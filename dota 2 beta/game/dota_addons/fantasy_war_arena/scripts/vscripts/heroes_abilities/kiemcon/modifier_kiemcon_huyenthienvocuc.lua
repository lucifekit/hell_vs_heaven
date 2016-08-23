modifier_kiemcon_huyenthienvocuc = class({})
require('kem_lib/kem')
function modifier_kiemcon_huyenthienvocuc:IsHidden()
   return true
end

function modifier_kiemcon_huyenthienvocuc:RemoveOnDeath()
   return false
end

function modifier_kiemcon_huyenthienvocuc:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_huyenthienvocuc:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_huyenthienvocuc:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_huyenthienvocuc:OnCreated( kv )
end

function modifier_kiemcon_huyenthienvocuc:OnRefresh( kv )
end
