modifier_kiemcon_loidinhquyet_target = class({})
require('kem_lib/kem')
function modifier_kiemcon_loidinhquyet_target:IsHidden()
   return false
end

function modifier_kiemcon_loidinhquyet_target:RemoveOnDeath()
   return true
end

function modifier_kiemcon_loidinhquyet_target:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_kiemcon_loidinhquyet_target:GetEffectName()
  return "particles/edited_particle/kiem_con/ldq.vpcf"
end
function modifier_kiemcon_loidinhquyet_target:Apply()
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  local regen_speed = 0.05+0.02*skill_level
  local critical_damage_receive = 0.1+0.05*skill_level
  local stun_time_increase = 60+20*skill_level
  local hero = self:GetParent()
  if(hero.inited)then
    hero.ldq_regen_multi = regen_speed
    hero.hpregen_multi = hero.hpregen_multi-regen_speed
    hero.mpregen_multi = hero.mpregen_multi-regen_speed
    hero.ldq_critical_damage_receive = critical_damage_receive
    hero.critical_damage_resist = hero.critical_damage_resist-critical_damage_receive
    hero.ldq_stun_time_increase = stun_time_increase
    hero.effect_stun_reduce_time = hero.effect_stun_reduce_time-stun_time_increase
    
    UpdatePlayerDataForHero(hero)
  end
  
end
function modifier_kiemcon_loidinhquyet_target:GainBack()
  local hero = self:GetParent()
  if(hero.inited)then
      --fall back
      if(hero.ldq_regen_multi)then
        hero.hpregen_multi = hero.hpregen_multi+hero.ldq_regen_multi
        hero.mpregen_multi = hero.mpregen_multi+hero.ldq_regen_multi
      end
      
      hero.critical_damage_resist = hero.critical_damage_resist+hero.ldq_critical_damage_receive
      hero.effect_stun_reduce_time = hero.effect_stun_reduce_time+hero.ldq_stun_time_increase
      hero.ldq_regen_multi = 0
      hero.ldq_critical_damage_receive = 0
      hero.ldq_stun_time_increase = 0
      UpdatePlayerDataForHero(hero)    
  end
  
end
function modifier_kiemcon_loidinhquyet_target:OnCreated( kv )
  if(IsServer())then
    self:Apply()
  end

end

function modifier_kiemcon_loidinhquyet_target:OnRefresh( kv )
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end

end
function modifier_kiemcon_loidinhquyet_target:OnDestroy()
  if(IsServer())then
    self:GainBack()
  end

end