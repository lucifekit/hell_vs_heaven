modifier_daocon_conlondaophap = class({})
function modifier_daocon_conlondaophap:IsHidden()
   return true
end

function modifier_daocon_conlondaophap:RemoveOnDeath()
   return false
end

function modifier_daocon_conlondaophap:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_daocon_conlondaophap:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_daocon_conlondaophap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_conlondaophap:OnCreated( kv )
  
    self.atk_speed = 5+self:GetAbility():GetLevel()*2
  
end

function modifier_daocon_conlondaophap:OnRefresh( kv )
    
    self.atk_speed = 5+self:GetAbility():GetLevel()*2
end