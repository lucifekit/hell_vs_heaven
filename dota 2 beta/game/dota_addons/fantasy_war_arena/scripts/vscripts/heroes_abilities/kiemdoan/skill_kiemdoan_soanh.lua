skill_kiemdoan_soanh = class({})
require('heroes_abilities/kiemdoan/kiemdoan')
SETTING_BUFF_MODIFIER = "modifier_kiemdoan_soanh"
SETTING_FIND_RADIUS = 300
LinkLuaModifier(SETTING_BUFF_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_BUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )



function skill_kiemdoan_soanh:OnAbilityPhaseStart()
  --self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_ATTACK,atk_perseconds)
  return true
end
function skill_kiemdoan_soanh:OnUpgrade()

  local caster = self:GetCaster()

  caster:AddNewModifier( caster, self,SETTING_BUFF_MODIFIER, {} )
  
end
function skill_kiemdoan_soanh:OnSpellStart()

  local caster = self:GetCaster()  
  local target_point = self:GetCursorPosition()
  local skill_level = self:GetLevel()
  local phongvan_level = caster:GetAbilityByIndex(0):GetLevel()
  local lucmach_level = caster:GetAbilityByIndex(3):GetLevel()
  phongvan_level = math.min(10+skill_level*2,phongvan_level)
  lucmach_level = math.min(10+skill_level*2,lucmach_level)
  local enemies = FindUnitsInRadius(caster:GetTeam(), target_point, nil, SETTING_FIND_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
  if #enemies > 0 then
    local nTarget = math.ceil(skill_level/2)

    for _,enemy in pairs(enemies) do
        if(nTarget>0)then
          nTarget = nTarget-1
          local temp_target_point = enemy:GetOrigin()
          if(phongvan_level>0)then          
            CastPhongVanBienHuyen(caster,temp_target_point,self,phongvan_level)
          end
          if(lucmach_level>0)then
            CastLucMachThanKiem(caster,enemy,nil,self,lucmach_level)
          end
          CastSoAnh(caster,temp_target_point,self,skill_level)
        end
      
      
    end
  end
end