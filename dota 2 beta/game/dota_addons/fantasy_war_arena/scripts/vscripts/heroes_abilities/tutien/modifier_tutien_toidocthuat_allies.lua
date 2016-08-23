modifier_tutien_toidocthuat_allies = class({})
require('kem_lib/kem')
function modifier_tutien_toidocthuat_allies:IsHidden()
   return false
end
function modifier_tutien_toidocthuat_allies:GetEffectName()
   return "particles/edited_particle/tu_tien/tdt.vpcf"
end

function modifier_tutien_toidocthuat_allies:RemoveOnDeath()
   return true
end
function modifier_tutien_toidocthuat_allies:Apply()
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  local critical_damage = 0.1+0.1*skill_level
  local hero = self:GetParent()
  if(hero.inited)then
      hero.tdt_critical_damage = critical_damage
      hero.critical_damage = hero.critical_damage +hero.tdt_critical_damage
  end
  UpdatePlayerDataForHero(hero)
  
end
function modifier_tutien_toidocthuat_allies:GainBack()
  local hero = self:GetParent()
  if(hero.inited)then
      hero.critical_damage = hero.critical_damage-hero.tdt_critical_damage
      hero.tdt_critical_damage = 0 
  end
  UpdatePlayerDataForHero(hero)
end
function modifier_tutien_toidocthuat_allies:OnCreated( kv )
  if(IsServer())then
    self:Apply()
  end
  
end

function modifier_tutien_toidocthuat_allies:OnRefresh( kv )
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end
 
end

function modifier_tutien_toidocthuat_allies:OnDestroy( kv )
  if(IsServer())then
    self:GainBack()
  end

end