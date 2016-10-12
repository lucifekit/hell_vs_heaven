modifier_aow_truyhontrao_thientamcong = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_thientamcong:IsHidden()
   return true
end

function modifier_aow_truyhontrao_thientamcong:RemoveOnDeath()
   return false
end

LinkLuaModifier("modifier_aow_truyhontrao_brawl","heroes_abilities/aow_truyhontrao/modifier_aow_truyhontrao_brawl",LUA_MODIFIER_MOTION_NONE)

function modifier_aow_truyhontrao_thientamcong:ActiveOnHit(target)
  if(math.random(0,100)<self.stack_chance)then
    local modifier = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_aow_truyhontrao_brawl",{duration=self.stack_duration})
    if(modifier:GetStackCount()<7)then
      modifier:IncrementStackCount()
    end
  end
end

--function modifier_aow_truyhontrao_thientamcong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_aow_truyhontrao_thientamcong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_aow_truyhontrao_thientamcong:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.stack_chance = (0.05+0.01*skill_level)*100
   
   self.stack_duration = 15+1*skill_level


   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_thientamcong:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_thientamcong:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_thientamcong:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_thientamcong:OnDestroy()
self:GainBack()
end
