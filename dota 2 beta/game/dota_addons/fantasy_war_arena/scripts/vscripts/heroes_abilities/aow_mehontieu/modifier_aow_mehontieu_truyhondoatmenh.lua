modifier_aow_mehontieu_truyhondoatmenh = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_truyhondoatmenh:IsHidden()
   return false
end

function modifier_aow_mehontieu_truyhondoatmenh:RemoveOnDeath()
   return true
end




function modifier_aow_mehontieu_truyhondoatmenh:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end

LinkLuaModifier("modifier_aow_mehontieu_doathon","heroes_abilities/aow_mehontieu/modifier_aow_mehontieu_doathon",LUA_MODIFIER_MOTION_NONE)

function modifier_aow_mehontieu_truyhondoatmenh:ActiveOnHit(target)
  if(IsServer())then
   
     local modifier = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_aow_mehontieu_doathon",{duration=30})
     if(modifier:GetStackCount()<20)then
      modifier:IncrementStackCount()
     end
    
  end
end

--function modifier_aow_mehontieu_truyhondoatmenh:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_mehontieu_truyhondoatmenh:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   
   end
   self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)
   ParticleManager:SetParticleControlEnt(self.particle, 1, p, PATTACH_POINT_FOLLOW, "attach_origin", p:GetAbsOrigin(), true)
   ParticleManager:SetParticleControlEnt(self.particle, 2, p, PATTACH_POINT_FOLLOW, "attach_origin", p:GetAbsOrigin(), true)
   ParticleManager:SetParticleControlEnt(self.particle, 3, p, PATTACH_POINT_FOLLOW, "attach_origin", p:GetAbsOrigin(), true)
end

function modifier_aow_mehontieu_truyhondoatmenh:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
   ParticleManager:DestroyParticle(self.particle,true)
end

function modifier_aow_mehontieu_truyhondoatmenh:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_truyhondoatmenh:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_truyhondoatmenh:OnDestroy()
self:GainBack()
end
