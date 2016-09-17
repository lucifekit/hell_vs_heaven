modifier_aow_mehontieu_mehontieu_expert = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_mehontieu_expert:IsHidden()
   return true
end

function modifier_aow_mehontieu_mehontieu_expert:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_mehontieu_expert:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_aow_mehontieu_mehontieu_expert:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_aow_mehontieu_mehontieu_expert:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_mehontieu_expert:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.atk_speed = math.floor(10+skill_level*1.6)
end

function modifier_aow_mehontieu_mehontieu_expert:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_mehontieu_expert:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_mehontieu_expert:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_mehontieu_expert:OnDestroy()
self:GainBack()
end
