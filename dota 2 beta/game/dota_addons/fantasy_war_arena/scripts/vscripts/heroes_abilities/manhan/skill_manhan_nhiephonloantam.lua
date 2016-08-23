skill_manhan_nhiephonloantam = class({})
require('kem_lib/kem')

SETTING_SKILL_MODIFIER = "modifier_paralized"
SETTING_DEBUFF_RADIUS = 300
LinkLuaModifier(SETTING_SKILL_MODIFIER,"modifiers/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


--SETTING_EFFECT_2 = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line.vpcf"
--particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf
--SETTING_EFFECT_2 = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"

function skill_manhan_nhiephonloantam:OnAbilityPhaseStart()
  self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  return true
end
function skill_manhan_nhiephonloantam:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*50
end
function skill_manhan_nhiephonloantam:GetCooldown()
  if(IsInToolsMode())then
    return 1
  end
    local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 45-skill_level
end

function skill_manhan_nhiephonloantam:OnSpellStart()
  local caster = self:GetCaster()
  local cast_point = self:GetCursorPosition()
  local skill_level = self:GetLevel() + GetSkillLevel(caster)
-- PARALYZED
local paralyzed_duration = 1.5+0.15*skill_level
local paralyzed_chance = 0.35+0.04*skill_level
local max_target = math.floor(3+0.3*skill_level)



  
  --self:PayManaCost()
  local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_DEBUFF_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  if #enemies > 0 then
    caster:EmitSound("Hero_Nevermore.Shadowraze")
    for _,enemy in pairs(enemies) do
    if(max_target>0)then
    StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_PARALIZED,paralyzed_chance*100,paralyzed_duration)
         max_target = max_target-1
    end
        
        --enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = duration } )
    end
  end
  
  
  
    
end