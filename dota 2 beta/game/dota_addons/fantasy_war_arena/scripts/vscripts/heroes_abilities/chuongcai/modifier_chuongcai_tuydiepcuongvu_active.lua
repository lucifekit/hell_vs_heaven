modifier_chuongcai_tuydiepcuongvu_active = class({})
require('kem_lib/kem')
function modifier_chuongcai_tuydiepcuongvu_active:IsHidden()
   return false
end

function modifier_chuongcai_tuydiepcuongvu_active:RemoveOnDeath()
   return true
end
function modifier_chuongcai_tuydiepcuongvu_active:GetEffectName()
  return "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf"
end

function modifier_chuongcai_tuydiepcuongvu_active:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
      local drunk_basic_damage_reduce = 0.06*skill_level
      local drunk_skill_damage_reduce = 0.06*skill_level
      p.tdcv_drunk_basic_damage = drunk_basic_damage_reduce
      p.tdcv_drunk_skill_damage = drunk_skill_damage_reduce
      p.basic_damage_percent = math.max(0,p.basic_damage_percent-p.tdcv_drunk_basic_damage)
      p.skill_amplify = math.max(0,p.skill_amplify-p.tdcv_drunk_skill_damage)
      UpdatePlayerDataForHero(p)
   end
end

function modifier_chuongcai_tuydiepcuongvu_active:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
      p.tdcv_drunk_basic_damage = 0
      p.tdcv_drunk_skill_damage = 0
      p.basic_damage_percent = p.basic_damage_percent+p.tdcv_drunk_basic_damage
      p.skill_amplify = p.skill_amplify+p.tdcv_drunk_skill_damage
      UpdatePlayerDataForHero(p)
   end
end

function modifier_chuongcai_tuydiepcuongvu_active:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_tuydiepcuongvu_active:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_tuydiepcuongvu_active:OnDestroy()
self:GainBack()
end
