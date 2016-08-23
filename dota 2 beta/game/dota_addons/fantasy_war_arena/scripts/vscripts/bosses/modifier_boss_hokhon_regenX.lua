modifier_boss_hokhon_regenX= class({})
function modifier_boss_hokhon_regenX:IsHidden()
   return true
end

function modifier_boss_hokhon_regenX:RemoveOnDeath()
   return false
end
function modifier_boss_hokhon_regenX:IsAura()
   return true
end

function modifier_boss_hokhon_regenX:GetAuraRadius()
   return 800
end

LinkLuaModifier("modifier_boss_hokhon_regenX_target","bosses/modifier_boss_hokhon_regenX_target", LUA_MODIFIER_MOTION_NONE )

function modifier_boss_hokhon_regenX:GetModifierAura()
  return "modifier_boss_hokhon_regenX_target"
end
--function modifier_boss_hokhon_reflect:GetAuraEntityReject(h)
--   if(h==self:GetParent())then
--    return true
--   end
--   return false
--end

function modifier_boss_hokhon_regenX:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_boss_hokhon_regenX:GetAuraSearchType()
   return DOTA_UNIT_TARGET_ALL
end
function modifier_boss_hokhon_regenX:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_boss_hokhon_regenX:GetAuraEntityReject(h)
   return false
end
