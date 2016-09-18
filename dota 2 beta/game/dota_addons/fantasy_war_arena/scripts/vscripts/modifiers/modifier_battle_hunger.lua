modifier_battle_hunger = class({})

function modifier_battle_hunger:GetTexture()
  return "axe_battle_hunger"
end

function modifier_battle_hunger:IsPurgable()
  return false
end
function modifier_battle_hunger:IsHidden()
  return false
end
function modifier_battle_hunger:IsDebuff()
  return false
end
function modifier_battle_hunger:RemoveOnDeath()
  return true
end


function modifier_battle_hunger:OnCreated(kv)
 

  if(IsServer())then
    self.x = kv.x
    self.y = kv.y 
  end
  
end
function modifier_battle_hunger:OnDestroy()

  --kemPrint("Ondestroy")
  if(IsServer())then
      
      local unit = self:GetParent()
      unit:SetOrigin(Vector(self.x,self.y,128))
      FindClearSpaceForUnit(unit,unit:GetAbsOrigin(),true)
      unit:Stop()
  end
  
  
end