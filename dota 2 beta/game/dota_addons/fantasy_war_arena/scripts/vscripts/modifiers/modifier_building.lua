modifier_building = class({})
--------------------------------------------------------------------------------
function modifier_building:RemoveOnDeath()
  return true
end
function modifier_building:GetEffectName()
  return "particles/items_fx/healing_flask.vpcf"
end
function modifier_building:GetEffectAttachType()
  return "follow_origin"
end
function modifier_building:GetTexture()
  return "item_flask"
end

function modifier_building:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_DISABLE_TURNING,
    MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
  }
 
  return funcs
end

function modifier_building:GetModifierDisableTurning()
  return 1 
end

function modifier_building:GetModifierIgnoreCastAngle()
  return 1 
end

function modifier_building:IsPassive()
  return false
end
function modifier_building:IsHidden()
  return false
end
function modifier_building:IsBuff()
  return false
end
function modifier_building:IsDebuff()
  return false
end
function modifier_building:IsPurgeable()
  return false
end
