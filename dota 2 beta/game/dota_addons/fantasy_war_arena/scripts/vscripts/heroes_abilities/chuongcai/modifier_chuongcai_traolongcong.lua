modifier_chuongcai_traolongcong = class({})
require('kem_lib/kem')
SETTING_HEALTH_PROC = 50
function modifier_chuongcai_traolongcong:IsHidden()
   return true
end

function modifier_chuongcai_traolongcong:RemoveOnDeath()
   return false
end

function modifier_chuongcai_traolongcong:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end
LinkLuaModifier("modifier_chuongcai_traolongcong_active","heroes_abilities/chuongcai/modifier_chuongcai_traolongcong_active",LUA_MODIFIER_MOTION_NONE)
function modifier_chuongcai_traolongcong:OnTakeDamage( params)
  if(IsServer())then
    local caster=self:GetParent()
    if(caster==params.unit)then
      if(caster:GetHealthPercent()<SETTING_HEALTH_PROC)then
        local ability = self:GetAbility()
        if(ability:IsCooldownReady())then
          if(math.random(0,100)<self.active_chance)then
            ability:StartCooldown(30)
            self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_chuongcai_traolongcong_active",{duration=self.active_duration})
            if(caster:HasModifier("modifier_chuongcai_thoithualuclong"))then
              local ttll_buff = self:GetParent():FindModifierByName("modifier_chuongcai_thoithualuclong")
              if(ttll_buff)then
                ttll_buff:Apply()
              end
              
            end
            
          end
          
        end
        
      end
      
    end
  end


end


function modifier_chuongcai_traolongcong:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
self.active_chance = 30+10*skill_level

self.active_duration = math.floor(2.5+1.5*skill_level)
   end
end

function modifier_chuongcai_traolongcong:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_traolongcong:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_traolongcong:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_traolongcong:OnDestroy()
self:GainBack()
end
