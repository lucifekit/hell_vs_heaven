modifier_manhan_kimthienthoatxac = class({})
--------------------------------------------------------------------------------
function modifier_manhan_kimthienthoatxac:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_manhan_kimthienthoatxac:GetEffectName()
  return "particles/econ/courier/courier_dc/dccourier_angel_flame.vpcf"
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
 
  self.evade = self:GetAbility():GetLevel()*2
  
end

--------------------------------------------------------------------------------
function modifier_manhan_kimthienthoatxac:OnRefresh( kv )
  self.evade = self:GetAbility():GetLevel()*2
end