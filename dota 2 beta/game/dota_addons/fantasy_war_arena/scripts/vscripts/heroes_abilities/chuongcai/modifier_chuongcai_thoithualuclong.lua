modifier_chuongcai_thoithualuclong = class({})
require('kem_lib/kem')
SETTING_BUFF_DURATION = 20--20
SETTING_EFFECT = "particles/edited_particle/chuong_cai/ttll.vpcf"
function modifier_chuongcai_thoithualuclong:IsHidden()
   return self:GetStackCount()==0
end
function modifier_chuongcai_thoithualuclong:DestroyOnExpire()
   return false
end
function modifier_chuongcai_thoithualuclong:RemoveOnDeath()
   return false
end

function modifier_chuongcai_thoithualuclong:OnIntervalThink()
  if IsServer() then
    --print("On interval think, set stack count 0")
    self:SetStackCount(0)
    
    self:StartIntervalThink( -1 )   
      
    ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(0, 0, 0 ) )
  end
  
end
--modifier_chuongcai_thoithualuclong
function modifier_chuongcai_thoithualuclong:ActiveOnHit(target)
  --print("Active on hit")
  if(self:GetStackCount()>0)then
    --print("Yes stack count > 0")
    local p = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local skill_11x = p:FindAbilityByName("skill_chuongcai_traolongcong")
    local skill_11x_level = 0
    if(skill_11x)then
      skill_11x_level = skill_11x:GetLevel()+GetSkillLevel(p)
    end
    self:DecrementStackCount()
    if(self:GetStackCount()==0)then
      self:StartIntervalThink(-1)
    end
    ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) ) 
    if(IsServer())then
      -- SIX INTERNAL DRAGON
      --print("Dealing damage")
local critInfo = DamageHandler:GetCritInfo(p)
local basic_damage = 0.5
local element_damage_min = 115+85*skill_level
local element_damage_max = 185+95*skill_level
local max_target = 5
local damageDataExplode = {
      caster = p,
      main_magic = p:GetIntellect(), 
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = element_damage_min,
      element_damage_max = element_damage_max
   }
   local damageAreaData = {
        whoDealDamage = p,
        byWhichAbility = self,        
        radius = 200,
        where  = target:GetOrigin(),
        damage = DamageHandler:GetDamage(damageDataExplode),
        damage_element = ELEMENT_FIRE,
        crit = critInfo,
        custom = {}
      }
      DamageHandler:DamageArea(damageAreaData)
      --FxPoint("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf",target:GetOrigin(),1)
      --print("create fx thoi thua luc long")
      local pfx = ParticleManager:CreateParticle(SETTING_EFFECT, PATTACH_ABSORIGIN, target )
      --print("set control ent 1")
      ParticleManager:SetParticleControlEnt( pfx, 0, target, PATTACH_POINT_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )
      --print("set control ent 2")
      ParticleManager:SetParticleControlEnt( pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
      --print("releasing")
      ParticleManager:ReleaseParticleIndex(pfx)
      --print("released")
      if(skill_11x_level>0)then
        local paralyze_chance = 0.05+0.03*skill_level
        local paralyze_time = 1.5+0.2*skill_level
        --print("apply paralayze")
        StatusEffectHandler:ApplyEffect(p, target, EFFECT_PARALIZED, paralyze_chance*100, paralyze_time)
      end
    end
  end
  
end
function modifier_chuongcai_thoithualuclong:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   print("applying thoi thua luc long")
   if(IsServer())then
     local max_stack = 1+1*skill_level
     local duration = 5+3*skill_level
     self:SetStackCount(max_stack)
     self:SetDuration(duration, true )
     self:StartIntervalThink(duration)
     ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(max_stack, 0, 0 ) )
     
   end
   
  
end

function modifier_chuongcai_thoithualuclong:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
   end
end

function modifier_chuongcai_thoithualuclong:OnCreated( kv )
  if(IsServer())then
      print("Oncreate modifier")
      self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
      ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(0, 0, 0 ) )      
      self:AddParticle( self.nFXIndex, false, false, -1, false, false )
   end
--self:Apply()
end

function modifier_chuongcai_thoithualuclong:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_chuongcai_thoithualuclong:OnDestroy()
self:GainBack()
end
