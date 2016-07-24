skill_kiemdoan_kimngocmanduong = class({})

--SETTING_KNMD_EFFECT = "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
--SETTING_KNMD_EFFECT = "models/heroes/bristleback/bristleback_offhand_weapon.vmdl"
SETTING_KNMD_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_kimngocmanduong.vpcf"
--SETTING_KNMD_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_KNMD_HIT_EFFECT = "particles/units/heroes/hero_wisp/wisp_tether_hit.vpcf"
--SETTING_KNMD_CASTER_EFFECT = "particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf"


SETTING_SWORD_FLY_SPEED = 900
SETTING_SWORD_FLY_TIME = 0.8
SETTING_SWORD_DISTANCE_BETWEEN_SWORD = 100
SETTING_SWORD_PIERCE_MULTIPLER = 0.5
SETTING_SWORD_PIERCE_MULTIPLER_MAX = 3
function skill_kiemdoan_kimngocmanduong:GetCooldown()
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  return 1/atk_perseconds
end
function skill_kiemdoan_kimngocmanduong:GetManaCost()
  return self:GetLevel()*10
end
function skill_kiemdoan_kimngocmanduong:OnAbilityPhaseStart()
  --self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_ATTACK,atk_perseconds)
  return true
end
function skill_kiemdoan_kimngocmanduong:OnSpellStart()
  local caster = self:GetCaster()
  local caster_point = caster:GetAbsOrigin()
  local target_point = self:GetCursorPosition()
  local skill_level = self:GetLevel()
  caster:EmitSound("Hero_Kunkka.Tidebringer.Attack")
  local angleBetweenCasterAndTarget = (target_point - caster_point):Normalized()--goc
  local tempPoint = RotatePosition(caster_point,QAngle(0,90,0),target_point)
  local point_2 = (tempPoint-caster_point):Normalized()
   local sword_range = SETTING_SWORD_FLY_SPEED/SETTING_SWORD_FLY_TIME

  -- HYDRO PULSE
local basic_damage = 0.5+0.015*skill_level
local element_damage_min = 432+36*skill_level
local element_damage_max = 528+44*skill_level
local chance_to_slow = 0.15+0.035*skill_level
local slow_time = 2.5
local max_target = 5
  
   local damageData = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
   local damageInfo = DamageHandler:GetDamage(damageData)
   local critInfo = DamageHandler:GetCritInfo(caster)
   for i=1,5 do
    
    local sword_start = caster_point+math.pow(-1,i)*SETTING_SWORD_DISTANCE_BETWEEN_SWORD*math.floor(i/2)*point_2
    local sword_target = sword_start+sword_range*angleBetweenCasterAndTarget
    sword_start = sword_start-20*angleBetweenCasterAndTarget
    
    Projectiles:CreateProjectile( {
        EffectName      = SETTING_KNMD_EFFECT,
        Ability         = self,
        vSpawnOrigin    = sword_start,
        fDistance     = sword_range,
        fStartRadius    = SETTING_SWORD_DISTANCE_BETWEEN_SWORD*0.5,
        fEndRadius      = SETTING_SWORD_DISTANCE_BETWEEN_SWORD*0.5,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = 0.8,--GameRules:GetGameTime() +100,--

      GroundBehavior = PROJECTILES_NOTHING,
      UnitBehavior  = PROJECTILES_NOTHING,
      vVelocity     = angleBetweenCasterAndTarget*SETTING_SWORD_FLY_SPEED,--angleBetweenCasterAndTarget,
      bProvidesVision   = true,
      numHit  = 0,
      iVisionRadius   = 200,
      knmd = 2,
      maxTarget = max_target,
      damage = damageInfo,
      crit = critInfo,
      effect = EFFECT_SLOW,
      effect_chance = chance_to_slow*10,
      effect_time = slow_time,
      iVisionTeamNumber = caster:GetTeamNumber(),
      UnitTest = GeneralUnitTest,
      OnUnitHit = function(proj,unit)
        DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)

          local hit_effect = ParticleManager:CreateParticle(SETTING_KNMD_HIT_EFFECT, PATTACH_POINT, unit)
          ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))          
          proj.numHit = proj.numHit+1
          local multipler = SETTING_SWORD_PIERCE_MULTIPLER*(math.min(SETTING_SWORD_PIERCE_MULTIPLER_MAX,proj.numHit)-1)
          --Say(nil,"Multipler : "..proj.numHit.." = "..multipler,false)
          unit:EmitSound("Hero_Kunkka.TidebringerDamage")

          
          DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WATER,{action="multiple_damage",value=1+multipler})
          StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
        end})
      end})
    
  
    
   end
 end