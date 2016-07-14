modifier_kiemdoan_thienlongthancong = class({})
--------------------------------------------------------------------------------

function modifier_kiemdoan_thienlongthancong:IsHidden()
  return true
end
function modifier_kiemdoan_thienlongthancong:RemoveOnDeath()
  return false
end

function modifier_kiemdoan_thienlongthancong:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_kiemdoan_thienlongthancong:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_kiemdoan_thienlongthancong:OnCreated( kv )
 
  self.atk_speed = math.ceil(10+self:GetAbility():GetLevel()*1.5)
  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_thienlongthancong:OnRefresh( kv )
  self.atk_speed = math.ceil(10+self:GetAbility():GetLevel()*1.5)
end