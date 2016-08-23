skill_tutien_meanhtung = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_tutien_meanhtung"
SETTING_CAST_SOUND = "Hero_Luna.Taunt.Leap"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/tutien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_tutien_meanhtung:GetManaCost()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   return 25+15*skill_level
end

function skill_tutien_meanhtung:GetCooldown()
   local caster=self:GetCaster()
   if(HasBook(caster))then
    return 3
   end
   return 5
end

function skill_tutien_meanhtung:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1,atk_perseconds)
   return true
end

function skill_tutien_meanhtung:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   
   local max_range = 600+skill_level*100
   if(HasBook(caster))then
    max_range = 600+skill_level*150
   end
   local range = (target_point-caster_position):Length2D()
   if(range>max_range)then
    target_point = caster_position+max_range*angleBetweenCasterAndTarget
   end
   local canMove = true
   local canFind = GridNav:CanFindPath(caster_position, target_point)
   local isBlock = GridNav:IsBlocked(target_point)
   local isTraversable = GridNav:IsTraversable(target_point)
  
   if(not canFind)then
    canMove =false
   end
   if(not isTraversable)then
    canMove=false
   end
   if(not canMove) then
    self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    self:EndCooldown()
    self:RefundManaCost()
    return
   end
   caster:EmitSound(SETTING_CAST_SOUND)
   Timers:CreateTimer(0.5,function() 
    self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
   end )
   
   caster:SetOrigin(target_point)
   FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
end