skill_chiennhan_vanlongtamhien = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_chiennhan_phihongvotich_stack"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_SKILL_MODIFIER_3X = "modifier_chiennhan_huyenanhtruyhonthuong_stack"
LinkLuaModifier(SETTING_SKILL_MODIFIER_3X,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER_3X, LUA_MODIFIER_MOTION_NONE )
SETTING_SKILL_MODIFIER_7X = "modifier_chiennhan_maamphephach_stack"
LinkLuaModifier(SETTING_SKILL_MODIFIER_7X,"heroes_abilities/chiennhan/"..SETTING_SKILL_MODIFIER_7X, LUA_MODIFIER_MOTION_NONE )


function skill_chiennhan_vanlongtamhien:OnUpgrade()
  self:UpdateSkill()
   
end
function skill_chiennhan_vanlongtamhien:UpdateSkill()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   --self:PayManaCost()
   -- DEATH MASTERY
   local stack_dragoff_to_hell = math.floor(2+0.2*skill_level)
   local stack_hell_sound = math.floor(2+0.2*skill_level)
   local stack_hell_dash = math.floor(2+0.2*skill_level)
  
     local skill_3x = caster:FindAbilityByName("skill_chiennhan_huyenanhtruyhonthuong")
   local drag_remain = skill_3x:GetCooldownTimeRemaining()
   caster:AddNewModifier(caster,skill_3x,SETTING_SKILL_MODIFIER_3X,{max_count = stack_dragoff_to_hell,start_count = 1, replenish_time = skill_3x:GetReplenishTime()})
   local skill_7x = caster:FindAbilityByName("skill_chiennhan_maamphephach")
   local sound_remain = skill_7x:GetCooldownTimeRemaining()
   caster:AddNewModifier(caster,skill_7x,SETTING_SKILL_MODIFIER_7X,{max_count = stack_hell_sound,start_count = 1,replenish_time = skill_7x:GetReplenishTime()})
   local dash_skill = caster:FindAbilityByName("skill_chiennhan_phihongvotich")
   local dash_remain = dash_skill:GetCooldownTimeRemaining()
   caster:AddNewModifier(caster,dash_skill,SETTING_SKILL_MODIFIER,{max_count = stack_hell_dash,start_count = 1,replenish_time = dash_skill:GetReplenishTime()})

end