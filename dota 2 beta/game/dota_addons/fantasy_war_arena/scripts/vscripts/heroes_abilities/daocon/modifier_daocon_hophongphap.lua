modifier_daocon_hophongphap = class({})
require('kem_lib/kem')
function modifier_daocon_hophongphap:IsHidden()
   return true
end

function modifier_daocon_hophongphap:RemoveOnDeath()
   return false
end

function modifier_daocon_hophongphap:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_hophongphap:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_hophongphap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_hophongphap:OnCreated( kv )
end

function modifier_daocon_hophongphap:OnRefresh( kv )
end
