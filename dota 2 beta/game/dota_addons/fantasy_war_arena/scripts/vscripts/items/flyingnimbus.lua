function swap_to_item(keys, ItemName)
  for i=0, 5, 1 do  --Fill all empty slots in the player's inventory with "dummy" items.
    local current_item = keys.caster:GetItemInSlot(i)
    if current_item == nil then
      keys.caster:AddItem(CreateItem("item_dummy", keys.caster, keys.caster))
    end
  end
  
  keys.caster:RemoveItem(keys.ability)
  keys.caster:AddItem(CreateItem(ItemName, keys.caster, keys.caster))  --This should be put into the same slot that the removed item was in.
  
  for i=0, 5, 1 do  --Remove all dummy items from the player's inventory.
    local current_item = keys.caster:GetItemInSlot(i)
    if current_item ~= nil then
      if current_item:GetName() == "item_dummy" then
        keys.caster:RemoveItem(current_item)
      end
    end
  end
end


function ActiveFlyingNimbus(params)
  --PrintTable(params)

  local caster = params.caster
  local hero_elements = LoadKeyValues("scripts/kv/hero_element.kv")
  local hero_name = caster:GetUnitName()
  local heroData = hero_elements[hero_name]
  --caster:SetOrigin(Vector(caster:GetOrigin().x,caster:GetOrigin().y,50))
  if(heroData["horse_disable_ability"]==1)then
    
    swap_to_item(params, "item_flying_nimbus")
  else
    swap_to_item(params, "item_flying_nimbus_no_disable")
  end
  
  --swap_to_item(keys, "item_flying_nimbus_no_disable")
end


function DeActiveFlyingNimbus(params)
  swap_to_item(params, "item_flying_nimbus_inactive")
end



function ActiveSkywing(params)
  --PrintTable(params)

  local caster = params.caster
  local hero_elements = LoadKeyValues("scripts/kv/hero_element.kv")
  local hero_name = caster:GetUnitName()
  local heroData = hero_elements[hero_name]
  --caster:SetOrigin(Vector(caster:GetOrigin().x,caster:GetOrigin().y,50))
  if(heroData["horse_disable_ability"]==1)then
    swap_to_item(params, "item_skywing")
  else
    swap_to_item(params, "item_skywing_no_disable")
  end
  
  --swap_to_item(keys, "item_flying_nimbus_no_disable")
end


function DeActiveSkywing(params)
  swap_to_item(params, "item_skywing_inactive")
end




function ActiveLegionwing(params)
  --PrintTable(params)

  local caster = params.caster
  local hero_elements = LoadKeyValues("scripts/kv/hero_element.kv")
  local hero_name = caster:GetUnitName()
  local heroData = hero_elements[hero_name]
  --caster:SetOrigin(Vector(caster:GetOrigin().x,caster:GetOrigin().y,50))
  if(heroData["horse_disable_ability"]==1)then
    swap_to_item(params, "item_legionwing")
  else
    swap_to_item(params, "item_legionwing_no_disable")
  end
  
  --swap_to_item(keys, "item_flying_nimbus_no_disable")
end


function DeActiveLegionwing(params)
  swap_to_item(params, "item_legionwing_inactive")
end