if not Kem_Attributes then
    Kem_Attributes = class({})
end

function Kem_Attributes:Init()

    local v = LoadKeyValues("scripts/kv/attributes.kv")
    LinkLuaModifier("modifier_movespeed_cap", "modifiers/modifier_movespeed_cap", LUA_MODIFIER_MOTION_NONE)

    -- Default Dota Values
    local DEFAULT_HP_PER_STR = 20
    local DEFAULT_HP_REGEN_PER_STR = 0.03
    local DEFAULT_MANA_PER_INT = 12
    local DEFAULT_MANA_REGEN_PER_INT = 0.04
    local DEFAULT_ARMOR_PER_AGI = 0.14
    local DEFAULT_ATKSPD_PER_AGI = 1
    
    local POINT_PER_STAT = 1
    
    local hp_adjustment = v.HP_PER_STR - DEFAULT_HP_PER_STR
    Kem_Attributes.hp_adjustment = hp_adjustment    
    Kem_Attributes.hp_adjustment_array = {hp_adjustment+2*POINT_PER_STAT,hp_adjustment-1*POINT_PER_STAT,hp_adjustment+1*POINT_PER_STAT,hp_adjustment,hp_adjustment-2*POINT_PER_STAT}
    
    
    
    
    Kem_Attributes.hp_regen_adjustment = v.HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
    
    local mp_adjustment = v.MANA_PER_INT - DEFAULT_MANA_PER_INT
    Kem_Attributes.mana_adjustment = mp_adjustment
    Kem_Attributes.mp_adjustment_array = {mp_adjustment-2*POINT_PER_STAT,mp_adjustment+1*POINT_PER_STAT,mp_adjustment-1*POINT_PER_STAT,mp_adjustment,mp_adjustment+2*POINT_PER_STAT}
    
    
    
    
    Kem_Attributes.mana_regen_adjustment = v.MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
    
    
    
    
    
    Kem_Attributes.armor_adjustment = v.ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
    
    
    
    
    Kem_Attributes.attackspeed_adjustment = v.ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI

    Kem_Attributes.applier = CreateItem("item_stat_modifier", nil, nil)
    Kem_Attributes.applier_add = CreateItem("item_stat_add_modifier", nil, nil)
end

function Kem_Attributes:ModifyBonuses(hero)

    kemPrint("Modifying Stats Bonus of hero "..hero:GetUnitName())


    -- hero:AddNewModifier(hero, nil, "modifier_movespeed_cap", {})
    Timers:CreateTimer(function()

        if not IsValidEntity(hero) then
            return
        end
        local hero_element = hero.element
        -- Initialize value tracking
        if not hero.custom_stats then
        
            hero.custom_stats = true
            hero.strength = 0 -- sinh khi
            hero.agility = 0 -- suc manh
            hero.intellect = 0 -- noi cong
            hero.level = hero:GetLevel()
            if hero_element == 0 then
              kemPrint("MISSING HERO ELEMENT ")
            end
        end

        -- Get player attribute values
        local strength = hero:GetStrength()
        local agility = hero:GetAgility()
        local intellect = hero:GetIntellect()
        local level = hero:GetLevel()
        local leveled_up = false
        if(level>hero.level)then

          --kemPrint("86 Leveled up")
          leveled_up = true
        end
        hero.level = hero:GetLevel()
        --kemPrint("Kem_attritbute : ",strength," | ",agility," | ",intellect)

        -- Base Armor Bonus
        local armor = agility * Kem_Attributes.armor_adjustment
        hero:SetPhysicalArmorBaseValue(armor)
        local modified = false
        -- STR

        if strength ~= hero.strength or leveled_up then
            modified = true
            -- HP Bonus
            if not hero:HasModifier("modifier_health_bonus") then

                Kem_Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_bonus", {})
                Kem_Attributes.applier_add:ApplyDataDrivenModifier(hero, hero, "modifier_health_bonus_add", {})
            end
            
            local health_stacks = math.abs(strength * Kem_Attributes.hp_adjustment_array[hero_element])
            local health_stacks2 = (hero:GetLevel()-1)*20
            

            hero:SetModifierStackCount("modifier_health_bonus", Kem_Attributes.applier, health_stacks)
            hero:SetModifierStackCount("modifier_health_bonus_add", Kem_Attributes.applier_add, health_stacks2)

            -- HP Regen Bonus
            if not hero:HasModifier("modifier_health_regen_constant") then

                Kem_Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_regen_constant", {})
            end

            local health_regen_stacks = math.abs(strength * Kem_Attributes.hp_regen_adjustment * 100)
           
            hero:SetModifierStackCount("modifier_health_regen_constant", Kem_Attributes.applier, health_regen_stacks)
        end

        -- AGI
         if agility ~= hero.agility or leveled_up  then        
             modified = true
             -- Attack Speed Bonus
             if not hero:HasModifier("modifier_attackspeed_bonus_constant") then
                 Kem_Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_attackspeed_bonus_constant", {})
             end

             local attackspeed_stacks = math.abs(agility * Kem_Attributes.attackspeed_adjustment)

             hero:SetModifierStackCount("modifier_attackspeed_bonus_constant", Kem_Attributes.applier, attackspeed_stacks)
         end

        -- INT
        if intellect ~= hero.intellect  or leveled_up then
            modified = true
            -- Mana Bonus
            if not hero:HasModifier("modifier_mana_bonus") then

                Kem_Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_mana_bonus", {})
                Kem_Attributes.applier_add:ApplyDataDrivenModifier(hero, hero, "modifier_mana_bonus_add", {})
            end

            local mana_stacks = math.abs(intellect * Kem_Attributes.mp_adjustment_array[hero.element])
            local mana_stacks_each_level = hero:GetLevel()*10

            hero:SetModifierStackCount("modifier_mana_bonus", Kem_Attributes.applier, mana_stacks)
            hero:SetModifierStackCount("modifier_mana_bonus_add", Kem_Attributes.applier_add, mana_stacks_each_level)

            -- Mana Regen Bonus
            if not hero:HasModifier("modifier_base_mana_regen") then

                Kem_Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_base_mana_regen", {})
            end

            local mana_regen_stacks = math.abs(intellect * Kem_Attributes.mana_regen_adjustment * 100)

            hero:SetModifierStackCount("modifier_base_mana_regen", Kem_Attributes.applier, mana_regen_stacks)
        end

        -- Update the stored values for next timer cycle
        hero.strength = strength
        hero.agility = agility
        hero.intellect = intellect

        --kemPrint("recalculate bonus")
        hero:CalculateStatBonus()
        hero.leveled_up = false
        if(modified) then
          kemPrint("Kem_attributed : call update player data")

          HERO_READY[hero:GetPlayerOwnerID()] = true
          
          UpdatePlayerData(hero:GetPlayerOwnerID())
        end

        return 0.25
    end)
end

if not Kem_Attributes.applier then Kem_Attributes:Init() end