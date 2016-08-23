modifier_tutien_tanghondinh_allies = class({})
require('kem_lib/kem')
function modifier_tutien_tanghondinh_allies:IsHidden()
   return false
end
function modifier_tutien_tanghondinh_allies:GetEffectName()
   return "particles/edited_particle/tu_tien/thd.vpcf"
end

function modifier_tutien_tanghondinh_allies:RemoveOnDeath()
   return true
end
function modifier_tutien_tanghondinh_allies:Apply()
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  local critical_chance = 150+30*skill_level
  local hero = self:GetParent()
  if(hero.inited)then
      hero.thd_critical_chance = critical_chance
      hero.critical_chance = hero.critical_chance +critical_chance
  end
  UpdatePlayerDataForHero(hero)
end
function modifier_tutien_tanghondinh_allies:GainBack()
  local hero = self:GetParent()
  if(hero.inited)then
      hero.critical_chance = hero.critical_chance-hero.thd_critical_chance
      hero.thd_critical_chance = 0 
  end
  UpdatePlayerDataForHero(hero)
end
function modifier_tutien_tanghondinh_allies:OnCreated( kv )
  if(IsServer())then
   self:Apply() 
  end

end

function modifier_tutien_tanghondinh_allies:OnRefresh( kv )
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end

end

function modifier_tutien_tanghondinh_allies:OnDestroy( kv )
  if(IsServer())then
  self:GainBack()
  end

end