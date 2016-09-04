modifier_chiennhan_bitothanhphong = class({})
require('kem_lib/kem')
function modifier_chiennhan_bitothanhphong:IsHidden()
   return true
end

function modifier_chiennhan_bitothanhphong:RemoveOnDeath()
   return false
end
DEBUFF_BITOTHANHPHONG = "modifier_chiennhan_bitothanhphong_target"
LinkLuaModifier(DEBUFF_BITOTHANHPHONG,"heroes_abilities/chiennhan/"..DEBUFF_BITOTHANHPHONG, LUA_MODIFIER_MOTION_NONE )

function modifier_chiennhan_bitothanhphong:ActiveOnHit(target)
  local caster = self:GetParent()
  local skill_bitothanhphong = self:GetAbility()
  local level_bitothanhphong = skill_bitothanhphong:GetLevel()+GetSkillLevel(caster)
  target:AddNewModifier(caster,skill_bitothanhphong,DEBUFF_BITOTHANHPHONG,{duration=180})
end