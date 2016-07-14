modifier_thuongthien_thienvuongthuongphap = class({})
function modifier_thuongthien_thienvuongthuongphap:IsHidden()
   return true
end

function modifier_thuongthien_thienvuongthuongphap:RemoveOnDeath()
   return false
end

function modifier_thuongthien_thienvuongthuongphap:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_thienvuongthuongphap::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_thienvuongthuongphap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_thienvuongthuongphap:OnCreated( kv )
end

function modifier_thuongthien_thienvuongthuongphap:OnRefresh( kv )
end
