modifier_daocon_huyenthienvocuc = class({})
require('kem_lib/kem')
function modifier_daocon_huyenthienvocuc:IsHidden()
   return true
end

function modifier_daocon_huyenthienvocuc:RemoveOnDeath()
   return false
end

function modifier_daocon_huyenthienvocuc:DeclareFunctions()
local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end

function modifier_daocon_huyenthienvocuc:OnTakeDamage( params)
  --print("on take damage ")
  if(IsServer())then
    if(self:GetParent()==params.unit)then
      local damage_taken = params.damage
      if(damage_taken>0)then
        --PrintTable(params)
        local damage_negate_max = math.ceil(self:GetParent():GetMaxHealth() * self.damage_negate_max)
        local heal = math.ceil(damage_taken * self.damage_negate)
        if(damage_negate_max<heal)then
          heal = damage_negate_max
        end
        local current_health = self:GetParent():GetHealth()
        if(current_health>0)then
          self:GetParent():SetHealth(self:GetParent():GetHealth()+heal)
        end
        --print("heal "..heal.." hp from "..damage_taken.." when got "..current_health)
        
        --(3974)-1233=2741
        --2741+159=2900
        --(x)-1480=(0-)
        --0+159
        --vd co 3000 hp, an 1 hit 3000 mau', con 0 mau'
        --regen 159--> con 159 mau--> song
        
      end
    end
  end
  
  --return 50--reduce 50%
end

--function modifier_daocon_huyenthienvocuc:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_huyenthienvocuc:OnCreated( kv )
  if(IsServer())then
    local p = self:GetParent()
    local skill_level=self:GetAbility():GetLevel()+GetSkillLevel(p)
    local damage_negate = 0.4
    local damage_negate_max = 0.015+0.005*skill_level
    local reflect_damage_resist = 0.1+0.07*skill_level
    self.damage_negate=0.4
    self.damage_negate_max=damage_negate_max
  end

end

function modifier_daocon_huyenthienvocuc:OnRefresh( kv )
  if(IsServer())then
    local p = self:GetParent()
    local skill_level=self:GetAbility():GetLevel()+GetSkillLevel(p)
    local damage_negate = 0.4
    local damage_negate_max = 0.015+0.005*skill_level
    local reflect_damage_resist = 0.1+0.07*skill_level
    self.damage_negate=0.4
    self.damage_negate_max=damage_negate_max
  end
end
