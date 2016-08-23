modifier_thuongthien_truytinhtrucnguyet = class({})
require('kem_lib/kem')
function modifier_thuongthien_truytinhtrucnguyet:IsHidden()
   return true
end

function modifier_thuongthien_truytinhtrucnguyet:RemoveOnDeath()
   return false
end

function modifier_thuongthien_truytinhtrucnguyet:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_thuongthien_truytinhtrucnguyet:GetModifierAttackSpeedBonus_Constant( params)
  return 800
end

--function modifier_thuongthien_truytinhtrucnguyet:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_truytinhtrucnguyet:OnCreated( kv )
end

function modifier_thuongthien_truytinhtrucnguyet:OnRefresh( kv )
end
