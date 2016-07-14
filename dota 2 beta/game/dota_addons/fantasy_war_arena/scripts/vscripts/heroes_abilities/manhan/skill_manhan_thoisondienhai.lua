skill_manhan_thoisondienhai = class({})

SETTING_TSDH_NUMBER_OF_FIRES = 1
SETTING_TSDH_DURATION_OF_FIRES = 5

SETTING_TSDH_SKILLCODE = "skill_manhan_thoisondienhai"
SETTING_TSDH_EFFECT = "particles/edited_particle/ma_nhan/thoisondienhai.vpcf"
SETTING_TSDH_EFFECT_MACROPYRE = "particles/edited_particle/ma_nhan/thoisondienhai_macropyre.vpcf"
SETTING_TSDH_SIZE_BETWEEN_FIRE = 100

--------------------------------------------------------------------------------
function skill_manhan_thoisondienhai:GetCooldown()
  --if mttc then return 2
  return 3.5
end

function skill_manhan_thoisondienhai:GetManaCost()
  --if mttc then return 2
  return 20*self:GetLevel()
end

function skill_manhan_thoisondienhai:OnAbilityPhaseStart()
	--self:GetCaster():StartGesture( ACT_DOTA_RAZE_3 )
	local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_RAZE_3,atk_perseconds)
	return true
end
function skill_manhan_thoisondienhai:OnSpellStart()
	self.duration = 10
	self.radius = self:GetSpecialValueFor( "radius" )
	self.vision_range = self:GetSpecialValueFor( "vision_range" )
	local caster = self:GetCaster()
	local skill_level = self:GetLevel()

	kemPrint("Skill level : "..skill_level)
	local caster_position = caster:GetAbsOrigin()
  local target_point = self:GetCursorPosition()
  

		local angle_from_caster_to_target = math.atan2(target_point.y-caster_position.y, target_point.x-caster_position.x ) +math.rad(90)

    
    -- FLAME WALL
local basic_damage = 0.2
local element_damage_min = 134+16*skill_level
local element_damage_max = 145+24*skill_level
local chance_to_burn = 0.15+0.015*skill_level
local burn_time = 2
local max_target = 3
local number_of_fire = 1+1*skill_level
    
    

		local numberOfFire = math.floor(skill_level*0.5+2)
		if (math.fmod(numberOfFire,2)==0) then
			numberOfFire=numberOfFire-1
		end
		
		--effect macropyre
		
		local distance_to_left =  math.pow(-1,numberOfFire-1)*math.floor((numberOfFire-1)/2)*SETTING_TSDH_SIZE_BETWEEN_FIRE
    local tempLeftX = math.cos(angle_from_caster_to_target)*distance_to_left
    local tempLeftY = math.sin(angle_from_caster_to_target)*distance_to_left
		local leftFX = ParticleManager:CreateParticle(SETTING_TSDH_EFFECT_MACROPYRE,PATTACH_WORLDORIGIN,caster)

    ParticleManager:SetParticleControl( leftFX, 0, target_point+Vector(0,0,50))
    ParticleManager:SetParticleControl( leftFX, 1, target_point+Vector(tempLeftX,tempLeftY,50))
    ParticleManager:SetParticleControl( leftFX, 2, Vector(SETTING_TSDH_DURATION_OF_FIRES,0,0))

    
		local distance_to_right =  math.pow(-1,numberOfFire)*math.floor(numberOfFire/2)*SETTING_TSDH_SIZE_BETWEEN_FIRE
    local tempRightX = math.cos(angle_from_caster_to_target)*distance_to_right
    local tempRightY = math.sin(angle_from_caster_to_target)*distance_to_right
    local rightFX = ParticleManager:CreateParticle(SETTING_TSDH_EFFECT_MACROPYRE,PATTACH_WORLDORIGIN,caster)

    ParticleManager:SetParticleControl( rightFX, 0, target_point+Vector(0,0,50))
    ParticleManager:SetParticleControl( rightFX, 1, target_point+Vector(tempRightX,tempRightY,50))
    ParticleManager:SetParticleControl( rightFX, 2, Vector(SETTING_TSDH_DURATION_OF_FIRES,0,0))
    
		
		
		kemPrint("Number of fire "..numberOfFire.." x "..distance_to_left.."x"..tempLeftX.."y"..tempLeftY.." right "..distance_to_right.."x"..tempRightX.."y"..tempRightY)

		local casted_sound = false
		
		--CREATE FIRE DUMMY 
		for i = 1,numberOfFire do
			local distance_to_cast_point =  math.pow(-1,i)*math.floor(i/2)*100
			--Create Particle  
			local tempX = math.cos(angle_from_caster_to_target)*distance_to_cast_point
			local tempY = math.sin(angle_from_caster_to_target)*distance_to_cast_point

			local tempPoint = target_point + Vector(tempX, tempY, 0 )

			--CreateDummyUnit to sound
			
			if casted_sound ==false then
  			local tsdh_dummy_unit = CreateUnitByName("npc_dummy_unit", tempPoint, false, nil, nil, caster:GetTeam())
        tsdh_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
--        local tsdh_unit_ability = tsdh_dummy_unit:FindAbilityByName(SETTING_TSDH_SKILLCODE)
--        if tsdh_unit_ability ~= nil then
--          tsdh_unit_ability:SetLevel(1)
--        --chaos_meteor_unit_ability:ApplyDataDrivenModifier(chaos_meteor_dummy_unit, chaos_meteor_dummy_unit, "modifier_invoker_chaos_meteor_datadriven_unit_ability", {duration = -1})
--        end
			  tsdh_dummy_unit:EmitSound("Hero_Huskar.Burning_Spear")
			  casted_sound=true
			  Timers:CreateTimer({
          endTime = 5,
          callback = function()
          tsdh_dummy_unit:RemoveSelf()
        end
        })
			end
			
			
      
      --DAMAGE
      local damageData = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
      local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = tempPoint,
        radius = 96,
        period = 0.5,
        duration = 5,
        maxTarget = max_target,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_FIRE,
        {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=chance_to_burn*100,
          effect_time=burn_time
        }
      }
      DamageHandler:DamageGroup(damageGroupData)


		end


end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------