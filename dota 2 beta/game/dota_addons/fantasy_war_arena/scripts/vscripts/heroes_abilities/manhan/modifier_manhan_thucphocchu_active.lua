modifier_manhan_thucphocchu_active = class({})
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
  self.move_speed = (10+self:GetAbility():GetLevel()*4)*2.5
end

--------------------------------------------------------------------------------
function modifier_manhan_thucphocchu_active:OnRefresh( kv )
  self.move_speed = (10+self:GetAbility():GetLevel()*4)*2.5
end