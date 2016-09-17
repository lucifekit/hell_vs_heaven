skill_aow_mehontieu_thienmagiangthe = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_mehontieu_thienmagiangthe"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_mehontieu/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_EFFECT = "particles/edited_particle/aow_mehontieu/tmgt.vpcf"
SETTING_RADIUS = 400
SETTING_CAST_SOUND = "Hero_LegionCommander.Overwhelming.Cast"
SETTING_POINT_SOUND = "Hero_LegionCommander.Overwhelming.Location"
function skill_aow_mehontieu_thienmagiangthe:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*0
end

function skill_aow_mehontieu_thienmagiangthe:GetCooldown()
   return 10
end

function skill_aow_mehontieu_thienmagiangthe:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   --self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,atk_perseconds)
   --self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   StartAnimation(self:GetCaster(), {duration=0.5, activity=ACT_DOTA_ATTACK,translate="meld", rate=atk_perseconds})
   return true
end

function skill_aow_mehontieu_thienmagiangthe:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   caster:EmitSound(SETTING_CAST_SOUND)
   
   -- STARSTORM
local basic_damage = 0.35+0.04*skill_level
local physical_damage_amplify = 0.7+0.04*skill_level
local element_damage_min = 153+53*skill_level
local element_damage_max = 243+67*skill_level
local chance_to_maim = 0.15+0.015*skill_level
local basic_damage_each_stack = 0.01+0.003*skill_level
local maim_time = 1
local max_target = 7

   --damage setting
   local soul_catcher_modifer = caster:FindModifierByName("modifier_aow_mehontieu_doathon")
   local soul_catcher_stack = 0
   if(soul_catcher_modifer)then
    soul_catcher_stack = soul_catcher_modifer:GetStackCount()
    caster:RemoveModifierByName("modifier_aow_mehontieu_doathon")
   end
   local damage1Data = {
        caster = caster,
        main_physic = caster.stat_tp,
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage+basic_damage_each_stack*soul_catcher_stack,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
   local critInfo = DamageHandler:GetCritInfo(caster)
   local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target_point,
        radius = SETTING_RADIUS,
        damage = DamageHandler:GetDamage(damage1Data),
        damage_element = ELEMENT_WATER,
        crit = critInfo,
        custom = {
          action="status_effect",
          effect_type=EFFECT_MAIM,
          effect_chance=chance_to_maim*100,
          effect_time=maim_time
        }
      }
      
   
   --end damage setting
   
   for i=0,14 do
    Timers:CreateTimer(i*0.33,function()
      FxPointControl(SETTING_EFFECT,cast_point,1.5,{[1]=caster_position,[4]=Vector(SETTING_RADIUS,SETTING_RADIUS,1)})
      SoundPoint(SETTING_POINT_SOUND,cast_point,0.5,caster:GetTeam())
      DamageHandler:DamageArea(damageAreaData)
    end)
      
   end
end
