--!strict
--!nolint LocalShadow

local RunService = game:GetService("RunService")

local Client = RunService:IsClient()
local Server = RunService:IsServer()

local buffIdCounter = 0

local BAC = {}
BAC.__index = BAC

local Signal = require("./addons/Signal/Signal")
local Networker = require("./addons/Networker/Networker")

local BuffConditions = require("././BuffCondition")
local BuffRegistry = require("././BuffRegistry")


Networker.init()

local BuffEvent, DirectoryToBuff = Networker.Get("BuffEvent", "RemoteEvent")
local BuffEventKey = DirectoryToBuff.BuffEvent.Keys

function BAC.new(Player: Player)
    assert(
        (typeof(Player) == "Instance" and Player:IsA("Player"))
            or (typeof(Player) == "table" and Player.UserId ~= nil),
        "BuffActionController.new: Player must be a valid Player instance or a table containing UserId."
    )

    local self = setmetatable({}, BAC)
    
    self.OnBuffApplied = Signal.new()
    self.OnBuffExpired = Signal.new()

    self.IsClient = Client
    self.IsServer = Server

    self.Player = Player

    self.ActiveBuffByBuff = {}

    if Server then
        self.OnBuffApplied:Connect(function(...)
            BuffEvent:FireClient(Player, BuffEventKey.BuffApplied, ...)
        end)

        self.OnBuffExpired:Connect(function(...)
            BuffEvent:FireClient(Player, BuffEventKey.BuffExpired, ...)
        end)
    end

    return self
end

export type BuffActionController = typeof(BAC.new({UserId = "ccc"} ::any))

type buffId = string
type ConditionIds = string
export type BuffType = "DamageIncrease"
    | "PhysicalDamageIncrease"
    | "IncomingDamageReduction"
    | "AttackSpeed"
    | "CriticalChance"
    | "CriticalDamage"
    | "Range"
    | "MovementSpeed"
    | "SprintSpeed"
    | "DashDistance"
    | "DashSpeed"
    | "DashCooldown"
    | "HealthIncrease"
    | "HealthRegen"
    | "StaminaIncrease"
    | "StaminaRegen"
    | "StaminaCost"
    | "StaminaRegenDelay"
    | "CombatCooldownReduction"
    | "NenDamageIncrease"
    | "NenIncomingDamageReduction"
    | "NenCost"
    | "NenRegeneration"
    | "NenXPBoost"
    | "DamageDecreasebyDefense"
    | "DefenseCost"
    | "DefenseRegen"
    | "DefenseRegenDelay"
    | "MiningDamage"
    | "MiningSpeed"
    | "ResourceDropIncreaseChance"
    | "StatXPBoost"
    | "StunResistance"
    | "KnockBackResistance"
    | "BleedResistance"
    | "BurnResistance"
    | "PoisonResistance"
    | "FreezeResistance"
    | "ShockResistance"
    | "SlowResistance"
    | "DamageImmunity"
    | "StunImmunity"
    | "Stun"
    | "StunDurationIncrease"
    | "Slow"
    | "Bleed"
    | "Burn"
    | "Poison"
    | "Freeze"
    | "Shock"
    | "Blind"
    | "Silence"
    | "Weaken"
    | "Vulnerability"
    | "Root"
    | "Ragdoll"
| "KnockBack"


function BAC:FindBuff(Buff:BuffType, safe:boolean?): any
    local FoundBuffRegistry = BuffRegistry.Qualities[Buff]
    if not safe then
        assert(FoundBuffRegistry ~= nil, "BuffRegistry Does not exist for: ".. Buff)
    end
    return FoundBuffRegistry
end

function BAC:compileresults(BuffType: BuffType, curr:number): number
    local self = self :: BuffActionController
    local buff = self:FindBuff(BuffType)
    if not buff then
        return curr    
    end

    return curr
end

function BAC:GetCondition(Buff:ConditionIds, safe:boolean?): number?
    local Condition = BuffConditions.data[Buff]
    if not safe then
        assert(Condition ~= nil, `Could not find buff related to: {Buff}`)    
    end
    return Condition
end


local function startListeningForBuffs()
        local Events = {
        [BuffEventKey.BuffApplied] = function()
            
        end,

        [BuffEventKey.BuffExpired] = function()
            
        end
    }

    BuffEvent.Event.OnClientEvent:Connect(function(KEY:number, ...:any)
        local Handle = Events[KEY]
        if Handle then
            Handle(...)
        end
    end)
end

if Client then
    startListeningForBuffs()
end

local function generateBuffId(): string
    buffIdCounter += 1
    return tostring(buffIdCounter)
end

-- Timelimit in seconds and set to workspace:getservertime() + Given timelimit
function BAC:ApplyBuffs(Buffs: string, TimeLimit: number?): buffId?
    local self = self :: BuffActionController
    local buffId = generateBuffId()
    local Condition = self:GetCondition(Buffs)

    assert(Condition ~= nil, "Could not find condition")

    if self:HasBuff(Buffs) then
        return nil
    end

    if self.OnBuffApplied then
        self.OnBuffApplied:Fire()
    end

    self.ActiveBuffByBuff[Buffs] = {Id = buffId, ExpiresAt = TimeLimit}

    if TimeLimit then
        
    end

    return buffId
end

function BAC:RemoveBuff(BuffId:buffId): boolean
    local self = self :: BuffActionController

    local buff_1 = self.ActiveBuffByBuff[BuffId]
    if buff_1 then
        if self.OnBuffExpired then
            self.OnBuffExpired:Fire()    
        end
        self.ActiveBuffByBuff[BuffId] = nil
    end
    return false
end

function BAC:HasBuff(Buff:string) 
    local self = self :: BuffActionController
    return self.ActiveBuffByBuff[Buff] ~= nil
end

-- Only call this when its definitively getting removed from memory, otherwise system will error
function BAC:Destroy()
    local self = self :: BuffActionController
    if self.OnBuffApplied then
        pcall(function()
            self.OnBuffApplied:Destroy()
            self.OnBuffApplied = nil
        end)
    end

    if self.OnBuffExpired then
        pcall(function()
          self.OnBuffExpired:Destroy()
          self.OnBuffExpired = nil
        end)
    end
    table.clear(self :: any)
end
return BAC