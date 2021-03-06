modifier_thuongthien_tinhtamquyet = class({})
require('kem_lib/kem')
function modifier_thuongthien_tinhtamquyet:IsHidden()
   return false
end

function modifier_thuongthien_tinhtamquyet:RemoveOnDeath()
   return false
end

function modifier_thuongthien_tinhtamquyet:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
}
return funcs
end

function modifier_thuongthien_tinhtamquyet:GetModifierExtraHealthPercentage( params)
  return self.extra_hp_percentage
end

--function modifier_thuongthien_tinhtamquyet:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_tinhtamquyet:OnCreated( kv )
--10-80
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.extra_hp_percentage = 0.05+skill_level*0.075

end

function modifier_thuongthien_tinhtamquyet:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.extra_hp_percentage = 0.05+skill_level*0.075
end
