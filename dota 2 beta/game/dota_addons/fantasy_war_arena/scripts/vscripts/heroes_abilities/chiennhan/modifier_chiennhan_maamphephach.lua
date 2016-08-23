modifier_chiennhan_maamphephach = class({})
require('kem_lib/kem')
function modifier_chiennhan_maamphephach:IsHidden()
   return true
end

function modifier_chiennhan_maamphephach:RemoveOnDeath()
   return false
end

function modifier_chiennhan_maamphephach:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_chiennhan_maamphephach:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_chiennhan_maamphephach:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_maamphephach:OnCreated( kv )
end

function modifier_chiennhan_maamphephach:OnRefresh( kv )
end
