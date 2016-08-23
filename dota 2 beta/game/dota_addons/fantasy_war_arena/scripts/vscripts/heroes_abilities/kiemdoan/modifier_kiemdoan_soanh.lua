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
  
  --------------------------------------------------------------------------------
  
  function modifier_kiemdoan_soanh:OnCreated( kv )
    
  end
  
  --------------------------------------------------------------------------------
  function modifier_kiemdoan_soanh:OnRefresh( kv )
  
  end

end