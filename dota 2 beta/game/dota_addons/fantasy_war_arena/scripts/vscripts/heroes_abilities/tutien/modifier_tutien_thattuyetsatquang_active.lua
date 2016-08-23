modifier_tutien_thattuyetsatquang_active = class({})
require('kem_lib/kem')
function modifier_tutien_thattuyetsatquang_active:IsHidden()
   return false
end

function modifier_tutien_thattuyetsatquang_active:RemoveOnDeath()
   return true
end
function modifier_tutien_thattuyetsatquang_active:GetEffectName()
   return "particles/edited_particle/tu_tien/ttsq.vpcf"
end


function modifier_tutien_thattuyetsatquang_active:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_tutien_thattuyetsatquang_active:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_tutien_thattuyetsatquang:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_thattuyetsatquang_active:Apply()
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)

  local critical_chance = 50+25*skill_level
  local maim_chance_increase = 10+18*skill_level

  local hero = self:GetParent()
  if(hero.inited)then
      hero.ttsq_critical_chance = critical_chance
      hero.ttsq_maim_chance_increase = maim_chance_increase
      hero.critical_chance = hero.critical_chance +hero.ttsq_critical_chance
      hero.effect_maim_add_percent = hero.effect_maim_add_percent+hero.ttsq_maim_chance_increase
      UpdatePlayerDataForHero(hero) 
  end
  
end
function modifier_tutien_thattuyetsatquang_active:GainBack()
  local hero = self:GetParent()
  if(hero.inited)then
      
      hero.critical_chance = hero.critical_chance -hero.ttsq_critical_chance
      hero.effect_maim_add_percent = hero.effect_maim_add_percent-hero.ttsq_maim_chance_increase 
      hero.ttsq_critical_chance = 0
      hero.ttsq_maim_chance_increase = 0
      UpdatePlayerDataForHero(hero)
  end
  
end

function modifier_tutien_thattuyetsatquang_active:OnCreated( kv )
  local p = self:GetParent()
	local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 10+2*skill_level
  -- MOON FALL

  if(IsServer())then
    self:Apply()
  end
  
end

function modifier_tutien_thattuyetsatquang_active:OnRefresh()
  local p = self:GetParent()
	local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.atk_speed = 10+2*skill_level
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end
  
end
function modifier_tutien_thattuyetsatquang_active:OnDestroy()
  if(IsServer())then
    self:GainBack()
  end
end
