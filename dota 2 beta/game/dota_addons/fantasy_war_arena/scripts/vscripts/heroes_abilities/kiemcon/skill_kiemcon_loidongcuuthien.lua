skill_kiemcon_loidongcuuthien = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/kiem_con/ldct.vpcf"
SETTING_CAST_SOUND = "Hero_Zuus.GodsWrath"
SETTING_HIT_SOUND = "Hero_Zuus.GodsWrath.Target"
SETTING_LDCT_DELAY = 0.25
--------------------------------------------------------------------------------
function skill_kiemcon_loidongcuuthien:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
   return 150+skill_level*15
end

function skill_kiemcon_loidongcuuthien:GetCooldown(level)
   local ms = self:GetCaster():GetModifierStackCount("modifier_kiemcon_nguynguyconlon",self:GetCaster())
   return 5-0.2*ms
end

function skill_kiemcon_loidongcuuthien:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4,atk_perseconds)
   return true
end

function skill_kiemcon_loidongcuuthien:OnSpellStart()
   local caster = self:GetCaster()
   
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   
-- LIGHTNING NINE
local basic_damage = 1.18+0.075*skill_level
local element_damage_min = 1374+85*skill_level
local element_damage_max = 1680+104*skill_level
local chance_to_stun = 0.15+0.025*skill_level
local stun_time = 2
local max_target = math.floor(4.5+0.5*skill_level)

   
   
  local damageData = {
      caster = caster,
      main_magic = caster:GetIntellect(), 
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = element_damage_min,
      element_damage_max = element_damage_max
   }
   
   local damageInfo = DamageHandler:GetDamage(damageData)
 
   local critInfo = DamageHandler:GetCritInfo(caster)
   caster:EmitSound(SETTING_CAST_SOUND)
   
   if(hTarget)then
      
      
      local count = 1
      local bounceTable = {}
      local lastTargetPoint = hTarget:GetOrigin()
      FxPointRelease(SETTING_EFFECT,lastTargetPoint+Vector(0,0,1000),{[1]=lastTargetPoint})
      DamageHandler:ApplyDamage(caster,self,hTarget,damageInfo,critInfo,ELEMENT_EARTH,{})
      StatusEffectHandler:ApplyEffect(caster,hTarget,EFFECT_STUN,chance_to_stun*100,stun_time)
      bounceTable[hTarget] = 1  
      Timers:CreateTimer(SETTING_LDCT_DELAY,function()
        --find new target
          if(count<max_target)then            
            count=count+1
            local enemies = FindUnitsInRadius(caster:GetTeam(), 
              lastTargetPoint, 
              nil, 
              800, 
              DOTA_UNIT_TARGET_TEAM_ENEMY, 
              DOTA_UNIT_TARGET_ALL, 
              DOTA_UNIT_TARGET_FLAG_NONE, 
              FIND_CLOSEST, false )
            if #enemies > 0 then
              for _,enemy in pairs(enemies) do
                if(bounceTable[enemy]==nil)then
                  bounceTable[enemy] = 1
                  local tempPoint = enemy:GetOrigin()
                  enemy:EmitSound(SETTING_HIT_SOUND)
                  FxPointRelease(SETTING_EFFECT,tempPoint+Vector(0,0,1000),{[1]=tempPoint})
                  DamageHandler:ApplyDamage(caster,self,enemy,damageInfo,critInfo,ELEMENT_EARTH,{})
                  StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_STUN,chance_to_stun*100,stun_time)
                  --print("LDCT : Damage "..enemy:GetUnitName().." id "..enemy:entindex())
                  break  
                end
                
              end
              return SETTING_LDCT_DELAY
            else
              --print("LDCT : Found no target")
            end
          end
            
      
        
     end)
   else
    self:EndCooldown()
    
   end
  
   
   
   
   
end
