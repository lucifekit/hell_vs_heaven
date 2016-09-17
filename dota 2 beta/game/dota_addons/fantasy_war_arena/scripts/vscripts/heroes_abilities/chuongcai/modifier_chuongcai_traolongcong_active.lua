modifier_chuongcai_traolongcong_active = class({})
require('kem_lib/kem')
function modifier_chuongcai_traolongcong_active:IsHidden()
   return false
end

function modifier_chuongcai_traolongcong_active:RemoveOnDeath()
   return true
end
function modifier_chuongcai_traolongcong_active:GetEffectName()
  return "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf"
end

function modifier_chuongcai_traolongcong_active:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
      local tlc_resist_return_damage = 0.2+0.08*skill_level
      local tlc_active_damage = 0.02*skill_level
      local tlc_active_skill =  0.02*skill_level
      local tlc_active_drain = 0.02*skill_level
      
      p.tlc_resist_return_damage = tlc_resist_return_damage
      p.tlc_active_damage = tlc_active_damage
      p.tlc_active_skill = tlc_active_skill
      p.tlc_active_drain = tlc_active_drain
      
      p.basic_damage_percent = p.basic_damage_percent+p.tlc_active_damage
      p.skill_amplify = p.skill_amplify+p.tlc_active_skill
      p.hp_drain = p.hp_drain+p.tlc_active_drain
      p.return_damage_resist = p.return_damage_resist +p.tlc_resist_return_damage
      UpdatePlayerDataForHero(p)
   end
end

function modifier_chuongcai_traolongcong_active:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
      
      
      p.basic_damage_percent = p.basic_damage_percent-p.tlc_active_damage
      p.skill_amplify = p.skill_amplify-p.tlc_active_skill
      p.hp_drain = p.hp_drain-p.tlc_active_drain
      p.return_damage_resist = p.return_damage_resist -p.tlc_resist_return_damage
      
      p.tlc_resist_return_damage = 0
      p.tlc_active_damage = 0
      p.tlc_active_skill = 0
      p.tlc_active_drain = 0
      UpdatePlayerDataForHero(p)
   end
end

function modifier_chuongcai_traolongcong_active:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_traolongcong_active:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_traolongcong_active:OnDestroy()
self:GainBack()
end
