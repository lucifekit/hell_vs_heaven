modifier_aow_truyhontrao_brawl = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_brawl:IsHidden()
   return false
end

function modifier_aow_truyhontrao_brawl:RemoveOnDeath()
   return true
end
function modifier_aow_truyhontrao_brawl:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
return funcs
end

function modifier_aow_truyhontrao_brawl:GetModifierBonusStats_Agility()
  return self:GetStackCount()*self.agility_per_stack
end


function modifier_aow_truyhontrao_brawl:ActiveOnHit(target)
    if(IsServer())then
       local caster = self:GetParent()
       if(self:GetStackCount()>=7)then
          if(target:GetHealthPercent()<20)then
            local multiplier = self.multiplier
            local hp_lost = target:GetMaxHealth()-target:GetHealth()
            local damage = hp_lost*multiplier
            if(target:IsHero())then
              damage=damage*5
            end
            print("Brawl damage = "..damage.." hp lost = "..hp_lost.." * "..multiplier)
            DamageHandler:ApplyDamage(
              caster,
              self:GetAbility(),
              target,
              damage,
              DamageHandler:InitCrit(0,0),
              ELEMENT_METAL,
              {flag="no_director"})
          end
          
       end
    end
end


function modifier_aow_truyhontrao_brawl:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
   self.multiplier = 0.03+0.005*skill_level
   self.agility_per_stack = 20+5*skill_level
end

function modifier_aow_truyhontrao_brawl:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_brawl:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_brawl:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_brawl:OnDestroy()
self:GainBack()
end
