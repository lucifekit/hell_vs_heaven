function skill_manhan_thucphocchu_onTakeDamage(event)

  kemPrint("datadriven take damage thucphocchu")
  PrintTable(event)
end
function skill_manhan_thucphocchu_onUpgrade(event)
  kemPrint("Upgrade")
  local caster = event.caster
  local ability = event.ability
  kemPrint("Upgrading "..ability:GetAbilityName())
  ability:ApplyDataDrivenModifier(caster, caster, "modifier_datadriven_thucphocchu", {})
  kemPrint("Added modifier")

end

SETTING_MDTT_EFFECT = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
SETTING_MDTT_EFFECT_2 = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
function CastMDTT(caster,ability)

  local caster_point = caster:GetOrigin()
  local caster_angle = caster:GetForwardVector()
  local caster_forward_point = caster_point +150*caster_angle
  local skill_level = ability:GetLevel()
  -- SOUL REVENGE
local basic_damage = 0.05+0.01*skill_level
local element_damage_min = 100+7*skill_level
local element_damage_max = 125+10*skill_level
local life_steal = 0.01+0.01*skill_level
  
  caster:EmitSound("Hero_Nevermore.ROS_Flames")
  for i = 0,5 do
      local rotate_angle = math.pow(-1,i)*math.ceil(i/2)
      
      local temp_angle = RotateVector2D(caster_angle,math.rad(rotate_angle*22.5)):Normalized()

      --kemPrint(temp_angle)
      local target_point = temp_angle*800
      --kemPrint("Create "..i)

      --local p = ParticleManager:CreateParticle(SETTING_EFFECT_2,PATTACH_POINT,caster)
      --ParticleManager:SetParticleControl( p, 0, caster_point)
      --ParticleManager:SetParticleControl( p, 1, temp_angle*800)
      --ParticleManager:SetParticleControl( p, 2, Vector(0,1,0))
      --ParticleManager:SetParticleControl( p, 3, Vector(0,0,0))
    
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
      Projectiles:CreateProjectile( {
          EffectName      = SETTING_MDTT_EFFECT_2,
          ControlPoints   = {[1]=target_point,[2]=Vector(0,1,0)},
          Ability         = ability,
          vSpawnOrigin    = caster_point,
          fDistance     = 800,
          fStartRadius    = 80,
          fEndRadius      = 80,
          Source        = caster,
          bHasFrontalCone   = true,
          bReplaceExisting  = false,
          fExpireTime     = 1,          
          GroundBehavior = PROJECTILES_NOTHING,
          UnitBehavior  = PROJECTILES_NOTHING,
          vVelocity     = temp_angle*800,--angleBetweenCasterAndTarget,
          bProvidesVision   = true,
          iVisionRadius   = 200,
          iVisionTeamNumber = caster:GetTeamNumber(),
          damage          =   damageInfo,
          crit            =   critInfo,
          UnitTest = GeneralUnitTest,
          OnUnitHit       = function(proj,unit)
            DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
              --unit:EmitSound("Hero_Kunkka.TidebringerDamage")
              local lifeStealValue = life_steal
              DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_FIRE,{action="lifesteal",value=lifeStealValue})
--              local hit_effect = ParticleManager:CreateParticle(SETTING_PVBH_HIT_EFFECT, PATTACH_ABSORIGIN_FOLLOW, unit)
--              ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
--              ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
--              Timers:CreateTimer(0.5,function() 
--                  ParticleManager:DestroyParticle(hit_effect,true)
--              end)
--              StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            end})
          end
        
          
        })
  
  end
end