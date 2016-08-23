modifier_boss_hokhon_casting= class({})
function modifier_boss_hokhon_casting:IsHidden()
   return false
end

function modifier_boss_hokhon_casting:RemoveOnDeath()
   return true
end

function modifier_boss_hokhon_casting:CheckState()
  local state = {
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED] = true,
  }
 
  return state
end


--function modifier_boss_hokhon_casting:GetOverrideAnimation( params )
--  return ACT_DOTA_ATTACK
--end