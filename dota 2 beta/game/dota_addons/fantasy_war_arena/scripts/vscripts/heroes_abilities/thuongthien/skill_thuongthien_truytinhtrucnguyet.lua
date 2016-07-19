skill_thuongthien_truytinhtrucnguyet = class({})
SETTING_SKILL_MODIFIER = "modifier_thuongthien_truytinhtrucnguyet"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/thuongthien/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_DEBUFF_RADIUS = 120
--SETTING_SPEAR_EFFECT = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
SETTING_SPEAR_EFFECT = "particles/edited_particle/thuong_thien/tttn.vpcf"
SETTING_IMPACT_EFFECT = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_target_explodes.vpcf"
SETTING_IMPACT_EFFECT_2 = "particles/units/heroes/hero_phantom_lancer/phantom_lancer_deathflash.vpcf"

function skill_thuongthien_truytinhtrucnguyet:GetManaCost()
   return 25+2*self:GetLevel()
end

function skill_thuongthien_truytinhtrucnguyet:GetCooldown()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   local cd = 1 / atk_perseconds
   return cd
end

function skill_thuongthien_truytinhtrucnguyet:OnAbilityPhaseStart()

   --kemPrint("Casting TTTN")
   self:GetCaster():AddNewModifier(self:GetCaster(),self,SETTING_SKILL_MODIFIER,{duration=0.3})
   --kemPrint("Added")

   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,math.min(2,atk_perseconds))   
   return true
end

function skill_thuongthien_truytinhtrucnguyet:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()   
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local castAngle = caster:GetAngles()
   local angleBetweenCasterAndTarget = (target_point-caster_position):Normalized()

   local unit = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)
   --self:PayManaCost()
   --unit:AddNewModifier(caster,self,"modifier_maim",{})
   --
   unit:AddAbility("dummy_unit")
   unit:FindAbilityByName("dummy_unit"):SetLevel(1)
   unit:SetRenderAlpha(1)
   unit:SetRenderColor(255,255,100)
   unit:SetRenderMode(5)
   unit:SetAngles(castAngle.x,castAngle.y,castAngle.z)
   unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)   
   unit:MakeIllusion()
   Timers:CreateTimer(0.3,function()
    unit:RemoveSelf()
   end)
-- RAPID STRIKE
local physical_damage_amplify = 0.82+0.05*skill_level
local element_damage_min = 403+24*skill_level
local element_damage_max = 493+30*skill_level
local basic_damage = 0.45+0.02*skill_level
local chance_to_maim = 0.15+0.015*skill_level
local maim_time = 1
local max_target = 3

  local damageData = {
        caster = caster,
        main_attribute_value = caster:GetAgility(),
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min =element_damage_min,
        element_damage_max = element_damage_max
        }

  local damage = DamageHandler:GetDamage(damageData)
  local critInfo = DamageHandler:GetCritInfo(caster)
  --sound
  caster:EmitSound("Ability.static.start")
  --effect
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
        damage          = damage,
        crit            = critInfo,
        UnitTest = GeneralUnitTest,
        targetAllow = max_target,

        effect  = EFFECT_MAIM,
        effect_time = maim_time,
        effect_chance = chance_to_maim*100,
        OnUnitHit = function(proj,unit)
           kemPrint("hit")
           if(proj.targetAllow>0) then
             proj.targetAllow = proj.targetAllow-1
             --damage
             --kemPrint(proj.targetAllow.." applying damage to "..unit:GetUnitName())
             DamageHandler:ApplyDamage(caster,self,unit,proj.damage,proj.crit,ELEMENT_METAL,{})
             StatusEffectHandler:ApplyEffect(caster,unit,proj.effect,proj.effect_chance,proj.effect_time)

             
             --fx
             local pfx =ParticleManager:CreateParticle(SETTING_IMPACT_EFFECT,PATTACH_WORLDORIGIN,caster)
             ParticleManager:SetParticleControl( pfx, 0, unit:GetAbsOrigin())
             local pfx2 =ParticleManager:CreateParticle(SETTING_IMPACT_EFFECT_2,PATTACH_WORLDORIGIN,caster)
             ParticleManager:SetParticleControl( pfx2, 0, unit:GetAbsOrigin()+Vector(0,0,50))
             Timers:CreateTimer(0.1,function()
              ParticleManager:DestroyParticle(pfx,true)
              ParticleManager:DestroyParticle(pfx2,true)
             end)
           end
        end
      } )
  
end

