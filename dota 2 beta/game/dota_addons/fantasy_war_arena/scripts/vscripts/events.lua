-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.
--require("kem_mechanic")


TEAM_POINT = {}
TEAM_POINT[DOTA_TEAM_GOODGUYS] = 0
TEAM_POINT[DOTA_TEAM_BADGUYS] = 0
TEAM_POINT[DOTA_TEAM_NEUTRALS] = 0
HERO_READY = {}
GAME_STATE = 0
LinkLuaModifier("modifier_battle_hunger","modifiers/modifier_battle_hunger",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_defense","modifiers/modifier_defense",LUA_MODIFIER_MOTION_NONE)

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)
  
  -- This internal handling is used to set up main barebones functions
  GameMode:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
  GAME_STATE = newState

  kemPrint("GAME STATE = "..newState)
  if(GAME_STATE==6)then
    --try init paronama lan dau tien
    --kemPrint("Try init paronama lan dau tien")
    initParonama()
  end
    kemPrint("END GAME STATE = "..newState)

end


-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  --DebugPrint("[BAREBONES] NPC Spawned")
  --DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnNPCSpawned(keys)
  
  local npc = EntIndexToHScript(keys.entindex)


  --kemPrint("71",npc:GetOwner())
  --kemPrint("54",npc:IsOwnedByAnyPlayer(),npc:IsRealHero(),npc:GetOwner())

  if npc:IsOwnedByAnyPlayer() and npc:IsRealHero() and npc:GetOwner() then
    local hPlayerHero = npc
    GameRules:GetGameModeEntity():SetContextThink( "think_create_hero", function() return GameMode:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
  end
end


--kem add
function GameMode:MarkInitedJS(keys)
  if keys.playerID then
    GameMode._tJSInitedStatus[keys.playerID] = true
  end
  
end

function GameMode:InitedAbilityBook(keys)
  if keys.playerID then

    kemPrint("Call after inited ability book for player "..keys.playerID)

    UpdatePlayerData(keys.playerID)
  end
  
end


function GameMode:Think_InitializePlayerHero( hPlayerHero )

  if not hPlayerHero then
    return 0.1
  end

  kemPrint("Initializing hero")
  local nPlayerID = hPlayerHero:GetPlayerID()
  --kemPrint(type(self))

  if self._tPlayerHeroInitStatus[ nPlayerID ] == false then
    self._tPlayerHeroInitStatus[ nPlayerID ] = true
    PlayerResource:SetCameraTarget( nPlayerID, hPlayerHero )
    --PlayerResource:SetOverrideSelectionEntity( nPlayerID, hPlayerHero )

    kemPrint("Set hero of player "..nPlayerID)
    HERO_OF_PLAYER[nPlayerID] = hPlayerHero
    --kemPrint("create data for player commented")
    CreateDataForPlayer(nPlayerID)
    --kemPrint("handle hero created for player commented")
    HandleHeroCreated(hPlayerHero)
    
--    kemPrint("Leveling up..."..nPlayerID.." "..hPlayerHero:GetUnitName())

--    for i=0,56 do
--      hPlayerHero:HeroLevelUp(false)
--    end
     --1x    

    --kemPrint("init paronama commented")

    initParonama()
    
    
    
--    Timers:CreateTimer(1,function()
--      CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "init_ability", {player = nPlayerID ,hero = hPlayerHero})
--      return 1
--    end)
    
    
    
    --CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "update_skill", {player = nPlayerID ,data = data})
  end
  hPlayerHero:AddNewModifier(hPlayerHero,nil,"modifier_mango",{})
  if(Battle_Time)then
    hPlayerHero:SetOrigin(hPlayerHero.battle_position)
    hPlayerHero:AddNewModifier(hPlayerHero,nil,"modifier_prepare",{duration=5})
  else
    print("HERO CREATED "..hPlayerHero:GetUnitName())
    if(hPlayerHero:GetTeam()==DOTA_TEAM_GOODGUYS)then
      print("good guy")
      local targetEntities_2 = Entities:FindAllByName("heaven_teleport") 
      local target_point_2 = targetEntities_2[1]:GetAbsOrigin()
      target_point_2 = Vector(target_point_2.x+math.random(-500,500),target_point_2.y+math.random(-500,500),128)
      hPlayerHero:AddNewModifier(hPlayerHero,nil,"modifier_battle_hunger",{duration=60,x=target_point_2.x,y=target_point_2.y})
    end
    if(hPlayerHero:GetTeam()==DOTA_TEAM_BADGUYS)then
      local targetEntities_2 = Entities:FindAllByName("hell_teleport") 
      local target_point_2 = targetEntities_2[1]:GetAbsOrigin()
      target_point_2 = Vector(target_point_2.x+math.random(-500,500),target_point_2.y+math.random(-500,500),128)
      hPlayerHero:AddNewModifier(hPlayerHero,nil,"modifier_battle_hunger",{duration=60,x=target_point_2.x,y=target_point_2.y})
    end
  end

end
-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
  print("pick item "..itemname)
  Timers:CreateTimer(0.5,function()

    kemPrint("Items picked up")

    UpdatePlayerData(keys.PlayerID)
  end)
  
  
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
  
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local hero  = HERO_OF_PLAYER[keys.PlayerID]
  if not hero then return end
  initParonama()
  --CustomGameEventManager:Send_ServerToPlayer(player, "register_hero", {entity = hero,msg="onReconnect"})
  
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  --DebugPrint('[BAREBONES] AbilityUsed')
  --DebugPrintTable(keys)
  --PrintTable(keys)
  OnSkillUsed(keys)
  --hPlayerHero.skillCooldown
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
  local playerID = player:GetPlayerID()

  kemPrint("Learn ability")

  UpdatePlayerData(playerID)
  
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end



-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )

  --GameMode:_OnEntityKilled( keys )
  OnDie(keys)
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)

  GameMode:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
  

  
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)

  if keys==nil then

    kemPrint("429 keys = nil")
    return
  end
  if(self.vUserIds==nil) then
    kemPrint("432 vuser = nil")
    return
  end
  local userID = keys.userid
  --kemPrint("user id "..userID)
  if(userID<0)then
    kemPrint("console message user id < 0 ")

    return
  end
  local playerID = self.vUserIds[userID]:GetPlayerID()
  KemChat(keys,playerID)
  
end

function GameMode:LevelUpAbility(keys)
  DebugPrint('[KEM_BAREBONES] Level up ability')
  local PlayerID = keys.playerID
  local player = PlayerResource:GetPlayer(PlayerID)
  local ability = EntIndexToHScript(keys.ability)
  local hero = EntIndexToHScript(keys.unit)

  --local player_stats = CustomNetTables:GetTableValue("player_stats", tostring(player:GetPlayerID()))
  --local current_rune_points = player_stats.runePoints
  --local current_skill_points = player_stats.skillPoints
  --local hero = player:GetAssignedHero()
  local bAllow = true
  if not hero:GetPlayerOwnerID() == PlayerID then
    if hero:IsHero() then
      bAllow = false
    end
  end
  if hero.skill_point > 0 and ability:GetLevel() < ability:GetMaxLevel() and hero:IsAlive()  then
   hero.skill_point = hero.skill_point-1
   
   local newLevel = ability:GetLevel() + 1
   ability:SetLevel(newLevel)
   EmitSoundOnClient("ui.crafting_gem_applied", player)
   
   
   --UpdatePlayerData(PlayerID)
   print("#501 event sendCommand : update_stat and learned skill")
   CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(PlayerID), "update_stat", {playerID=PlayerID,hero=hero,msg="msg event 463"})
   CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(PlayerID), "learned_skill", {playerID=PlayerID,hero=hero,ability=keys.ability})
      
   --CustomGameEventManager:Send_ServerToPlayer(player, "update_skill", {player = PlayerID ,hero = hero,msg="event#478 learn ability"})
  else
   EmitSoundOnClient("General.Cancel", player)
  end
  --CustomGameEventManager:Send_ServerToPlayer(player, "AbilityUp", {playerId=PlayerID})
  --CustomGameEventManager:Send_ServerToPlayer(player, "ability_tree_upgrade", {playerId=PlayerID})
end
-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  --DebugPrintTable(keys)
  --PrintTable(keys)
  local player = EntIndexToHScript(keys.player)
  local level = keys.level
  local playerID = player:GetPlayerID()
  local hero = HERO_OF_PLAYER[playerID]
  local str = "Stat Point From "..hero.stat_point
  hero.stat_point =hero.stat_point +20
  str = str.." to "..hero.stat_point
  --print(str)
  hero.stat_gain = hero.stat_gain +20 
  hero.skill_point =hero.skill_point + 1
  hero.hero_level = hero:GetLevel()
  hero:SetAbilityPoints(0)
  
  hero.leveled_up = true
  

  --UpdatePlayerData(playerID) 
  
end

function GameMode:UpStatAuto(keys)
  local PlayerID = keys.playerID
  local player = PlayerResource:GetPlayer(PlayerID)
  

  local hero = HERO_OF_PLAYER[PlayerID]
  print("Update stat auto "..hero.stat_point)
  if(hero.stat_point>0)then
    local stat_gain = hero.stat_gain
    local stat_spend_on_sm=hero.stat_spend_on_sm
    local stat_spend_on_sk=hero.stat_spend_on_sk
    local stat_spend_on_nc=hero.stat_spend_on_nc
    local stat_spend_on_tp=hero.stat_spend_on_tp

    --kemPrint("Auto Spending "..hero.stat_point.." point of a hero has gained "..stat_gain.." stat :"..stat_spend_on_sm.."-sm, "..stat_spend_on_sk.."-sk, "..stat_spend_on_nc.."-nc, "..stat_spend_on_tp.." tp")
    --kemPrint("Auto data = "..hero.auto_sk.." sk | "..hero.auto_sm.." sm | "..hero.auto_nc.." nc | "..hero.auto_tp.." tp")
    
    if(hero.stat_point>0)then
      local stat_should_spend_on_sm = stat_gain*hero.auto_sm
      kemPrint("SM : "..stat_should_spend_on_sm.." | "..stat_spend_on_sm)

      if(stat_should_spend_on_sm>stat_spend_on_sm)then
        local stat_will_spend_on_sm=math.min(stat_should_spend_on_sm-stat_spend_on_sm,hero.stat_point)
        hero.stat_point = hero.stat_point-stat_will_spend_on_sm
        hero:ModifyAgility(stat_will_spend_on_sm)
        hero.stat_sm  = hero:GetAgility()
        hero.stat_spend_on_sm = hero.stat_spend_on_sm+stat_will_spend_on_sm
      end
    end
    
    if(hero.stat_point>0)then
      local stat_should_spend_on_sk = stat_gain*hero.auto_sk
      kemPrint("SK : "..stat_should_spend_on_sk.." | "..stat_spend_on_sk)
      if(stat_should_spend_on_sk>stat_spend_on_sk)then
        local stat_will_spend_on_sk=math.min(stat_should_spend_on_sk-stat_spend_on_sk,hero.stat_point)
        hero.stat_point = hero.stat_point-stat_will_spend_on_sk
        hero:ModifyStrength(stat_will_spend_on_sk)
        hero.stat_sk  = hero:GetStrength()
        hero.stat_spend_on_sk = hero.stat_spend_on_sk+stat_will_spend_on_sk
      end
    end
    
    if(hero.stat_point>0)then
      local stat_should_spend_on_nc = stat_gain*hero.auto_nc
      kemPrint("NC : "..stat_should_spend_on_nc.." | "..stat_spend_on_nc)
      if(stat_should_spend_on_nc>stat_spend_on_nc)then
        local stat_will_spend_on_nc=math.min(stat_should_spend_on_nc-stat_spend_on_nc,hero.stat_point)
        hero.stat_point = hero.stat_point-stat_will_spend_on_nc
        hero:ModifyIntellect(stat_will_spend_on_nc)
        hero.stat_nc = hero:GetIntellect()
        hero.stat_spend_on_nc = hero.stat_spend_on_nc+stat_will_spend_on_nc
      end
    end
    
    if(hero.stat_point>0)then
      local stat_should_spend_on_tp = stat_gain*hero.auto_tp
      kemPrint("TP : "..stat_should_spend_on_tp.." | "..stat_spend_on_tp)
      if(stat_should_spend_on_tp>stat_spend_on_tp)then
        local stat_will_spend_on_tp=math.min(stat_should_spend_on_tp-stat_spend_on_tp,hero.stat_point)
        hero.stat_point = hero.stat_point-stat_will_spend_on_tp
        --hero:ModifyAgility(stat_will_spend_on_tp)
        hero.stat_tp = hero.stat_tp+stat_will_spend_on_tp
        hero.stat_spend_on_tp = hero.stat_spend_on_tp+stat_spend_on_tp
      end
    end
    EmitSoundOnClient("ui.crafting_gem_applied", player)
    UpgradeStat(PlayerID)
  else
    EmitSoundOnClient("General.Cancel", player)
  end
  print("After Update stat auto "..hero.stat_point)
end
function GameMode:UpStat(keys)
  DebugPrint('[KEM_BAREBONES] Up stat')
  local PlayerID = keys.playerID
  local player = PlayerResource:GetPlayer(PlayerID)
  
  local hero = EntIndexToHScript(keys.heroIdx)
  local amount = keys.amount 
  local stat = keys.stat
  if not(amount==1 or amount==10 or amount==100) then

    kemPrint("Invalid amount when up stat")

    return
  end
  
  local bAllow = true
  if not hero:GetPlayerOwnerID() == PlayerID then
    if hero:IsHero() then
      bAllow = false
    end
  end

  kemPrint("Hero "..hero:GetUnitName().." is spending "..amount.." point on "..stat.." when having "..hero.stat_point.." point ")

  if hero.stat_point >= amount and amount>0 and hero:IsAlive()  then
   
   if(stat==STAT_TP) then
    --agility

    kemPrint("Upgrade than phap"..hero:GetUnitName().." for "..amount)

    hero.stat_point = hero.stat_point-amount
    hero.stat_spend_on_tp = hero.stat_spend_on_tp+amount
    hero.stat_tp = hero.stat_tp+amount
   end
   if(stat==STAT_SM) then

    kemPrint("Upgrade suc manh"..hero:GetUnitName().." for "..amount)

    hero.stat_point = hero.stat_point-amount
    hero:ModifyAgility(amount)
    hero.stat_sm  = hero:GetAgility()
    hero.stat_spend_on_sm = hero.stat_spend_on_sm+amount
   end
   
   if(stat==STAT_SK) then

    kemPrint("Upgrade sinh khi"..hero:GetUnitName().." for "..amount)

    hero.stat_point = hero.stat_point-amount
    hero:ModifyStrength(amount)
    hero.stat_sk  = hero:GetStrength()
    hero.stat_spend_on_sk = hero.stat_spend_on_sk+amount
   end
   
   if(stat==STAT_NC) then

    kemPrint("Upgrade noi cong "..hero:GetUnitName().." for "..amount)

    hero.stat_point = hero.stat_point-amount
    hero:ModifyIntellect(amount)
    hero.stat_nc  = hero:GetIntellect()
    hero.stat_spend_on_nc = hero.stat_spend_on_nc+amount
   end
   
   EmitSoundOnClient("ui.crafting_gem_applied", player)
   UpgradeStat(PlayerID)
   --CustomGameEventManager:Send_ServerToPlayer(player, "update_stat", {playerID=PlayerID,hero=hero})
  else
   EmitSoundOnClient("General.Cancel", player)
  end
  --CustomGameEventManager:Send_ServerToPlayer(player, "AbilityUp", {playerId=PlayerID})
  --CustomGameEventManager:Send_ServerToPlayer(player, "ability_tree_upgrade", {playerId=PlayerID})
end
function GameMode:ClearTarget(keys)
  local unitID = keys.unit
  local unit = EntIndexToHScript(unitID)
  if(unit)then
    print("Clear target for "..unit:GetUnitName())
    unit.lockTarget = nil
  end
end

function GameMode:DefenseOn(keys)
  local unitID = keys.unit
  local unit = EntIndexToHScript(unitID)
  if(unit)then
    if(unit:HasModifier("modifier_parry"))then
      local parry_modifier = unit:FindModifierByName("modifier_parry")
      if(parry_modifier)then
        if(parry_modifier:GetStackCount()>0)then
          unit:AddNewModifier(unit,nil,"modifier_defense",{})        
        end
      end
    end
    
  end
end


function GameMode:DefenseOff(keys)
  local unitID = keys.unit
  local unit = EntIndexToHScript(unitID)
  if(unit)then
    unit:RemoveModifierByName("modifier_defense")
  end
end
function GameMode:OpenPanel(keys)
  DebugPrint('[KEM_BAREBONES] Open Panel')
  local PlayerID = keys.playerID
  local player = PlayerResource:GetPlayer(PlayerID)
  
  local panel = keys.panel

  kemPrint("Lua Event receive : Open panel "..panel)
  print("#501 event sendCommand : open panel")
  CustomGameEventManager:Send_ServerToPlayer(player, "open_panel", {panel=panel})
end
