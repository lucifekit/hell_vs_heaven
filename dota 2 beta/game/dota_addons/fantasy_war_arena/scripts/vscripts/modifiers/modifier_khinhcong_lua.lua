modifier_khinhcong_lua = class({})

if IsServer() then
    function modifier_khinhcong_lua:Update()
        if self:GetDuration() == -1 then
            self:SetDuration(self.kv.replenish_time, true)
            self:StartIntervalThink(self.kv.replenish_time)
        end

        if self:GetStackCount() == 0 then
            self:GetAbility():StartCooldown(self:GetRemainingTime())
        end
    end
   
    function modifier_khinhcong_lua:OnCreated(kv)
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv

        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
        end
    end

    function modifier_khinhcong_lua:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_EXECUTED
        }

        return funcs
    end

    function modifier_khinhcong_lua:OnAbilityExecuted(params)
        if params.unit == self:GetParent() then
            local ability = params.ability

            if params.ability == self:GetAbility() then
                if params.unit:HasModifier("modifier_khinhcong_jumping_lua") then

                else
                  self:DecrementStackCount()
                  self:Update()
                
                end
                
            end
        end

        return 0
    end

    function modifier_khinhcong_lua:OnIntervalThink()
        local stacks = self:GetStackCount()

        if stacks < self.kv.max_count then
            self:SetDuration(self.kv.replenish_time, true)
            self:IncrementStackCount()

            if stacks == self.kv.max_count - 1 then
                self:SetDuration(-1, true)
                self:StartIntervalThink(-1)
            end
        end
    end
end
 function modifier_khinhcong_lua:RemoveOnDeath()
        return false
    end
function modifier_khinhcong_lua:DestroyOnExpire()
    return false
end

function modifier_khinhcong_lua:IsPurgable()
    return false
end