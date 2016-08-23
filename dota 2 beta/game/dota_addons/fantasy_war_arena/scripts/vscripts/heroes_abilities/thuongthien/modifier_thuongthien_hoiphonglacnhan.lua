modifier_thuongthien_hoiphonglacnhan = class({})
require('kem_lib/kem')
function modifier_thuongthien_hoiphonglacnhan:IsHidden()
   return false
end

function modifier_thuongthien_hoiphonglacnhan:RemoveOnDeath()
   return false
end

--function modifier_thuongthien_hoiphonglacnhan:DeclareFunctions()
--local funcs = {
--   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
--}
--return funcs
--end
--
--function modifier_thuongthien_hoiphonglacnhan:GetModifierAttackSpeedBonus_Constant( params)
--  return 100
--end

function modifier_thuongthien_hoiphonglacnhan:CheckState()
   local state = {
     [MODIFIER_STATE_ROOTED] = true
  }
return state
end

function modifier_thuongthien_hoiphonglacnhan:OnCreated( kv )
end

function modifier_thuongthien_hoiphonglacnhan:OnRefresh( kv )
end
