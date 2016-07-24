modifier_boss_ai = class({})
SETTING_FIND_ENEMY_RADIUS =500
SETTING_FOLLOW_RANGE =1000
SETTING_FOLLOW_MAX_RANGE =2000
--------------------------------------------------------------------------------
function modifier_boss_ai:IsHidden()
  return true
end
function modifier_boss_ai:IsPurgable()
  return false
end
function modifier_boss_ai:IsPurgeException()
  return false
end
function modifier_boss_ai:Back(reason)
      if(string.len(reason)>0)then
        
        if(IsServer())then        
          print(reason)
        end
      end
  
      local newOrder = {
          UnitIndex = self.unit:entindex(), 
          OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
          Position = self.spawn_position
        }
       
      ExecuteOrderFromTable(newOrder)
end
function modifier_boss_ai:OnIntervalThink()
  if(IsServer())then
    --print("Boss think "..self.name.."".. self.unit:GetUnitName())
    local haveValidTarget = false
    local havingTarget = false
    local havingTargetMsg = ""
    local isDebug = self.isDebug
    
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
    if(isDebug)then
      print("1",havingTarget,"2",haveValidTarget,"3",havingTargetMsg)
    end
    if(not haveValidTarget)then
      self.target=nil
      if(isDebug)then
        print("Team : ",self.unit:GetTeam(),DOTA_TEAM_BADGUYS,NEUTRALS_TEAM,"ORDER = ",DOTA_UNIT_ORDER_ATTACK_TARGET)
      end
      
      local enemies = FindUnitsInRadius(self.unit:GetTeam(),self.unit:GetOrigin(), nil, SETTING_FIND_ENEMY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_CLOSEST, false)
      if(#enemies>0)then
        self.target=enemies[1]
        local newOrder = {
            UnitIndex = self.unit:entindex(), 
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = self.target:entindex()
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
  
  
end
function modifier_boss_ai:OnCreated( kv )
  if(IsServer())then
    self.target = nil
    self.unit = self:GetParent()
    self.spawn_position = self.unit:GetOrigin()
    self.name = self.unit:GetUnitName().."-"..self.unit:entindex()
    self:StartIntervalThink(2)
    print("Inited ai for boss "..self.name)
    self.isDebug=false
    if(self.unit:GetUnitName()=="npc_boss_hell")then
      self.isDebug=false
    end
  end
  
end

--------------------------------------------------------------------------------
function modifier_boss_ai:OnRefresh( kv )
  if(IsServer())then
    self.target = nil
  end
end