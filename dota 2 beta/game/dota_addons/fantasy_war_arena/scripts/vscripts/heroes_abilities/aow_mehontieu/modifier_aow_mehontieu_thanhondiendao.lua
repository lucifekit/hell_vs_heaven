modifier_aow_mehontieu_thanhondiendao = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_thanhondiendao:IsHidden()
   return true
end

function modifier_aow_mehontieu_thanhondiendao:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_thanhondiendao:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_mehontieu_thanhondiendao:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_mehontieu_thanhondiendao:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_thanhondiendao:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thanhondiendao:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thanhondiendao:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_thanhondiendao:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_thanhondiendao:OnDestroy()
self:GainBack()
end
