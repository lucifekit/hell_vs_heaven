modifier_kiemcon_loidongcuuthien = class({})
require('kem_lib/kem')
function modifier_kiemcon_loidongcuuthien:IsHidden()
   return true
end

function modifier_kiemcon_loidongcuuthien:RemoveOnDeath()
   return false
end

function modifier_kiemcon_loidongcuuthien:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_loidongcuuthien:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_loidongcuuthien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_loidongcuuthien:OnCreated( kv )
end

function modifier_kiemcon_loidongcuuthien:OnRefresh( kv )
end
