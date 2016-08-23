modifier_fear = class({})

LinkLuaModifier("modifier_fear_moving","modifiers/modifier_fear_moving",LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
function modifier_fear:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_fear:GetEffectName()
  return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf"
end

function modifier_fear:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true,
  }
 
  return state
end
function modifier_fear:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_slow:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return -200
end
function modifier_fear:Move()
  local new_position = self:GetParent():GetOrigin()
  new_position = new_position+Vector(math.random(-500,500),math.random(-500,500),0)
   local table = {
        UnitIndex=self:GetParent():entindex(),
        OrderType=DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position=new_position}
  self:GetParent():RemoveModifierByName("modifier_fear_moving")
  ExecuteOrderFromTable(table)
  
  self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_fear_moving",{})
end
function modifier_fear:OnIntervalThink()
    if(IsServer())then
      self:Move()
      
    end
end
function modifier_fear:OnCreated()
  if(IsServer())then
    self:Move()
    self:StartIntervalThink(0.5)
  end
  
end

function modifier_fear:OnRefresh()
  
end
function modifier_fear:OnDestroy()
  if(IsServer())then
    self:StartIntervalThink(-1)
    print("remove moving")
    self:GetParent():RemoveModifierByName("modifier_fear_moving")
    print("removed moving")
  end
end