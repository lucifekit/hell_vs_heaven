skill_aow_truyhontrao_huyetvutinhphong = class({})
require('kem_lib/kem')
SETTING_EFFECT = ""
SETTING_FLY_TIME = 0.5 
SETTING_FLY_SPEED = 400 
SETTING_CAST_SOUND = ""
SETTING_HIT_SOUND = ""
SETTING_SKILL_MODIFIER = "modifier_aow_truyhontrao_huyetvutinhphong"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/aow_truyhontrao/"..SETTING_SKILL_MODIFIER,LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function skill_aow_truyhontrao_huyetvutinhphong:GetManaCost()
   local caster=self:GetCaster()
   local skill_level=self:GetLevel()+GetSkillLevel(caster)
   return 25+skill_level*10
end

function skill_aow_truyhontrao_huyetvutinhphong:GetCooldown()
    return 5
end

function skill_aow_truyhontrao_huyetvutinhphong:ActiveOnHit(target)
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  local multiplier_buff_name = "modifier_aow_truyhontrao_bleed"
  if(target:HasModifier(multiplier_buff_name))then
    local modifier = target:FindModifierByName(multiplier_buff_name)
    if(modifier)then
      local sc = modifier:GetStackCount()
      sc = math.min(20,sc)
      local multiplier = (0.01*skill_level)*sc
      local physical_damage_amplify = 0.5
      local basic_damage = multiplier
      local element_damage_min=(25+2*skill_level)*sc
      local element_damage_max=element_damage_min
      
      print("HTTP basic = "..multiplier.." element="..element_damage_max)
      local damageData = {
        caster = caster,
        main_attribute_value = caster:GetAgility(), 
        skill_physical_damage_percent = physical_damage_amplify,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
      }
      local damageInfo = DamageHandler:GetDamage(damageData)
      local critInfo = DamageHandler:GetCritInfo(caster)
      DamageHandler:ApplyDamage(caster, self, target, damageInfo, critInfo, ELEMENT_METAL, {})
    end
  end
end
function skill_aow_truyhontrao_huyetvutinhphong:OnSpellStart()
   local caster = self:GetCaster()
   local skill_level = self:GetLevel()+GetSkillLevel(caster)
   local caster_position = caster:GetAbsOrigin()
   local hTarget = self:GetCursorTarget()
   local cast_point = self:GetCursorPosition()
   local target_point = self:GetCursorPosition()
   local angleBetweenCasterAndTarget = (target_point - caster_position):Normalized()
   --self:PayManaCost()
   caster:EmitSound(SETTING_CAST_SOUND)
   caster:AddNewModifier(caster,self,SETTING_SKILL_MODIFIER,{duration=0.25*8})
   
end
