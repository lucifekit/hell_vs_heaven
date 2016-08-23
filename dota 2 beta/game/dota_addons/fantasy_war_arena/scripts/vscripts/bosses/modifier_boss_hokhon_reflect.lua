modifier_boss_hokhon_reflect= class({})
function modifier_boss_hokhon_reflect:IsHidden()
   return true
end

function modifier_boss_hokhon_reflect:RemoveOnDeath()
   return false
end
function modifier_boss_hokhon_reflect:IsAura()
   return true
end
function modifier_boss_hokhon_reflect:GetEffectName()
   return "particles/items_fx/blademail.vpcf"
end
function modifier_boss_hokhon_reflect:GetAuraRadius()
   return 800
end
LinkLuaModifier("modifier_boss_hokhon_reflect_target","bosses/modifier_boss_hokhon_reflect_target", LUA_MODIFIER_MOTION_NONE )

function modifier_boss_hokhon_reflect:GetModifierAura()
  return "modifier_boss_hokhon_reflect_target"
end
--function modifier_boss_hokhon_reflect:GetAuraEntityReject(h)
--   if(h==self:GetParent())then
--    return true
--   end
--   return false
--end

function modifier_boss_hokhon_reflect:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_boss_hokhon_reflect:GetAuraSearchType()
   return DOTA_UNIT_TARGET_ALL
end
function modifier_boss_hokhon_reflect:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end
function modifier_boss_hokhon_reflect:GetAuraEntityReject(h)
   return false
end


