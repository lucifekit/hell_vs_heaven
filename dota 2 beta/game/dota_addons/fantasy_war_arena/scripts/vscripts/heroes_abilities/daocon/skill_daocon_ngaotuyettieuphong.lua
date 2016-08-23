skill_daocon_ngaotuyettieuphong = class({})
require('kem_lib/kem')
SETTING_NTTP_EFFECT = "particles/edited_particle/dao_con/ngaotuyettieuphong.vpcf"
SETTING_NTTP_FLY_TIME = 0.8
SETTING_NTTP_FLY_SPEED = 800
--SETTING_NTTP_HIT_EFFECT = "particles/units/heroes/hero_wisp/wisp_tether_hit.vpcf"
SETTING_NTTP_HIT_EFFECT = "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_castfx_ground2.vpcf"
SETTING_NTTP_SOUND_EFFECT = "Hero_Juggernaut.BladeFuryStart"
SETTING_NTTP_SOUND_DURATION = 1
require('heroes_abilities/daocon/daocon')
--------------------------------------------------------------------------------
function skill_daocon_ngaotuyettieuphong:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
   return 50+skill_level*5
end

function skill_daocon_ngaotuyettieuphong:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_daocon_ngaotuyettieuphong:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_daocon_ngaotuyettieuphong:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel() + GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   --self:PayManaCost()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
    --dummy sound
    local ntkp_dummy_unit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeam())
    ntkp_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
    ntkp_dummy_unit:EmitSoundParams(SETTING_NTTP_SOUND_EFFECT, 1, 0.1, 1)
    
    -- SNOWY TORNADO
local physical_damage_amplify = 0.7+0.04*skill_level
local basic_damage = 0.45
local chance_to_stun = 0.15+0.025*skill_level
local stun_time = 1
local lightning_basic_damage = 0.13+0.01*skill_level
local lightning_physical_damage_amplify = 0.21+0.012*skill_level
local lightning_damage_min = 229+14*skill_level
local lightning_damage_max = 257+18*skill_level
local lightining_radius = 150
local max_target = 2
    
    
    local duration = SETTING_NTTP_SOUND_DURATION
    
    --if mtcc then duration = 10
    
    Timers:CreateTimer({
                endTime = SETTING_NTTP_SOUND_DURATION,
                callback = function()
                   
                   ntkp_dummy_unit:StopSound(SETTING_NTTP_SOUND_EFFECT)
                   ntkp_dummy_unit:RemoveSelf()
                end
              })
    --
    --70%,45% co ban,target max 5
    --21%,236-266,14%,target max 2
    
    --110%,71% co ban
    --33%,371-453,23%
   local damageData = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = 0,
        element_damage_max = 0
        }
        
   local damageInfo = DamageHandler:GetDamage(damageData)
   local damageData2 = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = lightning_physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = lightning_basic_damage,
        element_damage_min = lightning_damage_min,
        element_damage_max = lightning_damage_max
        }
   local critInfo = DamageHandler:GetCritInfo(caster)
   local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        radius = 150,
        period = 0.33,
        duration = 0.7,
        damage = DamageHandler:GetDamage(damageData2),
        damage_element = ELEMENT_EARTH,
        maxTarget = max_target,
        custom = ""
      }
   local missile_speed = SETTING_NTTP_FLY_SPEED+math.min(500,50*skill_level)
   Projectiles:CreateProjectile( {
        EffectName      = SETTING_NTTP_EFFECT,
        Ability         = self,
        vSpawnOrigin    = caster_position,
        fDistance     = SETTING_NTTP_FLY_TIME*missile_speed,
        fStartRadius    = 128,
        fEndRadius      = 128,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_NTTP_FLY_TIME,--GameRules:GetGameTime() +100,--
    
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*missile_speed,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo, 
        crit = critInfo,
        effect = EFFECT_STUN,
        effect_chance = chance_to_stun*100,
        effect_time = stun_time,
        maxTarget = 5,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          unit:EmitSound("Hero_Kunkka.TidebringerDamage")
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            
              DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_EARTH,{})
              CreateEffectOnUnit(SETTING_NTTP_HIT_EFFECT,unit,0.5)            
              StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
              unit:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
              damageGroupData.where = unit:GetOrigin()
              DamageHandler:DamageGroup(damageGroupData)
              local HPPL_Ability = proj.Source:FindAbilityByName("skill_daocon_hoiphongphatlieu")
              local HPPL_Level = HPPL_Ability:GetLevel()
              if(HPPL_Level>0)then
                HPPL_Level = HPPL_Level+GetSkillLevel(proj.Source)
                local HPPL_Chance = 5+HPPL_Level
                if(math.random(0,100)<HPPL_Chance)then
                  CastHoiPhongPhatLieu(proj.Source,unit:GetOrigin())
                end
              end
          end})
          
          
          --CreateEffectOnPoint(SETTING_NTTP_HIT_EFFECT,unit:GetAbsOrigin(),0.5)
        end
        
      } )
end
