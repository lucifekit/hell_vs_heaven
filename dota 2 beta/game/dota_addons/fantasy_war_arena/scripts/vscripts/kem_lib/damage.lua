--cd_main,cd_physical_damage_percent,cd_magic_damage_min,cd_magic_damage_max

--min_basic = (1+hotrokynang+luctancongkynang)(cd_main*skill_physical_damage_percent+cd_magic_damage_min)
--max_basic = (1+hotrokynang+luctancongkynang)(cd_main*skill_physical_damage_percent+cd_magic_damage_max)

--min_add = cd_luctancongcoban*cd_main*(1+physical_damage_addition_per)+satthuongdiem+nguhanhvukhi+nguhanhchieuthuc+1
--max_add = cd_luctancongcoban*cd_main*(1+physical_damage_addition_per)+satthuongdiem+nguhanhvukhi+nguhanhchieuthuc+10

require('kem_lib/kem')
SETTING_FX_DAMAGE = "particles/edited_particle/msg_damage.vpcf"
SETTING_FX_EVADE = "particles/fx_evade.vpcf"
SETTING_CRITICAL_BASE = 1000
if not DamageHandler then
  DamageHandler = class({})
end

DAMAGE_DELAY = 0.03

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
BUFF_BITOTHANHPHONG = "modifier_chiennhan_bitothanhphong"
SKILL_SOANH = "skill_kiemdoan_soanh"


--BUFF_TOIDOCTHUAT = ""
BUFF_THOITHUALUCLONG = "modifier_chuongcai_thoithualuclong"
BUFF_TUYDIEPCUONGVU = "modifier_chuongcai_tuydiepcuongvu"
BUFF_DOANCANNHAN = "modifier_tutien_doancannhan"
BUFF_DOANCANNHAN_COOLDOWN = "modifier_tutien_doancannhan_cooldown"
BUFF_DOANCANNHAN_ACTIVE = "modifier_tutien_doancannhan_active"
BUFF_TRUYHONDOATMENH = "modifier_aow_mehontieu_truyhondoatmenh"
BUFF_THIENLYTRUYHON = "modifier_aow_mehontieu_thienlytruyhon"
BUFF_LUCHOPKINH = "modifier_aow_mehontieu_luchopkinh"
BUFF_QUYANHHUBO = "modifier_aow_mehontieu_quyanhhubo"
BUFF_DEFENSE = "modifier_defense"
FX_DOANCANNHAN = "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf"

LinkLuaModifier(BUFF_DOANCANNHAN_ACTIVE,"heroes_abilities/tutien/"..BUFF_DOANCANNHAN_ACTIVE, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(BUFF_DOANCANNHAN_COOLDOWN,"heroes_abilities/tutien/"..BUFF_DOANCANNHAN_COOLDOWN, LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier(BUFF_THOITHUALUCLONG,"heroes_abilities/chuongcai/"..BUFF_THOITHUALUCLONG, LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier(BUFF_DOANCANNHAN_ACTIVE,"heroes_abilities/tutien/"..BUFF_DOANCANNHAN_ACTIVE, LUA_MODIFIER_MOTION_NONE )
function DamageHandler:OnCrititcal(whoDealDamage,whoTakeDamage)
  if(whoTakeDamage:HasModifier(BUFF_DOANCANNHAN))then
    if(not whoTakeDamage:HasModifier(BUFF_DOANCANNHAN_COOLDOWN))then
      whoTakeDamage:AddNewModifier(whoTakeDamage,whoTakeDamage:FindAbilityByName("skill_tutien_doancannhan"),BUFF_DOANCANNHAN_ACTIVE,{duration=5})
      whoTakeDamage:AddNewModifier(whoTakeDamage,whoTakeDamage:FindAbilityByName("skill_tutien_doancannhan"),BUFF_DOANCANNHAN_COOLDOWN,{duration=20})
    end
  end
  if(whoDealDamage:HasModifier(BUFF_DOANCANNHAN_ACTIVE))then
     FxPoint(FX_DOANCANNHAN,whoTakeDamage:GetOrigin(),1)
     StatusEffectHandler:ApplyEffect(whoDealDamage,whoTakeDamage,EFFECT_IMMOBILE,100,3)
  end
   if(whoDealDamage:HasModifier(BUFF_THIENLYTRUYHON))then
      local modifier = whoDealDamage:FindModifierByName(BUFF_THIENLYTRUYHON)
      modifier:OnCriticalHit(whoTakeDamage)
  end
end



function DamageHandler:OnHit(attacker,target,ability)
  for _,modifier in ipairs(attacker:FindAllModifiers()) do
    --print("on hit "..modifier:GetName())
    if(modifier.ActiveOnHit)then
      
      modifier:ActiveOnHit(target)
    end 
  end
  if(target:HasModifier(BUFF_DEFENSE))then
      for _,modifier in ipairs(target:FindAllModifiers()) do
        if(modifier.OnDefense)then
          modifier:OnDefense()
        end 
      end
  end
  
  if(target:HasModifier(BUFF_LUCHOPKINH))then
    local buff = target:FindModifierByName(BUFF_LUCHOPKINH)
    buff:ActiveOnTakeHit(attacker)
  end
  if(ability)then
    if(ability.ActiveOnHit)then
      ability:ActiveOnHit(target)
    end
  end
  
end
function DamageHandler:CalculateMiss(attacker,target)
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
        
        if(target:HasModifier("modifier_fall"))then
          return false
        end
        
        if(proc>chance_to_hit)then
          --print(proc.." > "..chance_to_hit.." accuracy = "..accuracy.."/"..accuracy.."+"..targetEvade)
          --truot
          return true
        end
        
        if(target.physic_evade)then
          if(target.physic_evade>0)then
            local proc_physic = math.random(0,100)
            if(proc_physic<=target.physic_evade)then
              print("Physical evade ")
              return true
            end
          end
        end
        
      else
        --noi cong
        if(target.element_evade)then
          if(target.element_evade>0)then
            local proc_element = math.random(0,100)
            if(proc_element<=target.element_evade)then
              print("Element evade ")
              return true
            end
          end
        end
        
      end
  end
  return false
end
function DamageHandler:MissileHandler(missile_data)
  --attacker,target,projectile,hit_function)
  local attacker = missile_data.attacker or nil
  local target = missile_data.target or nil
  local projectile = missile_data.projectile or nil
  local hit_function = missile_data.hit_function or function() 

    return
  end
  local miss_function = missile_data.miss_function or function()
    return
  end
  local no_miss = projectile.no_miss or false
  local missed = false
  
  if(projectile.maxTarget)then
    if(projectile.maxTarget>0)then
      projectile.maxTarget = projectile.maxTarget-1  
    else
      missed = true
    end
  end

  --local chance_to_hit = 100

  if not missed then
    --Tinh neu la ngoai cong thi kiem tra ne tranh, chinh xac cac kieu 
    if(no_miss)then
    else
      if(DamageHandler:CalculateMiss(attacker,target))then
        missed = true
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
    self:OnHit(attacker,target,projectile.Ability)
    
    --kemPrint("hit function "..type(hit_function))
    if(hit_function)then
      --kemPrint("Calling hit function")
      pcall(hit_function,projectile,target)
    end
  else
    if(miss_function)then
      --kemPrint("Calling hit function")
      pcall(miss_function,projectile,target)
    end
          --kemPrint("No miss function, Missed")
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
function DamageHandler:InitDamage(mip,map,mie,mae)
  return {min_physic=mip,min_element=mie,max_physic=map,max_element=mae}
end
function DamageHandler:ApplyDamage(whoDealDamage,byWhichAbility,whoTakeDamage,ADDamage,critInfo,damage_element,custom)
    if(type(ADDamage)=="number")then
      --ADDamage.min_physic==0 
      local tempTable = {}
      tempTable.min_element=ADDamage
      tempTable.max_element=ADDamage
      tempTable.min_physic=0
      tempTable.max_physic=0
      ADDamage=tempTable
    end
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
    --print("DAMAGE : "..damage_physic.."-"..damage_magic)
    if whoTakeDamage:IsHero() then
      
      damage_physic = damage_physic*0.2
      damage_magic = damage_magic*0.2

    end
    
  if(whoDealDamage.is_physical)then
    --neu la ngoai cong
    --neu co vu khi doc sat
    if(damage_element~=ELEMENT_WOOD)then
      if(whoDealDamage.weapon_poison_damage>0)then
        print("vu khi doc sat "..damage_magic.." vs wood = "..ELEMENT_WOOD.." va la physical")
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
    if(whoTakeDamage.critical_damage_resist)then
      critDamage = critDamage-whoTakeDamage.critical_damage_resist
    end
    local isCritical = false
    local critProc = math.random(0,100)
    --print("Chance = "..critChance.." rate= "..critRate)
    if(critProc<critRate)then
      isCritical = true

      damage_physic = damage_physic * critDamage
      damage_magic = damage_magic * critDamage
      DamageHandler:OnCrititcal(whoDealDamage,whoTakeDamage)
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
  --print(damage_physic,physical_def)
  damage_physic = damage_physic*(1-physical_def)
  --print("After : "..damage_physic)
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
      if(custom["action"]=="drain")then
        local drain_value = custom["value"]
        local heal_value = damage_physic*drain_value+damage_magic*drain_value

        whoDealDamage:Heal(heal_value,nil)
        whoDealDamage:SetMana(whoDealDamage:GetMana()+heal_value)
      end
      if(custom["flag"])then
        if(custom["flag"]=="reflect")then
          damageTable.damage_flag = DOTA_DAMAGE_FLAG_REFLECTION
        end
        if(custom["flag"]=="no_director")then
          print("Set flag = no director ")
          damageTable.damage_flag = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT
        end
      end
    end
  
  local magic_amplify = 0
  if(whoDealDamage.inited)then
  
    magic_amplify=whoDealDamage:GetIntellect()/1600
  end
  
  --print("Magic amplify : "..magic_amplify)
  
  if(damage_physic>0)then
    --damageTable.damage = damage_magic
    damageTable.damage = damage_physic*(1/(1+magic_amplify)) 
    --print("Physic damage : "..damageTable.damage.."Ori = "..damage_physic)
    --kemPrint(damageTable)
    --kemPrint(DAMAGE_TYPE_PHYSICAL.."|"..DAMAGE_TYPE_MAGICAL.."|"..DAMAGE_TYPE_PURE.."|"..DAMAGE_TYPE_ALL.."|")
    --kemPrint("Dealing "..damage_physic.." physic damage to "..whoTakeDamage:GetUnitName().." which has "..whoTakeDamage:GetHealth().." hp")
    local current_health = whoTakeDamage:GetHealth()
    --print("apply physic damage ")
    ApplyDamage(damageTable)
    local after_health = whoTakeDamage:GetHealth()
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
    damage_physic = math.max(0,current_health-after_health)
  end
  if(damage_magic>0)then
    
    local current_health = whoTakeDamage:GetHealth()
    --if(whoTakeDamage:HasModifier("modifier_kiemcon_nguynguyconlon_stack"))then
--      print(whoDealDamage:GetUnitName()..
--            " id="..whoDealDamage:entindex()..
--            " deal "..damage_magic.." damage to hero "..
--            whoTakeDamage:GetUnitName().."-hp="..whoTakeDamage:GetHealth().." id "..whoTakeDamage:entindex()..
--            " damage type "..DAMAGE_TYPE_PURE)
    --end
    
    --PrintTable(damageTable)
   
    damageTable.damage = damage_magic*(1/(1+magic_amplify))
    --print("Magic damage : "..damageTable.damage.."Ori = "..damage_magic)
    --print("apply magic damage ")
    ApplyDamage(damageTable)
    local after_health = whoTakeDamage:GetHealth()
    --if(whoTakeDamage:HasModifier("modifier_kiemcon_nguynguyconlon_stack"))then
    --print("after that  "..whoTakeDamage:GetHealth().."-->real take "..(current_health-after_health))
    --end
    
    
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
    damage_magic = math.max(0,current_health-after_health)
  end
  

  local idx = whoTakeDamage:GetEntityIndex()
    
    local totalDamage = damage_physic+damage_magic
    if(totalDamage>0)then
      
      if(not whoTakeDamage.next_damage)then
        whoTakeDamage.next_damage = 0
      end
      
      
      local now = GameRules:GetGameTime()
      local delay=0
      if(now<whoTakeDamage.next_damage)then
        delay=whoTakeDamage.next_damage-now
        whoTakeDamage.next_damage = whoTakeDamage.next_damage+DAMAGE_DELAY      
      else
        delay = 0
        whoTakeDamage.next_damage = now+DAMAGE_DELAY
      end 
      --print("create fx ")
      local numberIndex = ParticleManager:CreateParticle( SETTING_FX_DAMAGE, PATTACH_OVERHEAD_FOLLOW, whoTakeDamage )
      ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, totalDamage, 0 ) ) -- so luong damage
      
      if(isCritical)then
        ParticleManager:SetParticleControl( numberIndex, 2, Vector( 2, string.len( math.floor(totalDamage ) ) + 1, 0 ) ) -- do dai
        ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,50,50 ) ) --color
      else
        ParticleManager:SetParticleControl( numberIndex, 2, Vector( 1, string.len( math.floor(totalDamage ) ) + 1, 0 ) ) -- do dai
        ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,255,90 ) ) --color
      end
      --print("checking delay fx")
      if(delay>0)then
        local offset = math.floor(delay*1000)
        --print("Offset = "..offset)
        ParticleManager:SetParticleControl( numberIndex, 4, Vector( 0,0,offset) )
      end
      --print("release fx")
      ParticleManager:ReleaseParticleIndex(numberIndex)
      
      
      
    end
    
    --kemPrint("Total damage "..totalDamage)
       
--print("deal xong")
end

function DamageHandler:InitCrit(chance,damage)
  return {chance=chance,damage=damage}
end

function DamageHandler:GetCritInfo(caster)
  local chance = 0
  local damage = 1.8
  if(string.sub(caster:GetUnitName(),0,8)=="npc_boss")then
    return {chance=20,damage=2}
  end
  if(caster.critical_chance)then
    chance = caster.critical_chance
  end
  if(caster.critical_damage)then
    damage = caster.critical_damage
  end
--  if(caster:HasModifier(BUFF_TOIDOCTHUAT))then      
--        damage = damage + 1.2
--  end

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
  local att_physic_value = data.main_physic or 50
  local att_magic_value = data.main_magic or 50
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
  local buff_current = caster:FindAllModifiers()
            
  for _,modifier in ipairs(buff_current) do
    if(modifier.GetBasicDamage)then
      local add_basic = modifier:GetBasicDamage()
      --print("Add basic : "..add_basic)
      basic_damage =basic_damage +  add_basic
    end
  end
  
  
  -- luc tan cong co ban
  local hero_basic_attack_damage_percent = caster.basic_damage_percent or 1
  basic_damage = basic_damage+hero_basic_attack_damage_percent
  
  local physic_amplify = caster.physic_amplify  or 1  -- vat cong ngoai them vao tu vu khi-buff-chieuthuc
  local element_amplify =  caster.element_amplify or 1-- vat cong noi them vao tu vu khi-buff-buff-chieuthuc

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
  
  ---print(physic_amplify.."-"..element_amplify)
   
  --phat huy luc tan cong co ban
  local is_physic = data.is_physic or false
  if(skill_physical_damage_per==0 and not is_physic) then
--    --element_amplify = element_amplify -- skill noi cong
    physic_amplify = 0 --skill noi cong se khong cong dame vat ly vao -- check lai voi skill doan thi kiem

--    --physic_amplify = physic_amplify -- skill ngoai cong
  end
  
  --print("after : " ..physic_amplify.."-"..element_amplify)
  --

  local physic_min  =   (basic_damage+skill_tree_amplify_damage+skill_amplify)  * ((att_physic_value)*(physic_amplify+skill_physical_damage_per)+physical_damage)
  local physic_max  =   (basic_damage+skill_tree_amplify_damage+skill_amplify)  * ((att_physic_value)*(physic_amplify+skill_physical_damage_per)+physical_damage)
  

  
  --local add_element =   (basic_damage+skill_tree_amplify_damage+skill_amplify)  * (att_magic_value*element_amplify  +    weapon_element_damage  +  skill_element_damage  )
  
  
  local add_element =   (basic_damage)  * (att_magic_value*element_amplify)--phat huy luc tan cong co ban
  add_element = add_element + weapon_element_damage -- sat thuong tu vu khi 
  add_element = add_element + skill_element_damage*basic_damage--sat thuong chieu thuc noi tai
  
  local min_element = add_element + element_damage_min*(1+skill_amplify)
  min_element = (1+skill_tree_amplify_damage)*min_element
  
  local max_element = add_element + element_damage_max*(1+skill_amplify)
  max_element = (1+skill_tree_amplify_damage)*max_element
  
  --print("Physic calculate = ".."("..basic_damage.."+"..skill_tree_amplify_damage.."+"..skill_amplify..")  * (("..att_physic_value..")*("..physic_amplify.."+"..skill_physical_damage_per..")+"..physical_damage..")  = "..physic_min)
  --kemPrint("Magic calculate = ".."("..basic_damage.."*"..att_magic_value.."*"..element_amplify..")".." + weapon["..weapon_element_damage.."] "..
  --"+ skill [ ("..basic_damage..")  * "..skill_element_damage..")] + min["..element_damage_min.."* (1+"..skill_amplify..") ]====* ["..(1+skill_tree_amplify_damage).."] = "..min_element)
  
  --PrintTable(caster)
  --kemPrint("Physic : "..skill_physical_damage_per.."+"..attribute_amplify_physic.." = "..physic_min)
  --kemPrint("Min = "..min_basic.."+"..min_add.." Max = "..max_basic.."+"..max_add)

  return {min_physic=physic_min,max_physic=physic_max,
          min_element = min_element,max_element=max_element}  
  
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
  local crit = data.crit
  local damage_element = data.damage_element
  local custom = data.custom
  local maxTarget = data.maxTarget or 3
  local damageUnitTable = data.damageUnitTable or {}
  
  if(crit==nil)then
    print(byWhichAbility:GetAbilityName().." nil crit info")
  end
  DamageHandler:DamageAreaParams(whoDealDamage,byWhichAbility,where,radius,damage,crit,damage_element,maxTarget,damageUnitTable,custom)
end
LinkLuaModifier("modifier_aow_truyhontrao_bleed","heroes_abilities/aow_truyhontrao/modifier_aow_truyhontrao_bleed",LUA_MODIFIER_MOTION_NONE)
function DamageHandler:DamageAreaParams(whoDealDamage,byWhichAbility,where,radius,damage,crit,damage_element,maxTarget,damageUnitTable,custom)
    --custom[action]=status_effect thi can effect_type,effect_chance,effect_time
    --custom[modifier] la modifier name, can modifier_duration va modifier_increase_stack_count
    --custom[call]-->call
                     --damage
                     --local group = FindUnitsInRadius(owner:GetTeam(), point, nil, radius, int teamFilter, int typeFilter, int flagFilter, int order, bool canGrowCache)
                     --ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false
     --print("Calling damage area at "..where.x.."x"..where.y)
     local unitsToDamage = FindUnitsInRadius(whoDealDamage:GetTeam(), where, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
     
     --local critInfo = DamageHandler:GetCritInfo(whoDealDamage)
     
                          
     for _,victim in ipairs(unitsToDamage) do
        if(maxTarget>0)then
          maxTarget = maxTarget-1
          --print("Found victim "..victim:GetUnitName())
          if(DamageHandler:CalculateMiss(whoDealDamage,victim))then
            --miss
            kemPrint("Area miss")
            local numberIndex = ParticleManager:CreateParticle( SETTING_FX_EVADE, PATTACH_OVERHEAD_FOLLOW, victim )
            ParticleManager:SetParticleControl( numberIndex, 1, Vector( 6, 0, 0 ) )
            ParticleManager:SetParticleControl( numberIndex, 2, Vector( 1, 1, 0 ) )
            ParticleManager:SetParticleControl( numberIndex, 3, Vector( 255,25,25 ) )
            ParticleManager:ReleaseParticleIndex(numberIndex)
          else
            --print("Damage---------")
            kemPrint("Area trung")
            if(damageUnitTable[victim]==nil)then
              kemPrint("Area code")
              damageUnitTable[victim]=1
              --print("Deal damage to "..victim:GetUnitName())
              print("Area apply damage")
              DamageHandler:ApplyDamage(whoDealDamage,byWhichAbility,victim,damage,crit,damage_element,"")
              DamageHandler:OnHit(whoDealDamage,victim,byWhichAbility)
              
              if(type(custom)=="table")then
                print("check status effect")
                if(custom["action"]=="status_effect")then
                  local effect_type = custom["effect_type"]
                  local effect_chance = custom["effect_chance"]
                  local effect_time = custom["effect_time"]
                  StatusEffectHandler:ApplyEffect(whoDealDamage,victim,effect_type,effect_chance,effect_time)
                end
                print("check modifier")
                if(custom["modifier"])then
                  --add modifier
                  --LinkLuaModifier("modifier_aow_mehontieu_dutithoihon_active","heroes_abilities/aow_mehontieu/modifier_aow_mehontieu_dutithoihon_active",LUA_MODIFIER_MOTION_NONE)
                  print("add modifier "..custom["modifier"])
                  local modifier = victim:AddNewModifier(whoDealDamage,byWhichAbility,custom["modifier"],{duration=tonumber(custom["modifier_duration"])})
                  if(modifier)then
                    if(custom["modifier_increase_stack_count"])then
                      modifier:IncrementStackCount()
                    end
                  else
                    print("add failed")
                  end
                                      
                end
                print("Check callback")
                if(custom["callback"])then
                  print("Have callback")
                  pcall(custom["callback"],whoDealDamage,victim)
                else
                  print("not Have callback")
                end
                
              end
            else
              --print("Cancel---existed")
            end
            
          end
            
        end
        
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