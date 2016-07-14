modifier_daocon_suongngaoconlon = class({})
function modifier_daocon_suongngaoconlon:IsHidden()
   return true
end

function modifier_daocon_suongngaoconlon:RemoveOnDeath()
   return false
end

function modifier_daocon_suongngaoconlon:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_suongngaoconlon:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_suongngaoconlon:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_suongngaoconlon:OnCreated( kv )
end

function modifier_daocon_suongngaoconlon:OnRefresh( kv )
end
