skill_kiemminh_thauthienhoannhat = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------

SETTING_DEBUFF_RADIUS = 300
SETTING_BUFF_MODIFIER = "modifier_kiemminh_thauthienhoannhat_self"
SETTING_DEBUFF_MODIFIER = "modifier_kiemminh_thauthienhoannhat_enemy"
LinkLuaModifier(SETTING_BUFF_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_BUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(SETTING_DEBUFF_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_DEBUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )
SETTING_SOUND = "Hero_DeathProphet.SpiritSiphon.Cast"
SETTING_EFFECT = "particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf"
function skill_kiemminh_thauthienhoannhat:GetCooldown()  
 if(self:GetCaster():HasModifier("modifier_kiemminh_thanhhoalenhphap")) then
     local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
     return 1/atk_perseconds
  end
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return 60-skill_level*3
end
function skill_kiemminh_thauthienhoannhat:GetManaCost()  
  return 100
end
function skill_kiemminh_thauthienhoannhat:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
	return true
end
function skill_kiemminh_thauthienhoannhat:OnSpellStart()
  local caster = self:GetCaster()
  local skill_level = self:GetLevel() + GetSkillLevel(caster)
  local caster_position = caster:GetAbsOrigin()
	local hTarget = self:GetCursorTarget()
	local cast_point = self:GetCursorPosition()

	
-- SPIRIT SIPHON
local mp_loss = 100+50*skill_level
local debuff_duration = math.floor(2.9+0.21*skill_level)
local mp_regen = 100+50*skill_level
local hp_regen = 100+50*skill_level
local buff_duration = math.floor(4.74+0.526*skill_level)
local max_target = math.floor(1+0.2*skill_level)

local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_DEBUFF_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
caster:EmitSound(SETTING_SOUND)
if #enemies > 0 then
  --EmitSoundOn(SETTING_SOUND,caster)
  
  for _,enemy in pairs(enemies) do
      if(max_target>0)then
        max_target= max_target-1
        enemy:AddNewModifier( self:GetCaster(), self,SETTING_DEBUFF_MODIFIER, { duration = debuff_duration } )
        caster:AddNewModifier( self:GetCaster(), self,SETTING_BUFF_MODIFIER, { duration = buff_duration } )
        
        local pfx =ParticleManager:CreateParticle(SETTING_EFFECT,PATTACH_CUSTOMORIGIN,enemy)
        ParticleManager:SetParticleControl( pfx, 0, enemy:GetAbsOrigin())
        ParticleManager:SetParticleControl( pfx, 5, Vector(math.ceil(debuff_duration),0,0))
        ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(pfx)
        
       
   
      end
  end
end
   

	--self:PayManaCost()
end