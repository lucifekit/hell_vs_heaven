skill_kiemminh_vanvatcauphan = class({})

--------------------------------------------------------------------------------
SETTING_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_VVCP_SOUND_EFFECT = "Hero_Venomancer.PoisonNova"
SETTING_INITIAL_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf"
SETTING_NOVA_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
SETTING_TIME_BETWEEN_PROJ = 0.05
SETTING_NUMBER_PROJ = 8

SETTING_SPEED = 500
SETTING_PROJ_DURATION = 0.6

SETTING_MAX_TARGET = 5
SETTING_POISON_TIME = 2
SETTING_POISON_PERIOD = 0.5
SETTING_RADIUS = 160
function skill_kiemminh_vanvatcauphan:GetCooldown()
  --if mttc then return 1
  if(self:GetCaster():HasModifier("modifier_kiemminh_thanhhoalenhphap")) then
     local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
     return 1/atk_perseconds
  end
  if(self:GetCaster():GetLevel()>=25)then
    return 1
  end
  return 2.5
end
function skill_kiemminh_vanvatcauphan:GetManaCost()
  return self:GetLevel()*10
end
function skill_kiemminh_vanvatcauphan:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2)
	return true
end
function skill_kiemminh_vanvatcauphan:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()
  local caster_position = caster:GetAbsOrigin()
	local hTarget = self:GetCursorTarget()
	local target_point = self:GetCursorPosition()
	local cast_id = DoUniqueString("vvcp")
	local angleBetweenCast = (target_point-caster_position):Normalized()
	local numb_proj = SETTING_NUMBER_PROJ

	
	-- TOXIC BOMB
local basic_damage = 1
local poison_damage = 489+31*skill_level
local chance_to_weaken = 0.15+0.015*skill_level
local weak_time = 2+0.1*skill_level
local max_target = math.floor(2+0.1*skill_level)
local explode_poison = 367+23*skill_level
local explode_max_target = 2
	

	
	--self:PayManaCost()
	local damageData = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit

        skill_basic_damage_percent = basic_damage,

        element_damage_min = 0,
        element_damage_max = 0
        }
   
   local poison_data = {
       whoDealDamage = caster,
       byWhichAbility = self,
       where   = target_point,
       radius = SETTING_RADIUS,

       damage = poison_damage, -- tang 1

       period = SETTING_POISON_PERIOD,
       duration = SETTING_POISON_TIME,
       custom = ""
   }
   local damageAreaData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target_point,
        radius = SETTING_RADIUS,
        damage = DamageHandler:GetDamage(damageData),        
        damage_element = ELEMENT_WOOD,

        maxTarget=max_target,
        custom = {
          action="status_effect",
          effect_type=EFFECT_WEAK,
          effect_chance=chance_to_weaken*100,
          effect_time=weak_time
        }

      }
   local vvcp_dummy_unit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeam())
   vvcp_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
   vvcp_dummy_unit:EmitSoundParams(SETTING_VVCP_SOUND_EFFECT, 1, 0.1, 1)
   local pfx =ParticleManager:CreateParticle(SETTING_INITIAL_EFFECT,PATTACH_WORLDORIGIN,vvcp_dummy_unit)
   ParticleManager:SetParticleControl( pfx, 0, target_point)

   ParticleManager:ReleaseParticleIndex(pfx)

   local pfx2= ParticleManager:CreateParticle(SETTING_NOVA_EFFECT,PATTACH_CUSTOMORIGIN,vvcp_dummy_unit)
   ParticleManager:SetParticleControl( pfx2, 0, target_point)
   ParticleManager:SetParticleControl( pfx2, 1, Vector(1,1,1))
   ParticleManager:SetParticleControl( pfx2, 2, Vector(0,0,0))

   ParticleManager:ReleaseParticleIndex(pfx2)

   --ParticleManager:SetParticleControlEnt(pfx2, 0, vvcp_dummy_unit, PATTACH_POINT_FOLLOW, "attach_origin", vvcp_dummy_unit:GetAbsOrigin(), true)
   PoisonHandler:PoisonArea(poison_data) 
   DamageHandler:DamageArea(damageAreaData) 
   
   Timers:CreateTimer(1,function()
    vvcp_dummy_unit:RemoveSelf()
   end)
   
   
   local damageData2 = {
        caster = caster,
        main_attribute_value = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit

        skill_basic_damage_percent = basic_damage,
        element_damage_min = 0,
        element_damage_max = 0
        }

	
   local my_onFinish = function(proj,pos)
      proj.isDead = true
      proj:Destroy()
      return 
    end
   local critInfo = DamageHandler:GetCritInfo(caster)
	 Timers:CreateTimer(function()
	   if(numb_proj>0) then
	      numb_proj = numb_proj -1
        local tempPoint = RotatePosition(target_point,QAngle(0,numb_proj*360/SETTING_NUMBER_PROJ,0),caster_position)
        local tempAngle = (tempPoint-target_point):Normalized()
        local tempPoint_2 = RotatePosition(target_point,QAngle(0,(numb_proj+1)*360/SETTING_NUMBER_PROJ,0),caster_position)
        local tempAngle2 = (tempPoint_2-tempPoint):Normalized()
        local start_point = target_point+SETTING_RADIUS*tempAngle2
        local projectileInfo = {
              EffectName      = SETTING_EFFECT,
              Ability         = self,
              Source          = caster,
              vSpawnOrigin    = start_point,
              vVelocity       = tempAngle2*SETTING_SPEED,
              
              GroundBehavior  = PROJECTILES_FOLLOW,--ke me ground, co bay vao ground cung ke, nen de la PROJECTILES_FOLLOW
              UnitBehavior    = PROJECTILES_NOTHING,--co va vao unit cung ko chet
              fChangeDelay    = SETTING_SWORD_CHANGE_DELAY, -- cai nay hay, thoi gian de chuyen huong
              fDistance       = SETTING_SPEED*SETTING_PROJ_DURATION, -- di chuyen toi da 1500 pixel
              fExpireTime     = SETTING_PROJ_DURATION, -- thoi gian teo
              fGroundOffset   = 40, -- chi dung voi zCheck, lockGround
              nChangeMax      = 10, -- so lan toi da thay doi huong'
              
              fStartRadius    = 80,
              fEndRadius      = 80,
              
              bGroundLock     = false,--ko lock ground nua ( co the thay doi do cao -- (optional)
              bMultipleHits   = false,--default, ko hit nhieu lan (optional)
              --draw            = true, --default false (optional)
              fRehitDelay     = 10, -- (optional)
              
              
              --bRecreateOnChange = false,
              
              numHit          = 0,

              maxTarget       = explode_max_target,
              damage          = DamageHandler:GetDamage(damageData2),
              crit            = DamageHandler:GetCritInfo(caster),
              poison          = explode_poison,
              period          = SETTING_POISON_PERIOD,
              duration        = SETTING_POISON_TIME,
              effect          = EFFECT_WEAK,
              effect_chance   = chance_to_weaken*100,
              effect_time     = weak_time,

              cast_id         = cast_id.."-"..numb_proj,
              isDead = false,
              iVisionTeamNumber = caster:GetTeamNumber(),
              OnFinish = my_onFinish,
              UnitTest = GeneralUnitTest,
              OnUnitHit = function(proj,unit)
        
              --local hit_effect = ParticleManager:CreateParticle(SETTING_LMTK_HIT_EFFECT, PATTACH_POINT, unit)
              --ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))       
              if(proj.maxTarget>0)then
                proj.maxTarget = proj.maxTarget-1
                --local multipler = SETTING_SWORD_PIERCE_MULTIPLER*(math.min(SETTING_SWORD_PIERCE_MULTIPLER_MAX,proj.numHit)-1)
                --unit:EmitSound("Hero_Kunkka.TidebringerDamage")
               
                
                  DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WOOD,{})
                  PoisonHandler:ApplyPoison(proj.Source,unit,proj.Ability,proj.period,proj.duration,proj.poison,{})
                  StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
              end
              
            end       
            }
        Projectiles:CreateProjectile(projectileInfo)
        return SETTING_TIME_BETWEEN_PROJ
	   end
	 end)
	
end