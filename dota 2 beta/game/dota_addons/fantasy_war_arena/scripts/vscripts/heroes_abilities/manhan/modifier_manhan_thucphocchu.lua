modifier_manhan_thucphocchu = class({})
--------------------------------------------------------------------------------
SETTING_SKILL_MODIFIER = "modifier_paralized"
SETTING_BUFF_MODIFIER  = "modifier_manhan_thucphocchu_active"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"modifiers/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(SETTING_BUFF_MODIFIER,"heroes_abilities/manhan/"..SETTING_BUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_EFFECT = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
SETTING_COOLDOWN=30
function modifier_manhan_thucphocchu:IsHidden()
  return true
end
function modifier_manhan_thucphocchu:RemoveOnDeath()
  return false
end

function modifier_manhan_thucphocchu:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
 
  return funcs
end
function modifier_manhan_thucphocchu:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.move_speed
end

function modifier_manhan_thucphocchu:OnTakeDamage(params)
  if(IsServer())then
    if(params.unit==self:GetParent())then
      if(self:GetAbility():IsCooldownReady())then
        if(math.random(0,100)<self.paralyze_chance)then

          self:GetAbility():StartCooldown(SETTING_COOLDOWN)
          local caster = self:GetCaster()
          
           local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
           local tempNumberOfTarget = 5               
           if(#unitsToDamage>0)then
              caster:AddNewModifier( caster, self:GetAbility(),SETTING_BUFF_MODIFIER, { duration = self.speed_duration } )
              caster:EmitSound("Hero_Nevermore.RequiemOfSouls")
              --local leftFX = ParticleManager:CreateParticle(pl[i],PATTACH_WORLDORIGIN,caster)
              --ParticleManager:SetParticleControl( leftFX, 0, cast_point+Vector(math.random(-200,200),math.random(-200,200),50))  
           end
           for _,victim in ipairs(unitsToDamage) do
           
              if(tempNumberOfTarget>0)then            
                victim:AddNewModifier( caster, self:GetAbility(),SETTING_SKILL_MODIFIER, { duration = self.paralyze_duration } )
                tempNumberOfTarget = tempNumberOfTarget-1
              end
              
           end
        else

          --kemPrint("Not happen")  
        end
      else
        --kemPrint("Thuc phoc chu is cooldowning")
      end
    end
    
  end
end
--------------------------------------------------------------------------------

function modifier_manhan_thucphocchu:OnCreated( kv )
  local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
  self.speed = (10+self:GetAbility():GetLevel()*4)*settings.speed_base
  self.paralyze_chance = 3+self:GetAbility():GetLevel()
  self.paralyze_duration = 2+0.2*self:GetAbility():GetLevel()
  self.speed_duration = 5+2*self:GetAbility():GetLevel()
  
  

end

--------------------------------------------------------------------------------
function modifier_manhan_thucphocchu:OnRefresh( kv )
  local settings = CustomNetTables:GetTableValue( "kem_settings", "global")
  self.move_speed = (10+self:GetAbility():GetLevel()*4)*settings.speed_base

  
  self.paralyze_chance = 3+self:GetAbility():GetLevel()
  self.paralyze_duration = 2+0.2*self:GetAbility():GetLevel()
  self.speed_duration = 5+2*self:GetAbility():GetLevel()

end