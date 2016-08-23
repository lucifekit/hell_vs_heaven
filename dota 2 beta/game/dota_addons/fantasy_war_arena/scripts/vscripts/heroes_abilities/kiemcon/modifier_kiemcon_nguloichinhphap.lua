modifier_kiemcon_nguloichinhphap = class({})
require('kem_lib/kem')
function modifier_kiemcon_nguloichinhphap:IsHidden()
   return true
end

function modifier_kiemcon_nguloichinhphap:RemoveOnDeath()
   return false
end

function modifier_kiemcon_nguloichinhphap:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_kiemcon_nguloichinhphap:GetModifierAttackSpeedBonus_Constant( params)
return self.attack_speed
end

--function modifier_kiemcon_nguloichinhphap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_nguloichinhphap:OnCreated( kv )
-- EXPERT TALENT
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.attack_speed = math.floor(10+1.6*skill_level)
--local stun_chance_increase = 10+9*skill_level
--local slow_chance_reduce = 10+14*skill_level

end

function modifier_kiemcon_nguloichinhphap:OnRefresh( kv )
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.attack_speed = math.floor(10+1.6*skill_level)
end
