modifier_tutien_tamma = class({})
require('kem_lib/kem')
function modifier_tutien_tamma:IsHidden()
   return true
end

function modifier_tutien_tamma:RemoveOnDeath()
   return false
end

function modifier_tutien_tamma:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_tutien_tamma:GetModifierAttackSpeedBonus_Constant( params)
return self.atk_speed
end

--function modifier_tutien_tamma:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_tamma:OnCreated( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = math.floor(10+skill_level*1.6)
end

function modifier_tutien_tamma:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = math.floor(10+skill_level*1.6)
end
