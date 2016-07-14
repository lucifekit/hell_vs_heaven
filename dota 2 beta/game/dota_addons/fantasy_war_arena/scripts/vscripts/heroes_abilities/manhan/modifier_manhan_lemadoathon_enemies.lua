modifier_manhan_lemadoathon_enemies = class({})
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
 if(IsServer())then
  local skill_level = self:GetAbility():GetLevel()
  -- SOUL STEALER
  local physical_simplify = 0.5+0.15*skill_level
  local movement_speed_reduce = 20+8*skill_level
  local cooldown = 5
  self.physical_simplify = physical_simplify
  self.speed = movement_speed_reduce
  --self:GetParent().physic_amplify = self:GetParent().physic_amplify -self.physical_simplify 
  if(self:GetParent().physic_amplify)then
      self:GetParent().physic_amplify = self:GetParent().physic_amplify -self.physical_simplify
    end
 end
  

end

--------------------------------------------------------------------------------
function modifier_manhan_lemadoathon_enemies:OnRefresh( kv )
  if(IsServer())then
      local skill_level = self:GetAbility():GetLevel()
      local movement_speed_reduce = 20+8*skill_level
      self.speed = movement_speed_reduce
  end
end

function modifier_manhan_lemadoathon_enemies:OnDestroy( kv )
  if(IsServer())then
    if(self:GetParent().physic_amplify)then
      self:GetParent().physic_amplify = self:GetParent().physic_amplify +self.physical_simplify
    end
    
  end
end