skill_aow_truyhontrao_quytraothamu = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_quytraothamu"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_EFFECT = "particles/edited_particle/aow_truyhontrao/qttu.vpcf"
SETTING_FLY_SPEED = 1800--1800
SETTING_FLY_TIME  = 0.7--0.7
SETTING_SPIN_TIME = 0.5
SETTING_SPIN_TICK = 0.05
SETTING_ATTACH_POINT = "attach_sword"
function skill_aow_truyhontrao_quytraothamu:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_aow_truyhontrao_quytraothamu:GetCooldown()
   if(IsInToolsMode())then
    return 3
   end
   return 10
end

function skill_aow_truyhontrao_quytraothamu:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_1,0.28)
   return true
end
function skill_aow_truyhontrao_quytraothamu:ReturnHook(time)
    Timers:CreateTimer(time,function()
      kemPrint("Return hook")
      Attachments:AttachProp(self:GetCaster(),self:GetCaster().attach_point_1, self:GetCaster().attach_model_1, 1.0)
    end)
end
function skill_aow_truyhontrao_quytraothamu:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   kemPrint("Start hooking")
   
   --self.bChainAttached = false--deo hieu
--  if self.hVictim ~= nil then
--    self.hVictim:InterruptMotionControllers( true )
--  end

  self.hook_damage = 1000  
  self.hook_speed = SETTING_FLY_SPEED
  self.hook_width = 100
  self.hook_distance = SETTING_FLY_TIME*SETTING_FLY_SPEED
  self.hook_followthrough_constant = 0.65

  self.vision_radius = 500  
  self.vision_duration = 4  

  self.vStartPosition = self:GetCaster():GetOrigin()
  self.vProjectileLocation = self.vStartPosition
  
  
  local vDirection = self:GetCursorPosition() - self.vStartPosition
  vDirection.z = 0.0

  local vDirection = ( vDirection:Normalized() ) * self.hook_distance
  self.vTargetPosition = self.vStartPosition + vDirection
  self.vHookOffset = Vector( 0, 0, 96 )
 
  
  caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=1})
  
  local flFollowthroughDuration = ( self.hook_distance / self.hook_speed * self.hook_followthrough_constant )
    --self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_meat_hook_followthrough_lua", { duration = flFollowthroughDuration } )
    
   
    
  local vHookTarget = self.vTargetPosition + self.vHookOffset
  local vKillswitch = Vector( ( SETTING_FLY_TIME * 2 )+SETTING_SPIN_TIME+0.5, 0, 0 )

  self.nChainParticleFXIndex = ParticleManager:CreateParticle( SETTING_EFFECT, PATTACH_CUSTOMORIGIN, self:GetCaster() )
  ParticleManager:SetParticleAlwaysSimulate( self.nChainParticleFXIndex )
  local attach_location = self:GetCaster():GetOrigin() + self.vHookOffset
  --attach_location = attach_location+0*RotateVector2D(angleBetweenCasterAndTarget,math.rad(45))
  ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, SETTING_ATTACH_POINT, attach_location, true )
  ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, vHookTarget )
  ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
  ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, vKillswitch )--thoi gian luu lai cua xich
  --ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, Vector(5,0,0) )
  ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 1, 0, 0 ) )
  ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 0, 0, 0 ) )--1 xoay 0 o xoay
  
  local tick = math.floor(SETTING_SPIN_TIME/SETTING_SPIN_TICK)
  local max_tick = tick
  caster:EmitSound( "Hero_Pudge.AttackHookExtend")
  
  if(caster.hiddenWearables==nil)then
    caster.hiddenWearables = {}
  end
  HideModel(caster,7,1)
  --Attachments:AttachProp(hero, heroData["attach_point_1"], heroData["attach_model_1"], 1.0)
  Attachments:Attachment_HideAttach({index=caster:entindex(),properties={attach="attach_hitloc"}})
  local hook_start_position = caster_position+200*RotateVector2D(angleBetweenCasterAndTarget ,math.rad(-45))
  local newAngle = (target_point-hook_start_position):Normalized()
  Timers:CreateTimer(SETTING_SPIN_TICK,function()
    tick=tick-1
    if(tick>0)then
      local ang = (max_tick-tick)*(360/max_tick)
      local chain_length = (max_tick-tick)*(25)
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, caster_position+chain_length*RotateVector2D(angleBetweenCasterAndTarget ,math.rad(ang)))
      return SETTING_SPIN_TICK
    else
      print("Hooking")
      --START HOOK
      --attach lai vao giua nguoi
      ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", attach_location, true )
      --bo dong tac xoay
      caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
      --bat dau dong tac vay tay
      caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,0.48)
      --cho cai hook bay den target
      ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, vHookTarget )
      
      local hook_proj = Projectiles:CreateProjectile({
           EffectName      = "",
           Ability         = self,
           vSpawnOrigin    = hook_start_position,
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
           vVelocity     = newAngle*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
           vHookVelocity = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,
           bProvidesVision   = true,
           numHit  = 0,
           iVisionRadius   = 200,
           iVisionTeamNumber = caster:GetTeamNumber(), 
           UnitTest = GeneralUnitTest,
           handled=false,
           nChainParticleFXIndex = self.nChainParticleFXIndex,
           vHookOffset = self.vHookOffset,
           no_miss = true,
           OnUnitHit = function(proj, unit) 
           --unit:EmitSound(SETTING_HIT_SOUND)
           DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
              --DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_METAL, {})
              --StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
              --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
              local dragDistance =(unit:GetAbsOrigin()-proj.Source:GetAbsOrigin()):Length2D()
              local dragTime = dragDistance/SETTING_FLY_SPEED
              if(dragDistance>250)then
                --chi drag duoc khi range > 250 
                if(unit:HasModifier("modifier_defense"))then
                  ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, caster, PATTACH_POINT_FOLLOW, SETTING_ATTACH_POINT, caster:GetOrigin() + self.vHookOffset, true)
                  
                else
                  print("Create impact effect")
                  local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, unit )
                  ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", proj.Source:GetOrigin(), true )
                  ParticleManager:ReleaseParticleIndex( nFXIndex )
                  
                  print("return hook particle effect")
                  ParticleManager:SetParticleControlEnt( proj.nChainParticleFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin() + proj.vHookOffset, true )
                  ParticleManager:SetParticleControl( proj.nChainParticleFXIndex, 4, Vector( 0, 0, 0 ) )--thap xuong
                  ParticleManager:SetParticleControl( proj.nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )-- xoay hook
                  
                  local hookVelocity = (unit:GetOrigin()-proj.Source:GetOrigin()):Normalized()*SETTING_FLY_SPEED
                  StatusEffectHandler:KnockBack(proj.Source,unit:GetAbsOrigin()+hookVelocity,unit,100,dragTime,dragDistance)
                  Timers:CreateTimer(dragTime,function()
                    StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_FALL, 100, 3)              
                  end)
                end
                
              end
              self:ReturnHook(dragTime)
              print("Set life time")
              --ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, Vector(dragTime,0,0) )
              
              
              proj.handled=true
              
              proj:Destroy()
              
            end,miss_function=function(proj)
              proj.handled=true
              ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, caster, PATTACH_POINT_FOLLOW, SETTING_ATTACH_POINT, caster:GetOrigin() + self.vHookOffset, true)
            end})
           end
        })
        
        --Track missile
        Track(hook_proj,hTarget,0.03,SETTING_FLY_SPEED,0)
        --Track particle
        Timers:CreateTimer(0.03,function()
           if(GameRules:GetGameTime() < (hook_proj.spawnTime + hook_proj.fExpireTime))then
            if(not hook_proj.handled)then
              if(hTarget)then
                ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin() + self.vHookOffset, true )
                
              end
              --ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 0, 0, 0 ) )
              --ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )
              return 0.03
            end
            
          end
          
        end)
        --Thu lai neu ko trung ai
        Timers:CreateTimer(SETTING_FLY_TIME,function()
          if(hook_proj)then
              if(not hook_proj.handled)then
                ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, caster, PATTACH_POINT_FOLLOW, SETTING_ATTACH_POINT, caster:GetOrigin() + self.vHookOffset, true)
                self:ReturnHook(SETTING_FLY_TIME)
              else
                --handled roi thi thoi
              end
          else
            print("#221 Ko thay hook_proj")
            ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, caster, PATTACH_POINT_FOLLOW, SETTING_ATTACH_POINT, caster:GetOrigin() + self.vHookOffset, true)
            self:ReturnHook(SETTING_FLY_TIME)
          end
          
          
          
        end)
    end
  end)
   
   
end

