modifier_daocon_hoiphongphatlieu = class({})
function modifier_daocon_hoiphongphatlieu:IsHidden()
   return true
end

function modifier_daocon_hoiphongphatlieu:RemoveOnDeath()
   return false
end

function modifier_daocon_hoiphongphatlieu:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_hoiphongphatlieu:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_hoiphongphatlieu:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_hoiphongphatlieu:OnCreated( kv )
end

function modifier_daocon_hoiphongphatlieu:OnRefresh( kv )
end
