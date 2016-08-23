modifier_thuongthien_doanhonthich = class({})
require('kem_lib/kem')
function modifier_thuongthien_doanhonthich:IsHidden()
   return true
end

function modifier_thuongthien_doanhonthich:RemoveOnDeath()
   return false
end

function modifier_thuongthien_doanhonthich:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_doanhonthich::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_doanhonthich:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_doanhonthich:OnCreated( kv )
end

function modifier_thuongthien_doanhonthich:OnRefresh( kv )
end
