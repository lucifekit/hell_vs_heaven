modifier_tutien_thattuyetsatquang = class({})
require('kem_lib/kem')
function modifier_tutien_thattuyetsatquang:IsHidden()
   return false
end

function modifier_tutien_thattuyetsatquang:RemoveOnDeath()
   return false
end


SETTING_INTERVAL = 30
LinkLuaModifier("modifier_tutien_thattuyetsatquang_active","heroes_abilities/tutien/modifier_tutien_thattuyetsatquang_active",LUA_MODIFIER_MOTION_NONE)
function modifier_tutien_thattuyetsatquang:OnIntervalThink( kv )
  self:SetDuration(SETTING_INTERVAL,true)
  
  
  if(IsServer())then
    self:GetParent():EmitSound("Hero_ObsidianDestroyer.AstralImprisonment.Cast")
    self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_tutien_thattuyetsatquang_active",{duration=self.duration})
  end
  
end
function modifier_tutien_thattuyetsatquang:OnCreated( kv )
  local p = self:GetParent()
  local skill_level=self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.duration=skill_level+5
  self:StartIntervalThink(SETTING_INTERVAL)
  self:SetDuration(SETTING_INTERVAL,true)
end
function modifier_tutien_thattuyetsatquang:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level=self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.duration=skill_level+5
end

function modifier_tutien_thattuyetsatquang:DestroyOnExpire()
    return false
end