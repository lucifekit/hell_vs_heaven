EFFECT_MAIM = "modifier_maim"
EFFECT_SLOW = "modifier_slow"
EFFECT_BURN = "modifier_burn"
EFFECT_WEAK = "modifier_weak"
EFFECT_STUN = "modifier_stun"
EFFECT_NONE = ""
EFFECT_FEAR = "modifier_fear"
EFFECT_IMMOBILE = "modifier_immobile"
EFFECT_PARALIZED = "modifier_paralized"
EFFECT_KNOCKBACK = "modifier_knockback"

LinkLuaModifier(EFFECT_MAIM,"modifiers/"..EFFECT_MAIM, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_SLOW,"modifiers/"..EFFECT_SLOW, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_BURN,"modifiers/"..EFFECT_BURN, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_WEAK,"modifiers/"..EFFECT_WEAK, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_STUN,"modifiers/"..EFFECT_STUN, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_FEAR,"modifiers/"..EFFECT_FEAR, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_IMMOBILE,"modifiers/"..EFFECT_IMMOBILE, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(EFFECT_PARALIZED,"modifiers/"..EFFECT_PARALIZED, LUA_MODIFIER_MOTION_NONE )
if not StatusEffectHandler then
  StatusEffectHandler = class({})
end
MODIFIER_THUONGTHIEN_HOANHHANHVOKY = "modifier_thuongthien_hoanhhanhvoky"
MODIFIER_BOSS = "modifier_boss"

SETTING_EFFECT_BASE = 256
function StatusEffectHandler:ApplyEffect(caster,unit,effect,chance,time)
  if effect==EFFECT_NONE then
    return
  end
  if(unit:HasModifier(MODIFIER_THUONGTHIEN_HOANHHANHVOKY))then
    return
  end
  local unitLevel = unit:GetLevel()
  if(chance>100)then

    kemPrint("WARNING !!!!!!!!!!! "..caster:GetUnitName().." co skill chance > 100 "..chance)
    chance = chance/100
    
  end
  if(chance<1)then
    kemPrint("WARNING !!!!!!!!!!! "..caster:GetUnitName().." co skill chance < 1")
    chance = chance*100    

  end
  if(unit.inited)then
    --isPlayer
  else
    --quai 
    chance = chance-chance*(unitLevel/100)
  end
  if(unit:HasModifier(MODIFIER_BOSS))then
  	if(effect==EFFECT_MAIM or effect==EFFECT_KNOCKBACK or effect==EFFECT_IMMOBILE or effect==EFFECT_PARALIZED or effect==EFFECT_STUN)then
  		time = 0.03
  	else
  	  time = time*0.1
  	end
  end
  
  
  local inflict_chance = 0
  local inflict_time = 0
  local resist_chance = 0
  local reduce_time = 0
  -- MAIM
  if(effect==EFFECT_MAIM)then
      if(caster.effect_maim_add_percent)then
        inflict_chance = inflict_chance+ caster.effect_maim_add_percent
      end
      if(caster.effect_maim_add_time)then
        inflict_time = inflict_time+ caster.effect_maim_add_time
      end
      if(unit.effect_maim_resist_percent)then
        resist_chance = resist_chance+ unit.effect_maim_resist_percent
      end
      if(unit.effect_maim_reduce_time)then
        reduce_time = reduce_time+ unit.effect_maim_reduce_time
      end
  end
  -- WEAK
  if(effect==EFFECT_WEAK)then
      if(caster.effect_weak_add_percent)then
        inflict_chance = inflict_chance+ caster.effect_weak_add_percent
      end
      if(caster.effect_weak_add_time)then
        inflict_time = inflict_time+ caster.effect_weak_add_time
      end
      if(unit.effect_weak_resist_percent)then
        resist_chance = resist_chance+ unit.effect_weak_resist_percent
      end
      if(unit.effect_weak_reduce_time)then
        reduce_time = reduce_time+ unit.effect_weak_reduce_time
      end
  end
  
  -- BURN
  if(effect==EFFECT_BURN)then
      if(caster.effect_burn_add_percent)then
        inflict_chance = inflict_chance+ caster.effect_burn_add_percent
      end
      if(caster.effect_burn_add_time)then
        inflict_time = inflict_time+ caster.effect_burn_add_time
      end
      if(unit.effect_burn_resist_percent)then
        resist_chance = resist_chance+ unit.effect_burn_resist_percent
      end
      if(unit.effect_burn_reduce_time)then
        reduce_time = reduce_time+ unit.effect_burn_reduce_time
      end
  end
  
  -- SLOW
  if(effect==EFFECT_SLOW)then
      if(caster.effect_slow_add_percent)then
        inflict_chance = inflict_chance+ caster.effect_slow_add_percent
      end
      if(caster.effect_slow_add_time)then
        inflict_time = inflict_time+ caster.effect_slow_add_time
      end
      if(unit.effect_slow_resist_percent)then
        resist_chance = resist_chance+ unit.effect_slow_resist_percent
      end
      if(unit.effect_slow_reduce_time)then
        reduce_time = reduce_time+ unit.effect_slow_reduce_time
      end
  end
  
  -- STUN
  if(effect==EFFECT_STUN)then
      if(caster.effect_stun_add_percent)then
        inflict_chance = inflict_chance+ caster.effect_stun_add_percent
      end
      if(caster.effect_stun_add_time)then
        inflict_time = inflict_time+ caster.effect_stun_add_time
      end
      if(unit.effect_stun_resist_percent)then
        resist_chance = resist_chance+ unit.effect_stun_resist_percent
      end
      if(unit.effect_stun_reduce_time)then
        reduce_time = reduce_time+ unit.effect_stun_reduce_time
      end
  end
  
  if(effect==EFFECT_PARALIZED)then
      if(unit.effect_paralized_resist_percent)then
        resist_chance = resist_chance+ unit.effect_stun_resist_percent
      end
  end
  
  if(effect==EFFECT_FEAR)then
      if(unit.effect_fear_resist_percent)then
        resist_chance = resist_chance+ unit.effect_fear_resist_percent
      end
  end
  
  if(effect==EFFECT_KNOCKBACK)then
      if(unit.effect_knockback_resist_percent)then
        resist_chance = resist_chance+ unit.effect_knockback_resist_percent
      end
  end
  
  
  local modi_chance = inflict_chance-resist_chance
  --local real_chance = math.abs(modi_chance)*100/((math.abs(modi_chance)+SETTING_EFFECT_BASE))
  local modi_time = inflict_time-reduce_time
  local real_time = math.abs(modi_time)/((math.abs(modi_time)+SETTING_EFFECT_BASE))
  local debug_str = "Chance "..chance.." for "..time.." become "
 
  
  if(modi_time>0)then
    time = time*(1+real_time)
  else
    time = time*(1-real_time)
  end
  debug_str = debug_str.." "..chance.." for "..time
  
  if (StatusEffectHandler:CalculateChance(chance,modi_chance)) then

    unit:AddNewModifier( caster, nil,effect, { duration = time } )
  end
end
function StatusEffectHandler:CalculateChance(chance,modi_chance)
  local real_chance = math.abs(modi_chance)*100/((math.abs(modi_chance)+SETTING_EFFECT_BASE))

  if(math.random(0,100)<chance)then
    --trung
    if(modi_chance<0)then
      --duoc add them vao kha nang gay hieu ung
       if (math.random(0,100)<real_chance) then
          --thoat
          return false   
       end
    end
    return true
  else
    --ko trung
    if(modi_chance>0)then
      --duoc add them vao kha nang gay hieu ung
       if (math.random(0,100)<real_chance) then
          return true
       end
    end
    return false
  end
  return true
end



MODIFIER_BUILDING = "modifier_building"
function StatusEffectHandler:Pull(pull_data)

--function vacumm(pull_data)--caster,ability,pull_chance,pull_point,pull_radius,pull_duration,pull_tick,pull_modifier)
    local caster = pull_data.caster
    local ability = pull_data.ability
    local pull_chance = pull_data.pull_chance -- chance to pull
    local pull_point = pull_data.pull_point -- pull to where
    local pull_radius = pull_data.pull_radius -- pull pick radius
    local pull_duration = pull_data.pull_duration -- pull total duration
    local pull_step = pull_data.pull_step
    local pull_max_range = pull_data.pull_max_range
    local pull_custom = pull_data.pull_custom
    local cast_time = GameRules:GetGameTime()
    --PrintTable(pull_data)
    local team_to_find = 1
    if caster then
      team_to_find = caster:GetTeam()
    end
    local target_team = DOTA_UNIT_TARGET_TEAM_BOTH
    if caster then
      target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    end
      --kemPrint("Vacumm data "..team_to_find.."|"..target_team)
      
    
    Timers:CreateTimer(0.03,function()
    
      local now = GameRules:GetGameTime()
      if((now-cast_time)<pull_duration)then
        --kemPrint("Pull")
        local units = FindUnitsInRadius(team_to_find, pull_point, nil, pull_radius, target_team, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
      
        for _,unit in ipairs(units) do
            if(unit:HasModifier(MODIFIER_BUILDING))then
              --bo qua
            else
                if(math.random(0,100)<pull_chance) then
                 --StatusEffectHandler:ApplyEffect(caster,unit,EFFECT_KNOCKBACK,100,pull_duration)
                 if(type(pull_custom)=="table")then
                    if(pull_custom["action"]=="status_effect")then
                      local effect_type = pull_custom["effect_type"]
                      local effect_chance = pull_custom["effect_chance"]
                      local effect_time = pull_custom["effect_time"]
                      StatusEffectHandler:ApplyEffect(caster,unit,effect_type,effect_chance,effect_time)
                    end
                  end
                 --unit:AddNewModifier(caster, ability, pull_modifier,{duration = pull_duration})
                 local unit_location = unit:GetAbsOrigin()
                 local vector_distance = pull_point - unit_location
                 local distance = (vector_distance):Length2D()
                 if distance>pull_max_range then
                    distance = pull_max_range
                 end
                 
                 StatusEffectHandler:KnockBack(caster,pull_point,unit,pull_chance,0.5,-distance)
                 
                 
              end
            end
            
        end
        return pull_step
      else
        --kemPrint("End Pull")
      end
      
    end)
      
--end

end


function StatusEffectHandler:KnockBack(caster,start_point,unit,chance,knockback_duration,knockback_distance)
  local resist_chance = 0
  --kemPrint("call knockback ")
  if(start_point==nil)then
    start_point = caster:GetAbsOrigin()
  end
  if(unit.effect_knockback_resist_percent)then
        resist_chance = resist_chance+ unit.effect_knockback_resist_percent
  end
  if(unit:HasModifier(MODIFIER_BOSS))then
    chance = 0
  end
--  if(math.abs(knockback_angle.x)>1)then
--    --kemPrint("normalized angle")
--    knockback_angle = knockback_angle:Normalized()
--  end
  if (StatusEffectHandler:CalculateChance(chance,0-resist_chance)) then
    local startPosition = unit:GetOrigin()
    --kemPrint("Apply knockback "..knockback_distance.." point "..time.."s "..unit:GetUnitName().." at "..startPosition.x.."x"..startPosition.y)
    
    local knockbackModifierTable =
        {
          should_stun = 0,
          knockback_duration = knockback_duration,
          duration = knockback_duration,
          knockback_distance = knockback_distance,
          knockback_height = 0,
          center_x = start_point.x,
          center_y = start_point.y,
          center_z = start_point.z
        }
        --kemPrint("add modifier knockback "..knockback_duration.."s distance = "..knockback_distance)
    unit:AddNewModifier( caster, nil, EFFECT_KNOCKBACK, knockbackModifierTable )


  end
end