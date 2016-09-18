modifier_aow_mehontieu_thanhondiendao = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_thanhondiendao:IsHidden()
   return false
end

function modifier_aow_mehontieu_thanhondiendao:RemoveOnDeath()
   return false
end



LinkLuaModifier("modifier_aow_mehontieu_ngudockykinh","heroes_abilities/aow_mehontieu/modifier_aow_mehontieu_ngudockykinh",LUA_MODIFIER_MOTION_NONE)

function modifier_aow_mehontieu_thanhondiendao:ActiveOnHit(target)
  self:IncrementStackCount()
  if(self:GetStackCount()>=self.stack_require)then
    self:SetStackCount(0)
    local modi = target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_aow_mehontieu_ngudockykinh",{duration=60})
    if(modi)then
      modi:IncrementStackCount()
      if(modi:GetStackCount()==3)then
        --Explode
        target:RemoveModifierByName("modifier_aow_mehontieu_ngudockykinh")
        local p = self:GetParent()
        local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
        
        local basic_damage = 1+0.1*skill_level
        local physical_damage_amplify = 0.75+0.15*skill_level
        local element_damage_min = 312+144*skill_level
        local element_damage_max = 543+196*skill_level
        local immobile_chance = 0.5+0.1*skill_level
        local immobile_duration = 2+0.3*skill_level
        
        local damage1Data = {
        caster = p,
        main_physic = p.stat_tp,
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
       local critInfo = DamageHandler:GetCritInfo(p)
       local damageAreaData = {
            whoDealDamage = p,
            byWhichAbility = self,
            where = target:GetOrigin(),
            radius = 300,
            damage = DamageHandler:GetDamage(damage1Data),
            damage_element = ELEMENT_METAL,
            crit = critInfo,
            custom = {
              action="status_effect",
              effect_type=EFFECT_IMMOBILE,
              effect_chance=immobile_chance*100,
              effect_time=immobile_duration
            }
          }
          DamageHandler:DamageArea(damageAreaData)
          FxPoint("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf",target:GetOrigin(),1)
          SoundPoint("Hero_TemplarAssassin.Trap.Explode",target:GetOrigin(),1,p:GetTeam())
        
      end
    end
  end
end

function modifier_aow_mehontieu_thanhondiendao:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    self.stack_require=10-skill_level
   end
end

function modifier_aow_mehontieu_thanhondiendao:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_aow_mehontieu_thanhondiendao:OnCreated( kv )
self:Apply()
end

function modifier_aow_mehontieu_thanhondiendao:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_mehontieu_thanhondiendao:OnDestroy()
self:GainBack()
end
