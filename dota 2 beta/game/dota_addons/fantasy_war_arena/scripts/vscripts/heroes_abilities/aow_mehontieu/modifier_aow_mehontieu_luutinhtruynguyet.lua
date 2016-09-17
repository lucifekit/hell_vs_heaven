modifier_aow_mehontieu_luutinhtruynguyet = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_luutinhtruynguyet:IsHidden()
   return true
end

function modifier_aow_mehontieu_luutinhtruynguyet:RemoveOnDeath()
   return false
end

function modifier_aow_mehontieu_luutinhtruynguyet:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_aow_mehontieu_luutinhtruynguyet:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_mehontieu_luutinhtruynguyet:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_luutinhtruynguyet:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_luutinhtruynguyet:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_luutinhtruynguyet:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_luutinhtruynguyet:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_luutinhtruynguyet:OnDestroy()
self:GainBack()
end
