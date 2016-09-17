modifier_aow_mehontieu_phitanthienhoa = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_phitanthienhoa:IsHidden()
   return true
end

function modifier_aow_mehontieu_phitanthienhoa:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_phitanthienhoa:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_mehontieu_phitanthienhoa:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_mehontieu_phitanthienhoa:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_phitanthienhoa:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_phitanthienhoa:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_phitanthienhoa:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_phitanthienhoa:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_phitanthienhoa:OnDestroy()
self:GainBack()
end
