skill_kiemminh_thanhhoalieunguyen = class({})
--------------------------------------------------------------------------------
SETTING_THLN_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf"
--SETTING_THLN_EXPLODE_EFFECT = "particles/edited_particle/kiem_minh/thanhhoalieunguyen_explode.vpcf"
SETTING_THLN_EXPLODE_EFFECT = "particles/edited_particle/kiem_minh/thanhhoalieunguyen_explode.vpcf"
SETTING_THLN_EFFECT_HEIGHT = 800
SETTING_THLN_EFFECT_FALLING_TIME = 0.8
SETTING_THLN_X_DISTANCE = 140
SETTING_THLN_Y_DISTANCE = 100
SETTING_THLN_SOUND_EXPLODE = "Hero_Venomancer.Attack"
function skill_kiemminh_thanhhoalieunguyen:GetCooldown()
  if(self:GetCaster():HasModifier("modifier_kiemminh_thanhhoalenhphap")) then
     local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
     return 1/atk_perseconds
  end
  return 3.5
end
function skill_kiemminh_thanhhoalieunguyen:GetManaCost()
  return 150+self:GetLevel()*15
end
function skill_kiemminh_thanhhoalieunguyen:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_4)
	return true
end
function skill_kiemminh_thanhhoalieunguyen:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()
  local caster_position = caster:GetAbsOrigin()
	local hTarget = self:GetCursorTarget()
	local target_point = self:GetCursorPosition()
--	kemPrint("Cast 9x")
	local x = {-2,-1,-1,0,0,0,1,1,2}
	local y = {0,1,-1,2,0,-2,1,-1,0}
	--self:PayManaCost()

	-- TOXIC RAIN
local basic_damage = 0.9+0.06*skill_level
local poison_damage = 868+55*skill_level
local chance_to_weaken = 0.25+0.04*skill_level
local weak_time = 4
local radius = 50+5*skill_level
	

	caster:EmitSound("Hero_Sniper.AssassinateProjectile")
	local poison_data = {
       whoDealDamage = caster,
       byWhichAbility = self,
       where   = target_point,

       radius = radius,
       damage = poison_damage ,

       period = 0.5,
       duration = 2.1,
       custom = ""
  }

  local damageData = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit

        skill_basic_damage_percent = basic_damage,

        element_damage_min = 0,
        element_damage_max = 0
  }
  local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target_point,

        radius = radius,
        damage = DamageHandler:GetDamage(damageData),        
        damage_element = ELEMENT_WOOD,
        custom = {
          action="status_effect",
          effect_type=EFFECT_WEAK,
          effect_chance=chance_to_weaken*100,
          effect_time=weak_time
        }

      }
  local hhnp = caster:FindAbilityByName("skill_kiemminh_hoanghoangocphan")
  local hhnp_level = hhnp:GetLevel()
  if(hhnp_level>0) then
       

       poison_data.radius = poison_data.radius +20*hhnp_level
       damageAreaData.radius = damageAreaData.radius+20*hhnp_level
  end
	for i=0,8 do 
	  
	  local cast_where = target_point+Vector(x[i+1]*SETTING_THLN_X_DISTANCE,y[i+1]*SETTING_THLN_Y_DISTANCE,0)
	  local thln_missile = ParticleManager:CreateParticle(SETTING_THLN_EFFECT, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl( thln_missile, 0, cast_where +Vector(0,0,SETTING_THLN_EFFECT_HEIGHT))
    ParticleManager:SetParticleControl( thln_missile,1, cast_where+Vector(0,0,50))
    ParticleManager:SetParticleControl( thln_missile, 2, Vector(SETTING_THLN_EFFECT_HEIGHT/SETTING_THLN_EFFECT_FALLING_TIME,0,0) )
    Timers:CreateTimer(SETTING_THLN_EFFECT_FALLING_TIME,function() 
      ParticleManager:DestroyParticle(thln_missile,true)
      local thln_explode_missile = ParticleManager:CreateParticle(SETTING_THLN_EXPLODE_EFFECT, PATTACH_ABSORIGIN, caster)
      ParticleManager:SetParticleControl( thln_explode_missile, 0, cast_where+Vector(0,0,20) )
      ParticleManager:SetParticleControl( thln_explode_missile, 1, Vector(1,1,1) )
      ParticleManager:SetParticleControl( thln_explode_missile, 2, Vector(0,0,0) )
      --ParticleManager:DestroyParticle(thln_explode_missile,false)
      poison_data.where = cast_where
      PoisonHandler:PoisonArea(poison_data) 
      damageAreaData.where =cast_where
      DamageHandler:DamageArea(damageAreaData) 
      
      
      
      --ParticleManager:SetParticleControl( thln_missile,1, cast_where+Vector(0,0,50))
      --ParticleManager:SetParticleControl( thln_missile, 2, Vector(SETTING_THLN_EFFECT_HEIGHT/SETTING_THLN_EFFECT_FALLING_TIME,0,0) )
    end)
    
	end
	Timers:CreateTimer(SETTING_THLN_EFFECT_FALLING_TIME,function()
	 local sound_unit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeam())
   sound_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
   sound_unit:EmitSound(SETTING_THLN_SOUND_EXPLODE)--, 1, 0.1, 1)
   Timers:CreateTimer(1,function()
   sound_unit:StopSound(SETTING_THLN_SOUND_EXPLODE)
     sound_unit:RemoveSelf()
   end)
	
	end)
	
	
	
  
end