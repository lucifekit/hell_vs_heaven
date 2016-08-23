modifier_chiennhan_phihongvotich = class({})
require('kem_lib/kem')
function modifier_chiennhan_phihongvotich:IsHidden()
   return true
end
function modifier_chiennhan_phihongvotich:GetEffectName()
  return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end
function modifier_chiennhan_phihongvotich:RemoveOnDeath()
   return false
end

function modifier_chiennhan_phihongvotich:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_chiennhan_phihongvotich:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_chiennhan_phihongvotich:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_phihongvotich:OnCreated( kv )
end

function modifier_chiennhan_phihongvotich:OnRefresh( kv )
end
