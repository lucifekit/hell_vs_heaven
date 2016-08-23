modifier_daocon_nhatkhitamthanh_allies = class({})
require('kem_lib/kem')
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
    local par = self:GetParent()
    --self.ability_level = 

    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local allies_physical_amplify = 0.1+0.045*skill_level  
    if(par.inited)then
      par.nktt_physic = allies_physical_amplify
      par.physic_amplify = par.physic_amplify+ allies_physical_amplify--vat cong them vao
    end
    
  end
  
end

function modifier_daocon_nhatkhitamthanh_allies:OnRefresh( kv )
  if(IsServer())then
    kemPrint("refresh nhat khi tam thanh allies")
    local par = self:GetParent()
    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local allies_physical_amplify = 0.1+0.045*skill_level  
    if(par.inited)then
      if(par.nktt_physic)then
        par.physic_amplify = par.physic_amplify-par.nktt_physic--vat cong them vao
      end
      par.nktt_physic = allies_physical_amplify
      par.physic_amplify = par.physic_amplify+ allies_physical_amplify--vat cong them vao
    end
  end
  
end

function modifier_daocon_nhatkhitamthanh_allies:OnDestroy( kv )
 
  if(IsServer())then
    kemPrint("destroy nhat khi tam thanh allies")
    local par = self:GetParent()
    if(par.inited)then
      if(par.nktt_physic)then
        par.physic_amplify = par.physic_amplify-par.nktt_physic--vat cong them vao
      end
    end    
  end
end
