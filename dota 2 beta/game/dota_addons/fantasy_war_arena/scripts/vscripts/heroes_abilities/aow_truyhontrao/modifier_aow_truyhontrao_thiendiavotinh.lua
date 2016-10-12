modifier_aow_truyhontrao_thiendiavotinh = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_thiendiavotinh:IsHidden()
   return true
end

function modifier_aow_truyhontrao_thiendiavotinh:RemoveOnDeath()
   return false
end



function modifier_aow_truyhontrao_thiendiavotinh:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
return funcs
end

function modifier_aow_truyhontrao_thiendiavotinh:GetModifierIncomingDamage_Percentage( params)
  return self.incoming_damage
end



function modifier_aow_truyhontrao_thiendiavotinh:ActiveOnTakeHit(attacker)
    if(IsServer())then
      
   end
end

function modifier_aow_truyhontrao_thiendiavotinh:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
   self.incoming_damage = -skill_level
end

function modifier_aow_truyhontrao_thiendiavotinh:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_truyhontrao_thiendiavotinh:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_thiendiavotinh:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_thiendiavotinh:OnDestroy()
self:GainBack()
end
