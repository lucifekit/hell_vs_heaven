modifier_aow_truyhontrao_truyhontrao_basic = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_truyhontrao_basic:IsHidden()
   return true
end

function modifier_aow_truyhontrao_truyhontrao_basic:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_truyhontrao_basic:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_truyhontrao_truyhontrao_basic:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_truyhontrao_basic:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_truyhontrao_basic:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_truyhontrao_basic:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_truyhontrao_basic:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_truyhontrao_basic:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_truyhontrao_basic:OnDestroy()
self:GainBack()
end
