skill_thuongthien_hoiphonglacnhan = class({})
require('kem_lib/kem')
SETTING_DEBUFF_RADIUS = 120
SETTING_ATTACK_COUNT = 2
SETTING_RANGE_ALLOW = 225
SETTING_SKILL_MODIFIER="modifier_thuongthien_hoiphonglacnhan"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function skill_thuongthien_hoiphonglacnhan:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
   return 5+skill_level*2
end

function skill_thuongthien_hoiphonglacnhan:GetCooldown()
   return 0.7
end

function skill_thuongthien_hoiphonglacnhan:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)   
   return true
end

function skill_thuongthien_hoiphonglacnhan:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local castAngle = caster:GetAngles()
   local unit = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)
  
-- DOUBLE STRIKE
-- DOUBLE STRIKE
local physical_damage_amplify = 0.2*skill_level
local element_damage_min = 14+26*skill_level
local element_damage_max = 17+32*skill_level
local chance_to_maim = 0.15+0.02*skill_level
local maim_time = 1
local max_target = 3
local basic_damage = 0.5


  
  
  
  
   caster:EmitSound("Hero_PhantomLancer.PreAttack")
   unit:AddNewModifier(caster,self,"modifier_maim",{})
   unit:AddAbility("dummy_unit")
   unit:FindAbilityByName("dummy_unit"):SetLevel(1)   
   unit:SetAngles(castAngle.x,castAngle.y,castAngle.z)
   unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)   
   unit:MakeIllusion()
   Timers:CreateTimer(0.3,function()
    unit:RemoveSelf()
   end)
   
  caster:AddNewModifier(self:GetCaster(),self,SETTING_SKILL_MODIFIER,{duration=0.5})
   
  local damageData = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min =element_damage_min,
        element_damage_max = element_damage_max
        }

  local effectChance = chance_to_maim*100
  local damage = DamageHandler:GetDamage(damageData)
  local critInfo = DamageHandler:GetCritInfo(caster)
  local damageAreaData = {
      whoDealDamage = caster,
      byWhichAbility = self,
      where = target_point,
      radius = SETTING_DEBUFF_RADIUS,
      damage = damage,        
      crit = critInfo,
      damage_element = ELEMENT_METAL,
      maxTarget=max_target,
      custom = {
        action="status_effect",
        effect_type=EFFECT_MAIM,
        effect_chance=chance_to_maim*100,
        effect_time=maim_time
      }

    }
  DamageHandler:DamageArea(damageAreaData)  
 
  
       
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  local cd = 1 / atk_perseconds
  local abilityIndex = self:GetEntityIndex()

  Timers:CreateTimer(0.5,function()
    caster:EmitSound("Hero_PhantomLancer.PreAttack")
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)   
    --caster:RemoveModifierByName(SETTING_SKILL_MODIFIER)
    DamageHandler:DamageArea(damageAreaData)
    
    --caster:RemoveGesture(ACT_DOTA_ATTACK)
  end)
end
