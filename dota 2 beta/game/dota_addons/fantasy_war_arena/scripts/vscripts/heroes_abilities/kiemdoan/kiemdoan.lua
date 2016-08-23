

--SETTING PHONG VAN BIEN HUYEN

--SETTING_PVBH_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_phongvanbienhuyen.vpcf"
SETTING_PVBH_EFFECT = "particles/edited_particle/kiem_doan/fx_wyvern.vpcf"
--SETTING_PVBH_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_blue.vpcf"
SETTING_PVBH_HIT_EFFECT = "particles/edited_particle/kiem_doan/fx_phongvanbienhuyen_hit.vpcf"
--SETTING_PVBH_EFFECT = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
SETTING_PVBH_FLY_TIME = 1
SETTING_PVBH_FLY_SPEED = 700

function CastPhongVanBienHuyen(caster,target_point,ability,skill_level)
  local caster_point = caster:GetAbsOrigin()
  local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
  local target_point_temp = Vector(target_point.x, target_point.y,0)
  local angleBetweenCasterAndTarget = (target_point_temp - caster_point_temp):Normalized()
  
-- ICE SHARD
local basic_damage = 1+0.025*skill_level
local element_damage_min = 0+60*skill_level
local element_damage_max = 0+75*skill_level
local chance_to_slow = 0.15+0.035*skill_level
local slow_time = 2.5
local max_target = 3

  local damageData = {
        caster = caster,
        main_magic = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
  local damageInfo = DamageHandler:GetDamage(damageData)
  local critInfo = DamageHandler:GetCritInfo(caster)
  Timers:CreateTimer(0.3,function()
  Projectiles:CreateProjectile( {
        EffectName      = SETTING_PVBH_EFFECT,
        Ability         = ability,
        vSpawnOrigin    = caster_point,
        fDistance     = SETTING_PVBH_FLY_TIME*SETTING_PVBH_FLY_SPEED,
        fStartRadius    = 80,
        fEndRadius      = 80,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_PVBH_FLY_TIME,--GameRules:GetGameTime() +100,--
      
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*SETTING_PVBH_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit = critInfo,
        effect = EFFECT_SLOW,
        effect_chance = chance_to_slow*100,
        effect_time = slow_time,
        maxTarget = max_target,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WATER,{})
            local hit_effect = ParticleManager:CreateParticle(SETTING_PVBH_HIT_EFFECT, PATTACH_ABSORIGIN_FOLLOW, unit)
            ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
            ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
            Timers:CreateTimer(0.5,function() 
                ParticleManager:DestroyParticle(hit_effect,true)
            end)
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
          end})
        end
      } )
    
  
  
  end)
  
  
end


--SETTING LUC MACH THAN KIEM

--SETTING_KNMD_EFFECT = "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
--SETTING_KNMD_EFFECT = "models/heroes/bristleback/bristleback_offhand_weapon.vmdl"
SETTING_LMTK_EFFECT_BLUE = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_blue.vpcf"
SETTING_LMTK_EFFECT_GREY = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_grey.vpcf"
SETTING_LMTK_EFFECT_RED = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_red.vpcf"
SETTING_LMTK_EFFECT_YELLOW = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_yellow.vpcf"
SETTING_LMTK_EFFECT_ORANGE = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_orange.vpcf"
SETTING_LMTK_EFFECT_GREEN = "particles/edited_particle/kiem_doan/skill_kiemdoan_lmtk_green.vpcf"
SETTING_LMTK_HIT_EFFECT = "particles/units/heroes/hero_wisp/wisp_tether_hit.vpcf"
--SETTING_KNMD_CASTER_EFFECT = "particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf"


SETTING_LMTK_SWORD_FLY_SPEED =600
SETTING_LMTK_SWORD_FLY_TIME = 1.5
SETTING_LMTK_SWORD_DISTANCE_BETWEEN_SWORD = 100
SETTING_LMTK_SWORD_PIERCE_MULTIPLER = 0.5
SETTING_LMTK_SWORD_CHANGE_DELAY = 0.5
SETTING_LMTK_SWORD_PIERCE_MULTIPLER_MAX = 3

SETTING_LMTK_MAX_TARGET = 5


function CastLucMachThanKiem(caster,target,target_point,ability,skill_level)
  local caster_point = caster:GetAbsOrigin()
  
  if(target)then
    target_point=target:GetOrigin()
  end
  caster:EmitSound("Hero_Kunkka.Tidebringer.Attack")
  local angleBetweenCasterAndTarget = (target_point - caster_point):Normalized()--goc
 
  local sword_range = SETTING_LMTK_SWORD_FLY_SPEED/SETTING_LMTK_SWORD_FLY_TIME
  local effect_color = {
    SETTING_LMTK_EFFECT_YELLOW,--thieu thuong kiem - trong thuong
    SETTING_LMTK_EFFECT_BLUE,--trung xung kiem - lam cham
    SETTING_LMTK_EFFECT_GREY,--thieu trach kiem
    SETTING_LMTK_EFFECT_RED,--thuong duong kiem -- bong
    SETTING_LMTK_EFFECT_GREEN,--quan xung kiem -- yeu
    SETTING_LMTK_EFFECT_ORANGE,--thieu xung kiem -- choang
    
  }
  
  -- RAINBOW BEAM
local basic_damage = 0.22+0.01*skill_level
local element_damage_min = 300+17*skill_level
local element_damage_max = 374+20*skill_level
local ultima_basic_damage = 0.27+0.015*skill_level
local ultima_damage_min = 381+20*skill_level
local ultima_damage_max = 465+25*skill_level
local chance_to_maim = 0.05+0.01*skill_level
local maim_time = 1
local chance_to_slow = 0.15+0.035*skill_level
local slow_time = 2.5
local chance_to_burn = 0.05+0.005*skill_level
local burn_time = 2+0.1*skill_level
local chance_to_weaken = 0.05+0.005*skill_level
local weak_time = 2+0.1*skill_level
local chance_to_stun = 0.05+0.005*skill_level
local stun_time = 1
  
  
  
  --thieu thuong kiem + trung xung kiem
   local damageData = {
        caster = caster,
        main_magic = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
    local damageInfo = DamageHandler:GetDamage(damageData)
    --thieu trach kiem
     local damageData2 = {
        caster = caster,
        main_magic = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = ultima_basic_damage,
        element_damage_min = ultima_damage_min,
        element_damage_max = ultima_damage_max
        }
    local damageInfo2 = DamageHandler:GetDamage(damageData)
    
    
    local noDamage = DamageHandler:NoDamage()
    --thong so cac kiem
    local damage          =   {damageInfo,                damageInfo,     damageInfo2,            noDamage,           noDamage,               noDamage}
    local effect          =   {EFFECT_MAIM,               EFFECT_SLOW,    EFFECT_NONE,          EFFECT_BURN,        EFFECT_WEAK,           EFFECT_STUN}
    local effect_chance   =   {chance_to_maim*100, chance_to_slow*100,              0,  chance_to_burn*100,  chance_to_weaken*100,  chance_to_stun*100}
    --effect_chance         =   {100,0,0,0,0,0}           
    local effect_time     =   {maim_time,                 slow_time,                0,            burn_time,            weak_time,           stun_time}
    --tac dong len nhung unit nay
    local lmtk_unitTest = GeneralUnitTest
    --caster:AddNewModifier( caster, caster,EFFECT_WEAK, { duration = 100 } )
    --khi ket thuc
    local lmtk_onFinish = function(proj,pos)
      proj.isDead = true
      proj:Destroy()
      return 
    end
    local critInfo = DamageHandler:GetCritInfo(caster)
    for i=0,5 do
      
      --cai thu 1 se la 0
      --cai thu 2 se la 0.3
      --cai thu 3 se la 0.6
      ----
      --
      --                |
      --                |
      --
      --              |
      --              |
      --
      --                  |
      --                  ||
      --                   |
      --                
      --              |
      --              ||
      --               |
      --
      -- cai 1, 6 se o origin
      -- cai 2,5 se o left
      -- cai 3,4 se o right
      --
      ------------------------------------
      --
      --
      local timeBetweenSword = 0.25
      local timeAppear = i*timeBetweenSword
      if(i==3) then timeAppear = 2*timeBetweenSword+0.1 end
      if(i==4) then timeAppear = 3*timeBetweenSword end
      if(i==5) then timeAppear = 3*timeBetweenSword+0.1 end
    Timers:CreateTimer(timeAppear,function()
        local rotatePoint = 0
        local sword_start = caster_point
        if(i==1 or i==4) then
          local tempPoint = RotatePosition(caster_point,QAngle(0,60,0),target_point)
          local tempAngle = (tempPoint-caster_point):Normalized()
          sword_start = caster_point+60*tempAngle  
        else
          if(i==2 or i==3) then
            local tempPoint = RotatePosition(caster_point,QAngle(0,-60,0),target_point)
            local tempAngle = (tempPoint-caster_point):Normalized()
            sword_start = caster_point+(60+(i-2)*20)*tempAngle
          end
        end
        

        
        local projectileInfo = {
              EffectName      = effect_color[i+1],
              Ability         = ability,
              Source          = caster,
              vSpawnOrigin    = sword_start,
              vVelocity       = angleBetweenCasterAndTarget*SETTING_LMTK_SWORD_FLY_SPEED,
              
              GroundBehavior  = PROJECTILES_FOLLOW,--ke me ground, co bay vao ground cung ke, nen de la PROJECTILES_FOLLOW
              UnitBehavior    = PROJECTILES_NOTHING,--co va vao unit cung ko chet
              fChangeDelay    = SETTING_LMTK_SWORD_CHANGE_DELAY, -- cai nay hay, thoi gian de chuyen huong
              fDistance       = SETTING_LMTK_SWORD_FLY_SPEED*SETTING_LMTK_SWORD_FLY_TIME, -- di chuyen toi da 1500 pixel
              fExpireTime     = SETTING_LMTK_SWORD_FLY_TIME, -- thoi gian teo
              fGroundOffset   = 40, -- chi dung voi zCheck, lockGround
              nChangeMax      = 10, -- so lan toi da thay doi huong'
              
              fStartRadius    = 80,
              fEndRadius      = 80,
              
              bGroundLock     = false,--ko lock ground nua ( co the thay doi do cao -- (optional)
              bMultipleHits   = false,--default, ko hit nhieu lan (optional)
              --draw            = true, --default false (optional)
              fRehitDelay     = 10, -- (optional)
              
              
              --bRecreateOnChange = false,
              
              followTarget    = target,
              numHit          = 0,
              changeTimes     = 5,
              maxTarget       = SETTING_LMTK_MAX_TARGET,
              damage          = damage[i+1],
              crit            = critInfo,
              effect          = effect[i+1],
              effect_chance   = effect_chance[i+1],
              effect_time     = effect_time[i+1],
              
              isDead = false,
              iVisionTeamNumber = caster:GetTeamNumber(),
              OnFinish = lmtk_onFinish,
              UnitTest = lmtk_unitTest           
            }

        projectileInfo.OnUnitHit = function(proj,unit)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            local hit_effect = ParticleManager:CreateParticle(SETTING_LMTK_HIT_EFFECT, PATTACH_POINT, unit)
            ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))       
            --local multipler = SETTING_LMTK_SWORD_PIERCE_MULTIPLER*(math.min(SETTING_LMTK_SWORD_PIERCE_MULTIPLER_MAX,proj.numHit)-1)
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WATER,{})
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
          end})
        end
        
        
        if target then
          local tempProjectile = Projectiles:CreateProjectile( projectileInfo )
          Timers:CreateTimer(SETTING_LMTK_SWORD_CHANGE_DELAY,function()     

            local targetNewPos = target:GetAbsOrigin()
            local myNewPos = tempProjectile.pos--tempProjectile:GetOrigin()
            --PrintTable(tempProjectile)
            if(tempProjectile.isDead==false)then
              tempProjectile:SetVelocity((targetNewPos-myNewPos):Normalized()*SETTING_LMTK_SWORD_FLY_SPEED,myNewPos-angleBetweenCasterAndTarget*50)
            end
            
            
            if(tempProjectile.changes>0)then
              if(tempProjectile.isDead==false)then
                return SETTING_LMTK_SWORD_CHANGE_DELAY
              end
            end
          end)
        else
          Projectiles:CreateProjectile(projectileInfo)
        end
        
    end)
   end
end


SETTING_SOANH_EFFECT = "particles/edited_particle/kiem_doan/skill_kiemdoan_kimngocmanduong.vpcf"
SETTING_SOANH_FLY_TIME = 1
SETTING_SOANH_FLY_SPEED = 800
function CastSoAnh(caster,target_point,ability,skill_level)
  local caster_point = caster:GetAbsOrigin()
  local angleBetweenCasterAndTarget = (target_point - caster_point):Normalized()
  --658-804  940 -1149
  --46% - 66%
  --slow : 45% - 2.5s 
  
  -- ICE ESSENCE
local basic_damage = 0.44+0.05*skill_level
local element_damage_min = 620+70*skill_level
local element_damage_max = 760+86*skill_level
local chance_to_slow = 0.45
local slow_time = 2.5
local chance_to_stack_charge = 0.04
local max_target = 3
local max_level_of_ice_ability = 10+2*skill_level
  
  
  local damageData = {
        caster = caster,
        main_magic = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
  local damageInfo = DamageHandler:GetDamage(damageData)
  local critInfo = DamageHandler:GetCritInfo(caster)
  Projectiles:CreateProjectile( {
        EffectName      = SETTING_SOANH_EFFECT,
        Ability         = ability,
        vSpawnOrigin    = caster_point,
        fDistance     = SETTING_SOANH_FLY_TIME*SETTING_SOANH_FLY_SPEED,
        fStartRadius    = 80,
        fEndRadius      = 80,
        Source        = caster,
        bHasFrontalCone   = true,
        bReplaceExisting  = false,
        fExpireTime     = SETTING_SOANH_FLY_TIME,--GameRules:GetGameTime() +100,--
    
        GroundBehavior = PROJECTILES_NOTHING,
        UnitBehavior  = PROJECTILES_NOTHING,
        vVelocity     = angleBetweenCasterAndTarget*SETTING_SOANH_FLY_SPEED,--angleBetweenCasterAndTarget,
        bProvidesVision   = true,
        numHit  = 0,
        iVisionRadius   = 200,
        damage = damageInfo,
        crit   = critInfo,
        effect = EFFECT_SLOW,
        effect_chance = chance_to_slow*100,
        effect_time = slow_time,
        iVisionTeamNumber = caster:GetTeamNumber(),
        UnitTest = GeneralUnitTest,
        OnUnitHit = function(proj,unit)
          DamageHandler:MissileHandler({attacker=proj.Source,target=unit,projectile=proj,hit_function=function(proj,unit)
            unit:EmitSound("Hero_Kunkka.TidebringerDamage")
            DamageHandler:ApplyDamage(proj.Source,proj.Ability,unit,proj.damage,proj.crit,ELEMENT_WATER,{})
            local hit_effect = ParticleManager:CreateParticle(SETTING_PVBH_HIT_EFFECT, PATTACH_ABSORIGIN_FOLLOW, unit)
            ParticleManager:SetParticleControl( hit_effect, 0, unit:GetAbsOrigin()+Vector(0,0,50))     
            ParticleManager:SetParticleControl( hit_effect, 3, unit:GetAbsOrigin()+Vector(0,0,50))
            StatusEffectHandler:ApplyEffect(proj.Source,unit,proj.effect,proj.effect_chance,proj.effect_time)
            Timers:CreateTimer(0.5,function() 
                ParticleManager:DestroyParticle(hit_effect,true)
            end)
          end})
        end
      } )
end