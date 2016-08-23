modifier_kiemcon_tuytienthaccot = class({})
require('kem_lib/kem')
function modifier_kiemcon_tuytienthaccot:IsHidden()
   return true
end

function modifier_kiemcon_tuytienthaccot:RemoveOnDeath()
   return false
end

function modifier_kiemcon_tuytienthaccot:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_tuytienthaccot:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_tuytienthaccot:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_tuytienthaccot:OnCreated( kv )
end

function modifier_kiemcon_tuytienthaccot:OnRefresh( kv )
end
