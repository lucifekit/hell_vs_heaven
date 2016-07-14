modifier_kiemminh_minhgiaokiemphap = class({})
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
 
  self.atk_speed = math.ceil(5+math.floor(self:GetAbility():GetLevel()*2))
  
end

--------------------------------------------------------------------------------
function modifier_kiemminh_minhgiaokiemphap:OnRefresh( kv )
  self.atk_speed = math.ceil(5+math.floor(self:GetAbility():GetLevel()*2))
end