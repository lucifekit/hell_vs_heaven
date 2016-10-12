modifier_aow_truyhontrao_truyhontrao_expert = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_truyhontrao_expert:IsHidden()
   return true
end

function modifier_aow_truyhontrao_truyhontrao_expert:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_truyhontrao_expert:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_truyhontrao_truyhontrao_expert:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_truyhontrao_expert:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_truyhontrao_expert:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_truyhontrao_expert:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_truyhontrao_expert:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_truyhontrao_expert:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_truyhontrao_expert:OnDestroy()
self:GainBack()
end
