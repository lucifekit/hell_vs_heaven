modifier_kiemcon_cuongloichandia = class({})
require('kem_lib/kem')
function modifier_kiemcon_cuongloichandia:IsHidden()
   return true
end

function modifier_kiemcon_cuongloichandia:RemoveOnDeath()
   return false
end

function modifier_kiemcon_cuongloichandia:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_cuongloichandia:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_cuongloichandia:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_cuongloichandia:OnCreated( kv )
end

function modifier_kiemcon_cuongloichandia:OnRefresh( kv )
end
