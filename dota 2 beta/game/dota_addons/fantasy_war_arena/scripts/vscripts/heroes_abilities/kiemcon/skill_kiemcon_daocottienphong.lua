skill_kiemcon_daocottienphong = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_kiemcon_daocottienphong"
SETTING_DURATION = 300
SETTING_RADIUS = 600
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemcon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_kiemcon_daocottienphong:GetManaCost()
   return 25
end

function skill_kiemcon_daocottienphong:GetCooldown(nLevel)
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_kiemcon_daocottienphong:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4,atk_perseconds)
   return true
end

function skill_kiemcon_daocottienphong:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   
   -- LIGHTNING BODY

  caster:EmitSound("Hero_Zuus.Taunt.Jump")
  
  caster:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DURATION } )
  local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  if #enemies > 0 then
    for _,enemy in pairs(enemies) do
      enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DURATION } )
    end
  end
   
end
