modifier_kiemminh_thauthienhoannhat_enemy = class({})
--------------------------------------------------------------------------------
function modifier_kiemminh_thauthienhoannhat_enemy:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_kiemminh_thauthienhoannhat_enemy:GetEffectName()
  return "particles/econ/items/undying/undying_manyone/undying_pale_tombstone_ambient.vpcf"
end
function modifier_kiemminh_thauthienhoannhat_enemy:IsDebuff()
  return true
end
--------------------------------------------------------------------------------
function modifier_kiemminh_thauthienhoannhat_enemy:OnIntervalThink()
  if(IsServer())then
    --self:GetParent():SetHealth(self:GetParent():GetHealth()+self.hp_regen)
    self:GetParent():SetMana(self:GetParent():GetMana()-self.mp_regen)
  end
  
end
function modifier_kiemminh_thauthienhoannhat_enemy:OnCreated( kv )
 
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
function modifier_kiemminh_thauthienhoannhat_enemy:OnRefresh( kv )
  if(IsServer())then
    local skill_level = self:GetAbility():GetLevel()
    local mp_regen = 100+50*skill_level
    local hp_regen = 100+50*skill_level
    self.mp_regen = mp_regen
    self.hp_regen = hp_regen
  end
end

function modifier_kiemminh_thauthienhoannhat_enemy:OnDestroy( kv )
  self:StartIntervalThink(-1)
end