modifier_kiemdoan_bacminhthancong = class({})
--------------------------------------------------------------------------------

function modifier_kiemdoan_bacminhthancong:IsPurgable()
  return false
end

function modifier_kiemdoan_bacminhthancong:IsHidden()
  return false
end
function modifier_kiemdoan_bacminhthancong:RemoveOnDeath()
  return false
end

function modifier_kiemdoan_bacminhthancong:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
 
  return funcs
end
function modifier_kiemdoan_bacminhthancong:OnTakeDamage( params)
  if(IsServer())then
    if(self:GetParent()==params.unit)then
      local damage_taken = params.damage
      local damage_negate_max = math.ceil(self:GetParent():GetMaxHealth() * self.damage_negate_max)
      local heal = math.ceil(damage_taken * self.damage_negate)
      if(damage_negate_max<heal)then
        heal = damage_negate_max
      end
      if(self:GetParent():GetHealth()>0)then
        self:GetParent():SetHealth(self:GetParent():GetHealth()+heal)
      end    
    end
  end
  
  --return 50--reduce 50%
end

--------------------------------------------------------------------------------

function modifier_kiemdoan_bacminhthancong:OnCreated( kv )
   if(IsServer())then
  --self.damage_reduce = 30+self:GetAbility():GetLevel()*30
  local skill_level=self:GetAbility():GetLevel()
  self.damage_negate = 0.3
  self.damage_negate_max = 0.005+0.005*skill_level
--local reflect_damage_resist = 0.1+0.07*skill_level
  end
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_bacminhthancong:OnRefresh( kv )
  if(IsServer())then
  self.damage_reduce = 30+self:GetAbility():GetLevel()*30
  end
end