skill_chiennhan_tanduongnhuhuyet = class({})
require('kem_lib/kem')
SETTING_EFFECT = "particles/edited_particle/chien_nhan/vlk.vpcf"
SETTING_FLY_TIME = 0.5
SETTING_FLY_SPEED = 400
SETTING_CAST_SOUND = "Hero_Abaddon.PreAttack"
--------------------------------------------------------------------------------
function skill_chiennhan_tanduongnhuhuyet:GetManaCost()
   return 25
end

function skill_chiennhan_tanduongnhuhuyet:GetCooldown(nLevel)
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_chiennhan_tanduongnhuhuyet:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_chiennhan_tanduongnhuhuyet:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   -- FROST SLASH
local basic_damage = 1
local physical_damage_amplify = 0.35+0.04*skill_level
local element_damage_min = 51+53*skill_level
local element_damage_max = 69+65*skill_level
local chance_to_maim = 0.15+0.025*skill_level
local maim_time = 1
local chance_to_burn = 0.15+0.025*skill_level
local burn_time = 2+0.1*skill_level
local max_target = 3
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
        fStartRadius    = 100,
        fEndRadius      = 100,
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
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,EFFECT_BURN,chance_to_burn*100,burn_time)
            --proj:Destroy()
          end})
          
        end
        
      } )
end
