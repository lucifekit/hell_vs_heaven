--cd_main,cd_physical_damage_percent,cd_magic_damage_min,cd_magic_damage_max

--min_basic = (1+hotrokynang+luctancongkynang)(cd_main*skill_physical_damage_percent+cd_magic_damage_min)
--max_basic = (1+hotrokynang+luctancongkynang)(cd_main*skill_physical_damage_percent+cd_magic_damage_max)

--min_add = cd_luctancongcoban*cd_main*(1+physical_damage_addition_per)+satthuongdiem+nguhanhvukhi+nguhanhchieuthuc+1
--max_add = cd_luctancongcoban*cd_main*(1+physical_damage_addition_per)+satthuongdiem+nguhanhvukhi+nguhanhchieuthuc+10


SETTING_FX_DAMAGE = "particles/edited_particle/msg_damage.vpcf"
SETTING_FX_EVADE = "particles/msg_fx/msg_evade.vpcf"
SETTING_CRITICAL_BASE = 1000
if not DamageHandler then
  DamageHandler = class({})
end


ELEMENT_NONE = 0
ELEMENT_METAL = 1
ELEMENT_WOOD = 2
ELEMENT_FIRE = 3
ELEMENT_WATER = 4
ELEMENT_EARTH = 5

DAMAGE_TYPE_PHYSICAL = 0
DAMAGE_TYPE_MAGICAL = 1


BUFF_THAINHATCHANKHI = ""
BUFF_LANGBAVIBO = ""
BUFF_SOANH = "modifier_kiemdoan_soanh" 
SKILL_SOANH = "skill_kiemdoan_soanh"


BUFF_TOIDOCTHUAT = ""
function DamageHandler:MissileHandler(missile_data)
  --attacker,target,projectile,hit_function)
  local attacker = missile_data.attacker or nil
  local target = missile_data.target or nil
  local projectile = missile_data.projectile or nil
  local hit_function = missile_data.hit_function or function() 

    return
  end
  local missed = false
  
  if(projectile.maxTarget)then
    if(projectile.maxTarget>0)then
      projectile.maxTarget = projectile.maxTarget-1  
    else
      missed = true
    end
  end

  local chance_to_hit = 100

  if not missed then
    --Tinh neu la ngoai cong thi kiem tra ne tranh, chinh xac cac kieu 
    if (attacker.inited) then
      if(attacker.is_physical)then
        local accuracy = attacker.accuracy_point
        local accuracy_chance = attacker.accuracy_chance
        local targetEvade = 0
        if(target.inited)then
          targetEvade = target.evade_point
        else
          targetEvade = target:GetLevel()*20          
        end

        targetEvade = targetEvade-attacker.bypass_evade
    
        local chance_to_hit =( (accuracy*accuracy_chance) / (accuracy*accuracy_chance+targetEvade) ) *100
        local proc = math.random(0,100)
        --kemPrint("Accuracy = "..accuracy.." bypass ="..attacker.bypass_evade.." Evade = "..targetEvade.." Chance to hit= "..chance_to_hit.."%".." proc = "..proc)
        
        if(proc>chance_to_hit)then

          --truot
          missed = true
        end
      end
    end
  end    
  --
  --
  --    EVENT KHI DANH TRUNG
  --
  --
  if not missed then
    --   
    --        DOAN THI - SO ANH
    --
    if(attacker:HasModifier(BUFF_SOANH))then
      local buff_soanh = attacker:FindModifierByName(BUFF_SOANH)
      if(buff_soanh:GetStackCount()<15)then
        local random_value = math.random(0,100)
        local message = "Random value "..random_value
        if(random_value<5)then
          
          buff_soanh:IncrementStackCount()
          local skill_soanh = attacker:FindAbilityByName("skill_kiemdoan_soanh")
          skill_soanh:EndCooldown()
        
          message = message.." Proc "..skill_soanh:GetAbilityName()
         else
          message = message.." Missed"
        end

        --kemPrint(message)
      end
    end
    
    --kemPrint("hit function "..type(hit_function))
    if(hit_function)then
      --kemPrint("Calling hit function")
      pcall(hit_function,projectile,target)
    end
  else
      kemPrint("Missed "..chance_to_hit.."%")
          local numberIndex = ParticleManager:CreateParticle( SETTING_FX_EVADE, PATTACH_OVERHEAD_FOLLOW, target )
          ParticleManager:SetParticleControl( numberIndex, 1, Vector( 6, 0, 0 ) )
          ParticleManager:SetParticleControl( numberIndex, 2, Vector( 1, 1, 0 ) )
          ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,25,25 ) )
          ParticleManager:ReleaseParticleIndex(numberIndex)
  end
  local needDestroy = false
  if(projectile.maxTarget)then
    if(projectile.maxTarget==0)then
      needDestroy = true
    end  
  end
  if needDestroy then
    projectile:Destroy()
  end  
end
 
function DamageHandler:NoDamage()
  return {min_physic=0,min_element=0,max_physic=0,max_element=0}
end
function DamageHandler:ApplyDamage(whoDealDamage,byWhichAbility,whoTakeDamage,ADDamage,critInfo,damage_element,custom)

    if(ADDamage.min_physic==0 and ADDamage.min_element==0) then
      return
    end
    local damageTable = {
      attacker = whoDealDamage,
      ability = byWhichAbility,
      damage_type = DAMAGE_TYPE_PURE,
      victim = whoTakeDamage
    }
   
    local damage_physic = math.random(ADDamage.min_physic,ADDamage.max_physic)
    local damage_magic = math.random(ADDamage.min_element,ADDamage.max_element)
   
    if whoTakeDamage:IsHero() then
      
      damage_physic = damage_physic*0.2
      damage_magic = damage_magic*0.2

    end
    if(type(custom)=="table")then
      if(custom["action"]=="multiple_damage")then
        local multiple_value = custom["value"]
        damage_physic =damage_physic * multiple_value
        damage_magic =damage_magic * multiple_value
      end
      if(custom["action"]=="lifesteal")then
        local lifesteal_value = custom["value"]
        local heal_value = damage_physic*lifesteal_value+damage_magic*lifesteal_value

        whoDealDamage:Heal(heal_value,nil)
      end
    end
  if(whoDealDamage.is_physical)then
    --neu la ngoai cong
    --neu co vu khi doc sat
    if(damage_magic~=ELEMENT_WOOD)then
      if(whoDealDamage.weapon_poison_damage>0)then

        PoisonHandler:ApplyPoison(whoDealDamage,whoTakeDamage,byWhichAbility,0.5,5,whoDealDamage.weapon_poison_damage,{})
      end
    end
  end
-- Danh trung
-- Neu bi bong thi nhan dame voi 1.8
 --HIEU UNG
    if(whoTakeDamage:HasModifier(EFFECT_BURN))then

     damage_physic = damage_physic * 1.8
     damage_magic = damage_magic * 1.8
  end
-- Neu bi yeu thi nhan dame voi 0.6
-- Tinh critical
    local critChance = critInfo.chance
    local critRate   = critChance*100/(critChance+SETTING_CRITICAL_BASE)
    
    local critDamage = critInfo.damage
    local isCritical = false
    local critProc = math.random(0,100)
    
    if(critProc<critRate)then
      isCritical = true

      damage_physic = damage_physic * critDamage
      damage_magic = damage_magic * critDamage
    end
   
-- Tinh ngu hanh
  
  local physical_def = 0
  if(whoTakeDamage.inited)then
    if(whoTakeDamage.resist_metal<1280)then
      physical_def = whoTakeDamage.resist_metal/1536
    else
      physical_def = whoTakeDamage.resist_metal/(whoTakeDamage.resist_metal+256)
    end
  end

  damage_physic = damage_physic*(1-physical_def)
  
  local element_def = 0
  local resist_value = 0
  if(whoTakeDamage.resist_metal)then

    --kemPrint("checking element = ")
    if(damage_element==ELEMENT_WOOD)then
      --kemPrint("wood")
      resist_value=whoTakeDamage.resist_wood
    end
    if(damage_element==ELEMENT_FIRE)then
      --kemPrint("fire")
      resist_value=whoTakeDamage.resist_fire
    end
    
    if(damage_element==ELEMENT_WATER)then

      resist_value=whoTakeDamage.resist_water
    end
    
    if(damage_element==ELEMENT_EARTH)then

      resist_value=whoTakeDamage.resist_earth
    end
  end
  
  if(resist_value<1280)then
      element_def = resist_value/1536
  else
      element_def = resist_value/(resist_value+256)
  end

  --kemPrint("Element def : "..resist_value.." --> "..element_def.."%")
  damage_magic = damage_magic*(1-element_def)
  --kemPrint(whoDealDamage.mp_drain.." Drain")
  if(damage_physic>0)then
    damageTable.damage = damage_physic 
    --kemPrint(damageTable)
    --kemPrint(DAMAGE_TYPE_PHYSICAL.."|"..DAMAGE_TYPE_MAGICAL.."|"..DAMAGE_TYPE_PURE.."|"..DAMAGE_TYPE_ALL.."|")
    --kemPrint("Dealing "..damage_physic.." physic damage to "..whoTakeDamage:GetUnitName().." which has "..whoTakeDamage:GetHealth().." hp")

    ApplyDamage(damageTable)
    if(whoDealDamage.inited)then
      if(whoDealDamage.hp_drain>0)then
        local hp_physic_drain = damage_physic*whoDealDamage.hp_drain
        whoDealDamage:Heal(hp_physic_drain,nil)
      end
      if(whoDealDamage.mp_drain>0)then
          local mp_physic_drain = damage_physic*whoDealDamage.mp_drain
          whoDealDamage:GiveMana(mp_physic_drain)
      end
    end
    
  end
  if(damage_magic>0)then
    damageTable.damage = damage_magic

    ApplyDamage(damageTable)
    if(whoDealDamage.inited)then
      if(whoDealDamage.hp_drain>0)then
          local hp_magic_drain = damage_magic*whoDealDamage.hp_drain
          whoDealDamage:Heal(hp_magic_drain,nil)
      end
      if(whoDealDamage.mp_drain>0)then
          local mp_magic_drain = damage_magic*whoDealDamage.mp_drain
          whoDealDamage:GiveMana(mp_magic_drain)
      end
    end
  end
  

  local idx = whoTakeDamage:GetEntityIndex()
    
    local totalDamage = damage_physic+damage_magic
    --kemPrint("Total damage "..totalDamage)
    local numberIndex = ParticleManager:CreateParticle( SETTING_FX_DAMAGE, PATTACH_OVERHEAD_FOLLOW, whoTakeDamage )
    ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, totalDamage, 0 ) ) -- so luong damage
    ParticleManager:SetParticleControl( numberIndex, 2, Vector( 1, string.len( math.floor(totalDamage ) ) + 1, 0 ) ) -- do dai
    if(isCritical)then
      ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,50,50 ) )
    else
      ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,255,90 ) )
    end
    
    ParticleManager:ReleaseParticleIndex(numberIndex)
       

end



function DamageHandler:GetCritInfo(caster)
  local chance = 0
  local damage = 1.8
  if(caster.critical_chance)then
    chance = caster.critical_chance
  end
  if(caster.critical_damage)then
    damage = caster.critical_damage
  end
  if(caster:HasModifier(BUFF_TOIDOCTHUAT))then      
        damage = damage + 1.2
  end

  return {chance = chance,damage = damage}
end



--Input : object { caster,skill_physical_damage_percent,skill_basic_attack_damage_percent,element_damage_min,element_damage_max}
function DamageHandler:GetDamage(data)
  
  if not data.caster then

    return nil
  end
  
  --vat cong chieu thuc
  if not data.skill_physical_damage_percent then

    return nil
  end
  --ho tro ky nang
  if not data.skill_tree_amplify_damage then

    kemPrint("DamageHandler Error : Missing skill_tree_amplify_damage")

    return nil
  end
  --luc tan cong co ban
  if not data.skill_basic_damage_percent then

    kemPrint("DamageHandler Error : Missing basic_attack_damage_percent")

    return nil
  end
  
  if not data.element_damage_min then

    kemPrint("DamageHandler Error : Missing element_damage_min")

    return nil
  end
  
  if not data.element_damage_max then

    kemPrint("DamageHandler Error : Missing element_damage_max")

    return nil
  end
  
  local caster = data.caster
  local main_attribute_value = data.main_attribute_value
  local isNPC = false
  local unitName = data.caster:GetUnitName()
  if(string.sub(unitName,0,8)=="npc_boss")then
    isNPC = true
  end
  
  
  --local caster_playerID = caster:GetPlayerID()
  --local vat cong ngoai cua ky nang
  local skill_physical_damage_per = data.skill_physical_damage_percent
  -- ho tro cua cac ky nang cap thap
  local skill_tree_amplify_damage = data.skill_tree_amplify_damage
  
  local element_damage_min = data.element_damage_min
  local element_damage_max = data.element_damage_max
  
  local basic_damage = data.skill_basic_damage_percent
  -- luc tan cong co ban
  local hero_basic_attack_damage_percent = caster.basic_damage_percent or 1
  basic_damage = basic_damage+hero_basic_attack_damage_percent
  
  local physic_amplify = caster.physic_amplify  or 0  -- vat cong ngoai them vao tu vu khi-buff-chieuthuc
  local element_amplify =  caster.element_amplify or 0-- vat cong noi them vao tu vu khi-buff-buff-chieuthuc

  local skill_amplify = caster.skill_amplify or 0

  
  local physical_damage = caster.weapon_physical_damage or 0--+vat cong ngoai- diem tu khi vu khi  
  local weapon_element_damage = caster.weapon_element_damage or 0 --vat cong noi-diem tu vu khi
  local skill_element_damage = caster.skill_element_damage or 0 --vat cong noi tu chieu thuc
  --hero.skill_element_damage
  ----------------------------------
  --
  --
  --
  ----------------------------------

  
  local skill_tree_add =  (1+skill_tree_amplify_damage)
  
  
  --local min_basic_physic = main_attribute_value*(skill_physical_damage_per+attribute_amplify_physic) * skill_tree_add 
  --local max_basic_physic = main_attribute_value*(skill_physical_damage_per+attribute_amplify_physic) *skill_tree_add
  
  
   
  --phat huy luc tan cong co ban
  if(skill_physical_damage_per==0) then
    element_amplify = element_amplify -- skill noi cong
    physic_amplify = 0 --skill noi cong se khong cong dame vat ly vao -- check lai voi skill doan thi kiem
  else
    physic_amplify = physic_amplify -- skill ngoai cong
  end
  
  
  --

  local physic_min  =   (basic_damage+skill_tree_amplify_damage+skill_amplify)  * ((main_attribute_value)*(physic_amplify+skill_physical_damage_per)+physical_damage)
  local physic_max  =   (basic_damage+skill_tree_amplify_damage+skill_amplify)  * ((main_attribute_value)*(physic_amplify+skill_physical_damage_per)+physical_damage)
  

  
  local add_element =   (basic_damage+skill_tree_amplify_damage+skill_amplify)  * (main_attribute_value*element_amplify  +    weapon_element_damage  +  skill_element_damage  )
  --PrintTable(caster)
  --kemPrint("Physic : "..skill_physical_damage_per.."+"..attribute_amplify_physic.." = "..physic_min)
  --kemPrint("Min = "..min_basic.."+"..min_add.." Max = "..max_basic.."+"..max_add)

  return {min_physic=physic_min,max_physic=physic_max,
          min_element = element_damage_min+add_element,max_element=element_damage_max+add_element+10}  
  
end
--

--            DAMAGE AREA


--
function DamageHandler:DamageArea(data)

  local whoDealDamage = data.whoDealDamage
  local byWhichAbility = data.byWhichAbility
  local where = data.where
  local radius = data.radius
  local damage = data.damage
  local damage_element = data.damage_element
  local custom = data.custom
  
  DamageHandler:DamageAreaParams(whoDealDamage,byWhichAbility,where,radius,damage,damage_element,custom)
end
function DamageHandler:DamageAreaParams(whoDealDamage,byWhichAbility,where,radius,damage,damage_element,custom)

                     --damage
                     --local group = FindUnitsInRadius(owner:GetTeam(), point, nil, radius, int teamFilter, int typeFilter, int flagFilter, int order, bool canGrowCache)
                     --ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false
     local unitsToDamage = FindUnitsInRadius(whoDealDamage:GetTeam(), where, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
     
     local critInfo = DamageHandler:GetCritInfo(whoDealDamage)
     
                          
     for _,victim in ipairs(unitsToDamage) do
        DamageHandler:ApplyDamage(whoDealDamage,byWhichAbility,victim,damage,critInfo,damage_element,"")
     end

end
--

--            DAMAGE GROUP BY TIMES


--
--Input : object { whoDealDamage,byWhichAbility,where,radius,period,duration,damage_min,damage_max,crit_rate,crit_damage,damage_element,custom}
function DamageHandler:DamageGroup(data)

  local whoDealDamage = data.whoDealDamage
  local byWhichAbility = data.byWhichAbility
  local where = data.where
  local radius = data.radius
  local period = data.period
  local duration = data.duration
  local damage = data.damage
  local damage_element = data.damage_element
  local custom = data.custom
  local maxTarget = data.maxTarget or 3
  DamageHandler:DamageGroupParams(whoDealDamage,byWhichAbility,where,radius,period,duration,damage,damage_element,maxTarget,custom)
end
function DamageHandler:DamageGroupParams(whoDealDamage,byWhichAbility,where,radius,period,duration,damage,damage_element,maxTarget,custom)

  local startTime = GameRules:GetGameTime()
  local tick = 0
  local tempDamage = damage
  local critInfo = DamageHandler:GetCritInfo(whoDealDamage)
  Timers:CreateTimer(function()
                     --damage
                     --local group = FindUnitsInRadius(owner:GetTeam(), point, nil, radius, int teamFilter, int typeFilter, int flagFilter, int order, bool canGrowCache)
                     --ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false

                     if(whoDealDamage:IsNull())then
                      return --nothing
                     else
                        local unitsToDamage = FindUnitsInRadius(whoDealDamage:GetTeam(), where, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
                       tick = tick +1      
                       local tempNumberOfTarget = maxTarget               
                       for _,victim in ipairs(unitsToDamage) do
                       
                          if(tempNumberOfTarget>0)then
                            DamageHandler:ApplyDamage(whoDealDamage,byWhichAbility,victim,tempDamage,critInfo,damage_element,"")
                            if(type(custom)=="table")then
                              if(custom["action"]=="status_effect")then
                                local effect_type = custom["effect_type"]
                                local effect_chance = custom["effect_chance"]
                                local effect_time = custom["effect_time"]
                                StatusEffectHandler:ApplyEffect(whoDealDamage,victim,effect_type,effect_chance,effect_time)
                              end
                            end
                            tempNumberOfTarget = tempNumberOfTarget-1
                          end
                          
                       end
                       local now = GameRules:GetGameTime()
                       
                       --quit
                       if((now-startTime)>duration) then
                        return --nothing
                       end
                       return period
                     end
                     

                  end)

end