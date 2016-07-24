modifier_creep_ai = class({})
SETTING_FIND_ENEMY_RADIUS =500
SETTING_FOLLOW_RANGE =1000
SETTING_FOLLOW_MAX_RANGE =2000
--------------------------------------------------------------------------------
function modifier_creep_ai:IsHidden()
  return true
end
function modifier_creep_ai:IsPurgable()
  return false
end
function modifier_creep_ai:IsPurgeException()
  return false
end
function modifier_creep_ai:Back(reason)
      if(string.len(reason)>0)then
        --print(self.unit:GetUnitName())
        
      end
  
      local newOrder = {
          UnitIndex = self.unit:entindex(), 
          OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
          Position = self.spawn_position
        }
       
      ExecuteOrderFromTable(newOrder)
end
function modifier_creep_ai:OnIntervalThink()

  local haveValidTarget = false
  local havingTarget = false
  local havingTargetMsg = ""
  if((self.unit:GetOrigin()-self.spawn_position):Length2D()>=SETTING_FOLLOW_MAX_RANGE)then
    self:Back("Too far from spawn_position")
    return
  else
    if(self.target)then
    havingTarget = true

    --kemPrint(self.name.."Have target")
    if(self.target:IsAlive())then
      --kemPrint(self.name.."Target alive")
      if((self.target:GetOrigin()-self.unit:GetOrigin()):Length2D()<=SETTING_FOLLOW_RANGE)then
        --kemPrint(self.name.."Target is near, keep attacking")

        haveValidTarget=true
      else
       havingTargetMsg = "Far more than follow range"
      end
    else
      havingTargetMsg = "Target dead"
    end
  else

  end
  if(not haveValidTarget)then
    self.target=nil
    local enemies = FindUnitsInRadius(NEUTRALS_TEAM,self.unit:GetOrigin(), nil, SETTING_FIND_ENEMY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_CLOSEST, false)
    if(#enemies>0)then
      local tempUnit = enemies[1]
      self.target=tempUnit
      local newOrder = {
          UnitIndex = self.unit:entindex(), 
          OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
          TargetIndex = self.target:entindex(), --Optional.  Only used when targeting units
          AbilityIndex = 0, --Optional.  Only used when casting abilities
          Position = nil, --Optional.  Only used when targeting the ground
          Queue = 0 --Optional.  Used for queueing up abilities
        }
       
      ExecuteOrderFromTable(newOrder)

    else
      --self.spawn_position = self:GetOrigin()
      if(havingTarget)then
      self:Back("Invalid target "..havingTargetMsg)--Not have valid target")
      else
      self:Back("")--Not have valid target")
      end
      
      
    end
  end
end
  
  
end
function modifier_creep_ai:OnCreated( kv )
  if(IsServer())then
    self.target = nil
    self.unit = self:GetParent()
    self.spawn_position = self.unit:GetOrigin()
    self.name = self.unit:GetUnitName().."-"..self.unit:entindex()
    self:StartIntervalThink(2)
  end
  
end

--------------------------------------------------------------------------------
function modifier_creep_ai:OnRefresh( kv )
  if(IsServer())then
    self.target = nil
  end
end