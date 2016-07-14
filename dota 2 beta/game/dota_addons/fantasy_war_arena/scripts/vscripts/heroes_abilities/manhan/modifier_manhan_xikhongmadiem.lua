modifier_manhan_xikhongmadiem = class({})
--------------------------------------------------------------------------------

function modifier_manhan_xikhongmadiem:IsHidden()
  return true
end
function modifier_manhan_xikhongmadiem:RemoveOnDeath()
  return false
end

function modifier_manhan_xikhongmadiem:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_manhan_xikhongmadiem:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_manhan_xikhongmadiem:OnCreated( kv )
 
  self.atk_speed = math.ceil(11+self:GetAbility():GetLevel()*1.5)
  
end

--------------------------------------------------------------------------------
function modifier_manhan_xikhongmadiem:OnRefresh( kv )
  self.atk_speed = math.ceil(11+self:GetAbility():GetLevel()*1.5)
end