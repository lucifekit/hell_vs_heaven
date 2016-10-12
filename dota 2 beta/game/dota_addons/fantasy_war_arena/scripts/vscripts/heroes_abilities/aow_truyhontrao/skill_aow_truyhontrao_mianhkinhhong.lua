skill_aow_truyhontrao_mianhkinhhong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_mianhkinhhong"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_EFFECT = "particles/edited_particle/aow_truyhontrao/makh.vpcf"
SETTING_FLY_SPEED = 1800--1800
SETTING_FLY_TIME  = 0.7--0.7
SETTING_SPIN_TICK = 0.05
SETTING_ATTACH_POINT = "attach_sword"
function skill_aow_truyhontrao_mianhkinhhong:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_aow_truyhontrao_mianhkinhhong:GetCooldown()   
   return 8
end

function skill_aow_truyhontrao_mianhkinhhong:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,atk_perseconds)
   return true
end
function skill_aow_truyhontrao_mianhkinhhong:ReturnHook()

   Attachments:AttachProp(self:GetCaster(),self:GetCaster().attach_point_1, self:GetCaster().attach_model_1, 1.0)

end
function skill_aow_truyhontrao_mianhkinhhong:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   local distanceBetweenCasterAndCursor = (target_point-caster_position):Length2D()
   --self:PayManaCost()
   
  -- BLUR CHAIN
local basic_damage = 0.7+0.05*skill_level
local physical_damage_amplify = 0.65+0.08*skill_level
local chance_to_immobile = 0.25+0.15*skill_level
local immobile_time = 2+0.1*skill_level
local element_damage_min = 100
local element_damage_max = 200
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
   
  
   self.hook_speed = SETTING_FLY_SPEED
   self.hook_width = 100
   self.hook_distance = SETTING_FLY_TIME*SETTING_FLY_SPEED
  
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=SETTING_FLY_TIME})
  
  
   local vHookTarget = caster_position + angleBetweenCasterAndTarget * self.hook_distance
   local vKillswitch = Vector( SETTING_FLY_TIME , 0, 0 )
  
   self.nChainParticleFXIndex = ParticleManager:CreateParticle( SETTING_EFFECT, PATTACH_CUSTOMORIGIN, self:GetCaster() )
   ParticleManager:SetParticleAlwaysSimulate( self.nChainParticleFXIndex )
   
   --attach_location = attach_location+0*RotateVector2D(angleBetweenCasterAndTarget,math.rad(45))
   ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", caster_position, true )
   ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, vHookTarget )
   ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
   ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, vKillswitch )--thoi gian luu lai cua xich
   --ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, Vector(5,0,0) )
   ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 1, 0, 0 ) )
   ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )--1 xoay 0 o xoay
  
 
   caster:EmitSound( "Hero_Pudge.AttackHookExtend")
  
   if(caster.hiddenWearables==nil)then
     caster.hiddenWearables = {}
   end
  
   Attachments:Attachment_HideAttach({index=caster:entindex(),properties={attach="attach_hitloc"}})
  
  

  --START HOOK
  
   local hook_proj = Projectiles:CreateProjectile({
       EffectName      = "",
       Ability         = self,
       vSpawnOrigin    = caster_position,
       fDistance       = SETTING_FLY_TIME*SETTING_FLY_SPEED,
        --start tracking
       
         --end tracking
       fStartRadius    = 100,
       fEndRadius      = 100,
       Source        = caster,
       bHasFrontalCone   = true,
       bReplaceExisting  = false,
       fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
       GroundBehavior = PROJECTILES_NOTHING,
       UnitBehavior  = PROJECTILES_NOTHING,
       vVelocity     = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
       vHookVelocity = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,
       bProvidesVision   = true,
       numHit  = 0,
       iVisionRadius   = 200,
       iVisionTeamNumber = caster:GetTeamNumber(), 
       UnitTest = GeneralUnitTest,
       handled=false,
       nChainParticleFXIndex = self.nChainParticleFXIndex,
       no_miss = true,
       damage = damageInfo,
       crit = critInfo,
       effect = EFFECT_IMMOBILE,
       effect_chance=chance_to_immobile*100,
       effect_time=immobile_time,
       OnUnitHit = function(proj, unit) 
       --unit:EmitSound(SETTING_HIT_SOUND)
       DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
          DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_METAL, {})
          --StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
          --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
          print("reshow hook")
          self:ReturnHook()
          ParticleManager:DestroyParticle(self.nChainParticleFXIndex,true)
          BreakDefense(unit,proj.Source,function(breaker,target)
            StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
          end)
          
          proj.handled=true
          proj:Destroy()
        end,miss_function=function(proj)
          proj.handled=true          
        end})
       end
    })
    
    --Track missile
    Track(hook_proj,hTarget,0.1,SETTING_FLY_SPEED,0)
    --Track particle
    
    Timers:CreateTimer(0.1,function()
      if(GameRules:GetGameTime() < (hook_proj.spawnTime + hook_proj.fExpireTime))then
        if(hook_proj.handled)then
        else
          print("#138 - chua handled")
          if(hTarget)then
            ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin() , true )            
          end
          return 0.1
        end
        
      end
      
    end)
    
   
end
