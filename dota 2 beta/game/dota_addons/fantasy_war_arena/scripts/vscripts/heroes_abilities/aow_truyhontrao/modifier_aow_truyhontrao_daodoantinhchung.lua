modifier_aow_truyhontrao_daodoantinhchung = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_daodoantinhchung:IsHidden()
   return true
end

function modifier_aow_truyhontrao_daodoantinhchung:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_daodoantinhchung:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_truyhontrao_daodoantinhchung:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_daodoantinhchung:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_daodoantinhchung:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_daodoantinhchung:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_daodoantinhchung:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_daodoantinhchung:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_daodoantinhchung:OnDestroy()
self:GainBack()
end
