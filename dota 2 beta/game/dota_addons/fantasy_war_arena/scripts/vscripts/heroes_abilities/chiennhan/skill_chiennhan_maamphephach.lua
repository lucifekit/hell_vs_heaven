skill_chiennhan_maamphephach = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chiennhan_maamphephach"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_CAST_SOUND = "Hero_Abaddon.BorrowedTime"
SETTING_DEBUFF_RADIUS = 450
SETTING_STACK_MODIFIER = "modifier_chiennhan_maamphephach_stack"

function skill_chiennhan_maamphephach:GetManaCost()
   return 25
end
function skill_chiennhan_maamphephach:GetReplenishTime()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 45-skill_level
end



function skill_chiennhan_maamphephach:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,atk_perseconds)
   return true
end
  
function skill_chiennhan_maamphephach:OnUpgrade()
  if(self:GetLevel()==1)then
    self:EndCooldown()
  end
  local caster = self:GetCaster()
  local vlth_abi = caster:FindAbilityByName("skill_chiennhan_vanlongtamhien")
  local skill_level = vlth_abi:GetLevel()
  local drag_remain = self:GetCooldownTimeRemaining()
  if(skill_level>0)then
    skill_level = skill_level+GetSkillLevel(caster)
    local stack = math.floor(2+0.2*skill_level)    
    caster:AddNewModifier(caster,self,SETTING_STACK_MODIFIER,{max_count = stack,start_count = 1,replenish_time = self:GetReplenishTime()})
  else
    caster:AddNewModifier(caster,self,SETTING_STACK_MODIFIER,{max_count = 1,start_count = 1,replenish_time = self:GetReplenishTime()})
  end
  
   
end
function skill_chiennhan_maamphephach:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   --self:PayManaCost()
   caster:EmitSound(SETTING_CAST_SOUND)
   
     -- PARALYZED
     print("Death call")
-- DEATH CALL
local fear_chance = 0.4+0.04*skill_level
local fear_time = 3+0.3*skill_level
local burn_chance = 0.25+0.05*skill_level
local burn_time = 2+0.1*skill_level
local max_target = math.floor(3+0.3*skill_level)

  
  --self:PayManaCost()
  local enemies = FindUnitsInRadius(caster:GetTeam(), caster_position, nil, SETTING_DEBUFF_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  if #enemies > 0 then
    --caster:EmitSound("Hero_Nevermore.Shadowraze")
    for _,enemy in pairs(enemies) do
    if(max_target>0)then
        print("Apply fear to "..enemy:GetUnitName())
        StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_FEAR,fear_chance*100,fear_time)
        StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_BURN,burn_chance*100,burn_time)
         max_target = max_target-1
    end
        
        --enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = duration } )
    end
  else
    print("no enemy")
  end
end
