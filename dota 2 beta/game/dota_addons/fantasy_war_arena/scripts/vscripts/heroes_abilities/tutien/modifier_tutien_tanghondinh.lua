modifier_tutien_tanghondinh = class({})
require('kem_lib/kem')
function modifier_tutien_tanghondinh:IsHidden()
   return false
end

function modifier_tutien_tanghondinh:RemoveOnDeath()
   return false
end

function modifier_tutien_tanghondinh:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_ABILITY_EXECUTED
}
return funcs
end

SETTING_RADIUS = 600
SETTING_DURATION = 15
LinkLuaModifier("modifier_tutien_tanghondinh_allies","heroes_abilities/tutien/modifier_tutien_tanghondinh_allies",LUA_MODIFIER_MOTION_NONE)
function modifier_tutien_tanghondinh:OnAbilityExecuted(params)
    if params.unit == self:GetParent() then
        local ability = params.ability
        local mat_ability = self:GetParent():FindAbilityByName("skill_tutien_meanhtung")
        if params.ability == mat_ability then
           BuffAllies(self:GetParent(),self:GetAbility(),"modifier_tutien_tanghondinh_allies",SETTING_DURATION,self:GetParent():GetOrigin(),SETTING_RADIUS)
        end
    end

    return 0
end

function modifier_tutien_tanghondinh:OnCreated( kv )
end

function modifier_tutien_tanghondinh:OnRefresh( kv )
end
