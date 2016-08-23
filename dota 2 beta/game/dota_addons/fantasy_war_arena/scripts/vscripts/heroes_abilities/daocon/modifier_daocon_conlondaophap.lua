modifier_daocon_conlondaophap = class({})
require('kem_lib/kem')
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
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 5+skill_level*2
  
end

function modifier_daocon_conlondaophap:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)    
  self.atk_speed = 5+skill_level*2
end