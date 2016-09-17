skill_tutien_meanhtung = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_tutien_meanhtung"
SETTING_CAST_SOUND = "Hero_Luna.Taunt.Leap"
SETTING_FLY_TIME = 0.15
SETTING_EFFECT = "particles/units/heroes/hero_spectre/spectre_spectral_dagger.vpcf"
SETTING_START_EFFECT = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
SETTING_END_EFFECT = "particles/edited_particle/tu_tien/mat_end.vpcf"
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
    range = max_range
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
   FxPoint(SETTING_START_EFFECT,caster_position,0.5)
   Projectiles:CreateProjectile({
       EffectName      = SETTING_EFFECT,
       Ability         = self,
       vSpawnOrigin    = caster_position+Vector(0,0,100),
       fDistance     = range,
       fStartRadius    = 140,
       fEndRadius      = 140,
       Source        = caster,
       bHasFrontalCone   = true,
       bReplaceExisting  = false,
       fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
       GroundBehavior = PROJECTILES_NOTHING,
       UnitBehavior  = PROJECTILES_NOTHING,
       vVelocity     = angleBetweenCasterAndTarget*(range/SETTING_FLY_TIME),--angleBetweenCasterAndTarget,
       bProvidesVision   = true,
       numHit  = 0,
       iVisionRadius   = 200,
       iVisionTeamNumber = caster:GetTeamNumber(), 
       UnitTest = GeneralUnitTest,
       OnFinish = function(proj, unit)             
           caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
           caster:SetOrigin(target_point)
           FxPoint(SETTING_END_EFFECT,target_point,0.5)
           FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
     end
  })

   
end
