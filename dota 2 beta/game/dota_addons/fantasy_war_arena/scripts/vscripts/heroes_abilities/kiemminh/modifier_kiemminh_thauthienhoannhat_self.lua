modifier_kiemminh_thauthienhoannhat_self = class({})
--------------------------------------------------------------------------------
function modifier_kiemminh_thauthienhoannhat_self:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_kiemminh_thauthienhoannhat_self:GetEffectName()
  return "particles/econ/items/venomancer/toxicant/veno_toxicant_tail.vpcf"
end
function modifier_kiemminh_thauthienhoannhat_self:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE --we want item's passive abilities to be hidden most of the times
end
function modifier_kiemminh_thauthienhoannhat_self:IsDebuff()
  return false
end
--------------------------------------------------------------------------------
function modifier_kiemminh_thauthienhoannhat_self:OnIntervalThink()
  if(IsServer())then
    self:GetParent():SetHealth(self:GetParent():GetHealth()+self.hp_regen)
    self:GetParent():SetMana(self:GetParent():GetMana()+self.mp_regen)
  end
  
end
function modifier_kiemminh_thauthienhoannhat_self:OnCreated( kv )
 
 if(IsServer())then
    self:StartIntervalThink(0.5)
    local skill_level = self:GetAbility():GetLevel()
    local mp_regen = 100+50*skill_level
    local hp_regen = 100+50*skill_level
    self.mp_regen = mp_regen
    self.hp_regen = hp_regen
    --PrintTable(self:GetParent().cankhondainadi_bufflist)
 end
  

end

--------------------------------------------------------------------------------
function modifier_kiemminh_thauthienhoannhat_self:OnRefresh( kv )
  if(IsServer())then
    local skill_level = self:GetAbility():GetLevel()
    local mp_regen = 100+50*skill_level
    local hp_regen = 100+50*skill_level
    self.mp_regen = mp_regen
    self.hp_regen = hp_regen
  end
end

function modifier_kiemminh_thauthienhoannhat_self:OnDestroy( kv )
  self:StartIntervalThink(-1)
end