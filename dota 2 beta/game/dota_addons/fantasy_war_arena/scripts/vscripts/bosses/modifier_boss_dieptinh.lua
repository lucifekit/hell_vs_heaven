modifier_boss_dieptinh = class({})
function modifier_boss_dieptinh:IsHidden()
  return true
end
function modifier_boss_dieptinh:RemoveOnDeath()
  return false
end
function modifier_boss_dieptinh:IsPurgable()
  return false
end
function modifier_boss_dieptinh:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
 
  return funcs
end

function modifier_boss_dieptinh:GetModifierPreAttack_BonusDamage()
  return -10000
end

SETTING_BUFF_EFFECT = "modifier_boss_dieptinh_speed"

SETTING_HIGH_ABILITY = "boss_dieptinh_get_out"
SETTING_HIGH_ABILITY_MESSAGE = "dieptinh_get_out"
SETTING_MEDIUM_ABILITY = "boss_dieptinh_frozen_moon"
SETTING_MEDIUM_ABILITY_MESSAGE = "dieptinh_frozen_moon"

SETTING_ULTI_1 = "boss_dieptinh_nova"
SETTING_ULTI_2 = "boss_dieptinh_massage"
SETTING_ULTI_3 = "boss_dieptinh_true_love"
SETTING_ULTI_1_MESSAGE = "dieptinh_nova"
SETTING_ULTI_2_MESSAGE = "dieptinh_massage"
SETTING_ULTI_3_MESSAGE = "dieptinh_true_love"

SETTING_ATTACK_SOUND = "crystalmaiden_cm_attack_0"

SETTING_WELCOME_MESSAGE = "dieptinh_welcome"
SETTING_BUFF_MESSAGE = "dieptinh_angry"

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

SETTING_KNOCKBACK_EFFECT = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
SETTING_ACID_EFFECT = "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf"
SETTING_FROZEN_EFFECT = "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf"
SETTING_ACID_SOUND  = "Ability.FrostNova" 
SETTING_NOVA_EFFECT = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
SETTING_NOVA_SOUND  = "Hero_Crystal.CrystalNova"

SETTING_MISSILE_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_phongvanbienhuyen.vpcf"
SETTING_MISSILE_EFFECT = "particles/boss_dieptinh_8x.vpcf"
SETTING_MISSILE_HIT_EFFECT = "particles/edited_particle/kiem_doan/fx_phongvanbienhuyen_hit.vpcf"
--SETTING_PVBH_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_MISSILE_FLY_TIME = 1.3
SETTING_MISSILE_PUSHBACK = 500
SETTING_MISSILE_FLY_SPEED = 900
SETTING_MISSILE_MAX_DISTANCE = 1200
SETTING_MISSILE_MAX_TARGET = 4
SETTING_MISSILE_DAMAGE_MIN = 2600--2687
SETTING_MISSILE_DAMAGE_MAX = 3100--3165

SETTING_TORRENT_BUBBLE_EFFECT = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
SETTING_TORRENT_EFFECT = "particles/econ/items/kunkka/kunkka_torrent_base/kunkka_spell_torrent_splash_econ.vpcf"
SETTING_TORRENT_DAMAGE = 15000
SETTING_TORRENT_TICK = 6
SETTING_TORRENT_DAMAGE_DURATION = 1
SETTING_TORRENT_SOUND = "Ability.Torrent"


LinkLuaModifier("modifier_boss_dieptinh_speed","bosses/modifier_boss_dieptinh_speed",LUA_MODIFIER_MOTION_NONE)




function modifier_boss_dieptinh:OnAttack(kv)
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

function modifier_boss_dieptinh:HighHPCast(target)
  self:CastKnockbackMissile(target,1)
end
function modifier_boss_dieptinh:MediumHPCast(target)
  --kemPrint("Cast 50")
  if(math.random(0,100)<50)then
    self:AngryHighChance(target)
  else
    self:AutoLow(target)
  end
end

function modifier_boss_dieptinh:LowHPCast(target)
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
function modifier_boss_dieptinh:AngryUlti(target)
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
function modifier_boss_dieptinh:AutoLow(target)
  self:CastKnockbackMissile(target,3)
end

function modifier_boss_dieptinh:CastKnockbackMissile(target,number_of_missile)
  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local distanceBetwwenCasterAndTarget = (target_point-caster_point):Length2D()
  local damageData = {
        caster = caster,
        main_attribute_value = 0,
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = 1,
        element_damage_min = SETTING_MISSILE_DAMAGE_MIN,
        element_damage_max = SETTING_MISSILE_DAMAGE_MAX
        }
  local damageInfo = DamageHandler:GetDamage(damageData)
  local critInfo = DamageHandler:GetCritInfo(caster)
  
  for i = 1,number_of_missile do
    --missileData.vSpawnOrigin = 

    local spawn_point = caster_point+200*RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*90-180))
    if(i==2 or number_of_missile==1)then
      spawn_point = caster_point
    end
    --kemPrint("Create missile height "..spawn_point.z)
    Projectiles:CreateProjectile({
        EffectName      = SETTING_MISSILE_EFFECT,
        Ability         = nil,
        vSpawnOrigin    = spawn_point,
        fDistance     = SETTING_MISSILE_MAX_DISTANCE,
        fStartRadius    = 80,
        fEndRadius      = 80,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_MISSILE_FLY_TIME,--GameRules:GetGameTime() +100,--
      
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
        maxTarget = SETTING_MISSILE_MAX_TARGET,
        iVisionTeamNumber = caster:GetTeamNumber(),        
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)

          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            --kemPrint("Hit 141")
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            --kemPrint("Call damage "..proj.id.." hit "..proj.damage.element_min.." damage")
        
            local distanceB = (unit:GetAbsOrigin()-proj.Source:GetAbsOrigin()):Length2D()
            local multiplier = 0
            if(distanceB>400)then
              multiplier = (distanceB-400)/200
            end
            --kemPrint("Dealing damage to "..unit:GetUnitName().." multiplier = "..(1+multiplier))
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WATER,{action="multiple_damage",value=1+multiplier})

            local hit_effect = ParticleManager:CreateParticle(SETTING_MISSILE_HIT_EFFECT, PATTACH_ABSORIGIN_FOLLOW, unit)
            ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
            ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
            Timers:CreateTimer(0.5,function() 
                ParticleManager:DestroyParticle(hit_effect,true)
            end)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            if(distanceBetwwenCasterAndTarget<800)then

              local knockback_chance = 30
              local knockback_duration=0.5
              StatusEffectHandler:KnockBack(proj.Source,proj.Source:GetAbsOrigin(),unit,knockback_chance,knockback_duration,800-distanceBetwwenCasterAndTarget)
            end

          end})
        end
      })
  end
end


--
-- FROZEN MOON
--
function modifier_boss_dieptinh:AngryLowChance(target)

  local caster = self:GetParent()
  local caster_point = caster:GetOrigin()
  local target_point = target:GetOrigin()
  caster_point.z = 150
  target_point.z = 150
  local angleBetweenCasterAndTarget = (target_point-caster_point):Normalized()
  local number_of_torrents = 12

  local castSuccess = false
  local tempAbility = caster:FindAbilityByName(SETTING_MEDIUM_ABILITY)
  if(tempAbility)then
    if(tempAbility:IsCooldownReady())then
      kemPrint("Add bubble")
      caster:AddSpeechBubble(1, "#"..SETTING_MEDIUM_ABILITY_MESSAGE, 2, 0, SETTING_MESSAGE_HEIGHT)
      tempAbility:StartCooldown(10)
      castSuccess = true
      Timers:CreateTimer(2,function()
        caster:EmitSound(SETTING_TORRENT_SOUND)
      end)
      for i = 1,number_of_torrents do
        local tempPoint = caster_point+800*RotateVector2D(angleBetweenCasterAndTarget,math.rad(i*360/number_of_torrents))
        local pfx = ParticleManager:CreateParticle(SETTING_TORRENT_BUBBLE_EFFECT,PATTACH_WORLDORIGIN,caster)
          
        ParticleManager:SetParticleControl( pfx, 0, tempPoint+Vector(0,0,30)  ) 
        Timers:CreateTimer(2,function()
          ParticleManager:DestroyParticle(pfx,true)
          
           local pfx2 = ParticleManager:CreateParticle(SETTING_TORRENT_EFFECT,PATTACH_WORLDORIGIN,caster)
           ParticleManager:SetParticleControl( pfx2, 0, tempPoint+Vector(0,0,30)  ) 
           local damageData = {
                  caster = caster,
                  main_attribute_value = 0,
                  skill_physical_damage_percent = 0,
                  skill_tree_amplify_damage = 0,-- can edit
                  skill_basic_damage_percent = 1,
                  element_damage_min = SETTING_TORRENT_DAMAGE/6,
                  element_damage_max = SETTING_TORRENT_DAMAGE/6
                  }
                local damageGroupData = {
                  whoDealDamage = caster,
                  byWhichAbility = self,
                  where = tempPoint,
                  radius = 100,
                  period = SETTING_TORRENT_DAMAGE_DURATION/SETTING_TORRENT_TICK,
                  duration = SETTING_TORRENT_DAMAGE_DURATION,
                  maxTarget = 3,
                  damage = DamageHandler:GetDamage(damageData),
                  damage_element = ELEMENT_WATER,
                  custom = 0
                }
                DamageHandler:DamageGroup(damageGroupData)
           Timers:CreateTimer(2,function()
                
              ParticleManager:DestroyParticle(pfx2,true)
           end)
        end)
      end
      Timers:CreateTimer(2,function()
       caster:EmitSound(SETTING_TORRENT_SOUND)
      end)
      
    end
    
  else
    kemPrint("Frozen moon is nil")
  end
  if not castSuccess then
    self:CastKnockbackMissile(target,3)
  end
  
end
--
-- GET OUT
--
function modifier_boss_dieptinh:AngryHighChance(target)
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
        
        -- SKILL CODE ---
        FxPoint(SETTING_KNOCKBACK_EFFECT,Vector(caster_point.x,caster_point.y,200),1)
        SoundPoint(SETTING_ACID_SOUND,caster_point,1,caster:GetTeam())
        local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
        if #enemies > 0 then
          local damageData = {
                caster = caster,
                main_attribute_value = 0,
                skill_physical_damage_percent = 0,
                skill_tree_amplify_damage = 0,-- can edit
                skill_basic_damage_percent = 1,
                element_damage_min = 1000,
                element_damage_max = 2500
                }
          local damageInfo = DamageHandler:GetDamage(damageData)
          local critInfo = DamageHandler:GetCritInfo(caster)
          for _,enemy in pairs(enemies) do
            DamageHandler:ApplyDamage(caster,nil,enemy,damageInfo,critInfo,ELEMENT_WATER,{})
            local distanceBetwwenCasterAndTarget = (caster:GetAbsOrigin()-enemy:GetAbsOrigin()):Length2D()
            if(distanceBetwwenCasterAndTarget<800)then
              local knockback_chance = 100
              local knockback_duration=0.5
              kemPrint("Knockback unit with z = "..enemy:GetOrigin().z)
              StatusEffectHandler:KnockBack(caster,nil,enemy,knockback_chance,knockback_duration,800-distanceBetwwenCasterAndTarget)
            end
          end
        end
        --END SKILL CODE
      end
    end
    
    if not castSuccess then
      self:AutoLow(target)
    end
end


--NOVA
function modifier_boss_dieptinh:Ulti_1(caster,target)
  local tick = 20
  Timers:CreateTimer(0.1,function()
    if(tick>0)then
      tick = tick-1
      FxPoint(SETTING_NOVA_EFFECT,caster:GetOrigin(),0.5)
      SoundPoint(SETTING_NOVA_SOUND,caster:GetOrigin(),0.5,caster:GetTeam())
      return 0.5
    end
  end)
  local damageData = {
      caster = caster,
      main_attribute_value = 0,
      skill_physical_damage_percent = 0,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = 1,
      element_damage_min = 600,
      element_damage_max = 800
      }
    local damageGroupData = {
      whoDealDamage = caster,
      byWhichAbility = self,
      where = caster:GetOrigin(),
      radius = 300,
      period = 0.5,
      duration = 10,
      maxTarget = 5,
      damage = DamageHandler:GetDamage(damageData),
      damage_element = ELEMENT_WATER,
      custom = {
        action="status_effect",
        effect_type=EFFECT_SLOW,
        effect_chance=100,
        effect_time=2
      }
    }
    
    --kemPrint("84 : Call damage group")
    DamageHandler:DamageGroup(damageGroupData)
end
-- MASSAGE
function modifier_boss_dieptinh:Ulti_2(caster,target)
    StatusEffectHandler:ApplyEffect(caster,target,EFFECT_IMMOBILE,100,4)
    CreateEffectOnUnit(SETTING_FROZEN_EFFECT,target,4)
    local damageData = {
        caster = caster,
        main_attribute_value = 0,
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = 1,
        element_damage_min = 750,
        element_damage_max = 1250
        }
      local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target:GetOrigin(),
        radius = 120,
        period = 0.5,
        duration = 2,
        maxTarget = 5,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_WATER,
        custom = {
          action="status_effect",
          effect_type=EFFECT_SLOW,
          effect_chance=100,
          effect_time=2
        }
      }
      --kemPrint("84 : Call damage group")
      DamageHandler:DamageGroup(damageGroupData)
end
--TRUE LOVE
function modifier_boss_dieptinh:Ulti_3(caster,target)
  
  local tick = 30
  Timers:CreateTimer(1,function()
    if(tick>0)then
      local temp_point = caster:GetOrigin()
      temp_point = Vector(temp_point.x+math.random(-500,500),temp_point.y+math.random(-500,500),100)
      FxPoint(SETTING_ACID_EFFECT,temp_point,1)
      local damageData = {
          caster = caster,
          main_attribute_value = 0,
          skill_physical_damage_percent = 0,
          skill_tree_amplify_damage = 0,-- can edit
          skill_basic_damage_percent = 1,
          element_damage_min = 900,
          element_damage_max = 1500
          }
      local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = caster:GetOrigin(),
        radius = 300,
        period = 0.2,
        duration = 0.5,
        maxTarget = 5,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_WATER,
        custom = {
          action="status_effect",
          effect_type=EFFECT_SLOW,
          effect_chance=100,
          effect_time=2
        }
      }
      SoundPoint(SETTING_ACID_SOUND,temp_point,1,caster:GetTeam())
      --kemPrint("84 : Call damage group")
      DamageHandler:DamageGroup(damageGroupData)
      tick = tick-1
      return 0.33
    end
  end)
end

-- END ULTI
function modifier_boss_dieptinh:OnCreated(kv)
  --kemPrint("BOSS DIEP TINH ONCREATED")
     
  GameRules:SendCustomMessage("<font color='#0099ff'>Mystery voice:</font> I dont know what is love ...", 0, 0)
  GameRules:SendCustomMessage("<font color='#0099ff'>Mystery voice:</font> Until now, i killed 329 people, maybe you will become the 330th one...", 1, 0)
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

function modifier_boss_dieptinh:OnRefresh(kv)
  if(IsServer())then
    kemPrint("BOSS DIEP TINH ONUPGRADED")
  end
  
end