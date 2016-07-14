skill_thuongthien_doanhonthich = class({})
--range 550
--cooldown 3
--20 mân - 50
--27% 1s - 54
--35% 2s bat dong-85
SETTING_MOVE_RANGE = 550
SETTING_MOVE_RANGE_WITH_BOOK = 700
SETTING_MOVE_TICK = 12
SETTING_TICK = 0.04
SETTING_IMMOBILE_TIME =2 
SETTING_MAIM_TIME = 1
SETTING_AOE = 150
--------------------------------------------------------------------------------
--SETTING_SKILL_MODIFIER = "modifier_thuongthien_doanhonthich"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_thuongthien_doanhonthich:GetManaCost()
   return 10+10*self:GetLevel()
end

function skill_thuongthien_doanhonthich:GetCooldown()
   return 3
end
function skill_thuongthien_doanhonthich:GetRange()
  local heroLevel = self:GetCaster():GetLevel()
  if(heroLevel>25)then
    return SETTING_MOVE_RANGE_WITH_BOOK
  end
  return SETTING_MOVE_RANGE
end
function skill_thuongthien_doanhonthich:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_RUN,atk_perseconds)  
   return true
end

function skill_thuongthien_doanhonthich:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local tempAngle = (target_point-caster_position):Normalized()
   local tempRange = (target_point-caster_position):Length2D()
   if(tempRange>self:GetRange())then
    tempRange = self:GetRange()
   end
   if(target_point.z-caster_position.z>200)then
        --cao qua
        self:EndCooldown()
        self:RefundManaCost()
        self:GetCaster():RemoveGesture(ACT_DOTA_RUN)
        return
   end
   
   -- DASH
local chance_to_maim = 0.25+0.06*skill_level
local maim_time = 1
local chance_to_immobile = 0.35+0.1*skill_level
local immobile_time = 2
   
   
   caster:EmitSound("Hero_PhantomLancer.PhantomEdge")
   local tick = SETTING_MOVE_TICK
   local move_per_tick = tempRange/tick
--   for i = 0,move_per_tick do
--    local tempPoint = caster_position+tempAngle*move_per_tick
--    local groundHeight = GetGroundHeight(tempPoint,caster)
--    local cfp = GridNav:CanFindPath(caster_position,tempPoint)
--    local ib = GridNav:IsBlocked(tempPoint)

--   end
   Timers:CreateTimer(SETTING_TICK,function()
    if(tick>0)then
        --move
        --local gh = GetGroundHeight(caster:GetOrigin(),caster)

        caster:SetAbsOrigin(caster:GetAbsOrigin()+tempAngle*move_per_tick)
        tick = tick-1
        return SETTING_TICK
    else
        caster:RemoveGesture(ACT_DOTA_RUN)
        local co = caster:GetOrigin()
        local gh = GetGroundHeight(caster:GetOrigin(),caster)

        if(gh<co.z)then
            --cao hon mat dat
            caster:SetOrigin(Vector(co.x,co.y,gh))
        end
        FindClearSpaceForUnit(caster, co, false )
        local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, SETTING_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
        if #enemies > 0 then

             for _,enemy in ipairs(enemies) do
                --DamageHandler:ApplyDamage(caster,self,enemies[1],damage,critInfo,ELEMENT_METAL,"")
                StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_IMMOBILE,chance_to_immobile*100,immobile_time)
                StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_MAIM,chance_to_maim*100,maim_time)

             end
             
        end
        --apply tho thuong
        
        --apply bat dong      
    end
   end)
end
