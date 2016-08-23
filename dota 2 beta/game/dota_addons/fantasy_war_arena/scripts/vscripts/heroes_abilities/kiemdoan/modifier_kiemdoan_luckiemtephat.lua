modifier_kiemdoan_luckiemtephat = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_LKTP_EFFECT = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
--SETTING_SKILL_MODIFIER = "modifier_paralized"
SETTING_HEALTH_PROC = 25
SETTING_COOLDOWN = 30
--SETTING_BUFF_MODIFIER  = "modifier_manhan_thucphocchu_active"
--LinkLuaModifier(SETTING_SKILL_MODIFIER,"modifiers/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier(SETTING_BUFF_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_BUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )
--SETTING_EFFECT = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
SETTING_EFFECT_ONHIT = "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf"
function modifier_kiemdoan_luckiemtephat:IsHidden()
  return true
end
function modifier_kiemdoan_luckiemtephat:RemoveOnDeath()
  return false
end

function modifier_kiemdoan_luckiemtephat:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
 
  return funcs
end
function modifier_kiemdoan_luckiemtephat:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.move_speed
end

function modifier_kiemdoan_luckiemtephat:OnTakeDamage(params)
if(IsServer())then
  if(self:GetAbility():IsCooldownReady())then
    local caster = self:GetCaster()
    if(caster:GetHealthPercent()<SETTING_HEALTH_PROC)then
      if(math.random(0,100)<self.proc_chance)then

        self:GetAbility():StartCooldown(SETTING_COOLDOWN)
        local damageData = {
            caster = caster,
            main_magic = caster:GetIntellect(),
            skill_physical_damage_percent = 0,
            skill_tree_amplify_damage = 0,-- can edit
            skill_basic_damage_percent = self.basic_damage,
            element_damage_min = self.damage_min,
            element_damage_max = self.damage_max
            }
        local caster_point = caster:GetOrigin()
        local damageInfo = DamageHandler:GetDamage(damageData)
        local critInfo = DamageHandler:GetCritInfo(caster)
        --Projectiles:CreateProjectile( 
        local missileData = {
            EffectName      = SETTING_LKTP_EFFECT,
            Ability         = self,
            vSpawnOrigin    = caster_point,
            fDistance     = 1200,
            fStartRadius    = 80,
            fEndRadius      = 80,
            Source        = caster,
            bHasFrontalCone   = true,
            bReplaceExisting  = false,
            fExpireTime     = 1,--GameRules:GetGameTime() +100,--
            GroundBehavior = PROJECTILES_NOTHING,
            UnitBehavior  = PROJECTILES_NOTHING,
            --vVelocity     = angleBetweenCasterAndTarget*SETTING_PVBH_FLY_SPEED,--angleBetweenCasterAndTarget,
            bProvidesVision   = true,
            numHit  = 0,
            iVisionRadius   = 200,
            damage = damageInfo,
            crit = critInfo,
            iVisionTeamNumber = caster:GetTeamNumber(),
            UnitTest = GeneralUnitTest,
            OnUnitHit = function(proj,unit)

              unit:EmitSound("Hero_Kunkka.TidebringerDamage")
              DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WATER,{action="lifesteal",value=1})
              local hit_effect = ParticleManager:CreateParticle(SETTING_EFFECT_ONHIT, PATTACH_ABSORIGIN_FOLLOW, unit)
              ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))
              ParticleManager:SetParticleControl( hit_effect, 1, unit:GetAbsOrigin()+Vector(0,0,50))
              
              Timers:CreateTimer(0.5,function() 
                  ParticleManager:DestroyParticle(hit_effect,true)
              end)

              proj:Destroy()              
            end,
            OnFinish = function(proj)
              proj:Destroy()
            end        
          } 
          for i = 1, 6 do
             Timers:CreateTimer(0.25*i,function()
                local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
                     
                if(#unitsToDamage>0)then
                  local vVelocity = (unitsToDamage[1]:GetOrigin()-caster_point):Normalized()*800
                  missileData.vVelocity = vVelocity
                  missileData.numb = i
                  Projectiles:CreateProjectile(missileData)
                end
             
             end)
             
          end
        
  
        
      else

      end
    
    end
    
  end
end
  
end
--------------------------------------------------------------------------------

function modifier_kiemdoan_luckiemtephat:OnCreated( kv )
  -- HEXAGRAM FORCE
--local chance_to_proc = 0.1+0.1*skill_level
--local life_steal = 1
--local basic_damage = 0.5+0.03*skill_level
--local element_damage_min = 520+41*skill_level
--local element_damage_max = 610+52*skill_level
  if(IsServer())then
    local p = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
    self.proc_chance = 10+skill_level*10
    self.damage_min = 520+skill_level*41
    self.damage_max = 610+skill_level*52
    self.basic_damage = 0.5+0.03*skill_level
  end
  

end

--------------------------------------------------------------------------------
function modifier_kiemdoan_luckiemtephat:OnRefresh( kv )
  
if(IsServer())then
    local p = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
    self.proc_chance = 10+skill_level*10
    self.damage_min = 520+skill_level*41
    self.damage_max = 610+skill_level*52
    self.basic_damage = 0.5+0.03*skill_level
  end
end