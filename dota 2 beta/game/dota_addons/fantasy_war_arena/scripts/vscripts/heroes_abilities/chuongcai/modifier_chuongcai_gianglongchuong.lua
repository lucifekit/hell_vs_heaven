modifier_chuongcai_gianglongchuong = class({})
require('kem_lib/kem')
function modifier_chuongcai_gianglongchuong:IsHidden()
   return true
end

function modifier_chuongcai_gianglongchuong:RemoveOnDeath()
   return false
end

function modifier_chuongcai_gianglongchuong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end



--function modifier_chuongcai_gianglongchuong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chuongcai_gianglongchuong:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_gianglongchuong:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_gianglongchuong:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_gianglongchuong:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_gianglongchuong:OnDestroy()
self:GainBack()
end
