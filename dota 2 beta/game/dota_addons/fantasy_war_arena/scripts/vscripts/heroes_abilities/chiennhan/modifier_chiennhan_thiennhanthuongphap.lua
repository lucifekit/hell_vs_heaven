modifier_chiennhan_thiennhanthuongphap = class({})
require('kem_lib/kem')
function modifier_chiennhan_thiennhanthuongphap:IsHidden()
   return true
end

function modifier_chiennhan_thiennhanthuongphap:RemoveOnDeath()
   return false
end

function modifier_chiennhan_thiennhanthuongphap:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_chiennhan_thiennhanthuongphap:GetModifierAttackSpeedBonus_Constant( params)
return self.attack_speed
end

--function modifier_chiennhan_thiennhanthuongphap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_thiennhanthuongphap:OnCreated( kv )
  -- BASIC TALENT
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.attack_speed = 10+5*skill_level

end

function modifier_chiennhan_thiennhanthuongphap:OnRefresh( kv )
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.attack_speed = 10+5*skill_level
end
