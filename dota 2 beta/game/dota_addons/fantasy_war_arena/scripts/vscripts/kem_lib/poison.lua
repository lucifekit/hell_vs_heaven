LinkLuaModifier("modifier_poison","modifiers/modifier_poison", LUA_MODIFIER_MOTION_NONE )

if not PoisonHandler then
  PoisonHandler = class({})
end

function PoisonHandler:ApplyPoison(caster,target,ability,period,duration,damage,custom)
  --calculate target buff
  --calculate caster buff
  
  
  local startTime = GameRules:GetGameTime()

  --kemPrint("Poison "..damage.." each "..period.." last "..duration.."s")
  --kemPrint("Poison "..damage.." damage  each "..period.." last "..duration.."s".." to "..target:GetUnitName().."["..target:GetEntityIndex().."]")

  target:AddNewModifier( caster, nil,"modifier_poison", { duration = duration } )
  Timers:CreateTimer(function()
    local now = GameRules:GetGameTime()
    local last = now-startTime
    if last < duration then
      if(target:IsAlive())then
          local damageTable = {
            attacker = caster,
            ability = ability,
            damage_type = DAMAGE_TYPE_PURE,
            victim = target
          }
          local tempDamage = damage
          local debugMsg = "damage = "..damage
          if(caster.skill_poison_damage)then
            debugMsg = debugMsg.." + skill_poison_damage = "..caster.skill_poison_damage
            tempDamage = tempDamage+caster.skill_poison_damage
          end
          if(caster.weapon_poison_damage)then
            debugMsg = debugMsg.." + weapon_poison_damage = "..caster.weapon_poison_damage
            tempDamage = tempDamage+caster.weapon_poison_damage
          end

          if(caster.skill_amplify)then
            tempDamage = tempDamage+tempDamage*caster.skill_amplify 
            debugMsg = debugMsg.." + amplify  "..caster.skill_amplify
          end
          debugMsg = debugMsg.." = "..tempDamage
          damageTable.damage = tempDamage
          
          if(target:IsHero())then
            damageTable.damage = damageTable.damage*0.2
          end
          --check resist
          local resist_value = 0
          if(target.resist_wood)then
              resist_value=target.resist_wood
          end
          local element_def = 0
          if(resist_value<1280)then
              element_def = resist_value/1536
          else
              element_def = resist_value/(resist_value+256)
          end
          damageTable.damage = damageTable.damage*(1-element_def)
          print(debugMsg)
          --kemPrint("Poison target has  "..target:GetHealth().." hp, dealing "..tempDamage.."/"..damageTable.damage.." damage")
          ApplyDamage(damageTable)
          --show damage system
          local idx = target:GetEntityIndex()
          --kemPrint("Deal "..damage.." poison damage to "..target:GetUnitName().." idx "..idx.."  --- "..custom)
          if(PoisonDamage[idx]==nil) then
            --PoisonedUnits[idx] = 0
            --kemPrint("Inserting ")

            PoisonDamage[idx] = 0
          end
          PoisonDamage[idx] = PoisonDamage[idx]+damageTable.damage 
          
          
          local exists_in_table = false
          for _,u in ipairs(PoisonedUnitsList) do
            if u==target then
              exists_in_table = true
              break
            end
          end
          if not exists_in_table then
            table.insert(PoisonedUnitsList,target)
          end
          

          --end
          return period
      end
    end
    
    
  end)
end


function PoisonHandler:PoisonArea(data)

  local whoDealDamage = data.whoDealDamage or nil
  local byWhichAbility = data.byWhichAbility or nil
  local where = data.where or Vector(0,0,0)
  local radius = data.radius or 0
  local damage = data.damage or 0
  local custom = data.custom or ""
  local period = data.period or 5
  local duration = data.duration or 0
 
  PoisonHandler:PoisonAreaParams(whoDealDamage,byWhichAbility,where,radius,damage,period,duration,custom)
end
function PoisonHandler:PoisonAreaParams(whoDealDamage,byWhichAbility,where,radius,damage,period,duration,custom)

                     --damage
                     --local group = FindUnitsInRadius(owner:GetTeam(), point, nil, radius, int teamFilter, int typeFilter, int flagFilter, int order, bool canGrowCache)
                     --ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false
     local unitsToDamage = FindUnitsInRadius(whoDealDamage:GetTeam(), where, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
                     
     for _,victim in ipairs(unitsToDamage) do
        PoisonHandler:ApplyPoison(whoDealDamage,victim,byWhichAbility,period,duration,damage,{})
     end

end