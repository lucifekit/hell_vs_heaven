modifier_aow_truyhontrao_huyennguyenkinh = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_huyennguyenkinh:IsHidden()
   return true
end

function modifier_aow_truyhontrao_huyennguyenkinh:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_huyennguyenkinh:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
   MODIFIER_EVENT_ON_DEATH
}
return funcs
end

function modifier_aow_truyhontrao_huyennguyenkinh:GetModifierExtraHealthPercentage( params)
  return self.extra_hp_percentage
end


LinkLuaModifier("modifier_aow_truyhontrao_soul","heroes_abilities/aow_truyhontrao/modifier_aow_truyhontrao_soul",LUA_MODIFIER_MOTION_NONE)


function modifier_aow_truyhontrao_huyennguyenkinh:OnDeath( params)
  if(IsServer())then
    local p = self:GetParent()
    if(p==params.attacker)then
      local modi = p:AddNewModifier(p,self:GetAbility(),"modifier_aow_truyhontrao_soul",{duration=self.duration})
      if(modi:GetStackCount()<self.max_stack)then
        modi:IncrementStackCount()
      end
    end
  end
end

--function modifier_aow_truyhontrao_huyennguyenkinh:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_huyennguyenkinh:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.extra_hp_percentage = 0.08*skill_level
   self.max_stack=5+skill_level
   self.duration=70+10*skill_level
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_huyennguyenkinh:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_huyennguyenkinh:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_huyennguyenkinh:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_huyennguyenkinh:OnDestroy()
self:GainBack()
end
