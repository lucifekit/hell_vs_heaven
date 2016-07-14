modifier_thuongthien_duongquantamdiep = class({})
function modifier_thuongthien_duongquantamdiep:IsHidden()
   return true
end

function modifier_thuongthien_duongquantamdiep:RemoveOnDeath()
   return false
end

function modifier_thuongthien_duongquantamdiep:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_thuongthien_duongquantamdiep:GetModifierAttackSpeedBonus_Constant( params)
  return 250
end

function modifier_thuongthien_duongquantamdiep:CheckState()
  local state = {
   [MODIFIER_STATE_ROOTED] = true,
   [MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
   [MODIFIER_STATE_NO_TEAM_SELECT] = true
  }
return state
end

function modifier_thuongthien_duongquantamdiep:OnCreated( kv )
end

function modifier_thuongthien_duongquantamdiep:OnRefresh( kv )
end
