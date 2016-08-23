modifier_daocon_vonhanvonga_allies = class({})
require('kem_lib/kem')
function modifier_daocon_vonhanvonga_allies:IsHidden()
   return false
end
function modifier_daocon_vonhanvonga_allies:RemoveOnDeath()
   return true
end

function modifier_daocon_vonhanvonga_allies:DeclareFunctions()
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

function modifier_daocon_vonhanvonga_allies:OnCreated( kv )

 

  if(IsServer())then
    kemPrint("create vonhanvonga allies")
    local caster = self:GetCaster()
    local par = self:GetParent()
    --self.ability_level = 

    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local allies_bypass_evade = 35+5*skill_level
    local allies_stun_time_reduce = 45+5*skill_level  
    if(par.inited)then
      par.bypass_evade = par.bypass_evade+ allies_bypass_evade--vat cong them vao
      par.effect_stun_reduce_time = par.effect_stun_reduce_time+ allies_stun_time_reduce--vat cong them vao
    end
    
    
  end
  
end

function modifier_daocon_vonhanvonga_allies:OnRefresh( kv )
  if(IsServer())then
    kemPrint("refresh vonhan vo nga allies")
  end
  
end

function modifier_daocon_vonhanvonga_allies:OnDestroy( kv )
  
  if(IsServer())then
  kemPrint("destroy vonhan vo nga allies")
  
    local par = self:GetParent()
    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    
    local allies_bypass_evade = 35+5*skill_level
    local allies_stun_time_reduce = 45+5*skill_level  
    if(par.inited)then
      par.physic_amplify = par.physic_amplify-allies_bypass_evade--vat cong them vao
      par.effect_stun_reduce_time = par.effect_stun_reduce_time- allies_stun_time_reduce--vat cong them vao
    end
    
  end
end
