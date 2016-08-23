modifier_chiennhan_liethoatinhthien = class({})
require('kem_lib/kem')
function modifier_chiennhan_liethoatinhthien:IsHidden()
   return true
end

function modifier_chiennhan_liethoatinhthien:RemoveOnDeath()
   return false
end

function modifier_chiennhan_liethoatinhthien:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_chiennhan_liethoatinhthien:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_chiennhan_liethoatinhthien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_liethoatinhthien:OnCreated( kv )
end

function modifier_chiennhan_liethoatinhthien:OnRefresh( kv )
end
