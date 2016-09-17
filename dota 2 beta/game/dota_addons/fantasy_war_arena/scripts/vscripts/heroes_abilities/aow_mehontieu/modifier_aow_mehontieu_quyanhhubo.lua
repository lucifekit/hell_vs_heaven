modifier_aow_mehontieu_quyanhhubo = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_quyanhhubo:IsHidden()
   return true
end

function modifier_aow_mehontieu_quyanhhubo:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_quyanhhubo:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_mehontieu_quyanhhubo:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_mehontieu_quyanhhubo:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_quyanhhubo:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_quyanhhubo:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_quyanhhubo:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_quyanhhubo:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_quyanhhubo:OnDestroy()
self:GainBack()
end
