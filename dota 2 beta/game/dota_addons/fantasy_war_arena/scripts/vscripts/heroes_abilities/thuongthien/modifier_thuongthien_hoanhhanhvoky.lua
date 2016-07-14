modifier_thuongthien_hoanhhanhvoky = class({})
function modifier_thuongthien_hoanhhanhvoky:IsHidden()
   return false
end

function modifier_thuongthien_hoanhhanhvoky:RemoveOnDeath()
   return true
end

function modifier_thuongthien_hoanhhanhvoky:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_hoanhhanhvoky::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_hoanhhanhvoky:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_hoanhhanhvoky:OnCreated( kv )
end

function modifier_thuongthien_hoanhhanhvoky:OnRefresh( kv )
end
