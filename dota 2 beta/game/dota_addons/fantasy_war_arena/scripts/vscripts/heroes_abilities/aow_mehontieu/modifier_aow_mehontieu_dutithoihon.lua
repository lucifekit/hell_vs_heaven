modifier_aow_mehontieu_dutithoihon = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_dutithoihon:IsHidden()
   return false
end

function modifier_aow_mehontieu_dutithoihon:RemoveOnDeath()
   return true
end
function modifier_aow_mehontieu_dutithoihon:GetEffectName()
  return "particles/edited_particle/aow_mehontieu/dtth_cascade.vpcf"
end
function modifier_aow_mehontieu_dutithoihon:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
   
}
return funcs
end

function modifier_aow_mehontieu_dutithoihon:GetModifierMoveSpeedBonus_Constant( params)
  return self.speed
end

LinkLuaModifier("modifier_aow_mehontieu_dutithoihon_active","heroes_abilities/aow_mehontieu/modifier_aow_mehontieu_dutithoihon_active",LUA_MODIFIER_MOTION_NONE)

function modifier_aow_mehontieu_dutithoihon:OnDefense()
  if(IsServer())then
    print("Defense success du ti thoi hon")
    self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_aow_mehontieu_dutithoihon_active",{duration=60})
  end
end

function modifier_aow_mehontieu_dutithoihon:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
   local settings = CustomNetTables:GetTableValue( "kem_settings", "global")     
   self.speed = (10+skill_level*3)*settings.speed_base
   self.active_chance = 25+skill_level*5
end

function modifier_aow_mehontieu_dutithoihon:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_dutithoihon:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_dutithoihon:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_dutithoihon:OnDestroy()
self:GainBack()
end
