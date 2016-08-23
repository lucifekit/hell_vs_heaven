modifier_kiemminh_lyhoadaiphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------

function modifier_kiemminh_lyhoadaiphap:IsHidden()
  return true
end
function modifier_kiemminh_lyhoadaiphap:RemoveOnDeath()
  return false
end

function modifier_kiemminh_lyhoadaiphap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_kiemminh_lyhoadaiphap:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_kiemminh_lyhoadaiphap:OnCreated( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = math.ceil(10+skill_level*1.6)
  
end

--------------------------------------------------------------------------------
function modifier_kiemminh_lyhoadaiphap:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = math.ceil(10+skill_level*1.6)
end