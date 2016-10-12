modifier_aow_truyhontrao_daimaccohon = class({})
require('kem_lib/kem')
SETTING_RADIUS = 450
SETTING_SPEED = 2000
SETTING_EFFECT = "particles/edited_particle/aow_truyhontrao/qttu.vpcf"
SETTING_STORM_EFFECT = "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf"

function modifier_aow_truyhontrao_daimaccohon:IsHidden()
   return false
end

function modifier_aow_truyhontrao_daimaccohon:RemoveOnDeath()
   return true
end




function modifier_aow_truyhontrao_daimaccohon:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
return funcs
end
function modifier_aow_truyhontrao_daimaccohon:GetOverrideAnimation( params )
  return ACT_DOTA_OVERRIDE_ABILITY_1
end
--function modifier_aow_truyhontrao_huyetvutinhphong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

function modifier_aow_truyhontrao_daimaccohon:CheckState()
   local state = {
     [MODIFIER_STATE_DISARMED] = true,
     [MODIFIER_STATE_SILENCED] = true
   }
return state
end

LinkLuaModifier("modifier_aow_truyhontrao_bleed","heroes_abilities/aow_truyhontrao/modifier_aow_truyhontrao_bleed",LUA_MODIFIER_MOTION_NONE)

function modifier_aow_truyhontrao_daimaccohon:OnIntervalThink()
  if(IsServer())then
    
    local caster=self:GetParent()
    if(caster:isDisabled())then
      self:Destroy()
    else
      local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(caster)
      local physical_damage_amplify = 0.75+0.08*skill_level
      local basic_damage = 0.65+0.03*skill_level
      local element_damage_min=365+48*skill_level
      local element_damage_max=453+62*skill_level
      local chance_to_maim = 0.25+0.015*skill_level
      local maim_time=1
      local max_target=5
      
      caster:EmitSound("Hero_Pudge.DismemberSwings")
      
      FxPointControl(SETTING_STORM_EFFECT,caster:GetOrigin(),0.5,{[1]=Vector(SETTING_RADIUS,SETTING_RADIUS,0)})
      
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
            callback=function(attacker,target)
              kemPrint("Callback")
              if(not target:HasModifier("modifier_defense"))then
                  local chance_to_knockback=30+10
                  local knockback_distance=100+20
                  local current_distance = (target:GetOrigin()-attacker:GetOrigin()):Length2D()
                  if(current_distance<SETTING_RADIUS)then
                    local knockback_range = math.min(SETTING_RADIUS-current_distance,knockback_distance) 
                    kemPrint("APply knockback")
                    StatusEffectHandler:KnockBack(attacker,attacker:GetOrigin(),target,chance_to_knockback,0.5,knockback_range)
                  end
              end
            end
          }
       }        
       --kemPrint("Call damage area")
       DamageHandler:DamageArea(damageAreaData)
       local now_position = caster:GetOrigin()
       if(caster.dmch_last_position)then
         if((caster.dmch_last_position-now_position):Length2D()>1500)then
            self:Destroy()
         end
       end
    end
    
  end
  
end
function modifier_aow_truyhontrao_daimaccohon:Apply()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
    p:EmitSound("Hero_Juggernaut.BladeFuryStart")
   
    --print("Create fury effect")
    --self.particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_sword_dragon/juggernaut_blade_fury_dragon.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)
    --ParticleManager:SetParticleControl(self.particle, 5,Vector(250,250,1)) 
    --print("Create chain effect")
    self.nChainTick = 0
    self.nChainParticleFXIndex = {}
    local create_time = SETTING_RADIUS/SETTING_SPEED
    local live_time = self.tick_time*self.max_tick+create_time+0.25
    for i=1,4 do
      self.nChainParticleFXIndex[i] =  ParticleManager:CreateParticle( SETTING_EFFECT, PATTACH_CUSTOMORIGIN,p)
      ParticleManager:SetParticleAlwaysSimulate( self.nChainParticleFXIndex[i] )
      ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex[i], 0, p, PATTACH_POINT_FOLLOW, "attach_sword",p:GetOrigin() , true )
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex[i], 1, p:GetOrigin()+SETTING_RADIUS*RotateVector2D(self.vChainAngle,math.rad(90*i)))
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex[i], 2, Vector( SETTING_SPEED, SETTING_RADIUS*2, 100 ) )
      
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex[i], 3, Vector(live_time,0,0) )--thoi gian luu lai cua xich
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex[i], 4, Vector( 1, 0, 0 ) )
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex[i], 5, Vector( 1, 0, 0 ) )--1 xoay 0 o xoay
    end

    kemPrint("Start interval think")  
    p.dmch_last_position = p:GetOrigin()  
    Timers:CreateTimer(create_time,function()   
      local ang = self.nChainTick*18    
      self.nChainTick = self.nChainTick+1
      local now_position = p:GetOrigin()
      if(p.dmch_last_position)then
        if((p.dmch_last_position-now_position):Length2D()<1500)then
            for i=1,4 do
              local newPoint = p:GetOrigin()+SETTING_RADIUS*RotateVector2D(self.vChainAngle ,math.rad(ang+90*i))
              newPoint.z = math.random(0,100)
              ParticleManager:SetParticleControl( self.nChainParticleFXIndex[i], 1,newPoint)
            end
            
            return 0.05
        else
          for i =1,4 do
            ParticleManager:DestroyParticle(self.nChainParticleFXIndex[i],true)  
          end
        end
      end
    
    
    end)
    self:StartIntervalThink(self.tick_time)
   end
   
   
end

function modifier_aow_truyhontrao_daimaccohon:GainBack()
   local p = self:GetParent()
   local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
   if(IsServer())then
      p:StopSound("Hero_Juggernaut.BladeFuryStart")
      --kemPrint("Destroy particle")
      for i =1,4 do
        ParticleManager:DestroyParticle(self.nChainParticleFXIndex[i],true)  
      end
      --kemPrint("Stop think")
      self:StartIntervalThink(-1)
   end
   
   --ParticleManager:DestroyParticle(self.particle,true)
  
   
end

function modifier_aow_truyhontrao_daimaccohon:OnCreated( kv )

if(IsServer())then
  self.vChainAngle = Vector(tonumber(kv.angleX),tonumber(kv.angleY),tonumber(kv.angleZ))
  self.max_tick = kv.max_tick
  self.tick_time = kv.tick_time
end
self:Apply()
end

function modifier_aow_truyhontrao_daimaccohon:OnRefresh( kv )
self:GainBack()
self:Apply()
end

function modifier_aow_truyhontrao_daimaccohon:OnDestroy()
self:GainBack()
end
