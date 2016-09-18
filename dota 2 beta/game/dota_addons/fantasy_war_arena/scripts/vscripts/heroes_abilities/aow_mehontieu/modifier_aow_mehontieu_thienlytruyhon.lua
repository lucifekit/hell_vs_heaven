modifier_aow_mehontieu_thienlytruyhon = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_thienlytruyhon:IsHidden()
   return false
end

function modifier_aow_mehontieu_thienlytruyhon:RemoveOnDeath()
   return false
end
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_luchopkinh"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER,LUA_MODIFIER_MOTION_NONE)
function modifier_aow_mehontieu_thienlytruyhon:OnCriticalHit(target)
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
      --print("On critical hit thien ly truy hon, cast luc hop kinh")
      --target:SetHealth(target:GetMaxHealth())
      local modifier = target:AddNewModifier(self:GetParent(),self:GetAbility(),SETTING_SKILL_MODIFIER,{duration=20})
      if(modifier)then
        if(modifier:GetStackCount()<10)then
          modifier:IncrementStackCount()
        end
      end
   --local dexterity_multiple = 0+0.03*skill_level
   end
end

function modifier_aow_mehontieu_thienlytruyhon:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thienlytruyhon:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thienlytruyhon:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_thienlytruyhon:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_thienlytruyhon:OnDestroy()
self:GainBack()
end
