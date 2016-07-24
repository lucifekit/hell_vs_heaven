modifier_daocon_nhatkhitamthanh_allies = class({})
function modifier_daocon_nhatkhitamthanh_allies:IsHidden()
   return false
end
function modifier_daocon_nhatkhitamthanh_allies:RemoveOnDeath()
   return true
end

function modifier_daocon_nhatkhitamthanh_allies:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_thienvuongchieny::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_thienvuongchieny:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_nhatkhitamthanh_allies:OnCreated( kv )

  if(IsServer())then
    local caster = self:GetCaster()
    local par = self:GetParent()
    --self.ability_level = 

    local skill_level = self:GetAbility():GetLevel()
    local allies_physical_amplify = 0.1+0.045*skill_level  
    par.physic_amplify = par.physic_amplify+ allies_physical_amplify--vat cong them vao
  end
  
end

function modifier_daocon_nhatkhitamthanh_allies:OnRefresh( kv )

  kemPrint("refresh nhat khi tam thanh allies")
end

function modifier_daocon_nhatkhitamthanh_allies:OnDestroy( kv )
 
  if(IsServer())then
    kemPrint("destroy nhat khi tam thanh allies")
    local par = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()
    local skill_level = self:GetAbility():GetLevel()
    local allies_physical_amplify = 0.1+0.045*skill_level  
    par.physic_amplify = par.physic_amplify-allies_physical_amplify--vat cong them vao
  end
end
