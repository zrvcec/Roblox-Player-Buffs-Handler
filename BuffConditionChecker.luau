--!strict 
local BuffConditions = require(".//BuffCondition")
local BuffRegistry = require(".//BuffRegistry")
local BuffActionController = require(".//BuffActionController")

local warnings = 0
local errors = 0

local function Dbhandle(...)
    print("[BUFFCONDITIONCHECKER][SERER]".. ...)
end

for _, BuffHandler in pairs(BuffConditions.data) do

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
        local Buff = BuffActionController:FindBuff(effectId)
        if not Buff then
            
        end

    end

end
