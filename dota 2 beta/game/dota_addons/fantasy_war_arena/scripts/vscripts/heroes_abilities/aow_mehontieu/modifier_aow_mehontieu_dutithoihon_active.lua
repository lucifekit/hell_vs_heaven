modifier_aow_mehontieu_dutithoihon_active = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_dutithoihon_active:IsHidden()
   return false
end

function modifier_aow_mehontieu_dutithoihon_active:RemoveOnDeath()
   return true
end
function modifier_aow_mehontieu_dutithoihon_active:GetEffectName()
  return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end
function modifier_aow_mehontieu_dutithoihon_active:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_aow_mehontieu_dutithoihon_active:GetModifierMoveSpeedBonus_Constant( params)
  return self.speed
end

--function modifier_aow_mehontieu_dutithoihon:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_dutithoihon_active:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
   local settings = CustomNetTables:GetTableValue( "kem_settings", "global")     
   self.speed = (skill_level*3)*settings.speed_base
end

function modifier_aow_mehontieu_dutithoihon_active:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_dutithoihon_active:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_dutithoihon_active:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_dutithoihon_active:OnDestroy()
self:GainBack()
end
