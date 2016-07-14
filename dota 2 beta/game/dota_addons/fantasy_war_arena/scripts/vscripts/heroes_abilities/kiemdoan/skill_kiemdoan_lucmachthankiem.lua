skill_kiemdoan_lucmachthankiem = class({})

require('heroes_abilities/kiemdoan/kiemdoan')

function skill_kiemdoan_lucmachthankiem:GetCooldown()
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  --return 10
  return 1/atk_perseconds
end

function skill_kiemdoan_lucmachthankiem:OnAbilityPhaseStart()
  --self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_ATTACK,atk_perseconds)
  return true
end

function skill_kiemdoan_lucmachthankiem:OnSpellStart()


  local caster = self:GetCaster()
  local skill_level = self:GetLevel()
  local target_point = self:GetCursorPosition()
  local target = self:GetCursorTarget()
  if(target)then
    CastLucMachThanKiem(caster,target,nil,self,skill_level)
  else
    CastLucMachThanKiem(caster,nil,target_point,self,skill_level)
  end
  
  
 end