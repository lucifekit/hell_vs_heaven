modifier_aow_truyhontrao_quytraothamu = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_quytraothamu:IsHidden()
   return true
end

function modifier_aow_truyhontrao_quytraothamu:RemoveOnDeath()
   return false
end



function modifier_aow_truyhontrao_quytraothamu:CheckState()
   local state = {
     [MODIFIER_STATE_STUNNED] = true
   }
return state
end


function modifier_aow_truyhontrao_quytraothamu:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_quytraothamu:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_quytraothamu:OnCreated( kv )
  
  local caster = self:GetParent()
  self:Apply()
end

function modifier_aow_truyhontrao_quytraothamu:OnRefresh( kv )
  self:GainBack()
  self:Apply()
end

function modifier_aow_truyhontrao_quytraothamu:OnDestroy()
  self:GainBack()
  if(IsServer())then
  
  end
end
