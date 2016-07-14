modifier_manhan_thiennhandaophap = class({})
--------------------------------------------------------------------------------

function modifier_manhan_thiennhandaophap:IsHidden()
  return true
end
function modifier_manhan_thiennhandaophap:RemoveOnDeath()
  return false
end

function modifier_manhan_thiennhandaophap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_manhan_thiennhandaophap:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_manhan_thiennhandaophap:OnCreated( kv )
 
  self.atk_speed = 5+math.floor(self:GetAbility():GetLevel()*2)
  
end

--------------------------------------------------------------------------------
function modifier_manhan_thiennhandaophap:OnRefresh( kv )
  self.atk_speed = 5+math.floor(self:GetAbility():GetLevel()*2)
end