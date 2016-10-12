skill_aow_truyhontrao_daodoantinhchung = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf"
SETTING_FLY_TIME = 0.5 
SETTING_FLY_SPEED = 500 
SETTING_CAST_SOUND = ""
SETTING_HIT_SOUND = ""
--------------------------------------------------------------------------------
function skill_aow_truyhontrao_daodoantinhchung:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return skill_level*2
end

function skill_aow_truyhontrao_daodoantinhchung:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_aow_truyhontrao_daodoantinhchung:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,5)
   return true
end

function skill_aow_truyhontrao_daodoantinhchung:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   local physical_damage_amplify = 0.22+0.15*skill_level
   local basic_damage = 0.35+0.0075*skill_level
   local element_damage_min=15+28*skill_level
   local element_damage_max=23+32*skill_level
   local chance_to_maim = 0.15+0.015*skill_level
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
   caster:EmitSound(SETTING_CAST_SOUND)
   local myEffect = ParticleManager:CreateParticle(SETTING_EFFECT, PATTACH_ABSORIGIN_FOLLOW, caster)
   ParticleManager:SetParticleControlEnt( myEffect, 0, caster, PATTACH_POINT_FOLLOW, "attach_sword", caster_position, true )
        
   --ParticleManager:SetParticleControl(self.particle, 5,Vector(250,250,1)) 
   for i = 0,2 do
    Timers:CreateTimer(i*0.2,function()
      if(i==2)then
        ParticleManager:DestroyParticle(myEffect,false)
      end
      if(caster:IsAlive())then
        
        if(math.random(0,100)<50)then
          caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT,5)
          local crit_effect = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_sword_fireborn_odachi/jugg_crit_blur_fb_odachi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
          ParticleManager:ReleaseParticleIndex(crit_effect)
          caster:EmitSound("Hero_Juggernaut.BladeDance")
        else
          caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,5)
          caster:EmitSound("Hero_Juggernaut.OmniSlash.Damage")
        end
        
        Projectiles:CreateProjectile( {
         EffectName      = "particles/edited_particle/aow_truyhontrao/ddtc.vpcf",
         Ability         = self,
         vSpawnOrigin    = caster_position,
         fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
         
         
         
         fStartRadius    = 100,
         fEndRadius      = 100,
         Source        = caster,
         bHasFrontalCone   = true,
         bReplaceExisting  = false,
         fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
         GroundBehavior = PROJECTILES_NOTHING,
         UnitBehavior  = PROJECTILES_NOTHING,
         vVelocity     = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
         bProvidesVision   = true,
         numHit  = 0,
         iVisionRadius   = 200,
         damage = damageInfo,
         crit = critInfo,
         effect = EFFECT_MAIM,
         effect_chance = chance_to_maim*100,
         effect_time = maim_time,
         maxTarget = max_target,
         iVisionTeamNumber = caster:GetTeamNumber(), 
         UnitTest = GeneralUnitTest,
         OnUnitHit = function(proj, unit) 
         --unit:EmitSound(SETTING_HIT_SOUND)
         DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
           DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_METAL, {})
           StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
           --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
           --proj:Destroy()
           end})
         end
      } )
      end
      
    end)
   end
   
   
end
