modifier_chuongcai_trietythapbatdiet = class({})
require('kem_lib/kem')
function modifier_chuongcai_trietythapbatdiet:IsHidden()
   return false
end

function modifier_chuongcai_trietythapbatdiet:RemoveOnDeath()
   return false
end

function modifier_chuongcai_trietythapbatdiet:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end

function modifier_chuongcai_trietythapbatdiet:OnTakeDamage( params)
  if(IsServer())then
      if(self:GetParent()==params.unit)then
        local damage_taken = params.damage
        if(damage_taken>0)then
          --PrintTable(params)
          --print("Deal back damage")
          if(self:GetAbility():IsCooldownReady())then
            if(params.damage_flags~=DOTA_DAMAGE_FLAG_REFLECTION)then
              if(math.random(0,100)<self.chance_to_active)then
                StatusEffectHandler:KnockBack(params.unit,params.unit:GetAbsOrigin(),params.attacker,self.chance_to_knockback,0.2,self.knockback_range)
                self:GetAbility():StartCooldown(0.33)
              end
            end
          end
          
          
        end
      end
    end
end

--function modifier_chuongcai_trietythapbatdiet:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_chuongcai_trietythapbatdiet:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    self.chance_to_active = 3*skill_level
    self.chance_to_knockback = 20*skill_level 
    self.knockback_range = 100+60*skill_level
    -- DRAGON TAIL
--local active_chance = 0+0.03*skill_level
--local knockback_chance = 0+0.2*skill_level
--local knockback_range = 200+60*skill_level
    
   end
end

function modifier_chuongcai_trietythapbatdiet:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_trietythapbatdiet:OnCreated( kv )
self:Apply()
end

function modifier_chuongcai_trietythapbatdiet:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_trietythapbatdiet:OnDestroy()
self:GainBack()
end
