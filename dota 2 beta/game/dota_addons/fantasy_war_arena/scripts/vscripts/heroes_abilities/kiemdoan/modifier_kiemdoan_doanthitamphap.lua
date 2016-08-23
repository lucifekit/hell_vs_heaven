modifier_kiemdoan_doanthitamphap = class({})
require('kem_lib/kem')
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
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 3+math.floor(skill_level*2.5)
  
  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_doanthitamphap:OnRefresh( kv )
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 3+math.floor(skill_level*2.5)
end