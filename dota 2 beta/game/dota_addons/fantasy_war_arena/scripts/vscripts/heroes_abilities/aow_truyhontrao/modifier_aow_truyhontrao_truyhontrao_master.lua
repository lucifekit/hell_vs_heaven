modifier_aow_truyhontrao_truyhontrao_master = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_truyhontrao_master:IsHidden()
   return true
end

function modifier_aow_truyhontrao_truyhontrao_master:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_truyhontrao_master:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_truyhontrao_truyhontrao_master:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_truyhontrao_master:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_truyhontrao_master:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_truyhontrao_master:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_truyhontrao_master:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_truyhontrao_master:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_truyhontrao_master:OnDestroy()
self:GainBack()
end
