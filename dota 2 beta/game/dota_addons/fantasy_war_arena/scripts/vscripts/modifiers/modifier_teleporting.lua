modifier_kemtele = class({})

function modifier_kemtele:GetTexture()
  return "item_tpscroll"
end
function modifier_kemtele:GetEffectAttachType()
  return PATTACH_ABSORIGIN
end
function modifier_kemtele:GetEffectName()
  --return "particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015.vpcf"

  --return "particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015.vpcf"
  return "particles/econ/events/winter_major_2016/teleport_start_winter_major_2016_lvl3.vpcf"

end
function modifier_kemtele:IsPurgable()
  return false
end
function modifier_kemtele:IsHidden()
  return false
end
function modifier_kemtele:IsDebuff()
  return false
end
function modifier_kemtele:RemoveOnDeath()
  return true
end

function modifier_kemtele:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_UNIT_MOVED
}
return funcs

end
function modifier_kemtele:CheckState()
  local state = {
  }
 
  return state
end
function modifier_kemtele:OnUnitMoved(kv)
  --PrintTable(kv)

  if(kv.unit==self:GetParent())then
    self.interupted = true
    self:Destroy()
  end
  
end
function modifier_kemtele:OnCreated(kv)
 

  if(IsServer())then
    self.x = kv.x
    self.y = kv.y
    self.interupted = false  
  end
  
end
function modifier_kemtele:OnDestroy()

  --kemPrint("Ondestroy")
  if(IsServer())then
    if self.interupted then
      kemPrint("Interupted")

    else
      local unit = self:GetParent()
      unit:SetOrigin(Vector(self.x,self.y,128))
      FindClearSpaceForUnit(unit,unit:GetAbsOrigin(),true)
      unit:RemoveModifierByName("modifier_battle_hunger")
      unit:Stop()
    end
  end
  
  
end