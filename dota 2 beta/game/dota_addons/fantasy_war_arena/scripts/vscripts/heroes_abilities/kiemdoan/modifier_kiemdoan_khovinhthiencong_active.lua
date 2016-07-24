modifier_kiemdoan_khovinhthiencong_active = class({})
--------------------------------------------------------------------------------

function modifier_kiemdoan_khovinhthiencong_active:IsHidden()
  return false
end
function modifier_kiemdoan_khovinhthiencong_active:RemoveOnDeath()
  return true
end

function modifier_kiemdoan_khovinhthiencong_active:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
  }
 
  return funcs
end
function modifier_kiemdoan_khovinhthiencong_active:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return -self.atk_speed
end
function modifier_kiemdoan_khovinhthiencong_active:GetModifierHealthRegenPercentage( params)
  --PrintTable(params)
  --print(self.regen_speed)
  return self.regen_speed
end
--------------------------------------------------------------------------------

function modifier_kiemdoan_khovinhthiencong_active:OnCreated( kv )
  self.atk_speed =math.floor(self:GetAbility():GetLevel()*2)
  self.regen_speed=0
  if(IsServer())then
    
    self.regen_speed = 10+self:GetAbility():GetLevel()*2
    self.hp_regen = self:GetParent():GetMaxHealth()*self.regen_speed/100
    if(self.hp_regen>1000)then
      self.regen_speed = math.floor(100000/self:GetParent():GetMaxHealth())
      print("NOW REGEN SPEED = "..self.regen_speed)
    end 
    UpdatePlayerDataForHero(self:GetParent())
  end
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_khovinhthiencong_active:OnRefresh( kv )
  self.atk_speed = math.floor(self:GetAbility():GetLevel()*2)
  self.regen_speed = 10+self:GetAbility():GetLevel()*2
end

function modifier_kiemdoan_khovinhthiencong_active:OnDestroy()
  if(IsServer())then
    UpdatePlayerDataForHero(self:GetParent())
  end
  
end