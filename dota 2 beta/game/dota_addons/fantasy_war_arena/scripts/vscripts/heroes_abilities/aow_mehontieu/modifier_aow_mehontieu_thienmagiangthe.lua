modifier_aow_mehontieu_thienmagiangthe = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_thienmagiangthe:IsHidden()
   return true
end

function modifier_aow_mehontieu_thienmagiangthe:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_thienmagiangthe:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_mehontieu_thienmagiangthe:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_mehontieu_thienmagiangthe:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_thienmagiangthe:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thienmagiangthe:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thienmagiangthe:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_thienmagiangthe:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_thienmagiangthe:OnDestroy()
self:GainBack()
end
