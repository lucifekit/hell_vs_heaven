modifier_boss_hokhon_poison= class({})
function modifier_boss_hokhon_poison:IsHidden()
   return false
end

function modifier_boss_hokhon_poison:RemoveOnDeath()
   return false
end
function modifier_boss_hokhon_poison:IsAura()
   return true
end
function modifier_boss_hokhon_poison:GetEffectName()
   return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end
function modifier_boss_hokhon_poison:GetTexture()
   return "alchemist_acid_spray"
end
function modifier_boss_hokhon_poison:GetAuraRadius()
   return 200
end
LinkLuaModifier("modifier_boss_hokhon_poison_target","bosses/modifier_boss_hokhon_poison_target", LUA_MODIFIER_MOTION_NONE )

function modifier_boss_hokhon_poison:GetModifierAura()
  return "modifier_boss_hokhon_poison_target"
end
function modifier_boss_hokhon_poison:GetAuraEntityReject(h)
   if(h==self:GetParent())then
    return true
   end
   return false
end

function modifier_boss_hokhon_poison:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_boss_hokhon_poison:GetAuraSearchType()
   return DOTA_UNIT_TARGET_ALL
end
function modifier_boss_hokhon_poison:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end


