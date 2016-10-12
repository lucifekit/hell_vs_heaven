skill_aow_truyhontrao_sattamthanhphan = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf"
SETTING_FLY_TIME = 0.5 
SETTING_FLY_SPEED = 500 
SETTING_CAST_SOUND = ""
SETTING_HIT_SOUND = ""
--------------------------------------------------------------------------------
function skill_aow_truyhontrao_sattamthanhphan:GetManaCost()
   
   return 0
end

function skill_aow_truyhontrao_sattamthanhphan:GetCooldown()
   return 999   
end
function skill_aow_truyhontrao_sattamthanhphan:IsAngryAbility()
   return true
end
--function skill_aow_truyhontrao_daimaccohon:OnAbilityPhaseStart()
--   
--   return true
--end
function skill_aow_truyhontrao_sattamthanhphan:EndSlash()
  self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end
function skill_aow_truyhontrao_sattamthanhphan:OnUpgrade()
  self:StartCooldown(999)
end
function skill_aow_truyhontrao_sattamthanhphan:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   local tick = 7
   
   local physical_damage_amplify = 0.75+0.05*skill_level
   local basic_damage = 0.55+0.07*skill_level
   local element_damage_min=335+43*skill_level
   local element_damage_max=364+52*skill_level
   local chance_to_maim = 0.15+0.025*skill_level
   local maim_time=1
   local max_target=5

   local critInfo = DamageHandler:GetCritInfo(caster)
   
  
   FxPoint("particles/frostivus_herofx/juggernaut_omnislash_ascension.vpcf",caster_position,1)
   caster:EmitSound("juggernaut_jug_ability_omnislash_"..math.random(10,30))
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_4,atk_perseconds)
   
   
   caster:SetOrigin(caster_position+angleBetweenCasterAndTarget*((target_point-caster_position):Length2D()-100))
   FxPointControl("particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_trail_serrakura.vpcf",caster_position,1,{[1]=target_point})       
   
   
   Timers:CreateTimer(0.1,function()
    tick = tick -1--
    if(caster:IsMoving())then
      print("Is moving")
      tick=0
    else
      caster:EmitSound("Hero_Juggernaut.OmniSlash")
      local current_position = caster:GetOrigin()
      local target_position  = target_point
      if(hTarget~=nil)then
        if(hTarget:IsAlive())then
          if((hTarget:GetOrigin()-current_position):Length2D()<1500)then
            target_position = hTarget:GetOrigin()
            caster:SetOrigin(target_position+Vector(math.random(-100,100),math.random(-100,100),0))  
          end
        end
        
      end
      local new_position = caster:GetOrigin()
      FxPointControl("particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_trail_serrakura.vpcf",current_position,1,{[1]=target_position})
      caster:SetForwardVector((target_point-caster:GetOrigin()):Normalized())
      
      if(math.random(0,100)<50)then
        caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT,5)
        local crit_effect = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_sword_fireborn_odachi/jugg_crit_blur_fb_odachi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:ReleaseParticleIndex(crit_effect)
        --caster:EmitSound("Hero_Juggernaut.BladeDance")
      else
        caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,5)
        --caster:EmitSound("Hero_Juggernaut.OmniSlash.Damage")
      end
      
      --deal damage
      local damage1Data = {
          caster = caster,
          main_physic = caster:GetAgility(),
          skill_physical_damage_percent = physical_damage_amplify,
          skill_tree_amplify_damage = 0,-- can edit
          skill_basic_damage_percent = basic_damage,
          element_damage_min = element_damage_min,
          element_damage_max = element_damage_max
          }
     local damageAreaData = {
          whoDealDamage = caster,
          byWhichAbility = self,
          where = caster:GetOrigin()+100*angleBetweenCasterAndTarget,
          radius = 200,
          damage = DamageHandler:GetDamage(damage1Data),
          damage_element = ELEMENT_METAL,
          maxTarget = 7,
          crit = critInfo,
          custom = {
            action="status_effect",
            effect_type=EFFECT_MAIM,
            effect_chance=chance_to_maim*100,
            effect_time=1
          }
        }
        
     
     --end damage setting
     
   
        DamageHandler:DamageArea(damageAreaData)
    end
    
    
    if(tick==0)then
      self:EndSlash()
    else
      return 0.33
    end
    
    
    
    
   end)
end