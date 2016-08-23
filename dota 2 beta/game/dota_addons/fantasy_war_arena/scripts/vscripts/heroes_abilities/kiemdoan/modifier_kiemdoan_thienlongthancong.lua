modifier_kiemdoan_thienlongthancong = class({})
require('kem_lib/kem')
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
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = math.ceil(10+skill_level*1.5)
  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_thienlongthancong:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = math.ceil(10+skill_level*1.5)
end