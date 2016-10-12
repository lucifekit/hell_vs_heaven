modifier_aow_truyhontrao_huyetvutinhphong = class({})
require('kem_lib/kem')
SETTING_RADIUS = 270
function modifier_aow_truyhontrao_huyetvutinhphong:IsHidden()
   return true
end

function modifier_aow_truyhontrao_huyetvutinhphong:RemoveOnDeath()
   return true
end




function modifier_aow_truyhontrao_huyetvutinhphong:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
return funcs
end
function modifier_aow_truyhontrao_huyetvutinhphong:GetOverrideAnimation( params )
  return ACT_DOTA_OVERRIDE_ABILITY_1
end
--function modifier_aow_truyhontrao_huyetvutinhphong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

function modifier_aow_truyhontrao_huyetvutinhphong:CheckState()
   local state = {
     [MODIFIER_STATE_DISARMED] = true,
     [MODIFIER_STATE_SILENCED] = true
   }
return state
end

LinkLuaModifier("modifier_aow_truyhontrao_bleed","heroes_abilities/aow_truyhontrao/modifier_aow_truyhontrao_bleed",LUA_MODIFIER_MOTION_NONE)

function modifier_aow_truyhontrao_huyetvutinhphong:OnIntervalThink()
  if(IsServer())then
    local caster=self:GetParent()
    if(caster:isDisabled())then
      self:Destroy()
    else
      local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(caster)
      local physical_damage_amplify = 0.55+0.11*skill_level
      local basic_damage = 0.45+0.01*skill_level
      local element_damage_min=135+38*skill_level
      local element_damage_max=153+42*skill_level
      local chance_to_maim = 0.15+0.005*skill_level
      local maim_time=1
      local max_target=5
     
      local damageData = {
        caster = caster,
        main_attribute_value = caster:GetAgility(), 
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
      }
      local damageInfo = DamageHandler:GetDamage(damageData)
      local critInfo = DamageHandler:GetCritInfo(caster)
      
  --    local group = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, SETTING_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  --     if #group > 0 then
  --        for _,unit in pairs(group) do          
  --            local modifier = unit:AddNewModifier(caster, self:GetAbility(),"modifier_aow_truyhontrao_bleed", { duration = 20 } )
  --            modifier:IncrementStackCount()
  --        end
  --     end
      
      local damageAreaData = {
          whoDealDamage = caster,
          byWhichAbility = self:GetAbility(),
          where = caster:GetOrigin(),
          radius = SETTING_RADIUS,
          damage = damageInfo,
          damage_element = ELEMENT_METAL,
          maxTarget = 7,
          crit = critInfo,
          custom = {
            action="status_effect",
            effect_type=EFFECT_MAIM,
            effect_chance=chance_to_maim*100,
            effect_time=1,
            modifier="modifier_aow_truyhontrao_bleed",
            modifier_duration=20,
            modifier_increase_stack_count=true
            
          }
       }        
       DamageHandler:DamageArea(damageAreaData)
    end
    
     
  end
  
end
function modifier_aow_truyhontrao_huyetvutinhphong:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    p:EmitSound("Hero_Juggernaut.BladeFuryStart")
   end
   
   self.particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_sword_dragon/juggernaut_blade_fury_dragon.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)
   ParticleManager:SetParticleControl(self.particle, 5,Vector(250,250,1)) 
   self:StartIntervalThink(0.25)
end

function modifier_aow_truyhontrao_huyetvutinhphong:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    p:StopSound("Hero_Juggernaut.BladeFuryStart")
   end
   
   ParticleManager:DestroyParticle(self.particle,true)
   self:StartIntervalThink(-1)
end

function modifier_aow_truyhontrao_huyetvutinhphong:OnCreated( kv )
self:Apply()
end

function modifier_aow_truyhontrao_huyetvutinhphong:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_huyetvutinhphong:OnDestroy()
self:GainBack()
end
