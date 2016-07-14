modifier_kiemdoan_doanthitamphap = class({})
--------------------------------------------------------------------------------

function modifier_kiemdoan_doanthitamphap:IsHidden()
  return true
end

function modifier_kiemdoan_doanthitamphap:IsPurgable()
  return false
end

function modifier_kiemdoan_doanthitamphap:RemoveOnDeath()
  return false
end

function modifier_kiemdoan_doanthitamphap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_kiemdoan_doanthitamphap:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_kiemdoan_doanthitamphap:OnCreated( kv )
   self.atk_speed = math.ceil(3+math.floor(self:GetAbility():GetLevel()*2.5))
  
  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_doanthitamphap:OnRefresh( kv )
  self.atk_speed = math.ceil(3+math.floor(self:GetAbility():GetLevel()*2.5))
end