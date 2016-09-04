modifier_kiemdoan_soanh = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
if IsServer() then
  function modifier_kiemdoan_soanh:IsHidden()
    return false
  end
  function modifier_kiemdoan_soanh:RemoveOnDeath()
    return false
  end
  function modifier_kiemdoan_soanh:IsPurgable()
      return false
  end
  function modifier_kiemdoan_soanh:DeclareFunctions()
    local funcs = {
      MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
   
    return funcs
  end
  
  function modifier_kiemdoan_soanh:OnAbilityExecuted(params)
    if params.unit == self:GetParent() then
        local ability = params.ability
        local sc = self:GetStackCount()
        if params.ability == self:GetAbility() then
            if(sc>0)then
              self:DecrementStackCount()
  
              ability:EndCooldown()
            else
              ability:StartCooldown(999)
            end
        end
    end
  
  end
  
  function modifier_kiemdoan_soanh:ActiveOnHit(target)
    if(self:GetStackCount()<15)then
        local random_value = math.random(0,100)
        local message = "Random value "..random_value
        if(random_value<5)then
          
          self:IncrementStackCount()
          local skill_soanh = self:GetParent():FindAbilityByName("skill_kiemdoan_soanh")
          if(skill_soanh)then
            skill_soanh:EndCooldown()
            message = message.." Proc "..skill_soanh:GetAbilityName()
          end
          
        
          
         else
          message = message.." Missed"
        end

        --kemPrint(message)
      end
  end
  --------------------------------------------------------------------------------
  
  function modifier_kiemdoan_soanh:OnCreated( kv )
    
  end
  
  --------------------------------------------------------------------------------
  function modifier_kiemdoan_soanh:OnRefresh( kv )
  
  end

end