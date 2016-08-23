modifier_chiennhan_huyenanhtruyhonthuong = class({})
require('kem_lib/kem')
function modifier_chiennhan_huyenanhtruyhonthuong:IsHidden()
   return false
end

function modifier_chiennhan_huyenanhtruyhonthuong:RemoveOnDeath()
   return false
end

function modifier_chiennhan_huyenanhtruyhonthuong:DeclareFunctions()
local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
return funcs
end

function modifier_chiennhan_huyenanhtruyhonthuong:GetModifierMoveSpeedBonus_Constant( params)
  return -self.speed_reduce
end

--function modifier_chiennhan_huyenanhtruyhonthuong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chiennhan_huyenanhtruyhonthuong:OnCreated( kv )
  
  local p = self:GetParent()
	local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
  
  self.speed_reduce = (5+5*skill_level)*settings.speed_base
end

function modifier_chiennhan_huyenanhtruyhonthuong:OnRefresh( kv )
  local p = self:GetParent()
	local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
  self.speed_reduce = (5+5*skill_level)*settings.speed_base
end
