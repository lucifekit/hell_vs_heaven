skill_chuongcai_hanglonghuuhoi = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/chuong_cai/hlhh.vpcf"
--SETTING_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_phongvanbienhuyen.vpcf"
SETTING_FLY_TIME = 1 
SETTING_FLY_SPEED = 800 
SETTING_CAST_SOUND = "Hero_Lina.DragonSlave"
SETTING_HIT_SOUND = "Hero_Lina.ProjectileImpact"
--------------------------------------------------------------------------------
function skill_chuongcai_hanglonghuuhoi:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return skill_level*10
end

function skill_chuongcai_hanglonghuuhoi:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_chuongcai_hanglonghuuhoi:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_chuongcai_hanglonghuuhoi:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   -- DRAGON SPLASH
local mana_cost = 0+10*skill_level
local basic_damage = 0.17+0.005*skill_level
local element_damage_min = 181.58+4.842*skill_level
local element_damage_max = 222.06+5.894*skill_level
local chance_to_burn = 0.05+0.007*skill_level
local burn_time = 2+0.1*skill_level
local max_target = 5
   
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
   local skill_11x = caster:FindAbilityByName("skill_chuongcai_traolongcong")
   local skill_11x_level = 0
   if(skill_11x)then
      skill_11x_level = skill_11x:GetLevel()+GetSkillLevel(caster)
   end
   local hlhh_speed = SETTING_FLY_SPEED
   if(HasBook(caster))then
    hlhh_speed = hlhh_speed+400
   end
   for i = -3,3 do
      local angle = RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*22.5))
      local spawn_point = caster_position+angle*80+Vector(0,0,50)
      local cp1 = spawn_point+ angle*hlhh_speed
    
      Projectiles:CreateProjectile( {
         EffectName      = SETTING_EFFECT,
         Ability         = self,
         ControlPoints   = {[1]=cp1,[2]=Vector(hlhh_speed,0,0)},
         vSpawnOrigin    = spawn_point,
         fDistance     = SETTING_FLY_TIME*hlhh_speed,
         fStartRadius    = 120,
         fEndRadius      = 120,
         Source        = caster,
         bHasFrontalCone   = true,
         bReplaceExisting  = false,
         fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
         GroundBehavior = PROJECTILES_NOTHING,
         UnitBehavior  = PROJECTILES_NOTHING,
         vVelocity     = angle*hlhh_speed,--angleBetweenCasterAndTarget,
         bProvidesVision   = true,
         numHit  = 0,
         iVisionRadius   = 200,
         damage = damageInfo,
         crit = critInfo,
         effect = EFFECT_BURN,
         effect_chance = chance_to_burn*100,
         effect_time = burn_time,
         maxTarget = max_target,
         skill_11x_level = skill_11x_level,
         iVisionTeamNumber = caster:GetTeamNumber(), 
         UnitTest = GeneralUnitTest,         
         OnUnitHit = function(proj, unit)  
       
           
           DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
          
            unit:EmitSound(SETTING_HIT_SOUND)
            
            StatusEffectHandler:ApplyEffect(proj.Source, unit, proj.effect, proj.effect_chance, proj.effect_time)
            --PrintTable(proj)
            --print("103")
            local damage_action = {}
            --print("Level "..proj.skill_11x_level)
            if(proj.skill_11x_level>0)then
              proj.numHit = proj.numHit+1
              --local splash_damage = 0+0.1*skill_level
              --local splash_damage_max = 0+0.2*skill_level
              local multipler = 0.1*proj.skill_11x_level*math.min(proj.numHit-1,2) 
              if(HasBook(proj.Source))then
                multipler = multipler+math.min(0.5*proj.numHit-1,1)
              end
              print(proj.numHit,multipler)
              damage_action= {action="multiple_damage",value=1+multipler}
              
            end
            DamageHandler:ApplyDamage(proj.Source, proj.Ability, unit, proj.damage, proj.crit, ELEMENT_FIRE, damage_action)
            --PrintTable(damage_action)
            
            --StatusEffectHandler:ApplyEffect(proj.Source, unit, EFFECT_BURN, chance_to_burn, burn_time)
            --proj:Destroy()
           end})
         end
      } ) 
   end
   
end
