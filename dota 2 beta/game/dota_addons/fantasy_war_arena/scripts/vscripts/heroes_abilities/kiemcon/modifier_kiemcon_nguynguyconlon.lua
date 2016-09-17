modifier_kiemcon_nguynguyconlon = class({})
require('kem_lib/kem')
function modifier_kiemcon_nguynguyconlon:IsHidden()
   return true
end
SETTING_STACK_DURATION = 3
SETTING_ACTIVE_CHANCE = 35
function modifier_kiemcon_nguynguyconlon:RemoveOnDeath()
   return false
end

function modifier_kiemcon_nguynguyconlon:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end
LinkLuaModifier("modifier_kiemcon_nguynguyconlon_stack","heroes_abilities/kiemcon/modifier_kiemcon_nguynguyconlon_stack",LUA_MODIFIER_MOTION_NONE)
function modifier_kiemcon_nguynguyconlon:OnTakeDamage(params)
  if(IsServer())then
    if(params.unit==self:GetParent())then
      if(self:GetAbility():IsCooldownReady())then
        if(math.random(0,100)<SETTING_ACTIVE_CHANCE)then
          local caster = self:GetCaster()
          local modifier = caster:FindModifierByName("modifier_kiemcon_nguynguyconlon_stack")
          local current_stack = 0
          if(modifier)then
            current_stack = modifier:GetStackCount()
          end
          modifier = caster:AddNewModifier(caster,self:GetAbility(),"modifier_kiemcon_nguynguyconlon_stack",{duration=SETTING_STACK_DURATION})
          if(current_stack<self.max_stacks)then
            
            --modifier:ForceRefresh()
            if(modifier)then
              modifier:IncrementStackCount()
            end
            
            
            
--            Timers:CreateTimer(SETTING_STACK_DURATION,function()
--              if(not modifier:IsNull())then
--                modifier:DecrementStackCount()
--                modifier:Update()
--              end
--              
--            end)
          end
        else

          --kemPrint("Not happen")  
        end
      else
        --kemPrint("Thuc phoc chu is cooldowning")
      end
    end
    
  end
end
--function modifier_kiemcon_nguynguyconlon:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_nguynguyconlon:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_nguynguyconlon:OnCreated( kv )
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  --local stack_duration = 3
--local max_stack = 2+1*skill_level
--local critical_per_stack = 0+12*skill_level
--local damage_reduce_per_stack = 0+0.01*skill_level

  self.max_stacks = skill_level+2
  
end

function modifier_kiemcon_nguynguyconlon:OnRefresh( kv )
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  self.max_stacks = skill_level+2
end
