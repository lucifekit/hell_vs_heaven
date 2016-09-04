modifier_chuongcai_tuydiepcuongvu_target = class({})
require('kem_lib/kem')
function modifier_chuongcai_tuydiepcuongvu_target:IsHidden()
   return false
end

function modifier_chuongcai_tuydiepcuongvu_target:RemoveOnDeath()
   return true
end

--------------------------------------------------------------------------------
function modifier_chuongcai_tuydiepcuongvu_target:GetEffectAttachType()
  return PATTACH_CUSTOMORIGIN_FOLLOW
end
function modifier_chuongcai_tuydiepcuongvu_target:GetEffectName()
  return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end
function modifier_chuongcai_tuydiepcuongvu_target:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_EXECUTED
        }

        return funcs
    end
LinkLuaModifier("modifier_chuongcai_tuydiepcuongvu_active","heroes_abilities/chuongcai/modifier_chuongcai_tuydiepcuongvu_active",LUA_MODIFIER_MOTION_NONE)
function modifier_chuongcai_tuydiepcuongvu_target:OnAbilityExecuted(params)
  if(IsServer())then
    if params.unit == self:GetParent() then
       if(not self:GetParent():HasModifier("modifier_tuydiepcuongvu_active"))then
        --
        if(math.random(0,100)<self.drunk_chance)then
          self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_chuongcai_tuydiepcuongvu_active",{duration=5})
          self:DecrementStackCount()
          if(self:GetStackCount()==0)then
            self:Destroy()
          end
        end
       end
        
    end
  end
    
  
  end
--------------------------------------------------------------------------------
function modifier_chuongcai_tuydiepcuongvu_target:Apply()

  if(IsServer())then
    
    
    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    self.drunk_chance = 10
    self.drunk_basic_damage_reduce = 0+0.06*skill_level
    self.drunk_skill_damage_reduce = 0+0.06*skill_level
    
  end

end
function modifier_chuongcai_tuydiepcuongvu_target:GainBack()
  if(IsServer())then
    
    
  end
end

function modifier_chuongcai_tuydiepcuongvu_target:OnCreated( kv )
  if(IsServer())then
  self:Apply()  
  end

  
end

--------------------------------------------------------------------------------
function modifier_chuongcai_tuydiepcuongvu_target:OnRefresh( kv )
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end

end

function modifier_chuongcai_tuydiepcuongvu_target:OnDestroy( kv )
  if(IsServer())then
    self:GainBack()    
  end

end