modifier_chuongcai_caibangchuongphap = class({})
require('kem_lib/kem')
function modifier_chuongcai_caibangchuongphap:IsHidden()
   return true
end

function modifier_chuongcai_caibangchuongphap:RemoveOnDeath()
   return false
end

function modifier_chuongcai_caibangchuongphap:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_chuongcai_caibangchuongphap:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_chuongcai_caibangchuongphap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chuongcai_caibangchuongphap:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.atk_speed=10+skill_level
   if(IsServer())then
   end
end

function modifier_chuongcai_caibangchuongphap:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_caibangchuongphap:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_caibangchuongphap:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_caibangchuongphap:OnDestroy()
self:GainBack()
end
