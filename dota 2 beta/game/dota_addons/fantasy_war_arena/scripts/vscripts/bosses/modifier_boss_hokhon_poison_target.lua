modifier_boss_hokhon_poison_target = class({})
function modifier_boss_hokhon_poison_target:IsHidden()
   return false
end
function modifier_boss_hokhon_poison_target:RemoveOnDeath()
   return true
end

function modifier_boss_hokhon_poison_target:GetEffectName()
  return "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf"
end
--function modifier_poison:GetEffectName()
--  return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
--end
function modifier_boss_hokhon_poison_target:GetTexture()
  return "alchemist_acid_spray"
end

function modifier_boss_hokhon_poison_target:IsDebuff()
  return true
end

function modifier_boss_hokhon_poison_target:OnIntervalThink()
  if(IsServer())then
    --kemPrint(self:GetCaster():entindex().." .. Poisoning")
    PoisonHandler:ApplyPoison(self:GetCaster(),self:GetParent(),self:GetAbility(),0.5,3,1000,{})
  end
        
end

function modifier_boss_hokhon_poison_target:OnCreated( kv )

  if(IsServer())then
    self:StartIntervalThink(1)
    
  end
  
end



function modifier_boss_hokhon_poison_target:OnDestroy( kv )
 
  if(IsServer())then
    self:StartIntervalThink(-1)
  end
end
