modifier_daocon_thanhphongphu = class({})
function modifier_daocon_thanhphongphu:IsHidden()
   return false
end
function modifier_daocon_thanhphongphu:GetEffectName()
  return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_daocon_thanhphongphu:RemoveOnDeath()
   return false
end

function modifier_daocon_thanhphongphu:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
return funcs
end
function modifier_daocon_thanhphongphu:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.speed
end

--function modifier_daocon_thanhphongphu:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_thanhphongphu:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_thanhphongphu:OnCreated( kv )
 
 
  self.speed = 20+self:GetAbility():GetLevel()*6
 if(IsServer())then
 end
 
end

function modifier_daocon_thanhphongphu:OnRefresh( kv )
 self.speed = 20+self:GetAbility():GetLevel()*6
end
