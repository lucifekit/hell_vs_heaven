modifier_boss_heaven = class({})
function modifier_boss_heaven:IsHidden()
  return true
end
function modifier_boss_heaven:RemoveOnDeath()
  return false
end
function modifier_boss_heaven:IsPurgable()
  return false
end
function modifier_boss_heaven:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
 
  return funcs
end

function modifier_boss_heaven:GetModifierPreAttack_BonusDamage()
  return -10000
end

SETTING_ABILITY_80 = "boss_heaven_68"
SETTING_ABILITY_90 = "boss_heaven_9"
SETTING_ABILITY_100 = "boss_heaven_10"
SETTING_ABILITY_80_MESSAGE = "heaven_68"
SETTING_ABILITY_90_MESSAGE = "heaven_9"
SETTING_ABILITY_100_MESSAGE = "heaven_10"

SETTING_ATTACK_SOUND = "crystalmaiden_cm_attack_0"
SETTING_90_CAST_SOUND = "skywrath_mage_drag_mystic_flare_01"
SETTING_WELCOME_MESSAGE = "heaven_welcome"

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
SETTING_MISSILE_EFFECT = "particles/boss_kim.vpcf"
SETTING_CHAIN_MISSILE_EFFECT = "particles/boss_heaven_chain_frost.vpcf"
SETTING_MISSILE_HIT_EFFECT = "particles/edited_particle/kiem_doan/fx_phongvanbienhuyen_hit.vpcf"
SETTING_MISSILE_FALLDOWN_EFFECT = "particles/econ/items/skywrath_mage/skywrath_mage_weapon_empyrean/skywrath_mage_mystic_flare_ambient_hit_empyrean.vpcf"
SETTING_FLARE_SOUND = "Hero_SkywrathMage.MysticFlare"
--SETTING_PVBH_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_MISSILE_FLY_TIME = 1.3
SETTING_MISSILE_PUSHBACK = 500
SETTING_MISSILE_FLY_SPEED = 900
SETTING_MISSILE_MAX_DISTANCE = 1200
SETTING_MISSILE_DAMAGE_MIN = 1500
SETTING_MISSILE_DAMAGE_MAX = 2000
--LinkLuaModifier("modifier_boss_dieptinh_speed","bosses/modifier_boss_dieptinh_speed",LUA_MODIFIER_MOTION_NONE)




function modifier_boss_heaven:OnAttack(kv)
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
--      local ability_80 = caster:FindAbilityByName(SETTING_ABILITY_80)
--            if(ability_80:IsCooldownReady())then
--              self:Cast80(kv.target)
--              ability_80:StartCooldown(10)
--            end
--      do return end
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

function modifier_boss_heaven:NormalAttack(target)
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(SETTING_MISSILE_DAMAGE_MIN,SETTING_MISSILE_DAMAGE_MAX,SETTING_MISSILE_DAMAGE_MIN,SETTING_MISSILE_DAMAGE_MAX)
  local critInfo = DamageHandler:InitCrit(20,2)
  
  for i = -3,3 do
    --missileData.vSpawnOrigin = 

    local spawn_point = caster_point + i*200*RotateVector2D(angleBetweenCasterAndTarget,math.rad(90))
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
        vVelocity     = angleBetweenCasterAndTarget*SETTING_MISSILE_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        effect = EFFECT_SLOW,
        effect_chance = 60,
        effect_time = 2,
        fRehitDelay = 0.5,
        maxTarget = 4,
        iVisionTeamNumber = caster:GetTeamNumber(),        
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)

          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            --kemPrint("Hit 141")
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_EARTH,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
          end})
        end
      })
  end
end
function FindChainUnit(numbHit,caster,from_unit,where)
  
  
  local tempGroup = FindUnitsInRadius(caster:GetTeam(),where,nil,800,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,0,false)
  
  if(#tempGroup>0)then
    local hitUnit = nil
    for _,tempUnit in ipairs(tempGroup) do
      if(tempUnit~=from_unit)then
        hitUnit = tempUnit
      end
    end
    if(hitUnit)then
      --print("shot missile to "..hitUnit:GetUnitName())
      local caster_point = caster:GetOrigin()--vi tri caster
      local target_point = hitUnit:GetOrigin()--vi tri unit sap toi
      local spawn_point = caster_point
      if(from_unit)then
        spawn_point = where
      end
      target_point.z = 150
      spawn_point.z = 150
      local angleBetweenCasterAndTarget = (target_point-spawn_point):Normalized()
      local damageInfo = DamageHandler:InitDamage(SETTING_MISSILE_DAMAGE_MIN*(1+numbHit/10),SETTING_MISSILE_DAMAGE_MAX*(1+numbHit/10),SETTING_MISSILE_DAMAGE_MIN*(1+numbHit/10),SETTING_MISSILE_DAMAGE_MAX*(1+numbHit/10))
      local critInfo = DamageHandler:InitCrit(20,2)
      Projectiles:CreateProjectile({
      EffectName      = SETTING_CHAIN_MISSILE_EFFECT,
      Ability         = nil,
      vSpawnOrigin    = spawn_point,
      fDistance     =  2000,
      fStartRadius    = 150,
      fEndRadius      = 150,
      Source        = caster,
      bHasFrontalCone   = true,
      bReplaceExisting  = false,
      fExpireTime     = 1,--GameRules:GetGameTime() +100,--
    
      GroundBehavior = PROJECTILES_NOTHING,
      UnitBehavior  = PROJECTILES_NOTHING,
      vVelocity     = angleBetweenCasterAndTarget*SETTING_MISSILE_FLY_SPEED,--angleBetweenCasterAndTarget,
      bProvidesVision   = true,
      numHit  = 0,
      iVisionRadius   = 200,
      damage = damageInfo,
      crit = critInfo,
      effect = EFFECT_SLOW,
      effect_chance = 60,
      effect_time = 2,
      fRehitDelay = 0.5,
      maxTarget = 4,
      numbCounter = numbHit,
      iVisionTeamNumber = caster:GetTeamNumber(),   
      UnitTest = GeneralUnitTest,
      OnUnitHit = function(proj,unit) 
        if(unit~=from_unit)then
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
          --kemPrint("Hit 141")
              
              unit:EmitSound("Hero_Lich.ChainFrostImpact.Hero")
              
              DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_EARTH,{})
              StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
              print("hit "..proj.numbCounter.."-"..unit:GetUnitName().." calling find again")
              
              FindChainUnit(proj.numbCounter+1,caster,unit,unit:GetOrigin())
              print("called")
              proj:Destroy()
            end})
        else
          print("Same unit, next ")
        end
        
        
      end
    })
    end
  else
    print("Found nothing")
  end
end
function modifier_boss_heaven:Cast80(target)
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  caster:EmitSound("Hero_Lich.ChainFrost")
  FindChainUnit(0,caster,nil,target_point)

    --missileData.vSpawnOrigin = 
  
    
    --kemPrint("Create missile height "..spawn_point.z)
    
  
end
function modifier_boss_heaven:Cast90(target)
  local tick = 12
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(SETTING_MISSILE_DAMAGE_MIN,SETTING_MISSILE_DAMAGE_MAX,SETTING_MISSILE_DAMAGE_MIN,SETTING_MISSILE_DAMAGE_MAX)
  local critInfo = DamageHandler:InitCrit(20,2)
  
  caster:EmitSound(SETTING_90_CAST_SOUND)
  
  local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        radius = 100,
        damage =damageInfo,
        damage_element = ELEMENT_FIRE,
        crit = critInfo,
        custom = {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=60,
          effect_time=3
        }
      }
  Timers:CreateTimer(2,function() 
    caster:EmitSound(SETTING_FLARE_SOUND)
    if (tick>0)then
      tick=tick-1
      local tempAngle =RotateVector2D(angleBetweenCasterAndTarget,math.rad(tick*30))
      local tempPoint = target_point+Vector(math.random(-150,150),math.random(-150,150),0)
      FxPoint(SETTING_MISSILE_FALLDOWN_EFFECT, tempPoint, 1)
      Timers:CreateTimer(1,function()
         damageAreaData.where = tempPoint
         SoundPoint("Hero_TemplarAssassin.Trap.Explode",tempPoint,1,DOTA_TEAM_NEUTRALS)
         FxPoint("particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_death_esl_explode.vpcf",tempPoint,1)
         DamageHandler:DamageArea(damageAreaData)
      end)
  
      

         
            
       
      return 0.33
    end
  end)
end

function modifier_boss_heaven:Cast100(target)
  local number_of_missile = 30
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 50
  target_point.z = 50
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  
  local damageInfo = DamageHandler:InitDamage(SETTING_MISSILE_DAMAGE_MIN,SETTING_MISSILE_DAMAGE_MAX,SETTING_MISSILE_DAMAGE_MIN,SETTING_MISSILE_DAMAGE_MAX)
  local critInfo = DamageHandler:InitCrit(20,2)
  
  
  Timers:CreateTimer(2,function() 
    if (number_of_missile>0)then
      number_of_missile = number_of_missile-1
      FxPoint("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf",caster_point,1)
      SoundPoint("Hero_TemplarAssassin.Trap.Explode",caster_point,1,DOTA_TEAM_NEUTRALS)
      Projectiles:CreateProjectile({
        EffectName      = SETTING_MISSILE_EFFECT,
        Ability         = nil,
        vSpawnOrigin    = caster_point+Vector(math.random(-100,100),math.random(-100,100),0),
        fDistance     =  1000,
        fStartRadius    = 100,
        fEndRadius      = 100,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = 1,--GameRules:GetGameTime() +100,--
      
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity    = RotateVector2D(angleBetweenCasterAndTarget,math.rad(math.random(0,360)))*SETTING_MISSILE_FLY_SPEED,--angleBetweenCasterAndTarget,
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

function modifier_boss_heaven:OnCreated(kv)
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
