modifier_thuongthien_thienvuongchieny_allies = class({})
require('kem_lib/kem')
function modifier_thuongthien_thienvuongchieny_allies:IsHidden()
   return false
end
function modifier_thuongthien_thienvuongchieny_allies:RemoveOnDeath()
   return true
end

function modifier_thuongthien_thienvuongchieny_allies:DeclareFunctions()
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

function modifier_thuongthien_thienvuongchieny_allies:OnCreated( kv )

  if(IsServer())then
    local caster = self:GetCaster()
    local par = self:GetParent()
    --self.ability_level = 

    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local allies_physical_amplify = 0.1+0.05*skill_level    
    local allies_critical_chance = 10+2*skill_level
    local allies_maim_chance = 10+3.5*skill_level
    if(par.inited)then
      par.physic_amplify = par.physic_amplify+ allies_physical_amplify--vat cong them vao
      par.critical_chance = par.critical_chance+ allies_critical_chance--vat cong them vao
      par.effect_maim_add_percent = par.effect_maim_add_percent+ allies_maim_chance--vat cong them vao
    end
  end
  
end

function modifier_thuongthien_thienvuongchieny_allies:OnRefresh( kv )

  kemPrint("refresh thien vuong chien y allies")
end

function modifier_thuongthien_thienvuongchieny_allies:OnDestroy( kv )
  kemPrint("destroy thien vuong chien y allies")

  if(IsServer())then
    local par = self:GetParent()
    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local allies_physical_amplify = 0.1+0.05*skill_level    
    local allies_critical_chance = 10+2*skill_level
    local allies_maim_chance = 10+3.5*skill_level
    if(par.inited)then
      par.physic_amplify = par.physic_amplify- allies_physical_amplify--vat cong them vao
      par.critical_chance = par.critical_chance- allies_critical_chance--vat cong them vao
      par.effect_maim_add_percent = par.effect_maim_add_percent- allies_maim_chance--vat cong them vao
    end
    
  end
end
