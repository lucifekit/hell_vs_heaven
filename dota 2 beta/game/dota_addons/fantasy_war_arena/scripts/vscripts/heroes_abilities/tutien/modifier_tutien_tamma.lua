modifier_tutien_tamma = class({})
require('kem_lib/kem')
function modifier_tutien_tamma:IsHidden()
   return true
end

function modifier_tutien_tamma:RemoveOnDeath()
   return false
end

function modifier_tutien_tamma:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_tutien_tamma:GetModifierAttackSpeedBonus_Constant( params)
return self.atk_speed
end

--function modifier_tutien_tamma:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_tamma:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.atk_speed = math.floor(10+skill_level*1.6)
end

function modifier_tutien_tamma:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_tutien_tamma:OnCreated( kv )
self:Apply()
end

function modifier_tutien_tamma:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_tutien_tamma:OnDestroy()
self:GainBack()
end

