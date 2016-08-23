modifier_kiemcon_nguynguyconlon_stack = class({})
require('kem_lib/kem')
function modifier_kiemcon_nguynguyconlon_stack:IsHidden()
   return false
end
function modifier_kiemcon_nguynguyconlon_stack:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_kiemcon_nguynguyconlon_stack:GetEffectName()
  return "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
end

SETTING_STACK_DURATION = 30
function modifier_kiemcon_nguynguyconlon_stack:RemoveOnDeath()
   return false
end

function modifier_kiemcon_nguynguyconlon_stack:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
return funcs
end
function modifier_kiemcon_nguynguyconlon_stack:GetModifierIncomingDamage_Percentage()

  local damage_reduce =self.damage_reduce_per_stack*self:GetStackCount()
  --print("Stack count =  "..self:GetStackCount()) 
  return -damage_reduce
end

function modifier_kiemcon_nguynguyconlon_stack:OnCreated( kv )
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.critical_per_stack = skill_level*12
  self.damage_reduce_per_stack = skill_level
  if(IsServer())then
    local caster = self:GetParent()
    if(caster.inited)then
      caster.nncl_crit_add = self.critical_per_stack
      
      caster.critical_chance = caster.critical_chance+caster.nncl_crit_add
      --print(caster.nncl_crit_add.." - "..caster.critical_chance)
    end
    UpdatePlayerDataForHero(caster)
  end
  
end

function modifier_kiemcon_nguynguyconlon_stack:Update()
  
  if(IsServer())then
    --print("is server")
    local caster = self:GetParent()
    if(caster.inited)then
      if(caster.nncl_crit_add)then
        caster.critical_chance = caster.critical_chance-caster.nncl_crit_add
      end
      local current_stack_count = self:GetStackCount()
      caster.nncl_crit_add = self.critical_per_stack*current_stack_count
      caster.critical_chance = caster.critical_chance+caster.nncl_crit_add
      --print(current_stack_count.."-->each "..caster.nncl_crit_add.." - "..caster.critical_chance)
    else
      --print("Not inited")
    end
    UpdatePlayerDataForHero(caster)
  end
end

function modifier_kiemcon_nguynguyconlon_stack:OnRefresh( kv )
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.critical_per_stack = skill_level*12
  self.damage_reduce_per_stack = skill_level
  self:Update()
  
  
  
end

function modifier_kiemcon_nguynguyconlon_stack:OnDestroy()
  local caster = self:GetParent()
  if(IsServer())then
    if(caster.inited)then
      if(caster.nncl_crit_add)then
        caster.critical_chance = caster.critical_chance-caster.nncl_crit_add
      end
      UpdatePlayerDataForHero(caster)
    end
    
  end
  
end
