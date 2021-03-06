-- playerhero.lua
-- manages player data
LinkLuaModifier("modifier_khinhcong_lua", "modifiers/modifier_khinhcong_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_parry", "modifiers/modifier_parry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angry", "modifiers/modifier_angry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_game_speed", "modifiers/modifier_game_speed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_level", "modifiers/modifier_skill_level", LUA_MODIFIER_MOTION_NONE)
STAT_SM = 0
STAT_TP = 1
STAT_SK = 2
STAT_NC = 3
HERO_CLASS_KIEMDOAN = 'kiemdoan'
HERO_CLASS_MANHAN = 'manhan'
HERO_CLASS_KIEMMINH = 'kiemminh'
if not PlayerData then
  PlayerData = {}
end
function UpdatePlayerDataForHero(hero)
  if(IsServer())then
    kemPrint("Update player data for hero "..hero:GetUnitName())
  end
  

  UpdatePlayerData(hero:GetPlayerID())
end
function UpdatePlayerData(playerID)
  

  local hero = HERO_OF_PLAYER[playerID]
  if hero then
    hero.stat_sm  = hero:GetAgility()
    hero.stat_sk  = hero:GetStrength()
    hero.stat_nc  = hero:GetIntellect()
 
    
    --hero:AddNewModifier(hero,nil,"modifier_game_speed",{})
   
    --print("Calculate stat bonus "..hero.as)
    
       
    hero:CalculateStatBonus()
    hero.as = math.ceil(hero:GetAttackSpeed()*100-100)
    local ready = HERO_READY[playerID]
    if ready then

      --kemPrint("==================Sending update player data "..playerID.."====================")
      print("#45 player sendCommand : update_stat and skill")
      CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_stat", {playerID=playerID,hero=hero,msg="update player data 34"})
      CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_skill", {playerID=playerID,hero=hero})
    else
      --kemPrint("ooooooooooooooooooooooooCancel update player data "..playerID.."ooooooooooooooooooooooo")
    end
    
  else
    kemPrint("========Cancel update player data "..playerID)

  end
  
end

function UpgradeStat(playerID)
  local hero = HERO_OF_PLAYER[playerID]
  
  if hero then
    hero.evade_point  = hero.stat_tp*4
    hero.accuracy_point  = hero.stat_tp*4
    hero.hero_level = hero:GetLevel()
    print("#66 sendCommand : update_stat")
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_stat", {playerID=playerID,hero=hero,msg="player data 54"})

    
  end
end
function UpgradeSkillForHero(hero)
  print("72 upgrade skill for hero called")
  UpgradeSkill(hero:GetPlayerID())
end
function ResetStat(hero)
     hero.skill_level = 0
  hero.hero_level = hero:GetLevel()
  hero.physic_amplify  = 1 -- vat cong ngoai them vao tinh theo %
  hero.element_amplify  = 1 -- vat cong noi vao tinh theo %



  --caster.attribute_amplify_element
  hero.weapon_element_damage  = 0 -- ngu hanh vu khi
  hero.weapon_physical_damage  = 0 -- sat thuong diem tu vu khi cac kieu
  hero.weapon_poison_damage = 0 -- doc sat
  
  hero.skill_element_damage  = 0 -- ngu hanh chieu thuc, co the la vat cong ngoai luon
  hero.skill_physical_damage = 0 --vat cong ngoai cua chieu thuc
  hero.skill_poison_damage   = 0 -- doc sat
  
  --hero.skill_tree_add_percent  = 0.0 -- ko can thiet?
  hero.basic_damage_percent  = 0.0 -- phat huy luc tan cong co ban
  hero.skill_amplify = 0 -- ho tro ky nang
  --chance
  --print("Init set chance = 0 "..hero:GetUnitName())
  hero.critical_chance  = 0     --diem chi mang
  hero.critical_damage  = 1.8   --sat thuong chi mang gay ra
  hero.critical_damage_resist = 0 --sat thuong chi mang nhan vao
  hero.reduce_poison_time  = 0.0  --giam thoi gian trung doc
  
  hero.evade_point  = hero.stat_tp*4
  hero.accuracy_point  = hero.stat_tp*4 --chinh xac
  hero.accuracy_chance  = 1 -- diem danh trung (%)
  hero.bypass_evade  = 0 --bo qua ne tranh
  -- hieu suat phuc hoi:Giam thoi gian phuc hoi, tick giua cac thoi gian phuc hoi, tang sinh luc hoi moi tick
  hero.hpregen_multi  = 0.0
  --hero.mregen_multi  = 0.0
  hero.mpregen_multi = 0.0
  
  hero.hp_drain  = 0
  hero.mp_drain  = 0
  
  hero.physic_evade = 0
  hero.element_evade = 0

  
  hero.return_damage_resist  = 0 -- chong phan don
  hero.damage_to_mp = 0.0 -- sat thuong chuyen hoa thanh noi luc

  
  --DEFENSE
  hero.resist_metal = 0
  hero.resist_wood = 0
  hero.resist_fire = 0
  hero.resist_water = 0
  hero.resist_earth = 0
  --STATUS EFFECT
  hero.effect_burn_add_percent  = 0
  hero.effect_burn_resist_percent  = 0
  hero.effect_burn_add_time  = 0
  hero.effect_burn_reduce_time  = 0
  
  hero.effect_slow_add_percent  = 0
  hero.effect_slow_resist_percent  = 0
  hero.effect_slow_add_time  = 0
  hero.effect_slow_reduce_time  = 0
  
  hero.effect_stun_add_percent  = 0
  hero.effect_stun_resist_percent  = 0
  hero.effect_stun_add_time  = 0
  hero.effect_stun_reduce_time  = 0
  
  hero.effect_weak_add_percent  = 0
  hero.effect_weak_resist_percent  = 0
  hero.effect_weak_add_time  = 0
  hero.effect_weak_reduce_time  = 0
  
  hero.effect_maim_add_percent  = 0
  hero.effect_maim_resist_percent  = 0
  hero.effect_maim_add_time  = 0
  hero.effect_maim_reduce_time  = 0
  
  hero.effect_paralized_resist_percent = 0
  hero.effect_fear_resist_percent = 0
  hero.effect_knockback_resist_percent = 0
end
function UpgradeSkill(playerID)

  --kemPrint("call upgrade skill for player " ..playerID)
  local hero = HERO_OF_PLAYER[playerID]
  
  if hero then
    kemPrint("player data line 81 - upgrade skill - have hero, resetting stat")  
    ResetStat(hero)
    
    -- cong lai item truoc vi item co anh huong den skill level
    
    --cong lai item
    local modifiers_list = hero:FindAllModifiers()
    
    for _,modifier in pairs(modifiers_list) do
      if(modifier.GetItemData)then
          modifier:ApplyStat()
      end
    end
    
    local skill_level_modifier = hero:FindModifierByName("modifier_skill_level")
    if(skill_level_modifier)then
      print("Kem item line : 134 stack count "..hero.skill_level)
      skill_level_modifier:SetStackCount(hero.skill_level)
    end
    --cong lai cac modifier co refresh anh huong toi cac stat
    for _,modifier in pairs(modifiers_list) do
      if(modifier.DeclareFunctions)then
        --print("Refreshing "..modifier:GetName().." duration = "..modifier:GetDuration().." remain = "..modifier:GetRemainingTime())
        if(modifier.Update)then
        else
          --ko co update thi moi refresh
          modifier:OnRefresh(nil)
        end
        
      end
    end
    -- cong lai cac modifier co apply
    if(hero.class)then
      
      for _,modifier in pairs(modifiers_list) do
          if(modifier.Apply)then
            print("Reapply .."..modifier:GetName())
            modifier:Apply()
          end
      end  
    end
    -- cong lai skill
    for i=0,hero:GetAbilityCount()-1 do
      local tempAbility = hero:GetAbilityByIndex(i)
      if(tempAbility)then
        if(tempAbility:GetLevel()>0) then
          --diem danh trung theo % , so float

          if(tempAbility.GetAccuracyChance)then
            hero.accuracy_chance = hero.accuracy_chance +tempAbility:GetAccuracyChance()
          end
          if(tempAbility.GetCriticalChance)then
            hero.critical_chance = hero.critical_chance+tempAbility:GetCriticalChance()
          end
          if(tempAbility.GetCriticalDamage)then
            hero.critical_damage = hero.critical_damage+tempAbility:GetCriticalDamage()
          end
          if(tempAbility.GetEvade)then
            hero.evade_point = hero.evade_point+tempAbility:GetEvade()
          end
          if(tempAbility.GetByPassEvade)then
             hero.bypass_evade = hero.bypass_evade +tempAbility:GetByPassEvade()
          end
          --vat cong ngoai
          if(tempAbility.GetAmplifyPhysic)then
            hero.physic_amplify = hero.physic_amplify+tempAbility:GetAmplifyPhysic()
          end
          if(tempAbility.GetReducePoisonTime)then
            hero.reduce_poison_time = hero.reduce_poison_time+tempAbility:GetReducePoisonTime()
          end
          --hp
          

--          if(tempAbility.GetExtraHpPercentage) then
--            hero.extra_hp_percentage = hero.extra_hp_percentage+tempAbility:GetExtraHpPercentage()
--          end
--          if(tempAbility.GetExtraMpPercentage) then
--            hero.extra_mp_percentage = hero.extra_mp_percentage+tempAbility:GetExtraMpPercentage()
--          end
          --hpmp speed
          if(tempAbility.GetHpRegenPercentage)then
          hero.hpregen_multi = hero.hpregen_multi+tempAbility:GetHpRegenPercentage()
          end
          
          if(tempAbility.GetMpRegenPercentage)then
          hero.mpregen_multi = hero.mpregen_multi+tempAbility:GetMpRegenPercentage()
          end
          
          
          --damage

          if(tempAbility.GetSkillAmplify)then
            hero.skill_amplify = hero.skill_amplify +tempAbility:GetSkillAmplify()    
          end

          if(tempAbility.GetElementDamage)then
            hero.skill_element_damage = hero.skill_element_damage +tempAbility:GetElementDamage()    
          end
          if(tempAbility.GetBasicDamage) then
            hero.basic_damage_percent = hero.basic_damage_percent +tempAbility:GetBasicDamage()
          end
          
          if(tempAbility.GetPoisonDamage) then
            hero.skill_poison_damage = hero.skill_poison_damage +tempAbility:GetPoisonDamage()
          end
          
          
          if(tempAbility.GetPhysicEvade) then
            hero.physic_evade = hero.physic_evade +tempAbility:GetPhysicEvade()
          end
          if(tempAbility.GetElementEvade) then
            hero.element_evade = hero.element_evade +tempAbility:GetElementEvade()
          end
          if(tempAbility.GetReturnResist) then
            hero.return_damage_resist = hero.return_damage_resist +tempAbility:GetReturnResist()
          end
          -- STATUS EFFECT
          --BURN
          if(tempAbility.GetBurnInflictChance) then
            hero.effect_burn_add_percent = hero.effect_burn_add_percent +tempAbility:GetBurnInflictChance()
          end
          
          if(tempAbility.GetBurnResistChance) then
            hero.effect_burn_resist_percent = hero.effect_burn_resist_percent +tempAbility:GetBurnResistChance()
          end
             if(tempAbility.GetBurnInflictTime) then
            hero.effect_burn_add_time = hero.effect_burn_add_time +tempAbility:GetBurnInflictTime()
          end    
            if(tempAbility.GetBurnResistTime) then
            hero.effect_burn_reduce_time = hero.effect_burn_reduce_time +tempAbility:GetBurnResistTime()
          end
          
          --SLOW
            if(tempAbility.GetSlowInflictChance) then
            hero.effect_slow_add_percent = hero.effect_slow_add_percent +tempAbility:GetSlowInflictChance()
          end
  
            if(tempAbility.GetSlowResistChance) then
            hero.effect_slow_resist_percent = hero.effect_slow_resist_percent +tempAbility:GetSlowResistChance()
          end
  
            if(tempAbility.GetSlowInflictTime) then
            hero.effect_slow_add_time = hero.effect_slow_add_time +tempAbility:GetSlowInflictTime()
          end
  
            if(tempAbility.GetSlowResistTime) then
            hero.effect_slow_reduce_time = hero.effect_slow_reduce_time +tempAbility:GetSlowResistTime()
          end
  
        --STUN
            if(tempAbility.GetStunInflictChance) then
            hero.effect_stun_add_percent = hero.effect_stun_add_percent +tempAbility:GetStunInflictChance()
          end
          
  
            if(tempAbility.GetStunResistChance) then
            hero.effect_stun_resist_percent = hero.effect_stun_resist_percent +tempAbility:GetStunResistChance()
          end
  
            if(tempAbility.GetStunInflictTime) then
            hero.effect_stun_add_time = hero.effect_stun_add_time +tempAbility:GetStunInflictTime()
          end
  
            if(tempAbility.GetStunResistTime) then
            hero.effect_stun_reduce_time = hero.effect_stun_reduce_time +tempAbility:GetStunResistTime()
          end
  
          --WEAK
            if(tempAbility.GetWeakInflictChance) then
            hero.effect_weak_add_percent = hero.effect_weak_add_percent +tempAbility:GetWeakInflictChance()
          end
          if(tempAbility.GetWeakResistChance) then
            hero.effect_weak_resist_percent = hero.effect_weak_resist_percent +tempAbility:GetWeakResistChance()
          end
  
          if(tempAbility.GetWeakInflictTime) then
            hero.effect_weak_add_time = hero.effect_weak_add_time +tempAbility:GetWeakInflictTime()
          end
  
          if(tempAbility.GetWeakResistTime) then
            hero.effect_weak_reduce_time = hero.effect_weak_reduce_time +tempAbility:GetWeakResistTime()
          end
  
        --MAIM
            if(tempAbility.GetMaimInflictChance) then
            hero.effect_maim_add_percent = hero.effect_maim_add_percent +tempAbility:GetMaimInflictChance()
          end
  
            if(tempAbility.GetMaimResistChance) then
            hero.effect_maim_resist_percent = hero.effect_maim_resist_percent +tempAbility:GetMaimResistChance()
          end
  
            if(tempAbility.GetMaimInflictTime) then
            hero.effect_maim_add_time = hero.effect_maim_add_time +tempAbility:GetMaimInflictTime()
          end
  
            if(tempAbility.GetMaimResistTime) then
            hero.effect_maim_reduce_time = hero.effect_maim_reduce_time +tempAbility:GetMaimResistTime()
          end
        end
        --FEAR-PARALIZED-KNOCKBACK
        if(tempAbility.GetFearResistChance) then
            hero.effect_fear_resist_percent = hero.effect_fear_resist_percent +tempAbility:GetFearResistChance()
        end
        
        if(tempAbility.GetParalizedResistChance) then
            hero.effect_paralized_resist_percent = hero.effect_paralized_resist_percent +tempAbility:GetParalizedResistChance()
        end
        
        if(tempAbility.GetKnockbackResistChance) then
            hero.effect_knockback_resist_percent = hero.effect_knockback_resist_percent +tempAbility:GetKnockbackResistChance()
        end
        
        --SPECIAL BUFF
        if(tempAbility.UpdateSkill)then
          tempAbility:UpdateSkill()
        end
  
        
      end
      
    end
    
    
    kemPrint("Send update stat for player "..playerID.." got "..hero.stat_point)
    hero.as = math.ceil(hero:GetAttackSpeed()*100-100)
    print("#391 sendCommand : update_stat")
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_stat", {playerID=playerID,hero=hero,msg="player_data 298"})

    --CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_skill", {playerID=playerID,hero=hero})
  end
    
end
function CreateDataForPlayer(playerID)
    -- Don't create data twice
    if playerID<0 then 
      return 
    end
    
    local hero = HERO_OF_PLAYER[playerID]
    if not hero then
      return
    end
    if hero.inited then return end

  --Timers:CreateTimer(1,function()
    --hero:StartGesture(ACT_DOTA_CAST_ABILITY_2)  
    --return 1
  --end)
  
  hero.inited = true
  hero.idx = hero:GetEntityIndex()
  hero.hero_level = hero:GetLevel()
  hero:SetIdleAcquire( false ) 
  hero.skill_level = 0
  --kemPrint("Save spawn point "..hero:GetUnitName())
  hero.spawn_point = hero:GetOrigin()

  
  local hero_elements = LoadKeyValues("scripts/kv/hero_element.kv")
  local hero_name = hero:GetUnitName()
  local heroData = hero_elements[hero_name]
  
  
  --PrintTable(heroData)
  hero.element = heroData["element"] or ELEMENT_NONE
  hero.class   = heroData["class"] or ""
  --kemPrint("Element "..hero.element)
  local abilityCount  = hero:GetAbilityCount()
  for i=0,abilityCount-1 do
    local tempAbi = hero:GetAbilityByIndex(i)
    if(tempAbi)then
      kemPrint("Skill slot "..i.." : "..tempAbi:GetAbilityName())
    end
  end
  if(heroData["attach_point_1"])then
    hero.attach_point_1 = heroData["attach_point_1"]
    hero.attach_model_1 = heroData["attach_model_1"]
    Attachments:AttachProp(hero, heroData["attach_point_1"], heroData["attach_model_1"], 1.0)
  end
  
  if(heroData["effect_1"]) then
    --kemPrint("adding "..heroData["effect_1"])

    local tempAbi = hero:AddAbility(heroData["effect_1"])
    hero:UpgradeAbility(tempAbi)
  end
   if(heroData["effect_2"]) then

    --kemPrint("adding "..heroData["effect_2"])
    local tempAbi2 = hero:AddAbility(heroData["effect_2"])
    hero:UpgradeAbility(tempAbi2)
  end
  --kemPrint("Damage type "..hero_name.." is "..heroData["damage_type"])

  if(heroData["damage_type"]==0)then
     hero.is_physical  = true -- ngoai cong/ noi cong
     hero.is_magical = false
  else
     hero.is_physical = false
     hero.is_magical = true
  end
  hero.khinhcong_cooldown=true
  if(heroData['jump_type']=="aow_nhc")then
     hero.khinhcong_cooldown=false
  end
  if(heroData["horse_disable_ability"]==1)then
    local khinhcong_ability = hero:AddAbility("skill_khinhcong")
    hero:UpgradeAbility(khinhcong_ability)
    if  khinhcong_ability then
      local kc_time = 10
      if(IsInToolsMode())then
        kc_time = 10
      end
      hero:AddNewModifier(hero,khinhcong_ability , "modifier_khinhcong_lua",{max_count = 10,start_count = 10,replenish_time = kc_time})
    end
  end
  hero:AddNewModifier(hero,nil , "modifier_parry",{max_count = 50,start_count = 50,replenish_time = 2})--2 giay tang 1 diem
  hero:AddNewModifier(hero,nil , "modifier_angry",{max_count = 80,start_count = 0,replenish_time = 2})--3 giay giam 1 diem
  hero:AddNewModifier(hero,nil,"modifier_game_speed",{})
  hero:AddNewModifier(hero,nil , "modifier_skill_level",{})
  
  hero.stat_tp = 50
  Kem_Attributes:ModifyBonuses(hero)
  hero.hero_image= hero:GetUnitName()
  hero.hero_name= hero:GetUnitName()  
  hero.jump_time = 0
  
  hero.stat_sm  = hero:GetAgility()
  hero.stat_tp  = hero.stat_tp -- 1 than phap = 4 ne tranh, 4 chinh xac
  hero.stat_sk  = hero:GetStrength()
  hero.stat_nc  = hero:GetIntellect()
  
  hero.stat_point = 0
  hero.skill_point = 0
  hero.stat_gain = 0
  hero.stat_spend_on_sm = 0
  hero.auto_sm = 0
  if(heroData["auto_sm"])then
    hero.auto_sm = heroData["auto_sm"]/100
  end
  
  hero.stat_spend_on_tp = 0
  hero.auto_tp = 0
  if(heroData["auto_tp"])then
    hero.auto_tp= heroData["auto_tp"]/100
  end
  hero.stat_spend_on_sk = 0
   hero.auto_sk = 0
  if(heroData["auto_sk"])then
    hero.auto_sk = heroData["auto_sk"]/100
  end
  hero.stat_spend_on_nc = 0
  hero.auto_nc = 0
  if(heroData["auto_nc"])then
    hero.auto_nc = heroData["auto_nc"]/100
  end
  --damage
  
  ResetStat(hero)
  
  hero.player_name  = PlayerResource:GetPlayerName(playerID)
    if hero.player_name  == "" then -- This normally happens in dev tools
        hero.player_name  = 'Developer'
    end
  hero.canDive = function()
    if(hero:HasModifier("modifier_prepare"))then
      return false
    end
    if(hero:HasModifier("modifier_kem_moving"))then
    
    end
    if hero:IsStunned() or hero:IsHexed() or hero:IsFrozen() or hero:IsNightmared() or hero:IsOutOfGame() then
    -- Interrupt the ability
      return false
    end
    return true
  end
  hero.isDisabled = function()
    if hero:IsStunned() or hero:IsHexed() or hero:IsFrozen() or hero:IsNightmared() or hero:IsOutOfGame() then
    -- Interrupt the ability
      return true
    end
    return false
  end
  hero.skillCooldown = function()

    --PrintTable(self)
    local atk_perseconds = hero:GetAttacksPerSecond()
    local general_cooldown =  1/atk_perseconds
    for i = 0,11 do 
       local tempAbility = hero:GetAbilityByIndex(i)
       if(tempAbility)then
         local currentCooldown = tempAbility:GetCooldownTimeRemaining()
         local currentLevel  = tempAbility:GetLevel()
         local isActive = not tempAbility:IsPassive()
         if(currentCooldown<general_cooldown and currentLevel>0 and isActive) then
           tempAbility:StartCooldown(general_cooldown)
         end
       end
       

       
    end
  end   
  
  Timers:CreateTimer(0.5,function()
    if(hero.leveled_up)then
      hero.leveled_up=false

      Kem_Attributes:ModifyBonuses(hero)
    end
    return 0.5
  end)
  

  
  return hero
end



function IncreaseJumpTime(playerID)
  local hero = HERO_OF_PLAYER[playerID]
  hero.jump_time = hero.jump_time+1
  
end

