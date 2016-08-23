modifier_thuongthien_huyetchienbatphuong = class({})
require('kem_lib/kem')
function modifier_thuongthien_huyetchienbatphuong:IsHidden()
   return true
end

function modifier_thuongthien_huyetchienbatphuong:RemoveOnDeath()
   return false
end

function modifier_thuongthien_huyetchienbatphuong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_huyetchienbatphuong::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_huyetchienbatphuong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_huyetchienbatphuong:OnCreated( kv )
end

function modifier_thuongthien_huyetchienbatphuong:OnRefresh( kv )
end
