modifier_daocon_ngaotuyettieuphong = class({})
function modifier_daocon_ngaotuyettieuphong:IsHidden()
   return true
end

function modifier_daocon_ngaotuyettieuphong:RemoveOnDeath()
   return false
end

function modifier_daocon_ngaotuyettieuphong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_ngaotuyettieuphong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_ngaotuyettieuphong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_ngaotuyettieuphong:OnCreated( kv )
end

function modifier_daocon_ngaotuyettieuphong:OnRefresh( kv )
end
