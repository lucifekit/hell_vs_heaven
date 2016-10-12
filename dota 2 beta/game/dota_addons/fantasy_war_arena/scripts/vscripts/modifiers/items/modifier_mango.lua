modifier_mango = class({})
--------------------------------------------------------------------------------

SETTING_REGEN = 50
function modifier_mango:IsHidden()
  return true
end
function modifier_mango:RemoveOnDeath()
  return true
end

function modifier_mango:GetEffectAttachType()
  return "follow_origin"
end
function modifier_mango:GetTexture()
  return "item_enchanted_mango"
end

function modifier_mango:IsPassive()
  return false
end

function modifier_mango:IsBuff()
  return false
end
function modifier_mango:IsDebuff()
  return false
end
function modifier_mango:IsPurgeable()
  return false
end
function modifier_mango:OnIntervalThink()
    --heal toi da 20% hp/mp
    
    local hpRegen = math.min(self.hp_per_tick,self:GetCaster():GetMaxHealth()*0.2)
    local mpRegen = math.min(self.mp_per_tick,self:GetCaster():GetMaxMana()*0.2)
    self.target:SetHealth(self.target:GetHealth()+hpRegen)
    self.target:SetMana(self.target:GetMana()+mpRegen)
end


function modifier_mango:OnCreated(kv)
  if(IsServer())then

    local caster = self:GetCaster()
    
    local time_between_tick = 0.5
    local hp_per_tick = SETTING_REGEN
    local mp_per_tick = SETTING_REGEN/2
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
function modifier_mango:OnRefresh(kv)

  if(IsServer())then
    local caster = self:GetCaster()
    self.target = caster
    local time_between_tick = 0.5
    local hp_per_tick = SETTING_REGEN
    local mp_per_tick = SETTING_REGEN/2
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
    self:StartIntervalThink(self.time_between_tick)

    kemPrint("refreshed hp"..time_between_tick.." - "..hp_per_tick)
  end
end
function modifier_mango:OnDestroy(kv)
  --kemPrint("destroyed hp")

  self:StartIntervalThink(-1)
end