if kem_items_modifier == nil then
    kem_items_modifier = class({})
end
function kem_items_modifier:GetTexture()
    return self.texture --we want item's passive abilities to be hidden most of the times
end
function kem_items_modifier:IsHidden()
    return true
end
function kem_items_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT+MODIFIER_ATTRIBUTE_MULTIPLE --we want item's passive abilities to be hidden most of the times
end
function kem_items_modifier:GetTexture()
    return self.texture --we want item's passive abilities to be hidden most of the times
end
function kem_items_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
      MODIFIER_EVENT_ON_DEATH,
      MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
      MODIFIER_PROPERTY_MANA_BONUS,
      MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
      MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
      MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
      }
    return funcs
end
function kem_items_modifier:GetModifierAttackSpeedBonus_Constant()
  return self.atk_speed
end

function kem_items_modifier:GetModifierMoveSpeedBonus_Special_Boots()
  return self.move_speed
end
function kem_items_modifier:GetModifierExtraHealthBonus()
  return self.hp
end
function kem_items_modifier:GetModifierManaBonus()
  return self.mp
end

function kem_items_modifier:GetModifierConstantHealthRegen()
  return self.hp_regen
end
function kem_items_modifier:GetModifierConstantManaRegen()
  return self.mp_regen
end


function kem_items_modifier:GetNumber(key)
  if(IsServer())then
    if(self.data==nil)then
      return 0
    end
    return self.data[key]==nil and 0 or self.data[key]
  else
   local value = self:GetAbility():GetSpecialValueFor(key)
    if(value>0)then
      return value
    end
  
  end
  return 0
  
end

function kem_items_modifier:GetString(key)
  if(self.data==nil)then
    return ""
  end
  return self.data[key]==nil and "" or self.data[key]
end
function kem_items_modifier:GainExp(exp)
  --kemPrint("+"..params.unit:GetLevel().." exp")
  local item = self:GetAbility()
  if(item:IsItem())then

      if(self.item_level<self.item_max_level)then
        if(item.kill_count==nil)then
          item.kill_count = 0
        end
        item.kill_count = item.kill_count+exp
        item:SetCurrentCharges(item.kill_count)
        if(item.kill_count>=self.exp)then
          --kemPrint("Enough exp to upgrade item")
          if(self.upgrade~=nil)then
            --kemPrint("Upgrade item to "..self.upgrade)
      
            local caster = self:GetParent()
            caster:RemoveItem(item)
            caster:AddItemByName(self.upgrade)
            --local newItem = CreateItem(self.upgrade, caster,caster)
          end
        end
      end
      
  end
  
  
end
function kem_items_modifier:OnDeath( params ) 
  --PrintTable(params)
  local killer = params.attacker
  if(killer==self:GetParent())then
    local item =self:GetAbility()
     
    
    if(item:IsItem())then

      if(self.item_level<self.item_max_level)then
        
        self:GainExp(params.unit:GetLevel())
        
      end
      
      
    end
    --self:GetAbility():SetCurrentCharges(abi.kill_Count)
    
  end
  
end


LinkLuaModifier("modifier_two_weapon","modifiers/modifier_two_weapon", LUA_MODIFIER_MOTION_NONE )


function kem_items_modifier:SkillChange(hero)
  if(self.skill_level>0)then
    print("Skill change check : Call upgrade skill for hero ( reset all stat )")
    UpgradeSkillForHero(hero)
  end
  
  --chi refresh nhung cai nao ko co update
  
  -- bo cac effect o buff-debuff
--  if(hero.class)then
--    for _,modifier in pairs(modifiers_list) do      
--      if(modifier.GainBack)then
--        print("Gain back .."..modifier:GetName())
--        modifier:GainBack()
--      end
--    end  
--  end
  
  --init lai tu cac skill passive
  
  --reset
  
  --them lai cac effect o buff-debuff
  
  
end

function kem_items_modifier:GetItemData()
  local item = self:GetAbility()
  local hero = self:GetParent()
  if IsServer() then --this should be only run on server.
        local carryWeapon = false
        for _,modifiers in ipairs(hero:FindAllModifiers()) do
          if(modifiers.item_type)then
            if(modifiers.item_type=="weapon")then
              carryWeapon = true
            end
          end 
        end
        print("Created...kem_item_modifier")
        local itemname=item:GetAbilityName()
        local kv = LoadKeyValues("scripts/kv/items.kv")
        local itemData = kv[itemname]
        self.texture = self:GetString("texture") 
        
        
        --LinkLuaModifier("modifier_movespeed_cap", "modifiers/modifier_movespeed_cap", LUA_MODIFIER_MOTION_NONE)
        if(itemData==nil) then
          kemPrint("Nil item data "..itemname)

          UpdatePlayerDataForHero(hero)
          return
        end
        
        
        if(itemname=="item_book")then
          kemPrint("Buy book")
          local tempAbility = hero:FindAbilityByName("skill_tutien_xuyenvantien")
          if(tempAbility)then
            tempAbility:SetLevel(1)
          end
        end
        
          
          
          
        self.data = itemData
        self.item_level = self:GetNumber("level")
        self.item_max_level = self:GetNumber("max_level")
        self.exp = self:GetNumber("exp")
        self.upgrade = self:GetString("upgrade")
        self.item_type = self:GetString("type")
        if(self.item_type=="weapon" and carryWeapon)then
          hero:AddNewModifier(hero,nil,"modifier_two_weapon",{})
        end
        
        
        
        self.resist = self:GetNumber("resist")
        
        
        self.skill_level = self:GetNumber("skill_level")
        
        
    
    end
    --MODIFIER REGISTERED VALUE
    self.atk_speed = self:GetNumber("atk_speed")
    self.move_speed = self:GetNumber("move_speed")
    
    self.hp = self:GetNumber("hp")
    self.mp = self:GetNumber("mp")
    self.hp_regen= self:GetNumber("hp_regen")
    self.mp_regen= self:GetNumber("mp_regen")
    
end


function kem_items_modifier:ApplyStat()
    local hero = self:GetParent()
    hero.skill_level = hero.skill_level+self.skill_level
    hero.resist_metal = hero.resist_metal+self.resist+self:GetNumber("resist_physical")
    hero.resist_wood = hero.resist_wood +self.resist+self:GetNumber("resist_poison")
    hero.resist_fire = hero.resist_fire+self.resist+self:GetNumber("resist_fire")
    hero.resist_water = hero.resist_water+self.resist+self:GetNumber("resist_water")
    hero.resist_earth = hero.resist_earth+self.resist+self:GetNumber("resist_lightning")
    
    hero.accuracy_point = hero.accuracy_point+ self:GetNumber("accuracy_point")
    hero.evade_point = hero.evade_point+ self:GetNumber("evade")--ne tranh
    
    hero.physic_amplify = hero.physic_amplify+ self:GetNumber("physic_amplify")/100--vat cong them vao
    print("229 ea = "..hero.element_amplify.." self = "..self:GetNumber("element_amplify"))
    hero.element_amplify = hero.element_amplify+ self:GetNumber("element_amplify")/100--vat cong them vao
    print("231 ea = "..hero.element_amplify)
    print("Add element damage = "..self:GetNumber("weapon_element_damage"))
    hero.weapon_element_damage = hero.weapon_element_damage + self:GetNumber("weapon_element_damage")
    hero.weapon_physical_damage = hero.weapon_physical_damage + self:GetNumber("weapon_physical_damage")
    hero.weapon_poison_damage = hero.weapon_poison_damage + self:GetNumber("weapon_poison_damage")        
    hero.critical_damage = hero.critical_damage + self:GetNumber("critical_damage")
    hero.critical_chance = hero.critical_chance + self:GetNumber("critical_chance")
    hero.hp_drain = hero.hp_drain + self:GetNumber("hp_drain")/100
    hero.mp_drain = hero.mp_drain + self:GetNumber("mp_drain")/100
    local basic_damage = self:GetNumber("basic_damage")
    print("Basic damage = "..basic_damage)
    hero.basic_damage_percent = hero.basic_damage_percent + self:GetNumber("basic_damage")
    hero.damage_to_mp = hero.damage_to_mp + self:GetNumber("damage_to_mp")/100

    
    
end
function kem_items_modifier:OnCreated( params ) 
    self:GetItemData()
    local hero = self:GetParent()
    if(IsServer())then
        
      self:ApplyStat()
      print("Call skill change")
      self:SkillChange(hero)
      if(hero)then
      kemPrint("Got New Item, Call update line 235 item =  "..self:GetAbility():GetAbilityName().." of hero "..hero:GetUnitName())
      else
      kemPrint("!!!! Got New Item, Call update line 235 item =  "..self:GetAbility():GetAbilityName().." of hero nil !!!")
      end
      

      UpdatePlayerDataForHero(hero)
    end
end

function kem_items_modifier:GainBackStat()
  local hero = self:GetParent()
 
  hero.skill_level = hero.skill_level-self.skill_level
  hero.resist_metal = hero.resist_metal-self.resist-self:GetNumber("resist_physical")
  hero.resist_wood = hero.resist_wood -self.resist-self:GetNumber("resist_poison")
  hero.resist_fire = hero.resist_fire-self.resist-self:GetNumber("resist_fire")
  hero.resist_water = hero.resist_water-self.resist-self:GetNumber("resist_water")
  hero.resist_earth = hero.resist_earth-self.resist-self:GetNumber("resist_lightning")
  
  
  hero.accuracy_point = hero.accuracy_point- self:GetNumber("accuracy_point")
  hero.evade_point = hero.evade_point- self:GetNumber("evade")--ne tranh
  
  hero.physic_amplify = hero.physic_amplify- self:GetNumber("physic_amplify")/100--vat cong them vao
  print("313 rm ea = "..hero.element_amplify.." self = "..self:GetNumber("element_amplify"))
  hero.element_amplify = hero.element_amplify- self:GetNumber("element_amplify")/100
  print("315 rm ea = "..hero.element_amplify)
  print("Remove element damage = "..self:GetNumber("weapon_element_damage"))
  hero.weapon_element_damage = hero.weapon_element_damage - self:GetNumber("weapon_element_damage")
  hero.weapon_physical_damage = hero.weapon_physical_damage - self:GetNumber("weapon_physical_damage")
  hero.weapon_poison_damage = hero.weapon_poison_damage - self:GetNumber("weapon_poison_damage")        
  hero.critical_damage = hero.critical_damage - self:GetNumber("critical_damage")
  hero.critical_chance = hero.critical_chance - self:GetNumber("critical_chance")
  hero.hp_drain = hero.hp_drain - self:GetNumber("hp_drain")/100
  hero.mp_drain = hero.mp_drain - self:GetNumber("mp_drain")/100
  
  hero.basic_damage_percent = hero.basic_damage_percent - self:GetNumber("basic_damage")

end

function kem_items_modifier:OnDestroy() 
    if IsServer() then --this should be only run on server.
        print("Droping item,removing modifier")
        local hero = self:GetParent()
        local iNumbWeapons = 0
        for _,modifiers in ipairs(hero:FindAllModifiers()) do
          if(modifiers.item_type)then
            if(modifiers.item_type=="weapon")then
              iNumbWeapons = iNumbWeapons+1
            end
          end 
        end
        --print("Number of weapon "..carryWeaponNumb)
        if(iNumbWeapons<2)then
          hero:RemoveModifierByName("modifier_two_weapon")
        end
        local hero = self:GetParent()
        if(self.data==nil)then
          kemPrint("Call update 188 kem item = nil !!!!!!!!!!!!!!")
          UpdatePlayerDataForHero(hero)
          return
        end
        if(hero.resist_metal==nil)then
          return
        end
        
        
        self:GainBackStat()
        self:SkillChange(hero)
        kemPrint("Call update on Destroy 214 kem item "..self:GetAbility():GetAbilityName())

        UpdatePlayerDataForHero(hero)
    end
end