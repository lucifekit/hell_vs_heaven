modifier_chiennhan_tanduongnhuhuyet = class({})
require('kem_lib/kem')
function modifier_chiennhan_tanduongnhuhuyet:IsHidden()
   return true
end

function modifier_chiennhan_tanduongnhuhuyet:RemoveOnDeath()
   return false
end

function modifier_chiennhan_tanduongnhuhuyet:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_chiennhan_tanduongnhuhuyet:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_chiennhan_tanduongnhuhuyet:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_tanduongnhuhuyet:OnCreated( kv )
end

function modifier_chiennhan_tanduongnhuhuyet:OnRefresh( kv )
end
