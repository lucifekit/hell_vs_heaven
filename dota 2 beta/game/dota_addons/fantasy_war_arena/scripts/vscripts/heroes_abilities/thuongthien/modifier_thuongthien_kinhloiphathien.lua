modifier_thuongthien_kinhloiphathien = class({})
require('kem_lib/kem')

SETTING_HEALTH_PROC=25

SETTING_COOLDOWN=30
SETTING_BUFF_MODIFIER  = "modifier_thuongthien_kinhloiphathien_critical"
LinkLuaModifier(SETTING_BUFF_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_BUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_BUFF_MODIFIER_2  = "modifier_thuongthien_kinhloiphathien_invulnerable"
LinkLuaModifier(SETTING_BUFF_MODIFIER_2,"heroes_abilities/thuongthien/"..SETTING_BUFF_MODIFIER_2, LUA_MODIFIER_MOTION_NONE )
function modifier_thuongthien_kinhloiphathien:IsHidden()
   return true
end

function modifier_thuongthien_kinhloiphathien:RemoveOnDeath()
   return false
end

function modifier_thuongthien_kinhloiphathien:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end
function modifier_thuongthien_kinhloiphathien:OnTakeDamage(params)
  if(self:GetAbility():IsCooldownReady())then
    local caster = self:GetCaster()
    if(caster:GetHealthPercent()<SETTING_HEALTH_PROC)then
        self:GetAbility():StartCooldown(SETTING_COOLDOWN)
        caster:AddNewModifier( caster, self:GetAbility(),SETTING_BUFF_MODIFIER, { duration = self.buff_duration } )
        caster:AddNewModifier( caster, self:GetAbility(),SETTING_BUFF_MODIFIER_2, { duration = self.invulnerable_duration } )
    end
  end
end
--function modifier_thuongthien_kinhloiphathien::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_kinhloiphathien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_kinhloiphathien:OnCreated( kv )
  
  -- DANGER ZONE
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.invulnerable_duration = 0.83+0.334*skill_level
  self.buff_duration = 15
  
end

function modifier_thuongthien_kinhloiphathien:OnRefresh( kv )
  local p=self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.invulnerable_duration = 0.83+0.334*skill_level
  self.buff_duration = 15
end
