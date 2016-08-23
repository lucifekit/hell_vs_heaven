skill_manhan_madaothonthan = class({})
require('kem_lib/kem')
require('heroes_abilities/manhan/manhan')
SETTING_SKILL_MODIFIER = "modifier_manhan_madaothonthan"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_manhan_madaothonthan:GetManaCost()
  return 500
end

function skill_manhan_madaothonthan:OnSpellStart()
    local caster = self:GetCaster()
    if(caster:HasModifier(SETTING_SKILL_MODIFIER))then
      caster:RemoveModifierByName( SETTING_SKILL_MODIFIER)
    else
      caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{duration=300})
      Timers:CreateTimer(1.5,function()
        CastMDTT(caster,self)
      end)
      
      
    end
end