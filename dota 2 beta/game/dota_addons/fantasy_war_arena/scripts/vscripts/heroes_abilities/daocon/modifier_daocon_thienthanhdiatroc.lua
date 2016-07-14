modifier_daocon_thienthanhdiatroc = class({})
function modifier_daocon_thienthanhdiatroc:IsHidden()
   return true
end

function modifier_daocon_thienthanhdiatroc:RemoveOnDeath()
   return false
end

function modifier_daocon_thienthanhdiatroc:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_daocon_thienthanhdiatroc:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_daocon_thienthanhdiatroc:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_thienthanhdiatroc:OnCreated( kv )
  
    self.atk_speed = 6+self:GetAbility():GetLevel()*2
  
end

function modifier_daocon_thienthanhdiatroc:OnRefresh( kv )
    
    self.atk_speed = 6+self:GetAbility():GetLevel()*2
end
