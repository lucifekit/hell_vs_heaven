modifier_kiemminh_cankhondainadi = class({})
--------------------------------------------------------------------------------
function modifier_kiemminh_cankhondainadi:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_kiemminh_cankhondainadi:GetEffectName()
  return "particles/edited_particle/ma_nhan/fx_lemadoathon.vpcf"
end
function modifier_kiemminh_cankhondainadi:DeclareFunctions()
  local funcs = {
  
  }
 
  return funcs
end

--------------------------------------------------------------------------------
function modifier_kiemminh_cankhondainadi:OnIntervalThink()
  for _,modifier_name in ipairs(self:GetParent().cankhondainadi_bufflist) do
    if(self:GetParent():HasModifier(modifier_name))then
      self:GetParent():RemoveModifierByName(modifier_name)
    end
    
  end
end
function modifier_kiemminh_cankhondainadi:OnCreated( kv )
 
 if(IsServer())then
    self:StartIntervalThink(0.2)
    --PrintTable(self:GetParent().cankhondainadi_bufflist)
 end
  

end

--------------------------------------------------------------------------------
function modifier_kiemminh_cankhondainadi:OnRefresh( kv )
  if(IsServer())then
    PrintTable(kv)
  end
end

function modifier_kiemminh_cankhondainadi:OnDestroy( kv )
  
end