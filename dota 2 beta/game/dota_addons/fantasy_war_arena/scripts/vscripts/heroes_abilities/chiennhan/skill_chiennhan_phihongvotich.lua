skill_chiennhan_phihongvotich = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chiennhan_phihongvotich"
SETTING_MOVE_RANGE = 1000
SETTING_MOVE_TICK = 12
SETTING_TICK = 0.04

SETTING_AOE = 150

SETTING_PHVT_EFFECT = ""
SETTING_PHVT_FLY_TIME = 1
SETTING_PHVT_HIT_EFFECT = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
SETTING_CAST_SOUND = "Hero_Abaddon.DeathCoil.Target"
SETTING_HIT_SOUND = "Hero_Abaddon.Attack"
SETTING_MOVING_MODIFIER = "modifier_kem_moving"
LinkLuaModifier(SETTING_MOVING_MODIFIER,"modifiers/"..SETTING_MOVING_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_STACK_MODIFIER = "modifier_chiennhan_phihongvotich_stack"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_chiennhan_phihongvotich:GetManaCost()
   return 25
end
function skill_chiennhan_phihongvotich:GetReplenishTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 45-skill_level*2
end


function skill_chiennhan_phihongvotich:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4,atk_perseconds)
   return true
end

function skill_chiennhan_phihongvotich:OnUpgrade()
  
  local caster = self:GetCaster()
  local vlth_abi = caster:FindAbilityByName("skill_chiennhan_vanlongtamhien")
  local skill_level = vlth_abi:GetLevel()
  local drag_remain = self:GetCooldownTimeRemaining()
  if(skill_level>0)then
    skill_level=skill_level+GetSkillLevel(caster)
    local stack = math.floor(2+0.2*skill_level)    
    caster:AddNewModifier(caster,self,SETTING_STACK_MODIFIER,{max_count = stack,start_count = 1,replenish_time = self:GetReplenishTime()})
  else
    caster:AddNewModifier(caster,self,SETTING_STACK_MODIFIER,{max_count = 1,start_count = 1,replenish_time = self:GetReplenishTime()})
  end
  
   
end
function skill_chiennhan_phihongvotich:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local tempAngle = (target_point-caster_position):Normalized()
   local tempRange = SETTING_MOVE_RANGE
   if(target_point.z-caster_position.z>200)then
        --cao qua
        self:EndCooldown()
        self:RefundManaCost()
        self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
        return
   end
   
   -- DASH
-- ONE MAN ONE HORSE
-- ONE MAN ONE HORSE
local basic_damage = 1.9+0.15*skill_level
local physical_damage_amplify = 2.59+0.22*skill_level
local element_damage_min = 1360+136*skill_level
local element_damage_max = 2040+204*skill_level
local chance_to_maim = 0.35+0.03*skill_level
local maim_time = 1
local chance_to_burn = 0.25+0.03*skill_level
local burn_time = 2+0.2*skill_level


   
   local damageData = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   print("Emit "..SETTING_CAST_SOUND)
   caster:EmitSound(SETTING_CAST_SOUND)
   local tick = SETTING_MOVE_TICK
   local move_per_tick = tempRange/tick
--   for i = 0,move_per_tick do
--    local tempPoint = caster_position+tempAngle*move_per_tick
--    local groundHeight = GetGroundHeight(tempPoint,caster)
--    local cfp = GridNav:CanFindPath(caster_position,tempPoint)
--    local ib = GridNav:IsBlocked(tempPoint)

--   end

   local PHVT_Missile = Projectiles:CreateProjectile( {
        EffectName      = SETTING_PHVT_EFFECT,
        Ability         = self,
        vSpawnOrigin    = caster_position,
        fDistance     = SETTING_MOVE_RANGE*2,
        fStartRadius    = SETTING_AOE,
        fEndRadius      = SETTING_AOE,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_PHVT_FLY_TIME,--GameRules:GetGameTime() +100,--
   
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = tempAngle*SETTING_MOVE_RANGE*2,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        bZCheck=false,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          --unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,EFFECT_MAIM,chance_to_maim*100,maim_time)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,EFFECT_BURN,chance_to_burn*100,burn_time)
            unit:EmitSound(SETTING_HIT_SOUND)
            FxPoint(SETTING_PHVT_HIT_EFFECT,unit:GetOrigin(),1)
            --proj:Destroy()
          end})
          
        end
        
      } ) 

   caster:AddNewModifier(caster,self,SETTING_MOVING_MODIFIER,{})
   Timers:CreateTimer(0.01,function()
    local canMove =true
    if(tick==0)then
      canMove=false
    end
    if(not caster:canDive())then
      canMove = false
    end
    
    if(canMove)then
        --move
        --local gh = GetGroundHeight(caster:GetOrigin(),caster)
        --kemPrint("PHVT Moving")
        caster:SetAbsOrigin(caster:GetAbsOrigin()+tempAngle*move_per_tick)
        tick = tick-1
        return SETTING_TICK
    else
        PHVT_Missile:Destroy()
        caster:RemoveModifierByName(SETTING_MOVING_MODIFIER)
        caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
        local co = caster:GetOrigin()
        local gh = GetGroundHeight(caster:GetOrigin(),caster)

        if(gh<co.z)then
            --cao hon mat dat
            caster:SetOrigin(Vector(co.x,co.y,gh))
        end
        FindClearSpaceForUnit(caster, co, false )
        
    end
   end)
end
