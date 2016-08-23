skill_chiennhan_liethoatinhthien = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/chien_nhan/vlk.vpcf"
SETTING_FLY_TIME = 0.5
SETTING_FLY_SPEED = 600
SETTING_CAST_SOUND = "Hero_Abaddon.PreAttack"
--------------------------------------------------------------------------------
function skill_chiennhan_liethoatinhthien:GetManaCost()
   return 25
end

function skill_chiennhan_liethoatinhthien:GetCooldown(nLevel)
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_chiennhan_liethoatinhthien:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_chiennhan_liethoatinhthien:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   --self:PayManaCost()
   
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   -- FROST SLASH
-- LEECH
local basic_damage = 0.75+0.04*skill_level
local drain = 0.01+0.004*skill_level
local physical_damage_amplify = 0.5+0.04*skill_level
local element_damage_min = 618.9+22.21*skill_level
local element_damage_max = 756.42+27.158*skill_level
local chance_to_maim = 0.15+0.035*skill_level
local maim_time = 1
local chance_to_burn = 0.15+0.025*skill_level
local burn_time = 2+0.1*skill_level
local max_target = math.floor(3+0.2*skill_level)
   --self:PayManaCost()
   local damageData = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   caster:EmitSound(SETTING_CAST_SOUND)
   Projectiles:CreateProjectile( {
        EffectName      = SETTING_EFFECT,
        Ability         = self,
        vSpawnOrigin    = caster_position,
        fDistance     = SETTING_FLY_TIME*SETTING_FLY_SPEED,
        fStartRadius    = 128,
        fEndRadius      = 128,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_FLY_TIME,--GameRules:GetGameTime() +100,--
   
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*SETTING_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        effect = EFFECT_MAIM,
        effect_chance = chance_to_maim*100,
        effect_time = maim_time,
        maxTarget = max_target,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          --unit:EmitSound(SETTING_HIT_SOUND)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{action="drain",value=drain})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,EFFECT_BURN,chance_to_burn*100,burn_time)
            --proj:Destroy()
          end})
          
        end
        
      } )
end
