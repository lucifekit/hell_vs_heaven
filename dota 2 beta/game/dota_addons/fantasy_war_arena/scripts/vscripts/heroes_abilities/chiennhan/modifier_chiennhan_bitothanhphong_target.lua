modifier_chiennhan_bitothanhphong_target = class({})
require('kem_lib/kem')
function modifier_chiennhan_bitothanhphong_target:IsHidden()
   return false
end

function modifier_chiennhan_bitothanhphong_target:RemoveOnDeath()
   return true
end

--------------------------------------------------------------------------------
function modifier_chiennhan_bitothanhphong_target:GetEffectAttachType()
  return PATTACH_CUSTOMORIGIN_FOLLOW
end
function modifier_chiennhan_bitothanhphong_target:GetEffectName()
  return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end


--------------------------------------------------------------------------------
function modifier_chiennhan_bitothanhphong_target:Apply()

  if(IsServer())then
    
    
    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local accuracy_chance_reduce = math.floor(5.5+28.88*skill_level)
    local evade = math.floor(38.89+22.222*skill_level)
    local maim_time_increase = math.floor(2.78+24.444*skill_level)
    local hero = self:GetParent()
    if(hero.accuracy_chance)then
        hero.bttp_accuracy_chance_reduce = accuracy_chance_reduce
        hero.accuracy_chance = hero.accuracy_chance - accuracy_chance_reduce
        hero.bttp_evade = evade
        hero.evade_point = hero.evade_point - evade
        hero.bttp_maim_time_increase = maim_time_increase
        hero.effect_maim_reduce_time =hero.effect_maim_reduce_time -maim_time_increase
        UpdatePlayerDataForHero(hero)
    end
    
  end

end
function modifier_chiennhan_bitothanhphong_target:GainBack()
  if(IsServer())then
    local hero = self:GetParent()
    if(hero.accuracy_chance)then
        hero.accuracy_chance = hero.accuracy_chance+hero.bttp_accuracy_chance_reduce
        hero.evade_point = hero.evade_point+hero.bttp_evade
        hero.effect_maim_reduce_time =hero.effect_maim_reduce_time+hero.bttp_maim_time_increase 
        hero.bttp_accuracy_chance_reduce = 0
        hero.bttp_evade = 0
        hero.bttp_maim_time_increase = 0
        UpdatePlayerDataForHero(hero)
    end
    
  end
end

function modifier_chiennhan_bitothanhphong_target:OnCreated( kv )
  if(IsServer())then
  self:Apply()  
  end

  
end

--------------------------------------------------------------------------------
function modifier_chiennhan_bitothanhphong_target:OnRefresh( kv )
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end

end

function modifier_chiennhan_bitothanhphong_target:OnDestroy( kv )
  if(IsServer())then
    self:GainBack()    
  end

end