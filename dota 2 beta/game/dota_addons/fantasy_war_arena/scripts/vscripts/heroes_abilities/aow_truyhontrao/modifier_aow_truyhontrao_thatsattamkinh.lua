modifier_aow_truyhontrao_thatsattamkinh = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_thatsattamkinh:IsHidden()
   return true
end

function modifier_aow_truyhontrao_thatsattamkinh:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_thatsattamkinh:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_truyhontrao_thatsattamkinh:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_thatsattamkinh:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_thatsattamkinh:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_thatsattamkinh:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_thatsattamkinh:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_thatsattamkinh:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_thatsattamkinh:OnDestroy()
self:GainBack()
end