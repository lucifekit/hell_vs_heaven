modifier_manhan_kimthienthoatxac = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
function modifier_manhan_kimthienthoatxac:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_manhan_kimthienthoatxac:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_EVASION_CONSTANT
  }
 
  return funcs
end
function modifier_manhan_kimthienthoatxac:GetModifierEvasion_Constant( params)
  --PrintTable(params)
  --return 1
  return self.evade
end

--------------------------------------------------------------------------------

function modifier_manhan_kimthienthoatxac:OnCreated( kv )
  local p = self:GetParent()
  local skill_level=self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.evade = skill_level*2
  
end

--------------------------------------------------------------------------------
function modifier_manhan_kimthienthoatxac:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level=self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.evade = skill_level*2
end