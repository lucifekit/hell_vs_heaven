modifier_hp_small = class({})
--------------------------------------------------------------------------------

SETTING_HP_REGEN = 250
SETTING_MP_REGEN = 250
function modifier_hp_small:RemoveOnDeath()
  return true
end
function modifier_hp_small:GetEffectName()
  return "particles/items_fx/healing_flask.vpcf"
end
function modifier_hp_small:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE --we want item's passive abilities to be hidden most of the times
end
function modifier_hp_small:GetEffectAttachType()
  return "follow_origin"
end
function modifier_hp_small:GetTexture()
  return "item_flask"
end

function modifier_hp_small:IsPassive()
  return false
end
function modifier_hp_small:IsHidden()
  return false
end
function modifier_hp_small:IsBuff()
  return false
end
function modifier_hp_small:IsDebuff()
  return false
end
function modifier_hp_small:IsPurgeable()
  return false
end
function modifier_hp_small:OnIntervalThink()

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


function modifier_hp_small:OnCreated(kv)
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
function modifier_hp_small:OnRefresh(kv)

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
      time_between_tick = time_between_tick/(1+caster.mpregen_multi)
      mp_per_tick = mp_per_tick*(1+caster.mpregen_multi)
    end
    self.time_between_tick = time_between_tick
    self.hp_per_tick = hp_per_tick
    self.mp_per_tick = mp_per_tick
    self.tick = 10
    self:StartIntervalThink(self.time_between_tick)

    kemPrint("refreshed hp"..time_between_tick.." - "..hp_per_tick)
  end
end
function modifier_hp_small:OnDestroy(kv)
  --kemPrint("destroyed hp")
  self:StartIntervalThink(-1)
end