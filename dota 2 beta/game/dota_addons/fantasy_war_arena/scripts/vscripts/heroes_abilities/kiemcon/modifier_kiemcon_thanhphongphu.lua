modifier_kiemcon_thanhphongphu = class({})
require('kem_lib/kem')
function modifier_kiemcon_thanhphongphu:IsHidden()
   return true
end

function modifier_kiemcon_thanhphongphu:RemoveOnDeath()
   return false
end

function modifier_kiemcon_thanhphongphu:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_thanhphongphu:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_thanhphongphu:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_thanhphongphu:OnCreated( kv )
end

function modifier_kiemcon_thanhphongphu:OnRefresh( kv )
end
