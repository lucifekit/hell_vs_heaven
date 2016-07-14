modifier_kiemminh_phieuducthanphap = class({})
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
  return self.move_speed
end

--------------------------------------------------------------------------------

function modifier_kiemminh_phieuducthanphap:OnCreated( kv )

    self.move_speed = math.ceil(20+self:GetAbility():GetLevel()*6)

  
  
end

--------------------------------------------------------------------------------
function modifier_kiemminh_phieuducthanphap:OnRefresh( kv )
 
    self.move_speed = math.ceil(20+self:GetAbility():GetLevel()*6)

  
end