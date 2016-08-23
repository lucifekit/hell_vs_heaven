skill_thuongthien_duongquantamdiep = class({})
require('kem_lib/kem')
SETTING_SKILL_MODIFIER="modifier_thuongthien_duongquantamdiep"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_DEBUFF_RADIUS = 120
SETTING_CAST_RANGE = 150
SETTING_ATTACK_COUNT = 3
--------------------------------------------------------------------------------
function skill_thuongthien_duongquantamdiep:GetManaCost()
   if(self:GetCaster():HasModifier(SETTING_SKILL_MODIFIER)) then
    return 0
   end
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   return skill_level*5
end

function skill_thuongthien_duongquantamdiep:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_thuongthien_duongquantamdiep:OnAbilityPhaseStart()
   if(self:GetCaster():HasModifier(SETTING_SKILL_MODIFIER)) then

    --kemPrint("Have modifier, reduce count")
    self:GetCaster():SetModifierStackCount(SETTING_SKILL_MODIFIER,self:GetCaster(),self:GetCaster():GetModifierStackCount(SETTING_SKILL_MODIFIER,self:GetCaster())-1)
   else
    --kemPrint("First attack")

    self:GetCaster():AddNewModifier(self:GetCaster(),self,SETTING_SKILL_MODIFIER,{duration=1})
    self:GetCaster():SetModifierStackCount(SETTING_SKILL_MODIFIER,self:GetCaster(),SETTING_ATTACK_COUNT)
   end
   
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)   
   return true
end

function skill_thuongthien_duongquantamdiep:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local castAngle = caster:GetAngles()
   local unit = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)

   --self:PayManaCost()
   caster:EmitSound("Hero_PhantomLancer.Attack")
   unit:AddNewModifier(caster,self,"modifier_maim",{})
   unit:AddAbility("dummy_unit")
   unit:FindAbilityByName("dummy_unit"):SetLevel(1)   
   unit:SetAngles(castAngle.x,castAngle.y,castAngle.z)
   unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)   
   unit:MakeIllusion()
   Timers:CreateTimer(0.3,function()
    unit:RemoveSelf()
   end)
   
  -- TRIPLE STRIKE
local physical_damage_amplify = 0.2*skill_level
local element_damage_min = 261+18*skill_level
local element_damage_max = 319+22*skill_level
local basic_damage = 0.5
local chance_to_maim = 0.15+0.025*skill_level
local maim_time = 1
local max_target = 4
  
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

  Timers:CreateTimer(cd+0.03,function()
    if(caster:HasModifier(SETTING_SKILL_MODIFIER))then
      --Order cast again
      caster:EmitSound("Hero_PhantomLancer.Attack")
      local tempRange = (target_point-caster_position):Length2D()

      local newPoint = target_point
      if(tempRange>SETTING_CAST_RANGE) then
        local tempAngle = (target_point-caster_position):Normalized()
        newPoint = caster_position+tempAngle*(SETTING_CAST_RANGE-10)
        local newRange = (newPoint-caster_position):Length2D()

      
      end
      local newOrder = {
          UnitIndex = caster:GetEntityIndex(), 
          OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
          AbilityIndex  = abilityIndex,
          Position = newPoint, --Optional.  Only used when targeting the ground
          Queue = 0 --Optional.  Used for queueing up abilities
        }
       
        ExecuteOrderFromTable(newOrder)
    end
  end)
end
