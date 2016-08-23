modifier_manhan_lemadoathon_enemies = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
function modifier_manhan_lemadoathon_enemies:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_manhan_lemadoathon_enemies:GetEffectName()
  return "particles/edited_particle/ma_nhan/fx_lemadoathon.vpcf"
end
function modifier_manhan_lemadoathon_enemies:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_manhan_lemadoathon_enemies:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return -self.speed
end

--------------------------------------------------------------------------------

function modifier_manhan_lemadoathon_enemies:OnCreated( kv )
 self.speed = 0

  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  -- SOUL STEALER
  local physical_simplify = 0.5+0.15*skill_level
  local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
  local movement_speed_reduce = (10+4*skill_level)*settings.speed_base
  local cooldown = 5
  self.physical_simplify = physical_simplify
  self.speed = movement_speed_reduce
  --self:GetParent().physic_amplify = self:GetParent().physic_amplify -self.physical_simplify 
  if(self:GetParent().physic_amplify)then
      self:GetParent().physic_amplify = self:GetParent().physic_amplify -self.physical_simplify
    end

  

end

--------------------------------------------------------------------------------
function modifier_manhan_lemadoathon_enemies:OnRefresh( kv )

      local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
      local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
      local movement_speed_reduce = (10+4*skill_level)*settings.speed_base
      self.speed = movement_speed_reduce

end

function modifier_manhan_lemadoathon_enemies:OnDestroy( kv )
  
    if(self:GetParent().physic_amplify)then
      self:GetParent().physic_amplify = self:GetParent().physic_amplify +self.physical_simplify
    end
    

end