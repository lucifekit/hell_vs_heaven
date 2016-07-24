modifier_daocon_tunguyenthuat = class({})
function modifier_daocon_tunguyenthuat:IsHidden()
   return false
end
function modifier_daocon_tunguyenthuat:GetStatusEffectName()
   return "particles/status_fx/status_effect_gods_strength.vpcf"
end
function modifier_daocon_tunguyenthuat:HeroEffectPriority()
   return 10
end
function modifier_daocon_tunguyenthuat:RemoveOnDeath()
   return true
end

function modifier_daocon_tunguyenthuat:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
}
return funcs
end

function modifier_daocon_tunguyenthuat:GetModifierExtraHealthPercentage( params)
  return self.hp_percent
end

--function modifier_daocon_tunguyenthuat:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_tunguyenthuat:OnCreated( kv )
  self.hp_percent = self:GetAbility():GetLevel()*0.2
end

function modifier_daocon_tunguyenthuat:OnRefresh( kv )
  self.hp_percent = self:GetAbility():GetLevel()*0.2
end
