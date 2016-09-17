modifier_aow_mehontieu_thienlytruyhon = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_thienlytruyhon:IsHidden()
   return true
end

function modifier_aow_mehontieu_thienlytruyhon:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_thienlytruyhon:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_mehontieu_thienlytruyhon:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_mehontieu_thienlytruyhon:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

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
