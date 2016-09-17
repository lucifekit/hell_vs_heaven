modifier_chuongcai_hoatbatluuthu = class({})
require('kem_lib/kem')
function modifier_chuongcai_hoatbatluuthu:IsHidden()
   return false
end

function modifier_chuongcai_hoatbatluuthu:RemoveOnDeath()
   return false
end
function modifier_chuongcai_hoatbatluuthu:GetEffectName()
  return "particles/edited_particle/chuong_cai/speed.vpcf"
end
function modifier_chuongcai_hoatbatluuthu:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_chuongcai_hoatbatluuthu:GetModifierMoveSpeedBonus_Constant( params)
  
    return self.speed
end

--function modifier_chuongcai_hoatbatluuthu:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chuongcai_hoatbatluuthu:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
   self.speed = (10+skill_level*3)*settings.speed_base
   if(IsServer())then
      
   end
end

function modifier_chuongcai_hoatbatluuthu:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_hoatbatluuthu:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_hoatbatluuthu:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_hoatbatluuthu:OnDestroy()
self:GainBack()
end
