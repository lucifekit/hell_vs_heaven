SETTING_SKILL_MODIFIER = "modifier_daocon_hoiphongphatlieu"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/daocon/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

SETTING_HPPL_EFFECT = "particles/edited_particle/dao_con/hoiphongphatlieu.vpcf"
--C:\Games\Steam\steamapps\common\dota 2 beta\content\dota_addons\fantasy_war_arena\particles\edited_particle\dao_con\hoiphongphatlieu.vpcf
SETTING_HPPL_SOUND_EFFECT = "Hero_Juggernaut.BladeFuryStart"
SETTING_HPPL_PULL_TICK = 6
SETTING_HPPL_PULL_DURATION = 0.2
SETTING_HPPL_TIME_BETWEEN_TICK = 2

function CastHoiPhongPhatLieu(caster,target_point)
  local abi = caster:FindAbilityByName("skill_daocon_hoiphongphatlieu")
  local skill_level = abi:GetLevel()
  if(skill_level==0)then
    return
  end
    
  skill_level = skill_level+GetSkillLevel(caster)
--CreateDummyUnit to cast sound
    local hlph_dummy_unit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeam())
    hlph_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
    hlph_dummy_unit:EmitSoundParams(SETTING_HPPL_SOUND_EFFECT, 1, 0.1, 1)
    
    
    -- WINDSTORM
local pull_radius = 350
local pull_chance = 0.45+0.1*skill_level
local tornado_pull_chance = 0.05+0.01*skill_level
local duration = 5
local max_target = 5
local basic_damage = 1
local physical_amplify = 0.2
    
    
    --if mtcc then duration = 10
    
    local pfx = ParticleManager:CreateParticle(SETTING_HPPL_EFFECT,PATTACH_WORLDORIGIN,caster)
    ParticleManager:SetParticleControl( pfx, 0, target_point+Vector(0,0,50))
    

    
    Timers:CreateTimer({
                endTime = duration,
                callback = function()
                   ParticleManager:DestroyParticle(pfx,true)
                   hlph_dummy_unit:StopSound(SETTING_HPPL_SOUND_EFFECT)
                   hlph_dummy_unit:RemoveSelf()
                  end
                })
    --if mtcc then pull_radius =+200
    local start_time=GameRules:GetGameTime()
    local last_time=0
     local damageData = {
        caster = caster,
        main_physic = caster:GetAgility(),
        skill_physical_damage_percent = physical_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = 0,
        element_damage_max = 0
        }
      local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,
        where = target_point,
        radius = pull_radius,
        period = SETTING_HPPL_TIME_BETWEEN_TICK,
        duration = duration,
        maxTarget = max_target,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_EARTH,
        custom = {}
      }

      --kemPrint("84 : Call damage group")
      DamageHandler:DamageGroup(damageGroupData)
      local pull_data = {
        caster = caster,
        ability = self,
        pull_chance = pull_chance*100,
        pull_point = target_point,
        pull_max_range = 300,
        pull_radius = pull_radius,
        pull_duration = duration,
        pull_step = SETTING_HPPL_TIME_BETWEEN_TICK
      }
      --kemPrint("Vacumming by "..caster:GetUnitName())
      StatusEffectHandler:Pull(pull_data)
          

end