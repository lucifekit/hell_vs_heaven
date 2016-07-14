modifier_daocon_cuongphongsaudien = class({})
function modifier_daocon_cuongphongsaudien:IsHidden()
   return true
end

function modifier_daocon_cuongphongsaudien:RemoveOnDeath()
   return false
end

function modifier_daocon_cuongphongsaudien:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_cuongphongsaudien:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_cuongphongsaudien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_cuongphongsaudien:OnCreated( kv )
end

function modifier_daocon_cuongphongsaudien:OnRefresh( kv )
end
