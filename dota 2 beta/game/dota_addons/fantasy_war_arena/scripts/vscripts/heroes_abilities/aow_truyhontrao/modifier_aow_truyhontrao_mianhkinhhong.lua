modifier_aow_truyhontrao_mianhkinhhong = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_mianhkinhhong:IsHidden()
   return true
end

function modifier_aow_truyhontrao_mianhkinhhong:RemoveOnDeath()
   return false
end

function modifier_aow_truyhontrao_mianhkinhhong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_truyhontrao_mianhkinhhong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_mianhkinhhong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_mianhkinhhong:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_mianhkinhhong:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_mianhkinhhong:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_mianhkinhhong:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_mianhkinhhong:OnDestroy()
self:GainBack()
end
