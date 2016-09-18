modifier_aow_mehontieu_quyanhhubo = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_quyanhhubo:IsHidden()
   return false
end

function modifier_aow_mehontieu_quyanhhubo:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_quyanhhubo:ActiveOnHit(target)
   self:IncrementStackCount()
   if(self:GetStackCount()>=self.stack_max)then
    self:SetStackCount(0)
    local p = self:GetParent()
    local health_recover = p:GetMaxHealth()*(self.recover/100)
     
     local mana_recover = p:GetMaxHealth()*(self.recover/100)
     if(IsInToolsMode())then
      --mana_recover=mana_recover+1000
     end
     p:Heal(health_recover,nil)
     p:GiveMana(mana_recover)
   end
end

function modifier_aow_mehontieu_quyanhhubo:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    self.stack_max=11-skill_level
    self.recover = skill_level
   end
end

function modifier_aow_mehontieu_quyanhhubo:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_quyanhhubo:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_quyanhhubo:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_quyanhhubo:OnDestroy()
self:GainBack()
end
