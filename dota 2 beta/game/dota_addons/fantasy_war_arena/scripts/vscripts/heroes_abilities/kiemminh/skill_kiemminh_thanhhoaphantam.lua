skill_kiemminh_thanhhoaphantam = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_POISON_TICK = 4
SETTING_POISON_TIME_BETWEEN_TICK = 0.5
SETTING_EFFECT = "particles/edited_particle/kiem_minh/thanhhoaphantam.vpcf"
function skill_kiemminh_thanhhoaphantam:GetCooldown()
  --if mttc then return 0.5
  if(self:GetCaster():HasModifier("modifier_kiemminh_thanhhoalenhphap")) then
     local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
     return 1/atk_perseconds
  end
  if(HasBook(self:GetCaster()))then
    return 0.5
  end
  return 2
end

function skill_kiemminh_thanhhoaphantam:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1)
	return true
end
function skill_kiemminh_thanhhoaphantam:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*2
end
function skill_kiemminh_thanhhoaphantam:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel() + GetSkillLevel(caster)
  local caster_position = caster:GetAbsOrigin()
	local hTarget = self:GetCursorTarget()
	local cast_point = self:GetCursorPosition()
  caster:EmitSound("Hero_DeathProphet.Exorcism.Damage")
	local pfx =ParticleManager:CreateParticle(SETTING_EFFECT,PATTACH_WORLDORIGIN,caster)
  ParticleManager:SetParticleControl( pfx, 0, cast_point+Vector(0,0,50))
  --self:PayManaCost()
	--StatusEffectHandler:ApplyEffect(caster,caster,EFFECT_MAIM,100,100)

	-- TOXIC FLAME
local basic_damage = 1
local poison_damage = 37+13*skill_level
local chance_to_weaken = 0.15+0.035*skill_level
local weak_time = 2+0.1*skill_level
local max_target = math.floor(2+0.2*skill_level)
	

	local poison_data = {
    	 whoDealDamage = caster,
    	 byWhichAbility = self,
    	 where   = cast_point,
    	 radius = 120,

    	 damage = poison_damage,
    	 period = 0.5,
    	 duration = 2.1,
    	 maxTarget = max_target,
    	 custom = ""
	}
	--kemPrint("poison damage "..poison_data.damage)
	--kemPrint(DOTA_UNIT_TARGET_MECHANICAL)

	
	local damageData = {
        caster = caster,
        main_magic = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit

        skill_basic_damage_percent = basic_damage,

        element_damage_min = 0,
        element_damage_max = 0
  }
  local critInfo = DamageHandler:GetCritInfo(caster)
  local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = cast_point,
        radius = 200,
        crit = critInfo,
        maxTarget = max_target,
        damage = DamageHandler:GetDamage(damageData),        
        damage_element = ELEMENT_WOOD,
         custom = {
          action="status_effect",
          effect_type=EFFECT_WEAK,
          effect_chance=chance_to_weaken*100,
          effect_time=weak_time
        }

      }
	local tick = SETTING_POISON_TICK
	Timers:CreateTimer(function()
	  if(tick>0)then
	     tick = tick -1
	     PoisonHandler:PoisonArea(poison_data) 
       DamageHandler:DamageArea(damageAreaData) 
	     return SETTING_POISON_TIME_BETWEEN_TICK
	  else
	     ParticleManager:DestroyParticle(pfx,true)
	  end    
  end)
	
end