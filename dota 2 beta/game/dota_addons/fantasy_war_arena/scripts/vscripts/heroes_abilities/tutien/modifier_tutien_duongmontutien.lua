modifier_tutien_duongmontutien = class({})
require('kem_lib/kem')
function modifier_tutien_duongmontutien:IsHidden()
   return true
end

function modifier_tutien_duongmontutien:RemoveOnDeath()
   return false
end

function modifier_tutien_duongmontutien:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_tutien_duongmontutien:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_tutien_duongmontutien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_duongmontutien:OnCreated( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = 5+skill_level*2
end

function modifier_tutien_duongmontutien:OnRefresh( kv )
  
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = 5+skill_level*2
  print("refreshing Duong mon tu tien "..self.atk_speed)
end
