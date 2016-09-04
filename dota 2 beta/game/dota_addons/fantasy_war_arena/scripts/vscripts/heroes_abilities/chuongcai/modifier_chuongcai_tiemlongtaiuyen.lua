modifier_chuongcai_tiemlongtaiuyen = class({})
require('kem_lib/kem')
function modifier_chuongcai_tiemlongtaiuyen:IsHidden()
   return true
end

function modifier_chuongcai_tiemlongtaiuyen:RemoveOnDeath()
   return false
end

function modifier_chuongcai_tiemlongtaiuyen:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_chuongcai_tiemlongtaiuyen:GetModifierAttackSpeedBonus_Constant( params)
  return self.atk_speed
end

--function modifier_chuongcai_tiemlongtaiuyen:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chuongcai_tiemlongtaiuyen:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   self.atk_speed = math.floor(10+skill_level*1.6)
   if(IsServer())then
   end
end

function modifier_chuongcai_tiemlongtaiuyen:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_tiemlongtaiuyen:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_tiemlongtaiuyen:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_tiemlongtaiuyen:OnDestroy()
self:GainBack()
end
