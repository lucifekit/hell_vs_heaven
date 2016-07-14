modifier_building_hp = class({})
--------------------------------------------------------------------------------
function modifier_building_hp:RemoveOnDeath()
  return true
end
function modifier_building_hp:GetEffectName()
  return "particles/items_fx/healing_flask.vpcf"
end
function modifier_building_hp:GetEffectAttachType()
  return "follow_origin"
end
function modifier_building_hp:GetTexture()
  return "item_flask"
end

function modifier_building_hp:CheckState()
  local state = {
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_STUNNED] = true,
  
  }
 
  return state
end

function modifier_building_hp:GetModifierDisableTurning()
  return 1 
end


function modifier_building_hp:IsPassive()
  return false
end
function modifier_building_hp:IsHidden()
  return false
end
function modifier_building_hp:IsBuff()
  return false
end
function modifier_building_hp:IsDebuff()
  return false
end
function modifier_building_hp:IsPurgeable()
  return false
end
function modifier_building_hp:OnIntervalThink()

  --kemPrint("Running interval "..GameRules:GetGameTime())
  if(self.tick>0)then
    
    --kemPrint("Tick "..self.tick.." "..GameRules:GetGameTime())

    self.tick = self.tick-1
    local hpRegen = self:GetParent():GetMaxHealth()*0.1
    self:GetParent():SetHealth(self:GetParent():GetHealth()+hpRegen)
  else
    self:StartIntervalThink(-1)
  end
end


function modifier_building_hp:OnCreated(kv)
  if(IsServer())then
    local caster = self:GetCaster()
    local tick = 10
    local time_between_tick = 0.5
    local hp_per_tick = 500
    local mp_per_tick = 500
    self.time_between_tick = time_between_tick
    self.hp_per_tick = hp_per_tick
    self.mp_per_tick = mp_per_tick
    self.tick = 10
    self.target = caster
    self:StartIntervalThink(self.time_between_tick)
    
  end
  
  --if(hero.hpregen_multi 
  
  
end
function modifier_building_hp:OnRefresh(kv)

  if(IsServer())then
    local caster = self:GetCaster()
    self.target = caster
    local tick = 10
    local time_between_tick = 0.5
    local hp_per_tick = 500
    local mp_per_tick = 500
    self.time_between_tick = time_between_tick
    self.hp_per_tick = hp_per_tick
    self.mp_per_tick = mp_per_tick
    self.tick = 10
    self:StartIntervalThink(self.time_between_tick)

    kemPrint("refreshed hp"..time_between_tick.." - "..hp_per_tick)
  end
end
function modifier_building_hp:OnDestroy(kv)
  kemPrint("destroyed hp")

  self:StartIntervalThink(-1)
end