modifier_tutien_ngudocthuat = class({})
require('kem_lib/kem')
function modifier_tutien_ngudocthuat:IsHidden()
   return true
end

function modifier_tutien_ngudocthuat:RemoveOnDeath()
   return false
end

function modifier_tutien_ngudocthuat:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_ngudocthuat:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_ngudocthuat:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_ngudocthuat:OnCreated( kv )
end

function modifier_tutien_ngudocthuat:OnRefresh( kv )
end
