skill_thuongthien_bonloitoanlongthuong = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_thuongthien_bonloitoanlongthuong"
SETTING_SKILL_DAMAGE_REDUCE = 0.85
SETTING_TIME_BETWEEN_SLASH = 0.25
SETTING_MOVE_TICK = 7
SETTING_CAST_RANGE = 700
SETTING_RADIUS = 700
SETTING_IMPACT_EFFECT = "particles/edited_particle/thuong_thien/bltlt_tgt.vpcf"
SETTING_IMPACT_EFFECT_2 = "particles/units/heroes/hero_phantom_lancer/phantom_lancer_deathflash.vpcf"

SETTING_CAST_EFFECT = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_thuongthien_bonloitoanlongthuong:GetManaCost()
   return 180
end

function skill_thuongthien_bonloitoanlongthuong:GetCooldown()
   return 5
end

function skill_thuongthien_bonloitoanlongthuong:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)   
   return true
end

function skill_thuongthien_bonloitoanlongthuong:OnSpellStart()
   local caster = self:GetCaster()
   
    --caster:SetForwardVector(Vector(math.random(0,255),math.random(0,255),0))
    --caster:SetAngles(0,math.random(-360,360),0)
    --caster:SetForwardVector(Vector(0,0,0))
   local skill_level = self:GetLevel()
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   
   -- OMNISLASH
local physical_damage_amplify = 1.25+0.12*skill_level
local element_damage_min = 293+28*skill_level
local element_damage_max = 356+36*skill_level
local chance_to_maim = 0.1+0.1*skill_level
local maim_time = 1
local max_target = 11
local basic_damage = 1+0.1*skill_level
local damage_reduce = 0.15
local number_of_slash = 7
   
    local canMove = true
    if(target_point.z-caster_position.z>200)then
          --cao qua
          canMove=false
     end
    local canFind = GridNav:CanFindPath(caster_position, target_point)
    local isBlock = GridNav:IsBlocked(target_point)
    local isTraversable = GridNav:IsTraversable(target_point)

    if(not canFind)then
      canMove =false
    end
    if(not isTraversable)then
      canMove=false
    end
    if(not canMove) then
      self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK)
      self:EndCooldown()
      self:RefundManaCost()
      return
    end
   
   
   
   local damageData = {
      caster = caster,
      main_attribute_value = caster:GetAgility(),
      skill_physical_damage_percent =physical_damage_amplify,
      skill_tree_amplify_damage = 0,-- can edit
      skill_basic_damage_percent = basic_damage,
      element_damage_min = element_damage_min,
      element_damage_max = element_damage_max
    }
    local damage = DamageHandler:GetDamage(damageData)
    local critInfo = DamageHandler:GetCritInfo(caster)
    local effectChance = chance_to_maim*100
    
    caster:EmitSound("Hero_PhantomLancer.SpiritLance.Cast")
    local currentAngle = (target_point-caster_position):Normalized()
    local currentRange = (target_point-caster_position):Length2D()
    if(currentRange>SETTING_CAST_RANGE)then
      currentRange = SETTING_CAST_RANGE
    end
    local tick = SETTING_MOVE_TICK
    local cast_pfx =ParticleManager:CreateParticle(SETTING_CAST_EFFECT,PATTACH_WORLDORIGIN,caster)
    ParticleManager:SetParticleControl( cast_pfx, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex( cast_pfx)--, 0, caster:GetAbsOrigin())
    local move_time = SETTING_TIME_BETWEEN_SLASH/SETTING_MOVE_TICK
   
    Timers:CreateTimer(SETTING_TIME_BETWEEN_SLASH,function()
      local tempMaxTarget = max_target
      local tempDamage = {}
      for orig_key, orig_value in pairs(damage) do
            tempDamage[orig_key] = orig_value
      end
      
      if(caster:IsAlive())then
        --deal damage
        caster:SetOrigin(target_point)
        local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, SETTING_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
        if #enemies > 0 then
          for _,enemy in pairs(enemies) do
            if(tempMaxTarget>0)then
              tempMaxTarget= tempMaxTarget-1
              --enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DEBUFF_DURATION } )
              tempDamage.min_physic=tempDamage.min_physic*(1-damage_reduce)
              tempDamage.max_physic=tempDamage.max_physic*(1-damage_reduce)
              tempDamage.min_element=tempDamage.min_element*(1-damage_reduce)
              tempDamage.max_element=tempDamage.max_element*(1-damage_reduce)
              PrintTable(tempDamage)
              DamageHandler:ApplyDamage(caster,self,enemy,tempDamage,critInfo,ELEMENT_METAL,{})
              StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_MAIM,effectChance,maim_time)
              local pfx =ParticleManager:CreateParticle(SETTING_IMPACT_EFFECT,PATTACH_WORLDORIGIN,caster)
              ParticleManager:SetParticleControl( pfx, 0, enemy:GetAbsOrigin())
              --local pfx2 =ParticleManager:CreateParticle(SETTING_IMPACT_EFFECT_2,PATTACH_WORLDORIGIN,caster)
              --ParticleManager:SetParticleControl( pfx2, 0, enemy:GetAbsOrigin()+Vector(0,0,50))
              Timers:CreateTimer(0.5,function()
                ParticleManager:DestroyParticle(pfx,true)
                --ParticleManager:DestroyParticle(pfx2,true)
              end)
            end
            
          end
          target_point =  enemies[#enemies]:GetOrigin() 
          caster:EmitSound("Hero_PhantomLancer.SpiritLance.Impact")
          caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)
          if(number_of_slash>0)then
            
            number_of_slash = number_of_slash-1
            --Timers:RemoveTimer(currentTimer)
            tick = SETTING_MOVE_TICK
            caster_position = caster:GetOrigin()

            --caster:SetAngles(-1,1,0)
            local table = {
            UnitIndex=caster:entindex(),
            OrderType=DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position=target_point}
            ExecuteOrderFromTable(table)
            
            return SETTING_TIME_BETWEEN_SLASH
          else
            --Timers:RemoveTimer(currentTimer)
            FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
          end
        end
        
        ---
        
      else
        --caster teo`
        --Timers:RemoveTimer(currentTimer)
      end
      
    end)
    
end
