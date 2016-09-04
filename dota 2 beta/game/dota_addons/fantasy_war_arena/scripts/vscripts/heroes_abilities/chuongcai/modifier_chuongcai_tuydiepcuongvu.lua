modifier_chuongcai_tuydiepcuongvu = class({})
require('kem_lib/kem')
function modifier_chuongcai_tuydiepcuongvu:IsHidden()
   return true
end

function modifier_chuongcai_tuydiepcuongvu:RemoveOnDeath()
   return false
end

function modifier_chuongcai_tuydiepcuongvu:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
return funcs
end

function modifier_chuongcai_tuydiepcuongvu:GetModifierIncomingDamage_Percentage( params)
  return self.incoming_damage
end


LinkLuaModifier("modifier_chuongcai_tuydiepcuongvu_target","heroes_abilities/chuongcai/modifier_chuongcai_tuydiepcuongvu_target",LUA_MODIFIER_MOTION_NONE)
function modifier_chuongcai_tuydiepcuongvu:ActiveOnHit(target)
  if(not target:HasModifier("modifier_chuongcai_tuydiepcuongvu_target"))then
    local tempModifier = target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_chuongcai_tuydiepcuongvu_target",{duration=60})
    tempModifier:SetStackCount(3)
  end
  
end

function modifier_chuongcai_tuydiepcuongvu:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    
    ---- DRAGON WINE
local reduce_damage = math.ceil(1.5*skill_level)
self.incoming_damage = reduce_damage 

    
   end
end

function modifier_chuongcai_tuydiepcuongvu:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_tuydiepcuongvu:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_tuydiepcuongvu:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_tuydiepcuongvu:OnDestroy()
self:GainBack()
end
