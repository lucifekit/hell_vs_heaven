modifier_chuongcai_hoahiemvidi = class({})
require('kem_lib/kem')
function modifier_chuongcai_hoahiemvidi:IsHidden()
   return true
end

function modifier_chuongcai_hoahiemvidi:RemoveOnDeath()
   return false
end

function modifier_chuongcai_hoahiemvidi:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end

function modifier_chuongcai_hoahiemvidi:OnTakeDamage( params)
    if(IsServer())then
      if(self:GetParent()==params.unit)then
        local damage_taken = params.damage
        if(damage_taken>0)then
          --PrintTable(params)
          --print("Deal back damage")
          if(params.damage_flags~=DOTA_DAMAGE_FLAG_REFLECTION)then
            if(IsShortRangeAttack(params.attacker,params.unit))then              
              ReturnDamage(params.unit,self:GetAbility(),params.attacker,params.damage,self.reflect_damage)              
            end
            
          end
          
        end
      end
    end
end

--function modifier_chuongcai_hoahiemvidi:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chuongcai_hoahiemvidi:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    --10 15 20 25 30
    self.reflect_damage = 0.05+0.05*skill_level
   end
end

function modifier_chuongcai_hoahiemvidi:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_hoahiemvidi:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_hoahiemvidi:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_hoahiemvidi:OnDestroy()
self:GainBack()
end
