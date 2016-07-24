modifier_hp_big = class({})
--------------------------------------------------------------------------------

SETTING_HP_REGEN = 500
SETTING_MP_REGEN = 500


function modifier_hp_big:RemoveOnDeath()
  return true
end
function modifier_hp_big:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE --we want item's passive abilities to be hidden most of the times
end
function modifier_hp_big:GetEffectName()
  return "particles/items_fx/healing_flask.vpcf"
end
function modifier_hp_big:GetEffectAttachType()
  return "follow_origin"
end
function modifier_hp_big:GetTexture()
  return "item_greater_salve"
end

function modifier_hp_big:IsPassive()
  return false
end
function modifier_hp_big:IsHidden()
  return false
end
function modifier_hp_big:IsBuff()
  return false
end
function modifier_hp_big:IsDebuff()
  return false
end
function modifier_hp_big:IsPurgeable()
  return false
end
function modifier_hp_big:OnIntervalThink()

  --kemPrint("Running interval "..GameRules:GetGameTime())
  if(self.tick>0)then
    
    --kemPrint("Tick "..self.tick.." "..GameRules:GetGameTime())

    self.tick = self.tick-1
    local hpRegen = math.min(self.hp_per_tick,self:GetCaster():GetMaxHealth()*0.2)
    local mpRegen = math.min(self.mp_per_tick,self:GetCaster():GetMaxMana()*0.2)
    self.target:SetHealth(self.target:GetHealth()+hpRegen)
    self.target:SetMana(self.target:GetMana()+mpRegen)
  end
end


function modifier_hp_big:OnCreated(kv)
  if(IsServer())then
    local caster = self:GetCaster()
    local tick = 10
    local time_between_tick = 0.5
    local hp_per_tick = SETTING_HP_REGEN
    local mp_per_tick = SETTING_MP_REGEN
    if(caster.hpregen_multi)then
      time_between_tick = time_between_tick/(1+caster.hpregen_multi)
      hp_per_tick = hp_per_tick*(1+caster.hpregen_multi)
    end
    if(caster.mpregen_multi)then
      time_between_tick = time_between_tick/(1+caster.hpregen_multi)
      mp_per_tick = mp_per_tick*(1+caster.hpregen_multi)
    end
    self.time_between_tick = time_between_tick
    self.hp_per_tick = hp_per_tick
    self.mp_per_tick = mp_per_tick
    self.tick = 10
    self.target = caster
    self:StartIntervalThink(self.time_between_tick)


  end
  
  --if(hero.hpregen_multi 
  
  
end
function modifier_hp_big:OnRefresh(kv)

  if(IsServer())then
    local caster = self:GetCaster()
    self.target = caster
    local tick = 10
    local time_between_tick = 0.5
    local hp_per_tick = SETTING_HP_REGEN
    local mp_per_tick = SETTING_MP_REGEN
    if(caster.hpregen_multi)then
      time_between_tick = time_between_tick/(1+caster.hpregen_multi)
      hp_per_tick = hp_per_tick*(1+caster.hpregen_multi)
    end
    if(caster.mpregen_multi)then
      time_between_tick = time_between_tick/(1+caster.hpregen_multi)
      mp_per_tick = mp_per_tick*(1+caster.hpregen_multi)
    end
    self.time_between_tick = time_between_tick
    self.hp_per_tick = hp_per_tick
    self.mp_per_tick = mp_per_tick
    self.tick = 10
    self:StartIntervalThink(self.time_between_tick)

    kemPrint("refreshed hp"..time_between_tick.." - "..hp_per_tick)
  end
end
function modifier_hp_big:OnDestroy(kv)
  --kemPrint("destroyed hp")

  self:StartIntervalThink(-1)
end