modifier_thuongthien_thiencanhchienkhi = class({})
require('kem_lib/kem')
function modifier_thuongthien_thiencanhchienkhi:IsHidden()
   return true
end

function modifier_thuongthien_thiencanhchienkhi:RemoveOnDeath()
   return false
end

function modifier_thuongthien_thiencanhchienkhi:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_thiencanhchienkhi::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_thiencanhchienkhi:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_thiencanhchienkhi:OnCreated( kv )
end

function modifier_thuongthien_thiencanhchienkhi:OnRefresh( kv )
end
