modifier_skill_level = class({})
--------------------------------------------------------------------------------
function modifier_skill_level:RemoveOnDeath()
  return false
end
function modifier_skill_level:IsPurgable()
  return false
end
function modifier_skill_level:IsDebuff()
  return false
end
function modifier_skill_level:IsHidden()
  return true
end
