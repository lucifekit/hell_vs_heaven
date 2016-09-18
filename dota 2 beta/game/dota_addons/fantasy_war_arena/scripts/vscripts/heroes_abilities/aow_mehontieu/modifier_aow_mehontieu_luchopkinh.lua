modifier_aow_mehontieu_luchopkinh = class({})
require('kem_lib/kem')
function modifier_aow_mehontieu_luchopkinh:IsHidden()
   return false
end

function modifier_aow_mehontieu_luchopkinh:RemoveOnDeath()
   return true
end

function modifier_aow_mehontieu_luchopkinh:GetEffectName()
   return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf"
end
function modifier_aow_mehontieu_luchopkinh:DeclareFunctions()
local funcs = {
   MODIFIER_EVENT_ON_TAKEDAMAGE
}
return funcs
end

function modifier_aow_mehontieu_luchopkinh:ActiveOnTakeHit(attacker)
    if(IsServer())then
      
       if(attacker.stat_tp)then
          local p = self:GetCaster()
          local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
          local dexterity_multiple = 0.03*skill_level
          local total_dex_multiple = self:GetStackCount()*dexterity_multiple
          local damage = attacker.stat_tp*total_dex_multiple
          if(self:GetParent():IsHero())then
            damage=damage*5
          end
          print("Luc hop kinh damage = "..attacker.stat_tp.."*"..total_dex_multiple.."="..damage)
          DamageHandler:ApplyDamage(
            attacker,
            self:GetAbility(),
            self:GetParent(),
            damage,
            DamageHandler:InitCrit(0,0),
            ELEMENT_METAL,
            {flag="no_director"})
       end
    end
end
