dummy_visibility = class({})
--------------------------------------------------------------------------------

function dummy_visibility:IsHidden()
  return true
end
function dummy_visibility:RemoveOnDeath()
  return true
end

function dummy_visibility:CheckState()
  local state = {
  [MODIFIER_STATE_INVISIBLE] = true,
  }
 
  return state
end