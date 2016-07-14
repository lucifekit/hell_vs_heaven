modifier_thuongthien_bonloitoanlongthuong = class({})
function modifier_thuongthien_bonloitoanlongthuong:IsHidden()
   return true
end

function modifier_thuongthien_bonloitoanlongthuong:RemoveOnDeath()
   return false
end

function modifier_thuongthien_bonloitoanlongthuong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_bonloitoanlongthuong::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_bonloitoanlongthuong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_bonloitoanlongthuong:OnCreated( kv )
end

function modifier_thuongthien_bonloitoanlongthuong:OnRefresh( kv )
end
