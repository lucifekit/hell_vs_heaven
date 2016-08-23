skill_daocon_hoiphongphatlieu = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
require('heroes_abilities/daocon/daocon')
function skill_daocon_hoiphongphatlieu:GetManacost()
   return 300
end

function skill_daocon_hoiphongphatlieu:GetCooldown()
   return 30
end

function skill_daocon_hoiphongphatlieu:OnAbilityPhaseStart()
   local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
   self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,atk_perseconds)
   return true
end

function skill_daocon_hoiphongphatlieu:OnSpellStart()
   local caster = self:GetCaster()
   local target_point = self:GetCursorPosition()
   CastHoiPhongPhatLieu(caster,target_point)       
end
