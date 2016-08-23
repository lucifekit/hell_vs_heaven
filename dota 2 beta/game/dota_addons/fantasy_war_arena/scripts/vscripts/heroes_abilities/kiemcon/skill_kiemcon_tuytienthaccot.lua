skill_kiemcon_tuytienthaccot = class({})
require('kem_lib/kem')

SETTING_EFFECT_ABOVE = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
SETTING_EFFECT_LIGHTNING = "particles/edited_particle/kiem_con/tuytienthaccot.vpcf"
SETTING_EFFECT_BOOM = "particles/units/heroes/hero_disruptor/disruptor_thuderstrike_aoe_area.vpcf"
SETTING_HIT_SOUND = "Hero_Disruptor.ThunderStrike.Target"
SETTING_CAST_SOUND = "Hero_Disruptor.ThunderStrike.Cast"
SETTING_RADIUS = 200
--------------------------------------------------------------------------------
function skill_kiemcon_tuytienthaccot:GetManaCost()
   return 100
end

function skill_kiemcon_tuytienthaccot:GetCooldown()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 60-6*skill_level
end

function skill_kiemcon_tuytienthaccot:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_kiemcon_tuytienthaccot:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   caster:EmitSound(SETTING_CAST_SOUND)
   FxPoint(SETTING_EFFECT_ABOVE,cast_point+Vector(0,0,780),10)
   FxPointControl(SETTING_EFFECT_LIGHTNING,cast_point,10,{[1]=cast_point+Vector(0,0,800)})
   local dummy_unit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeam())
   dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
   local tick = 10
   -- LIGHTINING STRIKE
local stun_chance = 0.35+0.05*skill_level
local stun_time = 1+0.2*skill_level
local max_target = math.floor(3+0.4*skill_level)
   local radius = SETTING_RADIUS
   local nncl_level = caster:FindAbilityByName("skill_kiemcon_nguynguyconlon"):GetLevel()
   if(nncl_level>0)then
    nncl_level = nncl_level+GetSkillLevel(caster)
    radius = radius+nncl_level*32
   end
   Timers:CreateTimer(0.03,function()
    if(tick>0)then
      local count = 0
      FxPoint(SETTING_EFFECT_BOOM,cast_point,1)
      dummy_unit:EmitSound(SETTING_HIT_SOUND)
      local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
      if #enemies > 0 then
        for _,enemy in pairs(enemies) do
          if(count<max_target)then
               StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_STUN,stun_chance*100,stun_time)
               count = count+1
          end
        end
      end
      
      
      tick = tick-1
      return 1
    else
      dummy_unit:RemoveSelf()
    end
   
   end)
end
