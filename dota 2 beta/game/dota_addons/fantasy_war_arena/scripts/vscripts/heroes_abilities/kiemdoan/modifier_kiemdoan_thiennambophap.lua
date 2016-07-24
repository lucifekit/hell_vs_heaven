modifier_kiemdoan_thiennambophap = class({})
--------------------------------------------------------------------------------

function modifier_kiemdoan_thiennambophap:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_kiemdoan_thiennambophap:GetEffectName()
  return "particles/edited_particle/kiem_doan/modifier_thiennambophap.vpcf"
  --return "particles/edited_particle/slardar_flying_nimbus.vpcf"
end

function modifier_kiemdoan_thiennambophap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_kiemdoan_thiennambophap:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.speed
end

--------------------------------------------------------------------------------

function modifier_kiemdoan_thiennambophap:OnCreated( kv )
  local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
  self.speed = (10+self:GetAbility():GetLevel()*3)*settings.speed_base
  

  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_thiennambophap:OnRefresh( kv )

   local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
   self.speed = (10+self:GetAbility():GetLevel()*3)*settings.speed_base

  
end