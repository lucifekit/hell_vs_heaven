skill_manhan_thienngoailuutinh = class({})

SkillCode = "skill_manhan_thienngoailuutinh"
SETTING_TNLT_EFFECT = "particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf"
SETTING_TNLT_IMPACT_EFFECT = "particles/edited_particle/ma_nhan/thienngoailuutinh.vpcf"
SETTING_TNLT_BURN_EFFECT ="particles/edited_particle/ma_nhan/thienngoailuutinh_ground.vpcf"
SETTING_TNLT_BURN_TIME = 2
SETTING_TNLT_EFFECT_HEIGHT = 1000
SETTING_TNLT_EFFECT_FALLING_TIME = 0.5

function skill_manhan_thienngoailuutinh:GetCooldown()
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  return 1/atk_perseconds
end
function skill_manhan_thienngoailuutinh:GetManaCost()
  --if mttc then return 2
  return 20*self:GetLevel()
end

function skill_manhan_thienngoailuutinh:OnAbilityPhaseStart()
	--self:GetCaster():StartGesture( ACT_DOTA_RAZE_2)
	local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_RAZE_2,atk_perseconds)
	return true
end

function skill_manhan_thienngoailuutinh:OnSpellStart()
	local caster = self:GetCaster()
	local caster_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()
	local skill_level = self:GetLevel()
	local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
	local target_point_temp = Vector(target_point.x, target_point.y, 0)
	
	local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
	local velocity_per_second = point_difference_normalized * 100
	
	caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
  --self:PayManaCost()
	--Create a particle effect consisting of the meteor falling from the sky and landing at the target point.
	local meteor_fly_original_point = (target_point - (velocity_per_second * SETTING_TNLT_EFFECT_FALLING_TIME)) + Vector (0, 0, 1000)  
	--Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
	local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle(SETTING_TNLT_EFFECT, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( chaos_meteor_fly_particle_effect, 0, target_point +Vector(0,0,SETTING_TNLT_EFFECT_HEIGHT))
  ParticleManager:SetParticleControl( chaos_meteor_fly_particle_effect,1, target_point+Vector(0,0,50))
  ParticleManager:SetParticleControl( chaos_meteor_fly_particle_effect, 2, Vector(SETTING_TNLT_EFFECT_HEIGHT/SETTING_TNLT_EFFECT_FALLING_TIME,0,0) )
	
	--Chaos Meteor's main and burn damage is dependent on the level of Exort.  This values are stored now since leveling up Exort while the meteor is in midair should have no effect.
	
	--Spawn the rolling meteor after the delay.
	Timers:CreateTimer({
		endTime = SETTING_TNLT_EFFECT_FALLING_TIME,
		callback = function()
		  ParticleManager:DestroyParticle(chaos_meteor_fly_particle_effect,true)
		  
		  -- METEOR CALLDOWN
local basic_damage = 0.58+0.03*skill_level
local element_damage_min = 450+45*skill_level
local element_damage_max = 550+55*skill_level
local chance_to_burn = 0.15+0.015*skill_level
local burn_time = 2
local ground_basic_damage = 0.06+0.005*skill_level
local ground_damage_min = 90+9*skill_level
local ground_damage_max = 108+12*skill_level
local ground_chance_to_burn = 0.05+0.02*skill_level
local ground_burn_time = 0.5
local max_target = 7
		  
		  --DAMAGE TANG 1
      local damage1Data = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
      local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target_point,
        radius = 200,
        damage = DamageHandler:GetDamage(damage1Data),
        damage_element = ELEMENT_FIRE,
        custom = {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=chance_to_burn*100,
          effect_time=burn_time
        }
      }
      DamageHandler:DamageArea(damageAreaData)
		  
		  
		  
		  
		  
		  
		  -----------------------------------------------
		  --
		  --
		  --
		  --
		  -------------------------------------------
		  local chaos_meteor_impact_effect = ParticleManager:CreateParticle(SETTING_TNLT_IMPACT_EFFECT, PATTACH_ABSORIGIN, caster)
      ParticleManager:SetParticleControl( chaos_meteor_impact_effect, 0, target_point+Vector(0,0,50))
      
      Timers:CreateTimer({
                  endTime = 2,
                  callback = function()
                    ParticleManager:DestroyParticle(chaos_meteor_impact_effect,true)
                  end
                })
                
      local chaos_meteor_burn_effect = ParticleManager:CreateParticle(SETTING_TNLT_BURN_EFFECT, PATTACH_ABSORIGIN, caster)
      ParticleManager:SetParticleControl( chaos_meteor_burn_effect, 0, target_point+Vector(0,0,50))
      
      Timers:CreateTimer({
                  endTime = SETTING_TNLT_BURN_TIME,
                  callback = function()
                    ParticleManager:DestroyParticle(chaos_meteor_burn_effect,true)
                  end
                })
      --DAMAGE TANG 2
      local damageData = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = ground_basic_damage,
        element_damage_min = ground_damage_min,
        element_damage_max = ground_damage_max
        }
      local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target_point,
        radius = 200,
        period = 0.2,
        duration = 2,
        maxTarget = max_target,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_FIRE,
        custom = {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=ground_chance_to_burn*100,
          effect_time=ground_burn_time
        }
      }
      DamageHandler:DamageGroup(damageGroupData)
		end
	})
end