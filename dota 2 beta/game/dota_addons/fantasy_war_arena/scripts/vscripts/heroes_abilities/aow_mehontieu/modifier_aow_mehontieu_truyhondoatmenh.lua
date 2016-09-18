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
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end
function modifier_aow_mehontieu_truyhondoatmenh:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
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



function modifier_aow_mehontieu_truyhondoatmenh:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.atk_speed = skill_level*2
   if(IsServer())then
    p.thdm_critical_chance = 50+skill_level*20
    p.critical_chance = p.critical_chance+p.thdm_critical_chance
    UpdatePlayerDataForHero(p)
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
    
    p.critical_chance = p.critical_chance-p.thdm_critical_chance
    p.thdm_critical_chance = 0
    UpdatePlayerDataForHero(p)
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
