modifier_kiemminh_minhgiaokiemphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------

function modifier_kiemminh_minhgiaokiemphap:IsHidden()
  return true
end
function modifier_kiemminh_minhgiaokiemphap:RemoveOnDeath()
  return false
end

function modifier_kiemminh_minhgiaokiemphap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_kiemminh_minhgiaokiemphap:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_kiemminh_minhgiaokiemphap:OnCreated( kv )
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 5+skill_level*2
  
end

--------------------------------------------------------------------------------
function modifier_kiemminh_minhgiaokiemphap:OnRefresh( kv )
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 5+skill_level*2
end