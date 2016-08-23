modifier_manhan_thucphocchu_active = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_EFFECT = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
--SETTING_EFFECT_2 = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
function modifier_manhan_thucphocchu_active:IsHidden()
  return false
end
function modifier_manhan_thucphocchu_active:RemoveOnDeath()
  return true
end

function modifier_manhan_thucphocchu_active:GetEffectName()
  return SETTING_EFFECT
end

function modifier_manhan_thucphocchu_active:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_manhan_thucphocchu_active:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.move_speed
end

function modifier_manhan_thucphocchu_active:OnCreated( kv )  
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.move_speed = (10+skill_level*4)*2.5
end

--------------------------------------------------------------------------------
function modifier_manhan_thucphocchu_active:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.move_speed = (10+skill_level*4)*2.5
end