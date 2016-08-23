modifier_boss_hokhon = class({})
function modifier_boss_hokhon:IsHidden()
  return true
end
function modifier_boss_hokhon:RemoveOnDeath()
  return false
end
function modifier_boss_hokhon:IsPurgable()
  return false
end
function modifier_boss_hokhon:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
 
  return funcs
end

function modifier_boss_hokhon:GetModifierPreAttack_BonusDamage()
  return -10000
end

SETTING_BUFF_EFFECT = "modifier_boss_hokhon_regen"
-- 1 hero co 7 skill
-- auto high : danh thuong khi hp cao
-- auto low  : danh thuong khi hp thap ( manh hon auto high 1 ty )
-- high_ability : tuc gian , ty le cao
-- medium_ability : tuc gian, ty le thap
-- ulti : tuc gian : ty le 10% , random 1 trong 3
SETTING_HIGH_ABILITY = "boss_hokhon_rains" --cast khi angry
SETTING_HIGH_ABILITY_MESSAGE = "hokhon_rains"
SETTING_MEDIUM_ABILITY = "boss_hokhon_flame_ring" -- khi low hp, ty le thap
SETTING_MEDIUM_ABILITY_MESSAGE = "hokhon_flame_ring"

SETTING_ULTI_1 = "boss_hokhon_summon" --ty le 10% khi low hp, random 1 trong 3 skill
SETTING_ULTI_2 = "boss_hokhon_breathe" --ty le 10% khi low hp, random 1 trong 3 skill
SETTING_ULTI_3 = "boss_hokhon_x_ring" --ty le 10% khi low hp, random 1 trong 3 skill
SETTING_ULTI_1_MESSAGE = "hokhon_summon"
SETTING_ULTI_2_MESSAGE = "hokhon_breathe"
SETTING_ULTI_3_MESSAGE = "hokhon_x_ring"

SETTING_ATTACK_SOUND = "ember_spirit_embr_attack_0"--edit

SETTING_WELCOME_MESSAGE = "hokhon_welcome"
SETTING_BUFF_MESSAGE = "hokhon_angry"

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

SETTING_NORMAL_SIZE_BETWEEN_FIRE = 200
SETTING_NORMAL_MACROPYRE = "particles/edited_particle/ma_nhan/thoisondienhai_macropyre.vpcf"
SETTING_NORMAL_DURATION = 5

SETTING_FIRE_FALL_EFFECT = "particles/boss_hokhon_rains.vpcf"
SETTING_FLAME_RING_TOTAL_DAMAGE = 36000
SETTING_FLAME_RING_AOE = 700
SETTING_FLAME_RING_COUNT = 12
SETTING_FLAME_RING_MISSILE_EFFECT = "particles/boss_hokhon_flame_ring.vpcf"

SETTING_NORMAL_DAMAGE_MIN = 1478--2687
SETTING_NORMAL_DAMAGE_MAX = 2268--3165



LinkLuaModifier("modifier_boss_hokhon_regen","bosses/modifier_boss_hokhon_regen",LUA_MODIFIER_MOTION_NONE)


--casted=false
--no need edit this
function modifier_boss_hokhon:OnAttack(kv)
  if(IsServer())then
    local caster = self:GetParent()
    if(not caster.SayHi)then
      kemPrint("Add bubble")
      caster:AddSpeechBubble(1, "#"..SETTING_WELCOME_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
      caster.SayHi=true
    end
    if(kv.attacker==caster)then
      --kemPrint(caster:GetUnitName().." - "..kv.attacker:GetUnitName().." - "..kv.target:GetUnitName())
      local hp_percent = caster:GetHealthPercent()
      if(math.random(0,100)<30)then
        caster:EmitSound(SETTING_ATTACK_SOUND..math.random(1,9))
      end
--      if not casted then
--        casted = true
--        self:Ulti_1(caster,kv.target)
--      end
      
        --self:Ulti_2(caster,kv.target)
      if(hp_percent>80)then
          self:HighHPCast(kv.target)
      else
          if(math.random(0,100)<20)then
            if(not caster.Angry)then    
              caster.Angry = true
              kemPrint("Add bubble")
              caster:AddSpeechBubble(1, "#"..SETTING_BUFF_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
            end
            caster:AddNewModifier(caster,nil,SETTING_BUFF_EFFECT,{})
          end
          if(hp_percent>50)then
            self:MediumHPCast(kv.target)
          else
            self:LowHPCast(kv.target)
          end
          
      end
    end
  end
  
  
end

function modifier_boss_hokhon:HighHPCast(target)
  self:CastFlameWall(target,1)
end
function modifier_boss_hokhon:MediumHPCast(target)
  --kemPrint("Cast 50")
  if(math.random(0,100)<50)then
    self:AngryHighChance(target)
  else
    self:AutoLow(target)
  end
end

function modifier_boss_hokhon:LowHPCast(target)
  --kemPrint("Cast 50")
    local chance = math.random(0,100)
    if(chance>50)then
      if(math.random(0,100)<50)then
        self:AngryHighChance(target)
      else
        self:AutoLow(target)
      end
      
    else
      if(chance>10)then
        self:AngryLowChance(target)
      else
        self:AngryUlti(target)
      end
    end
  
end
--
-- ULTI
--
function modifier_boss_hokhon:AngryUlti(target)
  local caster = self:GetParent()
  local skill_table = {}
  --kemPrint(SETTING_ULTI_1,SETTING_ULTI_2,SETTING_ULTI_3)
  local ability_1 = caster:FindAbilityByName(SETTING_ULTI_1)
  local ability_2 = caster:FindAbilityByName(SETTING_ULTI_2)
  local ability_3 = caster:FindAbilityByName(SETTING_ULTI_3)
  if(ability_1:IsCooldownReady())then
    table.insert(skill_table,SETTING_ULTI_1)
  end
  if(ability_2:IsCooldownReady())then
    table.insert(skill_table,SETTING_ULTI_2)
  end
  if(ability_3:IsCooldownReady())then
    table.insert(skill_table,SETTING_ULTI_3)
  end
  if(#skill_table>0)then
     local skill = skill_table[math.random(1,#skill_table)]
       --kemPrint("Add bubble")
       caster:FindAbilityByName(skill):StartCooldown(10) 
       if(skill==SETTING_ULTI_1)then
        self:Ulti_1(caster,target)        
        caster:AddSpeechBubble(1, "#"..SETTING_ULTI_1_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
       end
       if(skill==SETTING_ULTI_2)then
        self:Ulti_2(caster,target)
        caster:AddSpeechBubble(1, "#"..SETTING_ULTI_2_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
       end
       if(skill==SETTING_ULTI_3)then
        self:Ulti_3(caster,target)
        caster:AddSpeechBubble(1, "#"..SETTING_ULTI_3_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
       end
  else
    self:AutoLow(target)
  end
end


--EDITABLE CODE
function modifier_boss_hokhon:AutoLow(target)
  self:CastFlameWall(target,3)
end

function modifier_boss_hokhon:CastFlameWall(target,numberOfFire)
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
 
  
  
  local distance_to_edge =  math.floor((numberOfFire-1)/2)*SETTING_NORMAL_SIZE_BETWEEN_FIRE
  
  local leftPoint = target_point+distance_to_edge*RotateVector2D(angleBetweenCasterAndTarget,math.rad(90))
  local rightPoint = target_point+distance_to_edge*RotateVector2D(angleBetweenCasterAndTarget,math.rad(-90))
  
  local leftFX = ParticleManager:CreateParticle(SETTING_NORMAL_MACROPYRE,PATTACH_WORLDORIGIN,caster)

  ParticleManager:SetParticleControl( leftFX, 0, target_point+Vector(0,0,50))
  ParticleManager:SetParticleControl( leftFX, 1, leftPoint+Vector(0,0,50))
  ParticleManager:SetParticleControl( leftFX, 2, Vector(SETTING_NORMAL_DURATION,0,0))
  
  local rightFX = ParticleManager:CreateParticle(SETTING_NORMAL_MACROPYRE,PATTACH_WORLDORIGIN,caster)

  ParticleManager:SetParticleControl( rightFX, 0, target_point+Vector(0,0,50))
  ParticleManager:SetParticleControl( rightFX, 1, rightPoint+Vector(0,0,50))
  ParticleManager:SetParticleControl( rightFX, 2, Vector(SETTING_NORMAL_DURATION,0,0))
  
  
  SoundPoint("Hero_Huskar.Burning_Spear",target_point,5,caster:GetTeam())
   local damageData = {
        caster = caster,
        
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = 1,
        element_damage_min = SETTING_NORMAL_DAMAGE_MIN,
        element_damage_max = SETTING_NORMAL_DAMAGE_MAX
        }
        
  for i = 1,numberOfFire do
    --missileData.vSpawnOrigin = 

    local tempPoint = target_point+200*(i-math.ceil(numberOfFire/2))*RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*90-180))
    local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = tempPoint,
        radius = 96,
        period = 0.5,
        duration = 5,
        maxTarget = 5,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_FIRE,
        {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=60,
          effect_time=2
        }
      }
      DamageHandler:DamageGroup(damageGroupData)
    --kemPrint("Create missile height "..spawn_point.z)
  end
end

--
-- FIRE FALL
--
function modifier_boss_hokhon:AngryHighChance(target)
    local caster = self:GetParent()
    local tempAbility = caster:FindAbilityByName(SETTING_HIGH_ABILITY)
    local castSuccess = false
    if(tempAbility)then
      if(tempAbility:IsCooldownReady())then
        kemPrint("Add bubble")
        self:GetParent():AddSpeechBubble(1, "#"..SETTING_HIGH_ABILITY_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
        tempAbility:StartCooldown(10)  
        local caster_point = caster:GetOrigin()
        castSuccess = true
        local target_point = target:GetOrigin()
        -- SKILL CODE ---
        for i = 0,10 do
          Timers:CreateTimer(i*0.5,function()
            SoundPoint("Hero_Invoker.ChaosMeteor.Cast",target_point,1,caster:GetTeam())
            for j = 0,i do
              local min = i*100-150
              
              local tempPoint = target_point+Vector(math.random(-min,min),math.random(-min,min),0)
              FxPoint(SETTING_FIRE_FALL_EFFECT,tempPoint,1)
            end
          
          end)
          
        end
        --END SKILL CODE
      end
    end
    
    if not castSuccess then
      self:AutoLow(target)
    end
end

--
-- FLAME RING
--
function modifier_boss_hokhon:AngryLowChance(target)

  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local number_of_flames = SETTING_FLAME_RING_COUNT

  local castSuccess = false
  local tempAbility = caster:FindAbilityByName(SETTING_MEDIUM_ABILITY)
  if(tempAbility)then
    if(tempAbility:IsCooldownReady())then
      --kemPrint("Add bubble")
      caster:AddSpeechBubble(1, "#"..SETTING_MEDIUM_ABILITY_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
      tempAbility:StartCooldown(10)
      castSuccess = true
      local damageData = {
          caster = caster,
          
          skill_physical_damage_percent = 0,
          skill_tree_amplify_damage = 0,-- can edit
          skill_basic_damage_percent = 1,
          element_damage_min = SETTING_FLAME_RING_TOTAL_DAMAGE/number_of_flames,
          element_damage_max = SETTING_FLAME_RING_TOTAL_DAMAGE/number_of_flames
         }
      local damageInfo = DamageHandler:GetDamage(damageData)
      local critInfo = DamageHandler:GetCritInfo(caster)
      FxPointControl("particles/boss_hokhon_calldown_marker.vpcf",target_point+Vector(0,0,30),3,{[1]=Vector(700,700,30)})
      Timers:CreateTimer(3,function()
        for i = 1,number_of_flames do
          local tempPoint = target_point+SETTING_FLAME_RING_AOE*RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*360/number_of_flames))
          local tempAngle = (target_point-tempPoint):Normalized()
          local tempAngle_2 = RotateVector2D((tempPoint-target_point):Normalized(),math.rad(15))
         
          Projectiles:CreateProjectile({
            EffectName      = SETTING_FLAME_RING_MISSILE_EFFECT,
            Ability         = nil,
            vSpawnOrigin    = tempPoint,
            fDistance     = SETTING_FLAME_RING_AOE,
            fStartRadius    = 80,
            fEndRadius      = 80,
            Source        = caster,
            bHasFrontalCone   = true,
            bReplaceExisting  = false,
            fExpireTime     = 1,--GameRules:GetGameTime() +100,--
          
            GroundBehavior = PROJECTILES_NOTHING,
            UnitBehavior  = PROJECTILES_NOTHING,
            vVelocity     = tempAngle*SETTING_FLAME_RING_AOE,--angleBetweenCasterAndTarget,
            bProvidesVision   = true,
            numHit  = 0,
            iVisionRadius   = 200,
            damage = damageInfo,
            crit = critInfo,
            effect = EFFECT_SLOW,
            effect_chance = 60,
            effect_time = 2,
            maxTarget = 1,
            iVisionTeamNumber = caster:GetTeamNumber(),        
            UnitTest = GeneralUnitTest,
            OnUnitHit = function(proj,unit)
    
              DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
                --print("Flame ring deal "..i)
                DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})            
              end})
            end
          })
          Projectiles:CreateProjectile({
            EffectName      = SETTING_FLAME_RING_MISSILE_EFFECT,
            Ability         = nil,
            vSpawnOrigin    = target_point,
            fDistance     = SETTING_FLAME_RING_AOE,
            fStartRadius    = 80,
            fEndRadius      = 80,
            Source        = caster,
            bHasFrontalCone   = true,
            bReplaceExisting  = false,
            fExpireTime     = 1,--GameRules:GetGameTime() +100,--
          
            GroundBehavior = PROJECTILES_NOTHING,
            UnitBehavior  = PROJECTILES_NOTHING,
            vVelocity     = tempAngle_2*SETTING_FLAME_RING_AOE,--angleBetweenCasterAndTarget,
            bProvidesVision   = true,
            numHit  = 0,
            iVisionRadius   = 200,
            damage = damageInfo,
            crit = critInfo,
            effect = EFFECT_SLOW,
            effect_chance = 60,
            effect_time = 2,
            maxTarget = 1,
            iVisionTeamNumber = caster:GetTeamNumber(),        
            UnitTest = GeneralUnitTest,
            OnUnitHit = function(proj,unit)
    
              DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
                print("Flame ring 2 deal "..i)
                DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})            
              end})
            end
          })        
        end--end for  
             
      end)--end timer 3
      
     
      
    end
    
  else
    kemPrint("Flame ring is nil")
  end
  if not castSuccess then
    self:CastFlameWall(target,3)
  end
  
end


LinkLuaModifier("modifier_boss_hokhon_poison","bosses/modifier_boss_hokhon_poison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_boss_hokhon_reflect","bosses/modifier_boss_hokhon_reflect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_boss_hokhon_regenX","bosses/modifier_boss_hokhon_regenX", LUA_MODIFIER_MOTION_NONE )
--SUMMON
function modifier_boss_hokhon:Ulti_1(caster,target)
  local caster_position = caster:GetOrigin()
  local target_position = target:GetOrigin()
  local angle = (target_position-caster_position):Normalized()
  local unit_name = {"npc_unit_hokhon_summon_poison","npc_unit_hokhon_summon_reflect","npc_unit_hokhon_summon_regen"}
  local buff_name = {"modifier_boss_hokhon_poison","modifier_boss_hokhon_reflect","modifier_boss_hokhon_regenX"}
  for i = 1,3 do 
    local point = caster_position+RotateVector2D(angle,math.rad(i*120))*400
    local tempUnit  = CreateUnitByName(unit_name[i],point,true,nil,nil,caster:GetTeamNumber())
    tempUnit:AddNewModifier(caster,nil,buff_name[i],{duration=300})
    print("Created "..unit_name[i].." with buff "..buff_name[i])
    
  end
end
SETTING_EFFECT_FIRE = "particles/boss_hokhon_breathe_fire.vpcf"
SETTING_FIRE_TIME = 10
SETTING_FIRE_SOUND = "Hero_DragonKnight.BreathFire"
LinkLuaModifier("modifier_boss_hokhon_casting","bosses/modifier_boss_hokhon_casting", LUA_MODIFIER_MOTION_NONE )
--SETTING_EFFECT_FIRE = "particles/fx_test.vpcf"
--BREATH OF FIRE
function modifier_boss_hokhon:Ulti_2(caster,target)
    local caster_position = caster:GetOrigin()
    
    caster:AddNewModifier(caster,nil,"modifier_boss_hokhon_casting",{duration=SETTING_FIRE_TIME})
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,1)
    local damageData = {
          caster = caster,
          
          skill_physical_damage_percent = 0,
          skill_tree_amplify_damage = 0,-- can edit
          skill_basic_damage_percent = 1,
          element_damage_min = SETTING_NORMAL_DAMAGE_MIN+1000,
          element_damage_max = SETTING_NORMAL_DAMAGE_MAX+2000
         }
      local damageInfo = DamageHandler:GetDamage(damageData)
      local critInfo = DamageHandler:GetCritInfo(caster)
      
      
    for i = 0,SETTING_FIRE_TIME do
      Timers:CreateTimer(i,function()
        caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)  
        caster:EmitSound(SETTING_FIRE_SOUND)
        --caster:SetAngles(0,100,0)
        --local rt = math.max(5-i)
        for j=i,math.min(SETTING_FIRE_TIME,i+4) do
          local target_position = target:GetOrigin()
          local angle = (target_position-caster_position):Normalized()
          local time = j-i
          Timers:CreateTimer(j-i,function()
            local speed = 800
            local distance = 800+150*time
            local fx = FxPointControl(SETTING_EFFECT_FIRE,caster_position,1,{[1]=angle*speed})    
            Projectiles:CreateProjectile({
                EffectName      = SETTING_EFFECT_FIRE,
                Ability         = nil,
                vSpawnOrigin    = caster_position,
                fDistance     = distance,
                fStartRadius    = 80,
                fEndRadius      = 200,
                Source        = caster,
                bHasFrontalCone   = true,
                bReplaceExisting  = false,
                fExpireTime     = 1+0.25*time,--GameRules:GetGameTime() +100,--
                GroundBehavior = PROJECTILES_NOTHING,
                UnitBehavior  = PROJECTILES_NOTHING,
                vVelocity     = angle*speed,--angleBetweenCasterAndTarget,
                bProvidesVision   = true,
                iVisionRadius   = 200,
                damage = damageInfo,
                crit = critInfo,
                effect = EFFECT_BURN,
                effect_chance = 60,
                effect_time = 2,
                maxTarget = 1,
                iVisionTeamNumber = caster:GetTeamNumber(),        
                UnitTest = GeneralUnitTest,
                OnUnitHit = function(proj,unit)
        
                  DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
                    --print("Flame ring deal "..i)
                    DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})            
                  end})
                end
              })          
          end)
        end
        
      
      end)
      
        
    end
end
--X RING
SETTING_EFFECT_X_RING = "particles/boss_hokhon_x_ring.vpcf"
function modifier_boss_hokhon:Ulti_3(caster,target)
  local caster_position = caster:GetOrigin()
  local target_position = target:GetOrigin()
  local angle = (target_position-caster_position):Normalized()
   local damageData = {
        caster = caster,
        
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = 1,
        element_damage_min = SETTING_NORMAL_DAMAGE_MIN+1000,
        element_damage_max = SETTING_NORMAL_DAMAGE_MAX+2000
        }
  local flame_radius = 80
  for i = 1,10 do 
    local point = target_position+i*flame_radius*Vector(1,1,0)
    local point_2 = target_position+i*flame_radius*Vector(1,-1,0)
    local point_3 = target_position+i*flame_radius*Vector(-1,1,0)
    local point_4 = target_position+i*flame_radius*Vector(-1,-1,0)
    
    local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        radius =flame_radius/2,
        period = 0.5,
        duration = 10,
        maxTarget = 5,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_FIRE,
        {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=60,
          effect_time=2
        }
      }
      FxPoint(SETTING_EFFECT_X_RING,point,10)
      damageGroupData.where = point
      DamageHandler:DamageGroup(damageGroupData)
      FxPoint(SETTING_EFFECT_X_RING,point_2,10)
      damageGroupData.where = point_2
      DamageHandler:DamageGroup(damageGroupData)
      FxPoint(SETTING_EFFECT_X_RING,point_3,10)
      damageGroupData.where = point_3
      DamageHandler:DamageGroup(damageGroupData)
      FxPoint(SETTING_EFFECT_X_RING,point_4,10)
      damageGroupData.where = point_4
      DamageHandler:DamageGroup(damageGroupData)
    
  end
  
end

--edit message
function modifier_boss_hokhon:OnCreated(kv)
  --kemPrint("BOSS DIEP TINH ONCREATED")
  if(IsServer())then
    GameRules:SendCustomMessage("<font color='#ff2222'>Angry voice:</font> Every creature dare to face me, prepare to die ...", 0, 0)
    GameRules:SendCustomMessage("<font color='#ff2222'>Angry voice:</font> No one can hurt my family...", 1, 0)
    self:GetParent().SayHi = false
    self:GetParent().Angry = false
    self:GetParent().SayGetOut = false
    for i = 0,12 do
      local tempAbility = self:GetParent():GetAbilityByIndex(i)
      if(tempAbility)then
        --kemPrint("Ability : "..tempAbility:GetAbilityName())
        tempAbility:SetLevel(1)
      end
    end
  end
  

  
end

function modifier_boss_hokhon:OnRefresh(kv)
  if(IsServer())then
    kemPrint("BOSS HO KHON ONUPGRADED")
  end
  
end