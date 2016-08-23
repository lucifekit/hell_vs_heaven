
modifier_fear_moving = class({})
--------------------------------------------------------------------------------
function modifier_fear_moving:IsHidden()
  return true
end
function modifier_fear_moving:CheckState()
  local state = {
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true
  }
 
  return state
end
