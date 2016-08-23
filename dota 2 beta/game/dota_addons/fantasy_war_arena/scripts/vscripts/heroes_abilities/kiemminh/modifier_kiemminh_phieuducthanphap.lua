modifier_kiemminh_phieuducthanphap = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------

function modifier_kiemminh_phieuducthanphap:IsHidden()
  return true
end
function modifier_kiemminh_phieuducthanphap:RemoveOnDeath()
  return false
end

function modifier_kiemminh_phieuducthanphap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_kiemminh_phieuducthanphap:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.speed
end

--------------------------------------------------------------------------------

function modifier_kiemminh_phieuducthanphap:OnCreated( kv )

    local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
    local p = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.speed = (10+skill_level*3)*settings.speed_base

  
  
end

--------------------------------------------------------------------------------
function modifier_kiemminh_phieuducthanphap:OnRefresh( kv )
 
    local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
    local p = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.speed = (10+skill_level*3)*settings.speed_base

  
end