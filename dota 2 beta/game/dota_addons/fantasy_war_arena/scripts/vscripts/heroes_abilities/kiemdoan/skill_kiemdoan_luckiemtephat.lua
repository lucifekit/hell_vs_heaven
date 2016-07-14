skill_kiemdoan_luckiemtephat = class({})


SETTING_SKILL_MODIFIER = "modifier_kiemdoan_luckiemtephat"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )





function skill_kiemdoan_luckiemtephat:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  --caster:AddNewModifier(caster,self,"modifier_datadriven_thucphocchu",{})
  --self:ApplyDataDrivenModifier(caster, caster, "modifier_datadriven_thucphocchu", {})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())
  
end