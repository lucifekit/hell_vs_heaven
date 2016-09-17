modifier_kiemdoan_thiennambophap = class({})
require('kem_lib/kem')
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
function modifier_kiemdoan_thiennambophap:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   
   local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
   self.speed = (10+skill_level*3)*settings.speed_base
end
function modifier_kiemdoan_thiennambophap:OnCreated( kv )
 self:Apply()
  

  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_thiennambophap:OnRefresh( kv )
  self:Apply()  
end