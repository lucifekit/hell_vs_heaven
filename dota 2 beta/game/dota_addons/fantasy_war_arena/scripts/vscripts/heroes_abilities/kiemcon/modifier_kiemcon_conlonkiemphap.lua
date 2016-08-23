modifier_kiemcon_conlonkiemphap = class({})
require('kem_lib/kem')
function modifier_kiemcon_conlonkiemphap:IsHidden()
   return true
end

function modifier_kiemcon_conlonkiemphap:RemoveOnDeath()
   return false
end

function modifier_kiemcon_conlonkiemphap:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_kiemcon_conlonkiemphap:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_kiemcon_conlonkiemphap:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_conlonkiemphap:OnCreated( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = 5+skill_level*2
  -- BASIC TALENT
--local attack_speed = 5+2*skill_level
--local element_damage = 0+70*skill_level
--local critical_chance = 30+4*skill_level
  
end

function modifier_kiemcon_conlonkiemphap:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.atk_speed = 5+skill_level*2
end
