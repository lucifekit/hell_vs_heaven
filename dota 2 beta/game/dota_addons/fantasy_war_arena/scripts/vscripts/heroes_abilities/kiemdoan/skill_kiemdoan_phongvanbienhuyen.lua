skill_kiemdoan_phongvanbienhuyen= class({})
require('kem_lib/kem')
require('heroes_abilities/kiemdoan/kiemdoan')

function skill_kiemdoan_phongvanbienhuyen:GetCooldown()
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  return 1/atk_perseconds
end
function skill_kiemdoan_phongvanbienhuyen:GetManaCost()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*5
end
function skill_kiemdoan_phongvanbienhuyen:OnAbilityPhaseStart()
  --self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
  local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_ATTACK,atk_perseconds)
  return true
end

function skill_kiemdoan_phongvanbienhuyen:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel() + GetSkillLevel(caster)
  local target_point = self:GetCursorPosition()
  CastPhongVanBienHuyen(caster,target_point,self,skill_level)
 end