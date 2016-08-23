skill_chiennhan_vanlongkich = class({})
require('kem_lib/kem')
SETTING_SPEAR_EFFECT = "particles/edited_particle/chien_nhan/vlk.vpcf"
--------------------------------------------------------------------------------
function skill_chiennhan_vanlongkich:GetManaCost()
   return 25
end

function skill_chiennhan_vanlongkich:GetCooldown(nLevel)
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_chiennhan_vanlongkich:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_chiennhan_vanlongkich:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   
   local angleBetweenCasterAndTarget = (target_point-caster_position):Normalized()
   --self:PayManaCost()
   -- VAMPIRE SLASH
local drain = 0+0.01*skill_level
local basic_damage = 0.75+0.04*skill_level
local physical_damage_amplify = 1+0.06*skill_level
local element_damage_min = math.floor(611.06+37.894*skill_level)
local element_damage_max = math.floor(746.84+46.316*skill_level)
local chance_to_maim = 0.15+0.035*skill_level
local maim_time = 1
local chance_to_burn = 0.15+0.025*skill_level
local burn_time = 2+0.1*skill_level
local max_target = math.floor(3+0.2*skill_level)

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
   --caster:EmitSound("Hero_Invoker.Tornado.Cast")
   caster:EmitSound("Hero_Abaddon.PreAttack")
   Projectiles:CreateProjectile( {
        EffectName      = SETTING_SPEAR_EFFECT,
        Ability         = self,
        vSpawnOrigin    = caster_position-angleBetweenCasterAndTarget*50,
        fDistance     = 250,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fStartRadius    = 120,
        fEndRadius      = 120,
        fExpireTime     = 1,
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*800,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        iVisionRadius   = 100,
        damage          = damageInfo,
        crit            = critInfo,
        UnitTest = GeneralUnitTest,
        targetAllow = max_target,

        effect  = EFFECT_MAIM,
        effect_time = maim_time,
        effect_chance = chance_to_maim*100,
        OnUnitHit = function(proj,unit)
           DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{action="drain",value=drain})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,EFFECT_BURN,chance_to_burn*100,burn_time)
          
            --proj:Destroy()
          end})
        end
      } )
end
