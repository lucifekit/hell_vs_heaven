modifier_boss_hell = class({})
function modifier_boss_hell:IsHidden()
  return true
end
function modifier_boss_hell:RemoveOnDeath()
  return false
end
function modifier_boss_hell:IsPurgable()
  return false
end
function modifier_boss_hell:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
 
  return funcs
end

function modifier_boss_hell:GetModifierPreAttack_BonusDamage()
  return -10000
end

SETTING_ABILITY_80 = "boss_hell_68"
SETTING_ABILITY_90 = "boss_hell_9"
SETTING_ABILITY_100 = "boss_hell_10"
SETTING_ABILITY_80_MESSAGE = "hell_68"
SETTING_ABILITY_90_MESSAGE = "hell_9"
SETTING_ABILITY_100_MESSAGE = "hell_10"

SETTING_ATTACK_SOUND = "crystalmaiden_cm_attack_0"

SETTING_WELCOME_MESSAGE = "hell_welcome"

SETTING_MESSAGE_HEIGHT = -100

-----------------------------------------------------------------------------------
--
--
--
--  CUSTOM EFFECT , DAMAGE SETTING
--
--
--
--
--
--
----------------------------------------------------------------------------------------

--SETTING_MISSILE_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_phongvanbienhuyen.vpcf"
SETTING_MISSILE_EFFECT = "particles/boss_tong.vpcf"
SETTING_MISSILE_FALLDOWN_EFFECT = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack.vpcf"
SETTING_MISSILE_HIT_EFFECT = "particles/edited_particle/kiem_doan/fx_phongvanbienhuyen_hit.vpcf"
--SETTING_PVBH_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_MISSILE_FLY_TIME = 1.3
SETTING_MISSILE_PUSHBACK = 500
SETTING_MISSILE_FLY_SPEED = 900
SETTING_MISSILE_MAX_DISTANCE = 1200

--LinkLuaModifier("modifier_boss_dieptinh_speed","bosses/modifier_boss_dieptinh_speed",LUA_MODIFIER_MOTION_NONE)




function modifier_boss_hell:OnAttack(kv)
  if(IsServer())then
    local caster = self:GetParent()
    if(not caster.SayHi)then
      kemPrint("Add bubble")
      caster:AddSpeechBubble(1, "#"..SETTING_WELCOME_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
      caster.SayHi=true
    end
    if(kv.attacker==caster)then
      --kemPrint(caster:GetUnitName().." - "..kv.attacker:GetUnitName().." - "..kv.target:GetUnitName())
      local chance = math.random(0,100)
      if(chance<50)then
        self:NormalAttack(kv.target)
      else
        if(chance<80)then
            local ability_80 = caster:FindAbilityByName(SETTING_ABILITY_80)
            
            if(ability_80:IsCooldownReady())then
              caster:AddSpeechBubble(1, "#"..SETTING_ABILITY_80_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
              self:Cast80(kv.target)
              ability_80:StartCooldown(10)
            else
              self:NormalAttack(kv.target) 
            end
        else
          if(chance<90)then
             local ability_90 = caster:FindAbilityByName(SETTING_ABILITY_90)
             
             if(ability_90:IsCooldownReady())then
              caster:AddSpeechBubble(1, "#"..SETTING_ABILITY_90_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
              self:Cast90(kv.target)
              ability_90:StartCooldown(15)
             else
              self:NormalAttack(kv.target) 
             end
          else
             local ability_100 = caster:FindAbilityByName(SETTING_ABILITY_100)
             if(ability_100:IsCooldownReady())then
              caster:AddSpeechBubble(1, "#"..SETTING_ABILITY_100_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
              self:Cast100(kv.target)
              ability_100:StartCooldown(20)
             else
              self:NormalAttack(kv.target) 
             end
          end
        end
      end
    end
  end
  
  
end

function modifier_boss_hell:NormalAttack(target)
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(2000,3000,1000,2000)
  local critInfo = DamageHandler:InitCrit(20,2)
  
  for i = 1,6 do
    --missileData.vSpawnOrigin = 

    local spawn_point = caster_point
    --kemPrint("Create missile height "..spawn_point.z)
    Projectiles:CreateProjectile({
        EffectName      = SETTING_MISSILE_EFFECT,
        Ability         = nil,
        vSpawnOrigin    = spawn_point,
        fDistance     =  1000,
        fStartRadius    = 100,
        fEndRadius      = 100,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = 1,--GameRules:GetGameTime() +100,--
      
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*60))*SETTING_MISSILE_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        effect = EFFECT_BURN,
        effect_chance = 60,
        effect_time = 3,
        fRehitDelay = 0.5,
        maxTarget = 4,
        iVisionTeamNumber = caster:GetTeamNumber(),        
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)

          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            --kemPrint("Hit 141")
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
          end})
        end
      })
  end
end
--blink strike
function modifier_boss_hell:Cast80(target)
  
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(500,1000,1000,1500)
  local critInfo = DamageHandler:InitCrit(20,2)
   local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        radius = 200,
        damage =damageInfo,
        crit = critInfo,
        damage_element = ELEMENT_FIRE,
        custom = {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=60,
          effect_time=3
        }
      }
  for i=0,3 do
    Timers:CreateTimer(i*3,function()
      --print(i)
      caster:EmitSound("Ability.LightStrikeArray")
      local number_of_fire = i*3+1
      local multi = 0.5*(i+1)
      local tempDamage = {min_physic=damageInfo.min_physic*multi,max_physic=damageInfo.max_physic*multi,min_element=damageInfo.min_element*multi,max_element=damageInfo.max_element*multi,}
      damageAreaData.damage = tempDamage
      --PrintTable(damageAreaData.damage)
      for j = 1,number_of_fire do
        local tempPoint = caster_point+RotateVector2D(angleBetweenCasterAndTarget,math.rad(j*360/number_of_fire))*i*300
        FxPoint("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf",tempPoint,2)
        damageAreaData.where = tempPoint
        DamageHandler:DamageArea(damageAreaData)
             
      end
     
    end)
    
  end
  
  
end
--meteor fall
function modifier_boss_hell:Cast90(target)
  local tick = 12
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(1000,1500,3000,5000)
  local critInfo = DamageHandler:InitCrit(20,2)
  
  caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
  local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        radius = 100,
        damage =damageInfo,
        crit = critInfo,
        damage_element = ELEMENT_FIRE,
        custom = {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=60,
          effect_time=3
        }
      }
  Timers:CreateTimer(2,function() 
    if (tick>0)then
      tick=tick-1
      local tempAngle =RotateVector2D(angleBetweenCasterAndTarget,math.rad(tick*30))
      local tempPoint = target_point+Vector(math.random(-150,150),math.random(-150,150),0)
      local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle(SETTING_MISSILE_FALLDOWN_EFFECT, PATTACH_ABSORIGIN, caster)
      ParticleManager:SetParticleControl( chaos_meteor_fly_particle_effect, 0, tempPoint +Vector(0,0,900))
      ParticleManager:SetParticleControl( chaos_meteor_fly_particle_effect,1, tempPoint+Vector(0,0,50))
      ParticleManager:SetParticleControl( chaos_meteor_fly_particle_effect, 2, Vector(900,0,0) )
      
      Timers:CreateTimer(1,function()
         damageAreaData.where = tempPoint
         SoundPoint("Hero_TemplarAssassin.Trap.Explode",tempPoint,1,DOTA_TEAM_NEUTRALS)
         FxPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf",tempPoint,1)
         DamageHandler:DamageArea(damageAreaData)
         ParticleManager:DestroyParticle(chaos_meteor_fly_particle_effect,true)
      end)
  
      

         
            
       
      return 0.33
    end
  end)
end
--hell canon
function modifier_boss_hell:Cast100(target)
  local number_of_missile = 30
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(1000,1500,3000,5000)
  local critInfo = DamageHandler:InitCrit(20,2)
  
  
  Timers:CreateTimer(2,function() 
    if (number_of_missile>0)then
      number_of_missile = number_of_missile-1
      FxPoint("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf",caster_point,1)
      SoundPoint("Hero_TemplarAssassin.Trap.Explode",caster_point,1,DOTA_TEAM_NEUTRALS)
      Projectiles:CreateProjectile({
        EffectName      = SETTING_MISSILE_EFFECT,
        Ability         = nil,
        vSpawnOrigin    = caster_point+Vector(math.random(-150,150),math.random(-150,150),0),
        fDistance     =  1000,
        fStartRadius    = 100,
        fEndRadius      = 100,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = 1,--GameRules:GetGameTime() +100,--
      
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity    = angleBetweenCasterAndTarget*SETTING_MISSILE_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        effect = EFFECT_BURN,
        effect_chance = 60,
        effect_time = 3,
        fRehitDelay = 0.5,
        maxTarget = 4,
        iVisionTeamNumber = caster:GetTeamNumber(),        
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)

          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            --kemPrint("Hit 141")
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
          end})
        end
      })
      return 0.33
    end
  end)
  
end

function modifier_boss_hell:OnCreated(kv)
  --kemPrint("BOSS DIEP TINH ONCREATED")
  if(IsServer())then
    self:GetParent().SayHi = false
    for i = 0,12 do
      local tempAbility = self:GetParent():GetAbilityByIndex(i)
      if(tempAbility)then        
        tempAbility:SetLevel(1)
      end
    end
  end
end

function modifier_boss_hell:OnRefresh(kv)
  if(IsServer())then
    
  end
end