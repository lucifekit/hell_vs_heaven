modifier_creep_test = class({})
SETTING_FIND_ENEMY_RADIUS =500
SETTING_FOLLOW_RANGE =1000
SETTING_FOLLOW_MAX_RANGE =2000
--------------------------------------------------------------------------------
function modifier_creep_test:IsHidden()
  return true
end
function modifier_creep_test:IsPurgable()
  return false
end
function modifier_creep_test:IsPurgeException()
  return false
end
function modifier_creep_test:DeclareFunctions()
  local funcs = {
            MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE
        }

        return funcs
end
function modifier_creep_test:CheckState()
  local state = {
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true,
  }
 
  return state
end
function modifier_creep_test:GetModifierExtraHealthPercentage()
  return 100
end
function modifier_creep_test:GetModifierMoveSpeedBonus_Special_Boots()
  return 100
end
tick=0
function modifier_creep_test:OnIntervalThink()
  if(IsServer())then
    self.tick = self.tick+1
    local target_point = self.spawn_point+Vector(800,0,0)
    if(self.tick>3)then
      self.tick=0
    end
    if(self.tick==1)then
      target_point = self.spawn_point+Vector(0,800,0)
    end
    
    if(self.tick==2)then
      target_point = self.spawn_point+Vector(-800,0,0)
    end
    
    if(self.tick==3)then
      target_point = self.spawn_point+Vector(0,-800,0)
    end
      local newOrder = {
          UnitIndex = self:GetParent():entindex(), 
          OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
          AbilityIndex = 0, --Optional.  Only used when casting abilities
          Position = target_point, --Optional.  Only used when targeting the ground
          Queue = 0 --Optional.  Used for queueing up abilities
        }
       
      ExecuteOrderFromTable(newOrder)
  end
  

  
end
function modifier_creep_test:OnCreated( kv )
  if(IsServer())then
    local tempEntitiesGroupHeaven = Entities:FindAllByName("heaven_teleport")  
              for _,spawn_point in ipairs(tempEntitiesGroupHeaven) do
                self.spawn_point = spawn_point:GetOrigin()
              end
    self.tick=0
    self:StartIntervalThink(7)
  end
  
end

--------------------------------------------------------------------------------
function modifier_creep_test:OnRefresh( kv )
  if(IsServer())then
    self.target = nil
  end
end