skill_aow_truyhontrao_thiendiavotinh = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_thiendiavotinh"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_aow_truyhontrao_thiendiavotinh:OnUpgrade()
   local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER, {})
    caster:CalculateStatBonus()
    UpgradeSkill(caster:GetPlayerID())
   --self:PayManaCost()
   --defense
end
