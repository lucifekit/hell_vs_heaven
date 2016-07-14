modifier_kiemminh_lyhoadaiphap = class({})
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
 
  self.atk_speed = math.ceil(10+self:GetAbility():GetLevel()*1.6)
  
end

--------------------------------------------------------------------------------
function modifier_kiemminh_lyhoadaiphap:OnRefresh( kv )
  self.atk_speed = math.ceil(10+self:GetAbility():GetLevel()*1.6)
end