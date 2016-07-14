skill_daocon_thanhphongphu = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_daocon_thanhphongphu"
SETTING_RADIUS = 200
SETTING_DURATION = 300
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_daocon_thanhphongphu:GetManaCost()
   return 25
end

function skill_daocon_thanhphongphu:GetCooldown()
   return 15
end
function skill_daocon_thanhphongphu:GetSlowResistTime()
   return 10+12.5*self:GetLevel()
end
function skill_daocon_thanhphongphu:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_daocon_thanhphongphu:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()

  caster:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DURATION } )
  local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  if #enemies > 0 then
    for _,enemy in pairs(enemies) do
      enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DURATION } )
    end
  end
end
