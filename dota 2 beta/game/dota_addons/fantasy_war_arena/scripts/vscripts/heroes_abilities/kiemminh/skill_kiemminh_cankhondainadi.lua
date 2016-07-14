skill_kiemminh_cankhondainadi = class({})
--------------------------------------------------------------------------------

SETTING_SKILL_MODIFIER = "modifier_kiemminh_cankhondainadi"
SETTING_DEBUFF_RADIUS = 480
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_kiemminh_cankhondainadi:GetCooldown()
  if(self:GetCaster():HasModifier("modifier_kiemminh_thanhhoalenhphap")) then
     local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
     return 1/atk_perseconds
  end
  if(self:GetCaster():GetLevel()>=25)then
    return 105-6*self:GetLevel()
  end
  return 120-6*self:GetLevel()
end
function skill_kiemminh_cankhondainadi:GetManaCost()
  return 200+60*self:GetLevel()
end
function skill_kiemminh_cankhondainadi:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
	return true
end
function skill_kiemminh_cankhondainadi:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()
  local caster_position = caster:GetAbsOrigin()
	local hTarget = self:GetCursorTarget()
	local cast_point = self:GetCursorPosition()

  -- DISPEL
local buff_negate_duration = 15+9*skill_level
local max_buff_negate = 0+1*skill_level
local negate_chance = (0.35+0.11*skill_level)*100
  if(IsServer())then
    local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_DEBUFF_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
    if #enemies > 0 then
      caster:EmitSound("Hero_Nevermore.Shadowraze")
      for _,enemy in pairs(enemies) do
          if(math.random(0,100)<negate_chance)then
            local buff_list = {}
            local buff_negate_count = max_buff_negate
            local buff_current = enemy:FindAllModifiers()
            enemy.cankhondainadi_bufflist = {}
            for _,modifier in ipairs(buff_current) do
              if(buff_negate_count>0)then
                --kemPrint("Checking "..modifier:GetName())
                if(modifier.IsPurgable)then
                  --kemPrint("have isPurgable")
                  if(modifier:IsPurgable() and not modifier:IsDebuff() and not modifier:IsHidden())then
                    buff_negate_count = buff_negate_count-1
                    local tempModifierName = modifier:GetName()
                    --kemPrint("Removing "..tempModifierName)
                   
                    enemy:RemoveModifierByName(tempModifierName)
                    --table.insert(buff_list,tempModifierName)   
                  end
                end
                      
              end  
            end
            --PrintTable(buff_list)
            enemy.cankhondainadi_bufflist = buff_list
            enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = buff_negate_duration } )
            
          end
          --StatusEffectHandler:ApplyEffect(caster,enemy,EFFECT_PARALIZED,paralyzed_chance*100,paralyzed_duration)
          
          --enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = duration } )
      end
    end
  end

end