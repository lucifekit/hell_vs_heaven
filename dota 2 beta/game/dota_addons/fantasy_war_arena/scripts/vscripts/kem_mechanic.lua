

Spawn_Point = {}

Spawn_Point_Big = {}

Maps = {}
Maps[1] = {}
Maps[2] = {}
Maps[3] = {}

Creep_Level = 1
SETTING_CREEP_START_SPAWN_TIME = 5
SETTING_CREEP_SPAWNS_TICK = 30
SETTING_CREEP_CAMP_RADIUS = 500
SETTING_CREEP_NUMBER_PER_CAMP = 15

SETTING_CREEP_BIG_CAMP_RADIUS = 800
SETTING_CREEP_NUMBER_PER_BIG_CAMP = 30

SETTING_CREEP_UPGRADE_TICK = 180

SETTING_TIMER = 2
SETTING_EXPERIENCE_PER_TICK = 500
Boss_Heaven_Appear = false
Boss_Hell_Appear = false
LinkLuaModifier("modifier_creep_ai","modifiers/ai/modifier_creep_ai", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_boss_ai","modifiers/ai/modifier_boss_ai", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_building","modifiers/modifier_building", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_building_hp","modifiers/modifier_building_hp", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_prepare","modifiers/modifier_prepare", LUA_MODIFIER_MOTION_NONE )

require('battle')
function CreateBoss(where,team)
  local unit_name= "dieptinh"
  --kemPrint("Create bosssssssssssssssssss")
  if(team==DOTA_TEAM_GOODGUYS)then
    unit_name="heaven"
  end
  if(team==DOTA_TEAM_BADGUYS)then
    unit_name="hell"
  end
  LinkLuaModifier("modifier_boss_"..unit_name,"bosses/modifier_boss_"..unit_name, LUA_MODIFIER_MOTION_NONE )
  kemPrint("Link complete "..unit_name)
  local boss = CreateUnitByName("npc_boss_"..unit_name, where, true, nil, nil,team)
  if(boss)then
    kemPrint("boss : "..boss:GetUnitName())
    boss:AddNewModifier(boss,nil,"modifier_boss_"..unit_name,{})
    boss:AddNewModifier(boss,nil,"modifier_boss_ai",{})
  else
    kemPrint("=========WARNING : CREATE BOSS "..unit_name.." FAILED ===============")
  end
  
  --kemPrint("Created "..boss:GetUnitName())
end
function SpawnCreeps()
  --kemPrint("Spawn length : "..#Spawn_Point)

  local tower_exists = false
  local tower_entities = Entities:FindAllByName("npc_dota_creature")
 
  local t1_tower = 0
  local t2_tower = 0
  for _,ent in ipairs(tower_entities) do
    local tempName = ent:GetUnitName()

    if(tempName=='npc_tower_team1')then
      t1_tower = t1_tower+1
    end
    if(tempName=='npc_tower_team2')then
      t2_tower = t2_tower+1
    end
  end

  if(t1_tower>0)then
    GameRules:SendCustomMessage("Heaven got "..t1_tower.." towers!", 0, 0)
    else
    GameRules:SendCustomMessage("Heaven need to find some towers!", 0, 0)
  end
  if(t2_tower>0)then
  GameRules:SendCustomMessage("Hell got "..t2_tower.." towers!", 1, 0)
  else
  GameRules:SendCustomMessage("Hell need to find some towers!", 1, 0)
  
  end
  
  for i = 0,9 do
    --kemPrint("Must edit 49 kem_mechanic")
    if(HERO_OF_PLAYER[i])then
        local team_tower = 0
        if(HERO_OF_PLAYER[i]:GetTeam()==DOTA_TEAM_GOODGUYS)then
          team_tower = t1_tower
          else
          team_tower = t2_tower
        end
        local exp_add = SETTING_EXPERIENCE_PER_TICK*team_tower
        if(t1_tower>0)then
          exp_add = exp_add +Creep_Level*100
        end
        --kemPrint("Adding "..exp_add.." exp for "..HERO_OF_PLAYER[i]:GetUnitName())
        HERO_OF_PLAYER[i]:AddExperience(exp_add, 0, false, false)
    end
  end

  
  for _,spawn_point in ipairs(Spawn_Point) do
      local radius = SETTING_CREEP_CAMP_RADIUS
      local numbers_camp = SETTING_CREEP_NUMBER_PER_CAMP
  
        
      local neutralsUnitGroup = FindUnitsInRadius(NEUTRALS_TEAM,spawn_point, nil, radius*2, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false)
  
      for i=1,numbers_camp-#neutralsUnitGroup do
        local tempUnit = CreateUnitByName("npc_unit_level_"..math.random(Creep_Level,Creep_Level+1), Vector(math.random(spawn_point.x-radius,spawn_point.x+radius),math.random(spawn_point.y-radius,spawn_point.y+radius),0), true, nil, nil,DOTA_TEAM_NEUTRALS)

        --kemPrint("Adding modifier for "..tempUnit:GetUnitName().."-"..tempUnit:entindex())
        tempUnit:AddNewModifier(nil,nil,"modifier_creep_ai",nil)
      end
  end
  
  
  for _,spawn_point in ipairs(Spawn_Point_Big) do
      local big_radius = SETTING_CREEP_BIG_CAMP_RADIUS
      local big_numbers_camp = SETTING_CREEP_NUMBER_PER_BIG_CAMP
  
        
      local neutralsUnitGroup = FindUnitsInRadius(NEUTRALS_TEAM,spawn_point, nil, big_radius+500, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false)
      local big_creep_level = Creep_Level
      if(big_creep_level<10)then
        big_creep_level=big_creep_level+1
      end
      for i=1,big_numbers_camp-#neutralsUnitGroup do
        local tempUnit = CreateUnitByName("npc_unit_level_"..math.random(big_creep_level,big_creep_level+1), Vector(math.random(spawn_point.x-big_radius,spawn_point.x+big_radius),math.random(spawn_point.y-big_radius,spawn_point.y+big_radius),0), true, nil, nil,DOTA_TEAM_NEUTRALS)
        --kemPrint("Adding modifier for "..tempUnit:GetUnitName().."-"..tempUnit:entindex())

        tempUnit:AddNewModifier(nil,nil,"modifier_creep_ai",nil)
      end
  end
  createdTower = true
  return SETTING_CREEP_SPAWNS_TICK
end

function UpgradeCreeps()

  if(Creep_Level<10)then    
    Creep_Level = Creep_Level+1
    kemPrint("============UPGRADING CREEP TO LEVEL "..Creep_Level.."==================")

  end
  
  SETTING_CREEP_UPGRADE_TICK = SETTING_CREEP_UPGRADE_TICK+30
  return SETTING_CREEP_UPGRADE_TICK
end


function GameBegun()
  --kemPrint("GameBegun"..DAMAGE_TYPE_PHYSICAL)
  --kemPrint("GameBegun"..DAMAGE_TYPE_MAGICAL)
  --kemPrint("GameBegun"..DAMAGE_TYPE_PURE)
  --kemPrint("GameBegun"..DAMAGE_TYPE_ALL)
  
    CustomNetTables:SetTableValue( "kem_settings", "global", {speed_base=2.5} )

  GameRules:SendCustomMessage("<font color='#ff2222'>Tips:</font> Buy a mango for regen in early game.", 0, 0)
  GameRules:SendCustomMessage("<font color='#ff2222'>Tips:</font> Destroy tower at neutral camp to level up faster.", 1, 0)
  Battle_Step_0_Wait()
  
  for _,maps_1_point in ipairs(Entities:FindAllByName("maps_1")) do
    table.insert(Maps[1],maps_1_point:GetOrigin())
  end
  
  for _,maps_1_point in ipairs(Entities:FindAllByName("maps_2")) do
    table.insert(Maps[2],maps_1_point:GetOrigin())
  end
  
  for _,maps_1_point in ipairs(Entities:FindAllByName("maps_3")) do
    table.insert(Maps[3],maps_1_point:GetOrigin())
  end
  PrintTable(Maps)
  
  
   
  local tempEntitiesGroup2 = Entities:FindAllByName("spawn_point")  
  for _,spawn_point in ipairs(tempEntitiesGroup2) do
    table.insert(Spawn_Point,spawn_point:GetAbsOrigin())
    
          
    local tower = CreateUnitByName("npc_tower", spawn_point:GetAbsOrigin(), true, nil, nil,DOTA_TEAM_NEUTRALS)
    tower:RemoveModifierByName("modifier_invulnerable")
    tower:AddNewModifier( nil, nil,"modifier_building", {} )
       

    --kemPrint(spawn_point:GetAbsOrigin())
  end
  
  local tempEntitiesGroup3 = Entities:FindAllByName("spawn_point_big")  
  for _,spawn_point in ipairs(tempEntitiesGroup3) do
    table.insert(Spawn_Point_Big,spawn_point:GetAbsOrigin())
    
          
    local tower = CreateUnitByName("npc_tower", spawn_point:GetAbsOrigin(), true, nil, nil,DOTA_TEAM_NEUTRALS)
    tower:RemoveModifierByName("modifier_invulnerable")
    tower:AddNewModifier( nil, nil,"modifier_building", {} )
       
    --kemPrint(spawn_point:GetAbsOrigin())
  end
  
  CreateBoss(Vector(0,-600,0),DOTA_TEAM_NEUTRALS)
  
  Timers:CreateTimer(SETTING_CREEP_START_SPAWN_TIME,SpawnCreeps)
  Timers:CreateTimer(SETTING_CREEP_UPGRADE_TICK,UpgradeCreeps)
  --TestCreep()
end


function AllPlayerLoaded()

  kemPrint("All played loaded")
  Timers:CreateTimer(1,function()
    if(not Battle_Time)then
      for i = 0,10 do
      if(HERO_OF_PLAYER[i])then
        HERO_OF_PLAYER[i]:AddExperience(5,0,false,false)
        --HERO_OF_PLAYER[i]:AddExperience(5,0,false,false)
      end
    end
    end
    
    return 1
  end)
  Timers:CreateTimer(0.5,function()
      
      --DeepPrintTable(PoisonedUnits)
      
      for i,u in ipairs(PoisonedUnitsList) do
        
        local idx = u:GetEntityIndex()
        local damageTaken = PoisonDamage[idx]
        if damageTaken~= nil then
          --kemPrint("Unit with idx [".. idx.."] take "..damageTaken.." poison damage in the last 0.5s")

          local numberIndex = ParticleManager:CreateParticle( SETTING_FX_POISON, PATTACH_OVERHEAD_FOLLOW, u )
          ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, damageTaken, 0 ) )
          ParticleManager:SetParticleControl( numberIndex, 2, Vector( 1, string.len( math.floor( damageTaken ) ) + 1, 0 ) )
          ParticleManager:SetParticleControl( numberIndex, 3, Vector( 34,139,34 ) )
          ParticleManager:ReleaseParticleIndex(numberIndex)
        end
        PoisonDamage[idx] = nil
        PoisonedUnitsList[i] = nil
      end
      
      for i,u in ipairs(DamagedUnitsList) do

        --kemPrint("#99")
        local idx = u:GetEntityIndex()
        local damageTaken = DamageInfoList[idx]
        if damageTaken~= nil then
          --kemPrint("Unit with idx [".. idx.."] take "..damageTaken.." poison damage in the last 0.5s")

          local numberIndex = ParticleManager:CreateParticle( SETTING_FX_DAMAGE, PATTACH_OVERHEAD_FOLLOW, u )
          ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, damageTaken, 0 ) )
          ParticleManager:SetParticleControl( numberIndex, 2, Vector( 1, string.len( math.floor( damageTaken ) ) + 1, 0 ) )
          ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,55,55 ) )
          ParticleManager:ReleaseParticleIndex(numberIndex)
        end
        DamageInfoList[idx] = nil
        DamagedUnitsList[i] = nil
      end
      
      return 0.5
    end)  

    --kemPrint("All played loaded done")
end

function HandleHeroCreated(hero)
  --kemPrint("Handling hero create")
  local owner = hero:GetOwner()
  if owner == nil then
    --kemPrint("Owner = nil")

    return
  end
  local ownerID = owner:GetPlayerID()
  
 
  
  local hero_name = hero:GetUnitName()
  --------------------
  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(1000, false)


  hero:UpgradeAbility(hero:GetAbilityByIndex(0))--skill 1
  
  --kemPrint(hero:GetUnitName())

  
  
  local cs = PlayerResource:GetConnectionState(ownerID)
  if(cs==1)then
    --neu la bot
    hero:ModifyStrength(1000)

    while(hero:GetLevel()<88)do
                  hero:HeroLevelUp(false)
                end
    
    for i = 1,12 do
      hero:GetAbilityByIndex(i):SetLevel(5)
    end
  end
  
  --for i=0,10 do
  --    hero:HeroLevelUp(false)
  --  end
  Timers:CreateTimer(SETTING_TIMER,function()
    --

    if(hero:GetLevel()<65)then
    
    --hero:AddExperience(100000,0,false,false)
    end
    
   

   
    return SETTING_TIMER
  end)
  

end
function TestCreep()
  Timers:CreateTimer(0.1, -- Start this timer 30 game-time seconds later
    function()
      local radius = 2000
      local numbers_camp = 10
      local neutralsUnitGroup = FindUnitsInRadius(NEUTRALS_TEAM, Vector(0,0,0), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false)
      for i=0,numbers_camp-#neutralsUnitGroup do
        CreateUnitByName("npc_unit_level_"..math.random(1,2), Vector(math.random(-1000,1000),math.random(-1000,1000),0), true, nil, nil,DOTA_TEAM_NEUTRALS)
      end
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
    
   Timers:CreateTimer(0.1, -- Start this timer 30 game-time seconds later
    function()
      --vacumm(pull_data)
      --local tempOrigin = hero:GetOrigin()
      --local tempAbsOrigin = hero:GetAbsOrigin()

      --hero:SetOrigin(Vector(0,0,0))
     
      local radius = 1500
      local numbers_camp = 10
      local neutralsUnitGroup = FindUnitsInRadius(NEUTRALS_TEAM, Vector(0,0,0), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false)

      local tempVector = Vector(1000,1000,0)
      local gameTime = GameRules:GetGameTime()
      local tempValue = gameTime%60
      if(tempValue>15)then
        
        if(tempValue<30)then
          tempVector = Vector(-1000,1000,0)
          
        else
          if(tempValue<45)then
            tempVector = Vector(-1000,-1000,0)
            
          else
            tempVector = Vector(1000,-1000,0)
          end
        end
      end
      for _,victim in ipairs(neutralsUnitGroup) do
        local newOrder = {
          UnitIndex = victim:GetEntityIndex(), 
          OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
          Position = tempVector, --Optional.  Only used when targeting the ground
          Queue = 0 --Optional.  Used for queueing up abilities
        }
       
        ExecuteOrderFromTable(newOrder)
        --CreateUnitByName("npc_unit_level_1", Vector(math.random(-radius,radius),math.random(-radius,radius),0), true, nil, nil,DOTA_TEAM_NEUTRALS)
        --CreateUnitByName("npc_unit_level_1", Vector(0,0,0), true, nil, nil,DOTA_TEAM_NEUTRALS)
      end
      
            
      return 5.0 -- Rerun this timer every 30 game-time seconds 
    end)
end


function initParonama()
  
  if(GAME_STATE<6) then
      kemPrint("Hud not ready")

      return
  end
  
  for i=0,12 do
      local hPlayerHero = HERO_OF_PLAYER[i]
      if(PlayerResource:GetConnectionState(i)==2) then

        --kemPrint(i,hPlayerHero)
        if hPlayerHero then
          kemPrint("Init data")
          UpdatePlayerDataForHero(hPlayerHero)
         else
            kemPrint("Player "..i.." does not have hero")
         end
      else
        --kemPrint("Player "..i.." does not connected")

      end
      
    end
    

    kemPrint("====================INITED PARONAMA =======================")

end
function CreateHeavenBoss()
  local tempEntitiesGroupHeaven = Entities:FindAllByName("heaven_teleport")  
      for _,spawn_point in ipairs(tempEntitiesGroupHeaven) do
        GameRules:SendCustomMessage("<font color='#0099ff'>SKYWRATH MAGE:</font> FOR THE HEAVEN SAKE, I COME TO DESTROY THE HELL", 0, 0)
        --GameRules:SendCustomMessage("<font color='#0099ff'>Mystery voice:</font> Until now, i killed 329 people, maybe you will become the 330th one...", 1, 0)
        CreateBoss(spawn_point:GetOrigin(),DOTA_TEAM_GOODGUYS)
      end
  
end
function CreateHellBoss()
  local tempEntitiesGroupHell = Entities:FindAllByName("hell_teleport")  
      for _,spawn_point in ipairs(tempEntitiesGroupHell) do
      GameRules:SendCustomMessage("<font color='#0099ff'>NIGHT STALKER:</font> TIME FOR HEAVEN FALL", 0, 0)
        CreateBoss(spawn_point:GetOrigin(),DOTA_TEAM_BADGUYS)
      end
end
function OnDie(keys)

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  ------------

  --kemPrint("Killer team =="..killerEntity:GetTeam().."|"..DOTA_TEAM_NEUTRALS.." die = "..killedUnit:GetUnitName())
  local needUpdate = false
  if killedUnit:IsRealHero() then 
    kemPrint("real hero die")

    if END_GAME_ON_KILLS and TEAM_POINT[killerEntity:GetTeam()] >= KILLS_TO_END_GAME_FOR_TEAM then
      GameRules:SetSafeToLeave( true )
      GameRules:SetGameWinner( killerEntity:GetTeam() )
    end
    if(killerEntity:GetTeam()==DOTA_TEAM_GOODGUYS)then
      TEAM_POINT[DOTA_TEAM_GOODGUYS] =TEAM_POINT[DOTA_TEAM_GOODGUYS]+1 
    end
    if(killerEntity:GetTeam()==DOTA_TEAM_BADGUYS)then
      TEAM_POINT[DOTA_TEAM_BADGUYS] = TEAM_POINT[DOTA_TEAM_BADGUYS]+1 
    end
    --PlayerResource:GetTeamKills

    needUpdate = true
  else
    --creep die
    
    local killedName = killedUnit:GetUnitName()
    kemPrint("creep die "..killedName)
    if(killedName=="npc_tower" or killedName=="npc_tower_team1" or killedName=="npc_tower_team2")then
      killedUnit:AddNoDraw()
      --local team = GetTeamName(killerEntity:GetTeam())
      local unitName = "npc_tower"
      
      if(killerEntity:GetTeam()==DOTA_TEAM_GOODGUYS)then
        unitName = "npc_tower_team1"
      end
      if(killerEntity:GetTeam()==DOTA_TEAM_BADGUYS)then
        unitName = "npc_tower_team2"
      end
      kemPrint("Tower for "..killerEntity:GetTeam().." "..unitName)

      local newTower = CreateUnitByName(unitName, killedUnit:GetOrigin(), true, nil, nil,killerEntity:GetTeam())
      newTower:SetHealth(1)
      newTower:AddNewModifier( nil, nil,"modifier_building", {} )
      newTower:AddNewModifier( nil, nil,"modifier_building_hp", {duration=5} )
      FindClearSpaceForUnit(newTower,newTower:GetAbsOrigin(),true)
    end

    if(string.sub(killedName,0,8)=="npc_boss")then
      TEAM_POINT[killerEntity:GetTeam()] =TEAM_POINT[killerEntity:GetTeam()]+5
      needUpdate = true
    end
    RollDrops(killedUnit)
 
  end
  if needUpdate then
    if SHOW_KILLS_ON_TOPBAR then
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, TEAM_POINT[DOTA_TEAM_BADGUYS] )
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, TEAM_POINT[DOTA_TEAM_GOODGUYS])
    end
    if(TEAM_POINT[DOTA_TEAM_BADGUYS]>25)then
      CreateHeavenBoss()
      
  
    end
    if(TEAM_POINT[DOTA_TEAM_GOODGUYS]>25)then
      CreateHellBoss()
      
    end
    if END_GAME_ON_KILLS and TEAM_POINT[killerEntity:GetTeam()] >= KILLS_TO_END_GAME_FOR_TEAM then

        local teamName = "Heaven win"
        if(killerEntity:GetTeam()==2)then
          teamName = "Hell win"
        end
        kemPrint("Game end "..teamName)

        GameRules:SetCustomVictoryMessage(teamName)
        GameRules:SetCustomVictoryMessageDuration(10)
        GameRules:SetSafeToLeave( true )
        GameRules:SetGameWinner( killerEntity:GetTeam() )
      end

  end

end
function RollDrops(unit)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        print("Rolling Drops for "..unit:GetUnitName())
        for k,ItemTable in pairs(DropInfo) do
            -- If its an ItemSet entry, decide which item to drop
            local item_name
            if ItemTable.ItemSets then
                -- Count how many there are to choose from
                local count = 0
                for i,v in pairs(ItemTable.ItemSets) do
                    count = count+1
                end
                local random_i = RandomInt(1,count)
                item_name = ItemTable.ItemSets[tostring(random_i)]
            else
                item_name = ItemTable.Item
            end
            local chance = ItemTable.Chance or 100
            local max_drops = ItemTable.Multiple or 1
            for i=1,max_drops do
                print("Rolling chance "..chance)
                if RollPercentage(chance) then
                    print("Creating "..item_name)
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(0)
                    local pos = unit:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(150,200))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
                end
            end
        end
    end
end

function OnSkillUsed(keys)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
  
  if(string.sub(abilityname,0,5)~='item_')then
    if(HERO_OF_PLAYER[keys.PlayerID]) then
      local hero = HERO_OF_PLAYER[keys.PlayerID]
      if(hero.skillCooldown) then
        --hero:AddExperience(200,0,false,false)
        --hero:HeroLevelUp(true)
        hero.skillCooldown()
      end
      
        if(IsInToolsMode())then
--            if(hero.qX)then
--              PrintTable(keys)
--              local eff = "particles/edited_particle/kiem_minh/thanhhoaphantam.vpcf"
--              local caster_point = hero:GetOrigin()
--              local cast_point = Vector(caster_point.x+500,caster_point.y,caster_point.z)
--              local angle = (cast_point-caster_point):Normalized()
--              local vectorAngleRotated = RotateVector2D(angle,math.rad(90))
--              for i = 0,5 do
--                local pfx2 = ParticleManager:CreateParticle(eff,PATTACH_WORLDORIGIN,hero)
--                local where = caster_point+i*100*vectorAngleRotated
--                ParticleManager:SetParticleControl( pfx2, 0,where )
--                Timers:CreateTimer(2,function()
--                     ParticleManager:DestroyParticle(pfx2,true)
--                      
--                end)
--              end
--              

--              
--            end
        end
    end

  end
  
  
end


function KemChat(keys,playerID)
  local teamonly = keys.teamonly
  
  
 
  local hero = HERO_OF_PLAYER[playerID]

  
  local text = keys.text
  kemPrint("Player id  "..playerID.." in team "..hero:GetTeam().." chat "..text)

  local qX = -1
  local qY = -1
  local qZ = -1
  
 
    
    local command = ""
    for s in string.gmatch(text, "%S+") do
      if(command=="")then
        if(string.sub(s,0,1)=="-")then
          command = s

          ----------
          --
          --
          --    NO ARGUMENT COMMAND
          --
          --
          --
          --------------------------------------------

           if(command=="-stuck")then
            if(hero)then
              Timers:CreateTimer(10,function()
                hero:ForceKill(false)
              end)
              
            end
           end

           if(command=="-kem")then
              
             if(IsInToolsMode())then
                while(hero:GetLevel()<88)do
                  hero:HeroLevelUp(false)
                end
                hero:SetGold(500000, false)
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "enter_debug_mode", {playerID=playerID})
                for i = 1,12 do
                  hero:GetAbilityByIndex(i):SetLevel(5)
                end
             end
           end
           if(command=="-enterdebug")then
              kemPrint("command enter debug")
             if(IsInToolsMode())then
                kemPrint("ENTER DEBUG")
                 PlayerResource:SetCameraTarget( playerID,nil )
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "enter_debug_mode", {playerID=playerID})
             end
           end
           
           if(command=="-quitdebug")then
             if(IsInToolsMode())then
                kemPrint("QUIT DEBUG")
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "quit_debug_mode", {playerID=playerID})
             end
           end
           if(command=="-boss")then
             if(IsInToolsMode())then
              if(hero)then
                kemPrint("Set position")
                local bosses = Entities:FindAllByName("npc_dota_creature")
                kemPrint("Boss count "..#bosses)

                if(#bosses>0)then
                  for _,enemy in ipairs(bosses) do
                    if(enemy:GetUnitName()=="npc_boss_dieptinh")then
                      hero:SetAbsOrigin(enemy:GetOrigin())
                      FindClearSpaceForUnit(hero, hero:GetOrigin(),true)  
                    end
                  end
                  
                end
                
              end
             end
           end
           if(command=="-createheavenboss")then
             if(IsInToolsMode())then
              CreateHeavenBoss()
             end
             
           end
           if(command=="-createhellboss")then
             if(IsInToolsMode())then
              CreateHellBoss()
             end
             
           end
           if(command=="-heaven")then
             if(IsInToolsMode())then
              if(hero)then
                kemPrint("Set position")
                local bosses = Entities:FindAllByName("npc_dota_creature")
                                if(#bosses>0)then
                  for _,enemy in ipairs(bosses) do
                    if(enemy:GetUnitName()=="npc_boss_heaven")then
                      hero:SetAbsOrigin(enemy:GetOrigin()+Vector(math.random(-200,200),math.random(-200,200),0))
                      FindClearSpaceForUnit(hero, hero:GetOrigin(),true)  
                    end
                  end
                  
                end
                
              end
             end
           end
           
           
           if(command=="-hell")then
             if(IsInToolsMode())then
              if(hero)then
                kemPrint("Set position")
                local bosses = Entities:FindAllByName("npc_dota_creature")
                kemPrint("Boss count "..#bosses)

                if(#bosses>0)then
                  for _,enemy in ipairs(bosses) do
                    if(enemy:GetUnitName()=="npc_boss_hell")then
                      hero:SetAbsOrigin(enemy:GetOrigin())
                      FindClearSpaceForUnit(hero, hero:GetOrigin(),true)  
                    end
                  end
                  
                end
                
              end
             end
           end
           
           if(command=="-upgradecreeps")then
              if(IsInToolsMode())then
                UpgradeCreeps()
              end
           end
        end
      else
        --da co command     

        kemPrint("command "..command) 
        if(command=="-level")then
           if(IsInToolsMode())then
                    local level = tonumber(s)
                    if(level>99)then
                      level =  99
                    end

                    if(level>0 and level<=99)then
                      if(hero)then
                        while(hero:GetLevel()<level)do
                          hero:HeroLevelUp(false)
                        end

                        hero:SetGold(99999,false)
                        for i = 0,11 do
                          local tempAbility =hero:GetAbilityByIndex(i) 
                          tempAbility:SetLevel(hero:GetAbilityByIndex(i):GetMaxLevel())
                        end
                        --hero:AddNewModifier(hero,nil,"modifier_prepare",{duration=5})
                        kemPrint("up auto "..playerID)
                        GameMode:UpStatAuto({playerID=playerID})
                      else
                        kemPrint("NO hero")

                      end
                    end
          end
        end
        
        if(command=="-health")then
           if(IsInToolsMode())then
                  local level = tonumber(s)
                  if(level>0 and level<=100)then
                    if(hero)then
                      hero:SetHealth(hero:GetMaxHealth()*level/100)
                    else

                    end
                  end
          end
        end
        
        if(command=="-q")then
          if(hero)then
            if(qX==-1)then
              qX = tonumber(s)
            else
              if(qY==-1)then
                qY = tonumber(s)
              else
                qZ = tonumber(s)
                hero.qX = qX
                hero.qY = qY
                hero.qZ = qZ

              end
            end
          end 
        end
        

        if(command=="-questtime")then
          if(IsInToolsMode())then
            CurrentQuest.EndTime = tonumber(s)
          end
        end

        
      end
    end  
  end