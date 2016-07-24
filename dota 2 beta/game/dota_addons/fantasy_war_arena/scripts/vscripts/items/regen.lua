LinkLuaModifier("modifier_hp_small","modifiers/items/modifier_hp_small", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_hp_big","modifiers/items/modifier_hp_big", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_mango","modifiers/items/modifier_mango", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_test_speed","modifiers/items/modifier_test_speed", LUA_MODIFIER_MOTION_NONE )
function HpSmall(event)
  local target = event.caster
  --0-1-10-10
  --1-2-10-5
  --2-3--10-3.33
  local hpregen_multi = 0
  if(target.hpregen_multi)then
    hpregen_multi = target.hpregen_multi
  end

  local regen_duration = 5/(1+hpregen_multi)
  target:AddNewModifier(target,nil,"modifier_hp_small",{duration=regen_duration})
  
end

function HpBig(event)
  local target = event.caster
  --0-1-10-10
  --1-2-10-5
  --2-3--10-3.33
  local hpregen_multi = 0
  if(target.hpregen_multi)then
    hpregen_multi = target.hpregen_multi
  end

  local regen_duration = 5/(1+hpregen_multi)
  target:AddNewModifier(target,nil,"modifier_hp_big",{duration=regen_duration})
  
end

function Mango(event)
  local target = event.caster
  target:AddNewModifier(target,nil,"modifier_mango",{duration=1800})
  
end
function Exp(event)
   local target = event.caster
   if(IsServer())then
      
            
      local modifiers = target:FindAllModifiers()
      print("Count : "..#modifiers)
      for _,modi in ipairs(modifiers) do
        if(modi:GetName()=="kem_items_modifier")then
          modi:GainExp(1)
        end
      end
   end
end

function Exp10(event)
   local target = event.caster
   if(IsServer())then
      local modifiers = target:FindAllModifiers()
      print("Count : "..#modifiers)
      for _,modi in ipairs(modifiers) do
        if(modi:GetName()=="kem_items_modifier")then
          modi:GainExp(10)
        end
      end
   end
end
function TestSpeed(event)
  
  local target = event.caster
  if(IsInToolsMode())then
    target:AddNewModifier(target,nil,"modifier_test_speed",{duration=9999})
    while(target:GetLevel()<66)do
      target:AddExperience(500,0,false,false)
    end
  end
end