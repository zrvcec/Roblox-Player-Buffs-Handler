--!strict 
local BuffConditions = require(".//BuffCondition")
local BuffActionController = require(".//BuffActionController")
local BuffRegistry = require(".//BuffRegistry")

local warnings = 0
local errors = 0

local TotalBuffHandlers = 0
local TotalEffectsInsideBuffHandlers = 0

local BuffHandlersSuccess = 0
local EffectsInsideBuffHandlersSuccess = 0 

local function Dbhandle(...)
    print("[BUFFCONDITIONCHECKER][SERER]".. ...)
end

for i, v in pairs(BuffRegistry.Qualities) do
end

for _, BuffHandler in pairs(BuffConditions.data) do
    TotalBuffHandlers += 1
    local Effects = BuffHandler.effects
    local Name = BuffHandler.name
    local Description = BuffHandler.description

    if not Effects then
        errors += 1
        Dbhandle("BuffHandler effects missing for: ", BuffHandler)
        continue
    end

    if not Name then
        Dbhandle("Name missing for: ", BuffHandler)
        warnings += 1
    elseif typeof(Name) ~= "string" then
        Dbhandle("Name is not a string!")
        errors += 1
        continue
    end

    if not Description then
        print("Description missing for: ", BuffHandler)
        warnings += 1
    elseif typeof(Description) ~= "string" then
        Dbhandle("Description is not a string!")
        errors += 1
         continue
    end

    for effectId, data in pairs(Effects) do
        TotalEffectsInsideBuffHandlers +=1
        local Buff = BuffActionController:FindBuff(effectId)
        if not Buff then
            Dbhandle(`Buff with EffectId {effectId} inside {data} could not be found with BCA`)
            errors += 1
            continue
        end
        
        EffectsInsideBuffHandlersSuccess += 1
    end

    BuffHandlersSuccess += 1
end
