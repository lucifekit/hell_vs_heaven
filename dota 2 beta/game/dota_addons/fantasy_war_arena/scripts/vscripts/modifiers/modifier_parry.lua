modifier_parry = class({})
function modifier_parry:GetTexture()
  return "dazzle_weave"
end
if IsServer() then
    
    function modifier_parry:OnCreated(kv)
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv
        self:StartIntervalThink(self.kv.replenish_time)
    end

    function modifier_parry:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_TAKEDAMAGE
            --on defense
        }

        return funcs
    end
    function modifier_parry:OnTakeDamage(params)
      if(IsServer())then
        local caster = self:GetParent()
        if(caster==params.unit)then
          if(caster:HasModifier("modifier_defense"))then
            self:DecrementStackCount()
            if(self:GetStackCount()==0)then
              caster:RemoveModifierByName("modifier_defense")
            end
          end          
        end
      end
    end

    function modifier_parry:OnIntervalThink()
        local stacks = self:GetStackCount()

        if stacks < self.kv.max_count then
            self:IncrementStackCount()            
        end
    end
end
 function modifier_parry:RemoveOnDeath()
        return false
    end
function modifier_parry:DestroyOnExpire()
    return false
end

function modifier_parry:IsPurgable()
    return false
end